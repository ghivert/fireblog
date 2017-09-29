module Types exposing (..)

import Navigation exposing (Location)
import Window exposing (Size)
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
  | Contact
  | NotFound

type Msg
  = Navigation SpaNavigation
  | ToggleMenu
  | Resizes Size

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
