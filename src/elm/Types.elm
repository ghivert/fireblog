module Types exposing (..)

import Navigation exposing (Location)
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
  | ToggleDebugInfos

type alias Model =
  { location : Location
  , route : Route
  , debugInfos : Bool
  , articles : List Article
  }

setLocation : Location -> Model -> Model
setLocation location model =
  { model | location = location }

setRoute : Route -> Model -> Model
setRoute route model =
  { model | route = route }
