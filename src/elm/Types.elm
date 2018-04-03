module Types exposing (..)

import Json.Decode
import Navigation exposing (Location)
import Window exposing (Size)
import Date exposing (Date)

import Article exposing (Article)
import User exposing (User)

type SpaNavigation
  = NewLocation Location
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
  | ArticleSubmit
  | ArticleToggler
  | ArticlePreview
  | ArticleRemove
  | ArticleWrite

type Msg
  = Navigation SpaNavigation
  | HamburgerMenu MenuAction
  | Resizes Size
  | DateNow Date
  | ContactForm ContactAction
  | LoginForm LoginAction
  | ArticleForm ArticleAction
  | GetPosts Json.Decode.Value
  | GetUser Json.Decode.Value
  | AcceptPost Bool
  | RequestPosts String
  | UpdateTitle
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

articleWritingMap : (ArticleFields -> ArticleFields) -> ArticleWriting -> ArticleWriting
articleWritingMap mapper writing =
  case writing of
    NewArticle fields ->
      NewArticle (mapper fields)
    EditArticle fields ->
      EditArticle (mapper fields)
    SentArticle ->
      SentArticle

type alias ArticleFields =
  { title : String
  , content : String
  , focused : Bool
  , previewed : Bool
  , uuid : Maybe String
  }

defaultArticleFields : ArticleFields
defaultArticleFields =
  { title = ""
  , content = ""
  , focused = False
  , previewed = False
  , uuid = Nothing
  }

setTitleField : String -> ArticleFields -> ArticleFields
setTitleField title fields =
  { fields | title = title }

setContentField : String -> ArticleFields -> ArticleFields
setContentField content fields =
  { fields | content = content }

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
  { location : Location
  , route : Route
  , articles : Maybe (List Article)
  , menuOpen : Bool
  , user : Maybe User
  , date : Maybe Date
  , contactFields : ContactFields
  , loginFields : LoginFields
  , articleWriting : ArticleWriting
  }

setLocation : Location -> Model -> Model
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

asArticleFieldsIn : Model -> ArticleWriting -> Model
asArticleFieldsIn model articleWriting =
  { model | articleWriting = articleWriting }

setArticles : List Article -> Model -> Model
setArticles =
  flip setArticlesIn

setArticlesIn : Model -> List Article -> Model
setArticlesIn model articles =
    { model | articles = Just articles }

setRawArticles : Maybe (List Article) -> Model -> Model
setRawArticles =
  flip setRawArticlesIn

setRawArticlesIn : Model -> Maybe (List Article) -> Model
setRawArticlesIn model articles =
    { model | articles = articles }

setUser : Maybe User -> Model -> Model
setUser =
  flip setUserIn

setUserIn : Model -> Maybe User -> Model
setUserIn model user =
  { model | user = user }

setDate : Maybe Date -> Model -> Model
setDate =
  flip setDateIn

setDateIn : Model -> Maybe Date -> Model
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
