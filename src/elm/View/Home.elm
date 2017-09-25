module View.Home exposing (..)

import Html exposing (Html)
import Html.Attributes

-- import Article exposing (Article)
import View.Article
import Types exposing (..)

view : Model -> Html Msg
view model =
  Html.div
    [ Html.Attributes.class "articles" ]
    (List.map View.Article.preview model.articles)
