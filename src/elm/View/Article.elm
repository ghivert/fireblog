module View.Article exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events

import Article exposing (Article)
import Types exposing (..)

preview : Article -> Html Msg
preview { title, content } =
  Html.div
    [ Html.Attributes.class "article-preview" ]
    [ Html.div
      [ Html.Attributes.class "article-preview--title" ]
      [ Html.text title ]
    , Html.div
      [ Html.Attributes.class "article-preview--content" ]
      [ Html.text content ]
    ]
