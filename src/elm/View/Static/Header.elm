module View.Static.Header exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Types exposing (..)

view : Model -> Html Msg
view { debugInfos, route }=
  Html.div
    [ Html.Attributes.class "navbar" ]
    [ Html.div
      [ Html.Attributes.class "navbar-brand" ]
      [ Html.a
        [ Html.Attributes.class "navbar-brand--link" ]
        [ Html.text "Neptune" ]
      ]
    , Html.div
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
          "navbar-menu--link cursor" ++ (if debugInfos then " active" else "")
        , Html.Events.onClick ToggleDebugInfos
        ]
        [ Html.text "Debug" ]
      ]
    ]

link : Bool -> String -> Html msg
link active label =
  Html.a
    [ Html.Attributes.class <|
      "navbar-menu--link" ++ if active then " active" else ""
    ]
    [ Html.text label ]
