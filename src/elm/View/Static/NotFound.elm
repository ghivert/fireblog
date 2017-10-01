module View.Static.NotFound exposing (view)

import Html exposing (Html)
import Html.Attributes
import Html.Extra

import Types exposing (..)

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
      [ Html.text "Page Not Found" ]
    , case lastArticle of
      Nothing ->
        Html.Extra.none
      Just { uuid } ->
        Html.div
          [ Html.Attributes.class "not-found--proposition" ]
          [ Html.text "Maybe you're looking for the "
          , Html.a
            [ Html.Attributes.href <| "/article/" ++ uuid
            , Html.Extra.onPreventClick
              <| Navigation
              <| ChangePage
              <| "/article/" ++ uuid
            ]
            [ Html.text "last article?" ]
          ]
    ]
