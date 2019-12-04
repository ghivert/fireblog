module Types exposing (..)

import Json.Decode
import Browser
import Browser.Navigation as Navigation
import Time exposing (Posix)
import Url

import Article exposing (Article)
import User exposing (User)
import Remote exposing (Remote)

type SpaNavigation
  = NewLocation Url.Url
  | UrlRequest Browser.UrlRequest
  | ReloadHomePage
  | ChangePage String
  | BackPage
  | ForwardPage

type Route
  = Home
  | About
  | Article String
  | Edit String
  | Archives
  | Contact
  | Dashboard
  | Login
  | NotFound

type MenuAction
  = ToggleMenu

type ContactAction
  = SendContactMail
  | ContactEmailInput String
  | ContactMessageInput String

type LoginAction
  = LoginUser
  | LogoutUser
  | LoginEmailInput String
  | LoginPasswordInput String

type ArticleAction
  = ArticleTitle String
  | ArticleContent String
  | ArticleHeadline String
  | ArticleHeadImage String
  | ArticleSubmit
  | ArticleToggler
  | ArticlePreview
  | ArticleRemove
  | ArticleWrite

type Msg
  = Navigation SpaNavigation
  | HamburgerMenu MenuAction
  | Resizes Int Int
  | DateNow Posix
  | ContactForm ContactAction
  | LoginForm LoginAction
  | ArticleForm ArticleAction
  | GetPosts Json.Decode.Value
  | GetUser Json.Decode.Value
  | AcceptPost Bool
  | RequestPosts String
  | UpdateTitleAndStructuredData
  | StoreArticles
  | RestoreArticles String
  | UpdateEditFields

type alias ContactFields =
  { email : String
  , message : String
  }

setEmailField : String -> { a | email : String } -> { a | email : String }
setEmailField email fields =
  { fields | email = email }

setMessageField : String -> ContactFields -> ContactFields
setMessageField message fields =
  { fields | message = message }

type alias LoginFields =
  { email : String
  , password : String
  }

setPasswordField : String -> LoginFields -> LoginFields
setPasswordField password fields =
  { fields | password = password }

type ArticleWriting
  = NewArticle ArticleFields
  | EditArticle ArticleFields
  | SentArticle
  | NotFoundArticle

articleWritingMap : (ArticleFields -> ArticleFields) -> ArticleWriting -> ArticleWriting
articleWritingMap mapper writing =
  case writing of
    NewArticle fields ->
      NewArticle (mapper fields)
    EditArticle fields ->
      EditArticle (mapper fields)
    SentArticle ->
      SentArticle
    NotFoundArticle ->
      NotFoundArticle

type alias ArticleFields =
  { title : String
  , content : String
  , focused : Bool
  , previewed : Bool
  , uuid : Maybe String
  , headline : String
  , headImage : String
  }

defaultArticleFields : ArticleFields
defaultArticleFields =
  { title = ""
  , content = ""
  , focused = False
  , previewed = False
  , uuid = Nothing
  , headline = ""
  , headImage = ""
  }

setTitleField : String -> ArticleFields -> ArticleFields
setTitleField title fields =
  { fields | title = title }

setContentField : String -> ArticleFields -> ArticleFields
setContentField content fields =
  { fields | content = content }

setHeadlineField : String -> ArticleFields -> ArticleFields
setHeadlineField headline fields =
  { fields | headline = headline }

setHeadImageField : String -> ArticleFields -> ArticleFields
setHeadImageField headImage fields =
  { fields | headImage = headImage }

toggleFocus : ArticleFields -> ArticleFields
toggleFocus ({ focused } as fields) =
  { fields | focused = not focused }

togglePreview : ArticleFields -> ArticleFields
togglePreview ({ previewed } as fields) =
  { fields | previewed = not previewed }

setUuidField : String -> ArticleFields -> ArticleFields
setUuidField uuid fields =
  { fields | uuid = Just uuid }

