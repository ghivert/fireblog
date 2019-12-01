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
      Remote.Fetched fetchedArticles ->
        List.map View.Article.archivesLink fetchedArticles
      _ ->
        [ Html.img
          [ Html.Attributes.src "/img/loading.gif"
          , Html.Attributes.class "spinner"
          ] []
        ]
