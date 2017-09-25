module Main exposing (..)

import Navigation exposing (Location)
import Html exposing (Html)
import Html.Attributes
import Update.Extra as Update

import Types exposing (..)
import Routing
import View.Home
import View.Debug
import View.Static.Header as Header
import View.Static.Footer as Footer

import Seeds.Articles

main : Program Never Model Msg
main =
  Navigation.program (Navigation << NewLocation)
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }

init : Location -> (Model, Cmd Msg)
init location =
  { location = location
  , route = Routing.parseLocation location
  , debugInfos = False
  , articles = Seeds.Articles.samples
  } ! []

update : Msg -> Model -> (Model, Cmd Msg)
update msg ({ debugInfos } as model) =
  case msg of
    Navigation navigation ->
      handleNavigation model navigation
    ToggleDebugInfos ->
      { model | debugInfos = not debugInfos } ! []

handleNavigation : Model -> SpaNavigation -> (Model, Cmd Msg)
handleNavigation model navigation =
  case navigation of
    NewLocation location ->
      model
        |> setLocation location
        |> setRoute (Routing.parseLocation location)
        |> Update.identity
    ReloadHomePage ->
      model ! [ Navigation.newUrl "/" ]
    ChangePage url ->
      model ! [ Navigation.newUrl url ]
    BackPage ->
      model ! [ Navigation.back 1 ]
    ForwardPage ->
      model ! [ Navigation.forward 1 ]

view : Model -> Html Msg
view model =
  Html.div []
    [ Header.view model
    , Html.div
      [ Html.Attributes.class "body" ]
      [ Html.img
        [ Html.Attributes.class "banner-photo"
        , Html.Attributes.src "static/img/banner-photo.jpg"
        ]
        []
      , Html.div
        [ Html.Attributes.class "container" ]
        [ customView model ]
      ]
    , Footer.view
    , View.Debug.debugInfosPanel model
    ]

customView : Model -> Html Msg
customView ({ route } as model) =
  case route of
    Home ->
      View.Home.view model
    About ->
      Html.text ""
    Article id ->
      Html.text ""
    Contact ->
      Html.text ""
    NotFound ->
      Html.text ""
