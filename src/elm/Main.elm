port module Main exposing (..)

import Navigation exposing (Location)
import Html exposing (Html)
import Html.Attributes
import Update.Extra as Update
import Update.Extra.Infix exposing (..)
import Window
import Date exposing (Date)
import Task
import Json.Decode as Decode
import Json.Encode as Encode

import Types exposing (..)
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
import Firebase
import LocalStorage
import Remote exposing (Remote)

port changeTitle : String -> Cmd msg
port localStorage : String -> Cmd msg
port fromLocalStorage : (String -> msg) -> Sub msg

changeTitleIfArticle : Model -> Cmd msg
changeTitleIfArticle { route, articles } =
  case generateTitleAccordingToRoute route articles of
    Nothing ->
      Cmd.none
    Just title ->
      changeTitle title

generateTitleAccordingToRoute : Route -> Remote (List Article) -> Maybe String
generateTitleAccordingToRoute route articles =
  case route of
    Home ->
      Just "Guillaume Hivert | Blog"
    About ->
      Just "À Propos | Guillaume Hivert | Blog"
    Article title ->
      articles
        |> Remote.toMaybe
        |> Maybe.andThen (Article.getArticleByHtmlTitle title)
        |> Maybe.map .title
        |> Maybe.map (flip (++) " | Guillaume Hivert | Blog")
    Edit title ->
      articles
        |> Remote.toMaybe
        |> Maybe.andThen (Article.getArticleByHtmlTitle title)
        |> Maybe.map .title
        |> Maybe.map (flip (++) " | Édition | Guillaume Hivert | Blog")
    Archives ->
      Just "Archives | Guillaume Hivert | Blog"
    Contact ->
      Just "Contact | Guillaume Hivert | Blog"
    Dashboard ->
      Just "Dashboard | Guillaume Hivert | Blog"
    Login ->
      Just "Connexion | Guillaume Hivert | Blog"
    NotFound ->
      Just "Page Introuvable | Guillaume Hivert | Blog"

myself : String
myself =
  "myself"

main : Program Never Model Msg
main =
  Navigation.program (Navigation << NewLocation)
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Window.resizes Resizes
    , firebaseSubscriptions model
    , fromLocalStorage RestoreArticles
    ]

firebaseSubscriptions : Model -> Sub Msg
firebaseSubscriptions model =
  Sub.batch
    [ Firebase.requestedPosts GetPosts
    , Firebase.authChanges GetUser
    , Firebase.createdPost AcceptPost
    ]

