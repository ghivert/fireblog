module View.Home exposing (..)

import Html exposing (Html)
import Html.Attributes

import View.Article
import Types exposing (..)

view : Model -> Html Msg
view { articles } =
  Html.div
    [ Html.Attributes.class "articles" ]
    <| case articles of
      Nothing ->
        [ Html.img
          [ Html.Attributes.src "/static/img/loading.gif"
          , Html.Attributes.class "spinner"
          ] [] 
        ]
      Just articles ->
        List.map View.Article.preview articles
