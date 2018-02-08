module View.Dashboard exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events

import Types exposing (..)

view : Model -> Html Msg
view model =
  Html.div []
    [ Html.button
      [ Html.Events.onClick SubmitArticles ]
      [ Html.text "submit posts" ]
    ]
