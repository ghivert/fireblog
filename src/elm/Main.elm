port module Main exposing (..)

import Html exposing (Html)
import Html.Attributes
import Update.Extra as Update
import Browser
import Browser.Events
import Browser.Navigation as Navigation
import Task
import Json.Decode as Decode
import Json.Encode as Encode
import Update
import Update.Extra
import Time exposing (Posix)
import Url

import Types exposing (..)
import Ports exposing (..)
import Article exposing (Article)
import Article.Decoder
import Article.Encoder
import User.Decoder
import Routing
import View.Home
import View.Article
import View.Article.Edit
import View.Archives
import View.Contact
import View.Login
import View.Dashboard
import View.Static.Header
import View.Static.Footer
import View.Static.NotFound
import View.Static.About
import LocalStorage
import Remote exposing (Remote)
import Styles.Neptune.Main as Styles
import Styles.Main as CommonStyles

port toJS : Encode.Value -> Cmd msg
port fromJS : (Decode.Value -> msg) -> Sub msg

changeStructuredDataIfArticle : Model -> Cmd msg
changeStructuredDataIfArticle { route, articles, location } =
  Cmd.batch
    [ case generateStructuredDataAccordingToRoute route articles of
        Nothing -> Cmd.none
        Just content ->
          [ ("type", Encode.string changeStructuredData)
          , ("structuredData", content)
          ]
          |> Encode.object
          |> toJS
    , articles
      |> generateOpenGraphDataAccordingToRoute location route
      |> \openGraphData ->
        [ ("type", Encode.string changeOpenGraphData)
        , ("openGraphData", openGraphData)
        ]
      |> Encode.object
      |> toJS
    ]

generateStructuredDataAccordingToRoute : Route -> Remote (List Article) -> Maybe Encode.Value
generateStructuredDataAccordingToRoute route articles =
  case route of
    Home -> Nothing
    About -> Nothing
    Edit title -> Nothing
    Archives -> Nothing
    Contact -> Nothing
    Dashboard -> Nothing
    Login -> Nothing
    NotFound -> Nothing
    Types.Article title ->
      articles
      |> Remote.toMaybe
      |> Maybe.andThen (Article.getArticleByHtmlTitle title)
      |> Maybe.map encodeStructuredData

generateOpenGraphDataAccordingToRoute : Url.Url -> Route -> Remote (List Article) -> Encode.Value
generateOpenGraphDataAccordingToRoute location route articles =
  case route of
    Types.Article title ->
      articles
      |> Remote.toMaybe
      |> Maybe.andThen (Article.getArticleByHtmlTitle title)
      |> Maybe.map (encodeOpenGraphData location)
      |> Maybe.withDefault (Encode.object [])
    _ -> Encode.object []

encodeStructuredData : Article -> Encode.Value
encodeStructuredData article =
  Encode.object
  <| List.append
    [ ("@context", Encode.string "http://schema.org")
    , ("@type", Encode.string "NewsArticle")
    , ("headline", Encode.string article.title)
    ]
  <| case article.headImage of
      Nothing -> []
      Just headImage ->
        headImage
        |> List.singleton
        |> Encode.list Encode.string
        |> Tuple.pair "image"
        |> List.singleton

encodeOpenGraphData : Url.Url -> Article -> Encode.Value
encodeOpenGraphData location article =
  Encode.object
  <| List.append
    [ ("url", Encode.string location.path)
    , ("type", Encode.string "article")
    , ("title", Encode.string article.title)
    , ("description", Encode.string article.headline)
    ]
  <| case article.headImage of
    Nothing -> []
    Just url -> [ ("image", Encode.string url) ]

generateTitleAccordingToRoute : Route -> Remote (List Article) -> String
generateTitleAccordingToRoute route articles =
  let notFoundTitle = "Page Introuvable | Guillaume Hivert | Blog" in
  case route of
    Home ->
      "Guillaume Hivert | Blog"
    About ->
      "À Propos | Guillaume Hivert | Blog"
    Types.Article title ->
      articles
      |> Remote.toMaybe
      |> Maybe.andThen (Article.getArticleByHtmlTitle title)
      |> Maybe.map .title
      |> Maybe.map (\e -> e ++ " | Guillaume Hivert | Blog")
      |> Maybe.withDefault notFoundTitle
    Edit title ->
      articles
      |> Remote.toMaybe
      |> Maybe.andThen (Article.getArticleByHtmlTitle title)
      |> Maybe.map .title
      |> Maybe.map (\e -> e ++ " | Édition | Guillaume Hivert | Blog")
      |> Maybe.withDefault notFoundTitle
    Archives ->
      "Archives | Guillaume Hivert | Blog"
    Contact ->
      "Contact | Guillaume Hivert | Blog"
    Dashboard ->
      "Dashboard | Guillaume Hivert | Blog"
    Login ->
      "Connexion | Guillaume Hivert | Blog"
    NotFound ->
      "Page Introuvable | Guillaume Hivert | Blog"

