module Types exposing (..)

import Json.Decode
import List.Extra as List
import Navigation exposing (Location)
import Window exposing (Size)
import Date exposing (Date)
import Article exposing (Article)

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
  | NotFound

type MenuAction
  = ToggleMenu

type ContactAction
  = SendContactMail
  | EmailInput String
  | MessageInput String

type Msg
  = Navigation SpaNavigation
  | HamburgerMenu MenuAction
  | Resizes Size
  | DateNow Date
  | ContactForm ContactAction
  | GetPosts Json.Decode.Value

type alias ContactFields =
  { email : String
  , message : String
  }

setEmailField : String -> ContactFields -> ContactFields
setEmailField email fields =
  { fields | email = email }

setMessageField : String -> ContactFields -> ContactFields
setMessageField message fields =
  { fields | message = message }

type alias Model =
  { location : Location
  , route : Route
  , articles : List Article
  , menuOpen : Bool
  , contactFields : ContactFields
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

setArticlesIn : Model -> List Article -> Model
setArticlesIn model articles =
    { model | articles = articles }

getArticleById : String -> Model -> Maybe Article
getArticleById id { articles } =
  List.find (Article.isId id) articles
