module Main exposing (..)

import Navigation exposing (Location)
import Html exposing (Html)
import Html.Attributes
import Html.Extra as Html
import Update.Extra as Update
import Window

import Types exposing (..)
import Routing
import View.Home
import View.Static.Header as Header
import View.Static.Footer as Footer

import Seeds.Articles

main : Program Never Model Msg
main =
  Navigation.program (Navigation << NewLocation)
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

subscriptions : Model -> Sub Msg
subscriptions model =
  Window.resizes Resizes

init : Location -> (Model, Cmd Msg)
init location =
  { location = location
  , route = Routing.parseLocation location
  , articles = Seeds.Articles.samples
  , menuOpen = False
  } ! []

update : Msg -> Model -> (Model, Cmd Msg)
update msg ({ menuOpen } as model) =
  case msg of
    Navigation navigation ->
      handleNavigation model navigation
    ToggleMenu ->
      toggleMenu model ! []
    Resizes { width, height } ->
      if width >= 736 then
        model
          |> closeMenu
          |> Update.identity
      else
        model ! []
        
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
    ]

customView : Model -> Html Msg
customView ({ route } as model) =
  case route of
    Home ->
      View.Home.view model
    About ->
      Html.none
    Article id ->
      Html.none
    Contact ->
      Html.none
    NotFound ->
      Html.none