myself : String
myself =
  "myself"

main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = Navigation << NewLocation
    , onUrlRequest = Navigation << UrlRequest
    }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Browser.Events.onResize Resizes
    , fromJS FromJs
    ]

init : () -> Url.Url -> Navigation.Key -> (Model, Cmd Msg)
init flags location key =
  { location = location
  , key = key
  , route = Routing.parseLocation location
  , articles = Remote.NotFetched
  , menuOpen = False
  , contactFields =
    { email = ""
    , message = ""
    }
  , loginFields =
    { email = ""
    , password = ""
    }
  , articleWriting = NotFoundArticle
  , user = Nothing
  , date = Nothing
  }
  |> Update.identity
  |> Update.Extra.addCmd getActualTime
  |> Update.Extra.andThen update (RequestPosts myself)

getActualTime : Cmd Msg
getActualTime =
  Task.perform DateNow Time.now

update : Msg -> Model -> (Model, Cmd Msg)
update msg ({ menuOpen, date, route, articles, articleWriting } as model) =
  case msg of
    Navigation navigation ->
      handleNavigation navigation model
    HamburgerMenu action ->
      handleHamburgerMenu action model
    Resizes width height ->
      if width >= 736 then
        model
        |> closeMenu
        |> Update.identity
      else
        model |> Update.identity
    DateNow actualDate ->
      model
      |> setDate (Just actualDate)
      |> Update.identity
    ContactForm action ->
      handleContactForm action model
    LoginForm action ->
      handleLoginForm action model
    ArticleForm action ->
      handleArticleForm action model
    GetPosts posts ->
      posts
      |> Decode.decodeValue Article.Decoder.decodePosts
      |> Result.withDefault []
      |> List.map Article.toUnifiedArticle
      |> setArticlesIn model
      |> Update.identity
      |> Update.Extra.andThen update UpdateTitleAndStructuredData
      |> Update.Extra.andThen update StoreArticles
      |> Update.Extra.andThen update UpdateEditFields
    GetUser user ->
      user
      |> Decode.decodeValue User.Decoder.decodeUser
      |> Result.toMaybe
      |> setUserIn model
      |> redirectIfLogin
    AcceptPost accepted ->
      -- let debug = Debug.log "accepted" accepted in
      model
      |> Update.identity
    RequestPosts username ->
      model
      |> Update.identity
      |> Update.Extra.addCmd
        (toJS
          (Encode.object
            [ ("type", Encode.string requestPosts)
            , ("username", Encode.string username)
            ]
          )
        )
    UpdateTitleAndStructuredData ->
      model
      |> Update.identity
      |> Update.Extra.addCmd (changeStructuredDataIfArticle model)
    StoreArticles ->
      let encoded = Encode.encode 0 (LocalStorage.encodeModel model) in
      model
      |> Update.identity
      |> Update.Extra.addCmd
        (toJS
          (Encode.object
            [ ("type", Encode.string saveToLocalStorage)
            , ("model", Encode.string encoded)
            ]
          )
        )
    RestoreArticles savedArticles ->
      savedArticles
      |> Decode.decodeString LocalStorage.decodeModel
      |> Result.withDefault Nothing
      |> Remote.fromMaybe
      |> (\content -> if content == Remote.Absent then Remote.NotFetched else content)
      |> setInModelIfNotThere model
      |> Update.identity
    UpdateEditFields ->
      case route of
        Edit id ->
          case articles of
            Remote.Fetched fetchedArticles ->
              case Article.getArticleByHtmlTitle id fetchedArticles of
                Nothing -> setArticleFields NotFoundArticle model |> Update.identity
                Just content ->
                  content
                  |> toArticleFields id
                  |> EditArticle
                  |> asArticleFieldsIn model
                  |> Update.identity
            _ -> setArticleFields NotFoundArticle model |> Update.identity
        Dashboard ->
          case articleWriting of
            EditArticle _ -> handleArticleForm ArticleWrite model
            NotFoundArticle -> handleArticleForm ArticleWrite model
            _ -> model |> Update.identity
        _ ->
          model |> Update.identity
    FromJs value ->
      case Decode.decodeValue decodeFromJs value of
        Err error -> (model, Cmd.none)
        Ok val ->
          case val of
            UpdatePost updated -> (model, Cmd.none)
            SaveToLocalStorage -> (model, Cmd.none)
            FirebaseRequestPosts posts ->
              (model, Cmd.none)
              |> Update.andThen update (GetPosts posts)
            CreatePost accepted ->
              (model, Cmd.none)
              |> Update.andThen update (AcceptPost accepted)
            ReadFromLocalStorage serialized ->
              (model, Cmd.none)
              |> Update.andThen update (RestoreArticles serialized)

