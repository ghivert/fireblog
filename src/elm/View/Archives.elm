module View.Archives exposing (..)

import Html exposing (Html)
import Html.Attributes
-- import Html.Events

import Types exposing (..)
import View.Article
import Remote

view : Model -> Html Msg
view { articles } =
  Html.div
    [ Html.Attributes.class "archives" ]
    <| case articles of
      Remote.Fetched articles ->
        List.map View.Article.archivesLink articles
      _ ->
        [ Html.img
          [ Html.Attributes.src "/static/img/loading.gif"
          , Html.Attributes.class "spinner"
          ] []
        ]
