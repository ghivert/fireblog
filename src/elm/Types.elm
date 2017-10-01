module Types exposing (..)

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

type Msg
  = Navigation SpaNavigation
  | HamburgerMenu MenuAction
  | Resizes Size
  | DateNow Date

type alias Model =
  { location : Location
  , route : Route
  , articles : List Article
  , menuOpen : Bool
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

getArticleById : String -> Model -> Maybe Article
getArticleById id { articles } =
  List.find (Article.isId id) articles
