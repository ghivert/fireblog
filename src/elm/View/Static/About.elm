module View.Static.About exposing (view)

import Html exposing (Html)
import Html.Attributes

import Types exposing (..)

view : Model -> Html Msg
view model =
  Html.div
    [ Html.Attributes.class "about" ]
    [ Html.h1
      [ Html.Attributes.class "about--whoami" ]
      [ Html.text "Who am I?" ]
    , Html.p
      [ Html.Attributes.class "about--explanation" ]
      [ Html.text aboutMe ]
    ]

aboutMe : String
aboutMe =
  "I'm a polyglot software architect, working mainly with functional language. Coming from Academic (Paris 6 University), I'm mostly working with startups, as a freelance."
