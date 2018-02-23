module View.Archives exposing (..)

import Html exposing (Html)
import Html.Attributes
-- import Html.Events

import Types exposing (..)
import View.Article

view : Model -> Html Msg
view { articles } =
  Html.div
    [ Html.Attributes.class "archives" ]
    <| case articles of
      Nothing ->
        [ Html.img
          [ Html.Attributes.src "/static/img/loading.gif"
          , Html.Attributes.class "spinner"
          ] []
        ]
      Just articles ->
        List.map View.Article.archivesLink articles
