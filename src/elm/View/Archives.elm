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
    (List.map View.Article.archivesLink articles)
