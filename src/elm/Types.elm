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

type Msg
  = Navigation SpaNavigation
  | HamburgerMenu MenuAction
  | Resizes Size
  | DateNow Date
  | ContactForm ContactAction
  | LoginForm LoginAction
  | GetPosts Json.Decode.Value
  | GetUser Json.Decode.Value

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

type alias Model =
  { location : Location
  , route : Route
  , articles : List Article
  , menuOpen : Bool
  , user : Maybe User
  , contactFields : ContactFields
  , loginFields : LoginFields
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

setArticlesIn : Model -> List Article -> Model
setArticlesIn model articles =
    { model | articles = articles }

setUser : Maybe User -> Model -> Model
setUser =
  flip setUserIn

setUserIn : Model -> Maybe User -> Model
setUserIn model user =
  { model | user = user }

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

getArticleById : String -> Model -> Maybe Article
getArticleById id { articles } =
  List.find (Article.isId id) articles
