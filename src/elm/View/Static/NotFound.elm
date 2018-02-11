module View.Static.NotFound exposing (view)

import Html exposing (Html)
import Html.Attributes
import Html.Extra

import Types exposing (..)
import View.Article

view : Model -> Html Msg
view { articles } =
  let lastArticle = List.head articles in
  Html.div
    [ Html.Attributes.class "not-found" ]
    [ Html.div
      [ Html.Attributes.class "not-found--404" ]
      [ Html.text "404" ]
    , Html.div
      [ Html.Attributes.class "not-found--text" ]
      [ Html.text "Page non trouvée"
        -- "Page Not Found"
      ]
    , case lastArticle of
      Nothing ->
        Html.Extra.none
      Just ({ title, uuid } as article) ->
        Html.div
          [ Html.Attributes.class "not-found--proposition" ]
          [ Html.text "Peut-être cherchez vous "
            -- "Maybe you're looking for the "
          , Html.a
            [ Html.Attributes.href <| View.Article.articleUrl article
            , Html.Extra.onPreventClick
              <| Navigation
              <| ChangePage
              <| View.Article.articleUrl article
            ]
            [ Html.text "le dernier article"
              -- "last article?"
            ]
          ]
    ]
