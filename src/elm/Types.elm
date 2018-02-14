module Types exposing (..)

import Json.Decode
import List.Extra as List
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

type alias NewArticleFields =
  { title : String
  , content : String
  , focused : Bool
  , previewed : Bool
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
  , articles : List Article
  , menuOpen : Bool
  , user : Maybe User
  , date : Maybe Date
  , contactFields : ContactFields
  , loginFields : LoginFields
  , newArticleFields : NewArticleFields
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

asNewArticleFieldsIn : Model -> NewArticleFields -> Model
asNewArticleFieldsIn model newArticleFields =
  { model | newArticleFields = newArticleFields }

setArticles : List Article -> Model -> Model
setArticles =
  flip setArticlesIn

setArticlesIn : Model -> List Article -> Model
setArticlesIn model articles =
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

setNewArticleTitle : String -> Model -> Model
setNewArticleTitle title ({ newArticleFields } as model) =
  newArticleFields
    |> setTitleField title
    |> asNewArticleFieldsIn model

setNewArticleContent : String -> Model -> Model
setNewArticleContent content ({ newArticleFields } as model) =
  newArticleFields
    |> setContentField content
    |> asNewArticleFieldsIn model

toggleNewArticleFocus : Model -> Model
toggleNewArticleFocus ({ newArticleFields } as model) =
  newArticleFields
    |> toggleFocus
    |> asNewArticleFieldsIn model

toggleNewArticlePreview : Model -> Model
toggleNewArticlePreview ({ newArticleFields } as model) =
  newArticleFields
    |> togglePreview
    |> asNewArticleFieldsIn model

getArticleById : String -> Model -> Maybe Article
getArticleById id { articles } =
  List.find (Article.isId id) articles
