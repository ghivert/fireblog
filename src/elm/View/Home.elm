module View.Home exposing (..)

import Html exposing (Html)
import Html.Attributes

import View.Article
import Types exposing (..)
import Remote

view : Model -> Html Msg
view { articles } =
  Html.div
    [ Html.Attributes.class "articles" ]
    <| case articles of
      Remote.Fetched fetchedArticles ->
        List.map View.Article.preview fetchedArticles
      _ ->
        [ Html.img
          [ Html.Attributes.src "/img/loading.gif"
          , Html.Attributes.class "spinner"
          ] []
        ]