toArticleFields : String -> Article -> ArticleFields
toArticleFields uuid { title, content } =
  defaultArticleFields
  |> setUuidField uuid
  |> setTitleField title
  |> setContentField content

setInModelIfNotThere : Model -> Remote (List Article) -> Model
setInModelIfNotThere ({ articles } as model) articles_ =
  if not (Remote.isFetched articles) then
    setRawArticles articles_ model
  else
    model

handleNavigation : SpaNavigation -> Model -> (Model, Cmd Msg)
handleNavigation navigation model =
  case navigation of
    NewLocation location ->
      model
      |> setLocation location
      |> setRoute (Routing.parseLocation location)
      |> Update.identity
      |> Update.Extra.andThen update UpdateTitleAndStructuredData
      |> Update.Extra.andThen update UpdateEditFields
    UrlRequest request ->
      model
      |> Update.identity
    ReloadHomePage ->
      model
      |> Update.identity
      |> Update.addCmd (Navigation.pushUrl model.key "/")
    ChangePage url ->
      (closeMenu model)
      |> Update.identity
      |> Update.addCmd (Navigation.pushUrl model.key url)
    BackPage ->
      model
      |> Update.identity
      |> Update.addCmd (Navigation.back model.key 1)
    ForwardPage ->
      model
      |> Update.identity
      |> Update.addCmd (Navigation.forward model.key 1)

handleHamburgerMenu : MenuAction -> Model -> (Model, Cmd Msg)
handleHamburgerMenu action model =
  case action of
    ToggleMenu ->
      toggleMenu model
      |> Update.identity
      |> Update.addCmd (Cmd.none)

handleContactForm : ContactAction -> Model -> (Model, Cmd Msg)
handleContactForm contactAction model =
  case contactAction of
    SendContactMail ->
      model
      |> Update.identity
      |> Update.addCmd (Cmd.none) -- TODO SendGrid integration.
    ContactEmailInput email ->
      model
      |> setEmailContact email
      |> Update.identity
    ContactMessageInput message ->
      model
      |> setMessageContact message
      |> Update.identity

handleLoginForm : LoginAction -> Model -> (Model, Cmd Msg)
handleLoginForm loginAction ({ loginFields, user, key } as model) =
  case loginAction of
    LoginUser ->
      let { email, password } = loginFields in
      model
      |> Update.identity
      |> Update.addCmd
        (toJS
          (Encode.object
            [ ("type", Encode.string signinUser)
            , ("email", Encode.string email)
            , ("password", Encode.string password)
            ]
          )
        )
    LogoutUser ->
      case user of
        Just { email } ->
          model
          |> setUser Nothing
          |> Update.identity
          |> Update.addCmd
            (toJS (Encode.object [ ("type", Encode.string logoutUser) ]))
          |> Update.Extra.andThen handleNavigation (ChangePage "/")
        Nothing ->
          model
          |> Update.identity
          |> Update.addCmd (Navigation.pushUrl key "/")
    LoginEmailInput email ->
      model
      |> setEmailLogin email
      |> Update.identity
    LoginPasswordInput password ->
      model
      |> setPasswordLogin password
      |> Update.identity

