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

type NewArticleAction
  = NewArticleTitle String
  | NewArticleContent String
  | NewArticleSubmit
  | NewArticleToggler
  | NewArticlePreview
  | NewArticleRemove
  | NewArticleWrite

type Msg
  = Navigation SpaNavigation
  | HamburgerMenu MenuAction
  | Resizes Size
  | DateNow Date
  | ContactForm ContactAction
  | LoginForm LoginAction
  | NewArticleForm NewArticleAction
  | GetPosts Json.Decode.Value
  | GetUser Json.Decode.Value
  | AcceptPost Bool
  | RequestPosts String

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

type NewArticleWriting
  = NewArticle NewArticleFields
  | SentArticle

newArticleWritingMap : (NewArticleFields -> NewArticleFields) -> NewArticleWriting -> NewArticleWriting
newArticleWritingMap mapper writing =
  case writing of
    NewArticle fields ->
      NewArticle (mapper fields)
    SentArticle ->
      SentArticle

type alias NewArticleFields =
  { title : String
  , content : String
  , focused : Bool
  , previewed : Bool
  }

defaultNewArticleFields : NewArticleFields
defaultNewArticleFields =
  { title = ""
  , content = ""
  , focused = False
  , previewed = False
  }

setTitleField : String -> NewArticleFields -> NewArticleFields
setTitleField title fields =
  { fields | title = title }

setContentField : String -> NewArticleFields -> NewArticleFields
setContentField content fields =
  { fields | content = content }

toggleFocus : NewArticleFields -> NewArticleFields
toggleFocus ({ focused } as fields) =
  { fields | focused = not focused }

togglePreview : NewArticleFields -> NewArticleFields
togglePreview ({ previewed } as fields) =
  { fields | previewed = not previewed }

type alias Model =
  { location : Location
  , route : Route
  , articles : Maybe (List Article)
  , menuOpen : Bool
  , user : Maybe User
  , date : Maybe Date
  , contactFields : ContactFields
  , loginFields : LoginFields
  , newArticleWriting : NewArticleWriting
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

asNewArticleFieldsIn : Model -> NewArticleWriting -> Model
asNewArticleFieldsIn model newArticleWriting =
  { model | newArticleWriting = newArticleWriting }

setArticles : List Article -> Model -> Model
setArticles =
  flip setArticlesIn

setArticlesIn : Model -> List Article -> Model
setArticlesIn model articles =
    { model | articles = Just articles }

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

setNewArticleTitle : String -> Model -> Model
setNewArticleTitle title ({ newArticleWriting } as model) =
  newArticleWriting
    |> newArticleWritingMap (setTitleField title)
    |> asNewArticleFieldsIn model

setNewArticleContent : String -> Model -> Model
setNewArticleContent content ({ newArticleWriting } as model) =
  newArticleWriting
    |> newArticleWritingMap (setContentField content)
    |> asNewArticleFieldsIn model

toggleNewArticleFocus : Model -> Model
toggleNewArticleFocus ({ newArticleWriting } as model) =
  newArticleWriting
    |> newArticleWritingMap toggleFocus
    |> asNewArticleFieldsIn model

toggleNewArticlePreview : Model -> Model
toggleNewArticlePreview ({ newArticleWriting } as model) =
  newArticleWriting
    |> newArticleWritingMap togglePreview
    |> asNewArticleFieldsIn model
