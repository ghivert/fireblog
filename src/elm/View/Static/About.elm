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
      [ Html.text "Qui suis-je ?"
        -- "Who am I?"
      ]
    , Html.p
      [ Html.Attributes.class "about--explanation" ]
      [ Html.text aboutMe ]
    ]

aboutMe : String
aboutMe =
  "Je suis un architecte logiciel polyglotte, travaillant principalement avec des langages fonctionnels. Venant du milieu académique (l'université Paris 6), je travaille principalement avec des startups en tant que freelance."
  -- "I'm a polyglot software architect, working mainly with functional language. Coming from Academic (Paris 6 University), I'm mostly working with startups, as a freelance."