init : Location -> (Model, Cmd Msg)
init location =
  { location = location
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
    ! [ getActualTime ]
    :> update (RequestPosts myself)

getActualTime : Cmd Msg
getActualTime =
  Task.perform DateNow Date.now

update : Msg -> Model -> (Model, Cmd Msg)
update msg ({ menuOpen, date, route, articles, articleWriting } as model) =
  case msg of
    Navigation navigation ->
      handleNavigation navigation model
    HamburgerMenu action ->
      handleHamburgerMenu action model
    Resizes { width } ->
      if width >= 736 then
        model
          |> closeMenu
          |> Update.identity
      else
        model ! []
    DateNow date ->
      model
        |> setDate (Just date)
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
        :> update UpdateTitle
        :> update StoreArticles
        :> update UpdateEditFields
    GetUser user ->
      user
        |> Decode.decodeValue User.Decoder.decodeUser
        |> Result.toMaybe
        |> setUserIn model
        |> redirectIfLogin
    AcceptPost accepted ->
      let debug = Debug.log "accepted" accepted in
      model ! []
    RequestPosts username ->
      model ! [ Firebase.requestPosts username ]
    UpdateTitle ->
      model ! [ changeTitleIfArticle model ]
    StoreArticles ->
      model ! [ localStorage <| Encode.encode 0 <| LocalStorage.encodeModel model ]
    RestoreArticles articles ->
      articles
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
            Remote.Fetched articles ->
              case Article.getArticleByHtmlTitle id articles of
                Nothing -> setArticleFields NotFoundArticle model ! []
                Just content ->
                  content
                  |> toArticleFields id
                  |> EditArticle
                  |> asArticleFieldsIn model
                  |> Update.identity
            _ -> setArticleFields NotFoundArticle model ! []
        Dashboard ->
          case articleWriting of
            EditArticle _ -> handleArticleForm ArticleWrite model
            NotFoundArticle -> handleArticleForm ArticleWrite model
            _ -> model ! []
        _ ->
          model ! []

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
        :> update UpdateTitle
        :> update UpdateEditFields
    ReloadHomePage ->
      model ! [ Navigation.newUrl "/" ]
    ChangePage url ->
      (closeMenu model) ! [ Navigation.newUrl url ]
    BackPage ->
      model ! [ Navigation.back 1 ]
    ForwardPage ->
      model ! [ Navigation.forward 1 ]

handleHamburgerMenu : MenuAction -> Model -> (Model, Cmd Msg)
handleHamburgerMenu action model =
  case action of
    ToggleMenu ->
      toggleMenu model ! []

handleContactForm : ContactAction -> Model -> (Model, Cmd Msg)
handleContactForm contactAction model =
  case contactAction of
    SendContactMail ->
      model ! [] -- TODO SendGrid integration.
    ContactEmailInput email ->
      model
        |> setEmailContact email
        |> Update.identity
    ContactMessageInput message ->
      model
        |> setMessageContact message
        |> Update.identity

handleLoginForm : LoginAction -> Model -> (Model, Cmd Msg)
handleLoginForm loginAction ({ loginFields, user } as model) =
  case loginAction of
    LoginUser ->
      model ! [ Firebase.signInUser (loginFields.email, loginFields.password) ]
    LogoutUser ->
      case user of
        Just { email } ->
          model
            |> setUser Nothing
            |> Update.identity
            |> Update.addCmd (Firebase.logoutUser email)
            :> handleNavigation (ChangePage "/")
        Nothing ->
          model ! [ Navigation.newUrl "/" ]
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
    ArticleSubmit ->
      case articleWriting of
        NewArticle { title, content } ->
          case date of
            Nothing ->
              model ! []
            Just date ->
              date
                |> Article.toSubmit "" title content
                |> Article.Encoder.encodeArticle
                |> (,) myself
                |> Firebase.createPost
                |> List.singleton
                |> (!) model
                :> handleArticleForm ArticleRemove
                :> update (RequestPosts myself)
        EditArticle { title, content, uuid } ->
          case uuid of
            Nothing ->
              model ! []
            Just uuid ->
              case articles of
                Remote.Fetched articles ->
                  uuid
                    |> flip Article.getArticleByHtmlTitle articles
                    |> Maybe.map (\{ date, uuid } -> Article.toSubmit uuid title content date)
                    |> Maybe.map (Article.Encoder.encodeArticle)
                    |> Maybe.map ((,) myself)
                    |> Maybe.map Firebase.updatePost
                    |> Maybe.withDefault Cmd.none
                    |> List.singleton
                    |> (!) model
                    :> handleArticleForm ArticleRemove
                    :> update (RequestPosts myself)
                _ ->
                  model ! []
        SentArticle ->
          model ! []
        NotFoundArticle ->
          model ! []
    ArticleToggler ->
      model
        |> toggleArticleFocus
        |> Update.identity
    ArticlePreview ->
      model
        |> toggleArticlePreview
        |> Update.identity
    ArticleRemove ->
      { model | articleWriting = SentArticle } ! []
    ArticleWrite ->
      { model | articleWriting = NewArticle defaultArticleFields } ! []

redirectIfLogin : Model -> (Model, Cmd Msg)
redirectIfLogin ({ user, route } as model) =
  model ! [ selectRedirectPath model ]

selectRedirectPath : Model -> Cmd Msg
selectRedirectPath { user, route } =
  case user of
    Nothing ->
      Cmd.none
    Just _ ->
      case route of
        Login ->
          Navigation.newUrl "/dashboard"
        _ ->
          Cmd.none

view : Model -> Html Msg
view model =
  Html.div []
    [ View.Static.Header.view model
    , Html.div
      [ Html.Attributes.class "body" ]
      [ Html.img
        [ Html.Attributes.class "banner-photo"
        , Html.Attributes.src "/static/img/banner-photo.jpg"
        ] []
      , Html.div
        [ Html.Attributes.class "container" ]
        [ customView model ]
      ]
    , View.Static.Footer.view model
    ]

customView : Model -> Html Msg
customView ({ route, user, articles } as model) =
  case route of
    Home ->
      View.Home.view model
    About ->
      View.Static.About.view model
    Article id ->
      case articles of
        Remote.Fetched articles ->
          id
            |> flip Article.getArticleByHtmlTitle articles
            |> Maybe.map View.Article.view
            |> Maybe.withDefault (View.Static.NotFound.view model)
        _ ->
          Html.img
            [ Html.Attributes.src "/static/img/loading.gif"
            , Html.Attributes.class "spinner"
            ] []
    Edit id ->
      case user of
        Nothing ->
          View.Static.NotFound.view model
        Just user ->
          case articles of
            Remote.Fetched articles ->
              View.Article.Edit.view model
            _ ->
              Html.img
                [ Html.Attributes.src "/static/img/loading.gif"
                , Html.Attributes.class "spinner"
                ] []
    Archives ->
      View.Archives.view model
    Contact ->
      Html.map ContactForm <| View.Contact.view model
    Dashboard ->
      case user of
        Nothing ->
          View.Static.NotFound.view model
        Just user ->
          View.Dashboard.view model
    Login ->
      Html.map LoginForm <| View.Login.view model
    NotFound ->
      View.Static.NotFound.view model
