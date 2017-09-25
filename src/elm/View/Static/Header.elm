module View.Static.Header exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Types exposing (..)

view : Model -> Html Msg
view model =
  Html.div
    [ Html.Attributes.class "navbar" ]
    [ Html.div
      [ Html.Attributes.class "navbar-brand" ]
      [ Html.a
        [ Html.Attributes.class "navbar-brand--link" ]
        [ Html.text "Neptune" ]
      ]
    , navbarMenu model
    ]

navbarMenu : Model -> Html Msg
navbarMenu { debugInfos, route } =
  Html.div
    [ Html.Attributes.class "navbar-menu" ]
    [ link (route == Home) "Home"
    , link (route == About) "About"
    , link (case route of
        Article _ ->
          True
        _ ->
          False) "Archive"
    , link (route == Contact) "Contact"
    , Html.a
      [ Html.Attributes.class <|
        addActive debugInfos "navbar-menu--link cursor"
      , Html.Events.onClick ToggleDebugInfos
      ]
      [ Html.text "Debug" ]
    ]

link : Bool -> String -> Html msg
link active label =
  Html.a
    [ Html.Attributes.class <| addActive active "navbar-menu--link" ]
    [ Html.text label ]

addActive : Bool -> String -> String
addActive active classes =
  classes ++ if active then " active" else ""
