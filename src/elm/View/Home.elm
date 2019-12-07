module View.Home exposing (..)

import Html exposing (Html)
import Html.Attributes

import View.Article
import Types exposing (..)
import Remote
import Styles.Neptune.Main as Styles
import Styles.Main as CommonStyles

view : Model -> Html Msg
view { articles } =
  Html.div
    [ Html.Attributes.class Styles.articles ]
      <| case articles of
        Remote.Fetched fetchedArticles ->
          List.map View.Article.preview fetchedArticles
        _ ->
          [ Html.img
            [ Html.Attributes.src "/img/loading.gif"
            , Html.Attributes.class CommonStyles.spinner
            ] []
          ]