type alias Model =
  { location : Url.Url
  , key : Navigation.Key
  , route : Route
  , articles : Remote (List Article)
  , menuOpen : Bool
  , user : Maybe User
  , date : Maybe Posix
  , contactFields : ContactFields
  , loginFields : LoginFields
  , articleWriting : ArticleWriting
  }

setLocation : Url.Url -> Model -> Model
setLocation location model =
  { model | location = location }

setRoute : Route -> Model -> Model
setRoute route model =
  { model | route = route }

toggleMenu : Model -> Model
toggleMenu ({ menuOpen } as model) =
  { model | menuOpen = not menuOpen }

closeMenu : Model -> Model
closeMenu model =
  { model | menuOpen = False }

asContactFieldsIn : Model -> ContactFields -> Model
asContactFieldsIn model contactFields =
  { model | contactFields = contactFields }

asLoginFieldsIn : Model -> LoginFields -> Model
asLoginFieldsIn model loginFields =
  { model | loginFields = loginFields }

setArticleFields : ArticleWriting -> Model -> Model
setArticleFields articleWriting model =
  { model | articleWriting = articleWriting }

asArticleFieldsIn : Model -> ArticleWriting -> Model
asArticleFieldsIn model articleWriting =
  { model | articleWriting = articleWriting }

setArticles : List Article -> Model -> Model
setArticles a b =
  setArticlesIn b a

setArticlesIn : Model -> List Article -> Model
setArticlesIn model articles =
  { model | articles =
    if List.length articles == 0 then
      Remote.Absent
    else
      Remote.Fetched articles
  }

setRawArticles : Remote (List Article) -> Model -> Model
setRawArticles a b =
  setRawArticlesIn b a

setRawArticlesIn : Model -> Remote (List Article) -> Model
setRawArticlesIn model articles =
    { model | articles = articles }

setUser : Maybe User -> Model -> Model
setUser a b =
  setUserIn b a

setUserIn : Model -> Maybe User -> Model
setUserIn model user =
  { model | user = user }

setDate : Maybe Posix -> Model -> Model
setDate a b =
  setDateIn b a

setDateIn : Model -> Maybe Posix -> Model
setDateIn model date =
  { model | date = date }

setEmailContact : String -> Model -> Model
setEmailContact email ({ contactFields } as model) =
  contactFields
  |> setEmailField email
  |> asContactFieldsIn model

setMessageContact : String -> Model -> Model
setMessageContact message ({ contactFields } as model) =
  contactFields
  |> setMessageField message
  |> asContactFieldsIn model

setEmailLogin : String -> Model -> Model
setEmailLogin email ({ loginFields } as model) =
  loginFields
  |> setEmailField email
  |> asLoginFieldsIn model

setPasswordLogin : String -> Model -> Model
setPasswordLogin password ({ loginFields } as model) =
  loginFields
  |> setPasswordField password
  |> asLoginFieldsIn model

setArticleTitle : String -> Model -> Model
setArticleTitle title ({ articleWriting } as model) =
  articleWriting
  |> articleWritingMap (setTitleField title)
  |> asArticleFieldsIn model

setArticleContent : String -> Model -> Model
setArticleContent content ({ articleWriting } as model) =
  articleWriting
  |> articleWritingMap (setContentField content)
  |> asArticleFieldsIn model

setArticleHeadline : String -> Model -> Model
setArticleHeadline headline ({ articleWriting } as model) =
  articleWriting
  |> articleWritingMap (setHeadlineField headline)
  |> asArticleFieldsIn model

setArticleHeadImage : String -> Model -> Model
setArticleHeadImage headImage ({ articleWriting } as model) =
  articleWriting
  |> articleWritingMap (setHeadImageField headImage)
  |> asArticleFieldsIn model

toggleArticleFocus : Model -> Model
toggleArticleFocus ({ articleWriting } as model) =
  articleWriting
  |> articleWritingMap toggleFocus
  |> asArticleFieldsIn model

toggleArticlePreview : Model -> Model
toggleArticlePreview ({ articleWriting } as model) =
  articleWriting
  |> articleWritingMap togglePreview
  |> asArticleFieldsIn model