handleArticleForm : ArticleAction -> Model -> (Model, Cmd Msg)
handleArticleForm newArticleAction ({ articles, articleWriting, date } as model) =
  case newArticleAction of
    ArticleTitle title ->
      model
      |> setArticleTitle title
      |> Update.identity
    ArticleContent content ->
      model
      |> setArticleContent content
      |> Update.identity
    ArticleHeadline headline ->
      model
      |> setArticleHeadline headline
      |> Update.identity
    ArticleHeadImage headImage ->
      model
      |> setArticleHeadImage headImage
      |> Update.identity
    ArticleSubmit ->
      case articleWriting of
        NewArticle { title, content, headline, headImage } ->
          case date of
            Nothing ->
              model |> Update.identity |> Update.addCmd (Cmd.batch [])
            Just date_ ->
              let uuid = "" in
              Article.toSubmit uuid title content date_ headline
              (if headImage == "" then Nothing else Just headImage)
              |> Article.Encoder.encodeArticle
              |> \article -> toJS
                (Encode.object
                  [ ("type", Encode.string createPost)
                  , ("username", Encode.string myself)
                  , ("post", article)
                  ]
                )
              |> List.singleton
              |> Cmd.batch >> Tuple.pair model
              |> Update.Extra.andThen handleArticleForm ArticleRemove
              |> Update.Extra.andThen update (RequestPosts myself)
        EditArticle { title, content, uuid, headline, headImage } ->
          case uuid of
            Nothing -> model |> Update.identity
            Just existingUuid ->
              case articles of
                Remote.Fetched fetchedArticles ->
                  let articleHeadImage = if headImage == "" then Nothing else Just headImage
                      generateToSubmitArticle item =
                        Article.toSubmit item.uuid title content item.date headline articleHeadImage
                  in
                    existingUuid
                    |> \e -> Article.getArticleByHtmlTitle e fetchedArticles
                    |> Maybe.map generateToSubmitArticle
                    |> Maybe.map (Article.Encoder.encodeArticle)
                    |> Maybe.map
                      (\article ->
                        toJS
                          (Encode.object
                            [ ("type", Encode.string updatePost)
                            , ("username", Encode.string myself)
                            , ("post", article)
                            ]
                          )
                      )
                    |> Maybe.withDefault Cmd.none
                    |> List.singleton
                    |> Cmd.batch >> Tuple.pair model
                    |> Update.Extra.andThen handleArticleForm ArticleRemove
                    |> Update.Extra.andThen update (RequestPosts myself)
                _ ->
                  model |> Update.identity
        SentArticle ->
          model |> Update.identity
        NotFoundArticle ->
          model |> Update.identity
    ArticleToggler ->
      model
      |> toggleArticleFocus
      |> Update.identity
    ArticlePreview ->
      model
      |> toggleArticlePreview
      |> Update.identity
    ArticleRemove ->
      { model | articleWriting = SentArticle }
      |> Update.identity
    ArticleWrite ->
      { model | articleWriting = NewArticle defaultArticleFields }
      |> Update.identity

redirectIfLogin : Model -> (Model, Cmd Msg)
redirectIfLogin ({ user, route } as model) =
  (model, selectRedirectPath model)

selectRedirectPath : Model -> Cmd Msg
selectRedirectPath { user, route, key } =
  case user of
    Nothing -> Cmd.none
    Just _ ->
      case route of
        Login -> Navigation.pushUrl key "/dashboard"
        _ -> Cmd.none

view : Model -> Browser.Document Msg
view ({ route, articles } as model) =
  { title = generateTitleAccordingToRoute route articles
  , body =
    [ Html.div []
      [ View.Static.Header.view model
      , Html.div []
        [ Html.img
          [ Html.Attributes.class Styles.bannerPhoto
          , Html.Attributes.src "/img/banner-photo.jpg"
          ] []
        , Html.div
          [ Html.Attributes.class Styles.container ]
          [ customView model ]
        ]
      , View.Static.Footer.view model
      ]
    ]
  }

customView : Model -> Html Msg
customView ({ route, user, articles } as model) =
  case route of
    Home ->
      View.Home.view model
    About ->
      View.Static.About.view model
    Types.Article id ->
      case articles of
        Remote.Fetched fetchedArticles ->
          id
          |> \a -> Article.getArticleByHtmlTitle a fetchedArticles
          |> Maybe.map View.Article.view
          |> Maybe.withDefault (View.Static.NotFound.view model)
        _ ->
          Html.img
            [ Html.Attributes.src "/img/loading.gif"
            , Html.Attributes.class CommonStyles.spinner
            ] []
    Edit id ->
      case user of
        Nothing -> View.Static.NotFound.view model
        Just _ ->
          case articles of
            Remote.Fetched _ -> View.Article.Edit.view model
            _ ->
              Html.img
                [ Html.Attributes.src "/img/loading.gif"
                , Html.Attributes.class CommonStyles.spinner
                ] []
    Archives ->
      View.Archives.view model
    Contact ->
      Html.map ContactForm (View.Contact.view model)
    Dashboard ->
      case user of
        Nothing -> View.Static.NotFound.view model
        Just _ -> View.Dashboard.view model
    Login ->
      Html.map LoginForm (View.Login.view model)
    NotFound ->
      View.Static.NotFound.view model
