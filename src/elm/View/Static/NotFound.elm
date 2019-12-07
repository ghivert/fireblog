module View.Static.NotFound exposing (view)

import Html exposing (Html)
import Html.Attributes
import Html.Extra

import Types exposing (..)
import View.Article
import Remote
import Styles.Neptune.Main as Styles

view : Model -> Html Msg
view { articles } =
  let lastArticle = List.head (Remote.withDefault [] articles) in
  Html.div
    [ Html.Attributes.class Styles.notFound ]
    [ Html.div
      [ Html.Attributes.class Styles.notFound404 ]
      [ Html.text "404" ]
    , Html.div
      [ Html.Attributes.class Styles.notFoundText ]
      [ Html.text "Page non trouvée" ]
    , case lastArticle of
      Nothing -> Html.Extra.none
      Just ({ title, uuid } as article) ->
        Html.div []
          [ Html.text "Peut-être cherchez vous "
          , Html.a
            [ Html.Attributes.href <| View.Article.articleUrl article
            , Html.Extra.onPreventClick
              <| Navigation
              <| ChangePage
              <| View.Article.articleUrl article
            ]
            [ Html.text "le dernier article" ]
          ]
    ]
