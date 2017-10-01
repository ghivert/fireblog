module View.Article exposing (view, preview)

import Html exposing (Html)
import Html.Attributes
-- import Html.Events
import Html.Extra

import Article exposing (Article)
import Types exposing (..)

view : Article -> Html Msg
view { title, content, tags } =
  Html.div
    [ Html.Attributes.class "articles" ]
    [ Html.div
      [ Html.Attributes.class "article" ]
      [ Html.h1
        [ Html.Attributes.class "article--title" ]
        [ Html.text title ]
      , Html.p
        [ Html.Attributes.class "article--content" ]
        [ Html.text content ]
      , Html.div
        [ Html.Attributes.class "article--tags" ]
        [ tagsLink tags ]
      ]
    ]

preview : Article -> Html Msg
preview ({ title, content, uuid, tags } as article) =
  Html.div
    [ Html.Attributes.class "article" ]
    [ Html.h1
      [ Html.Attributes.class "article--title" ]
      [ Html.text title ]
    , Html.p
      [ Html.Attributes.class "article--content" ]
      [ Html.text <| shorten content ]
    , Html.div
      [ Html.Attributes.class "article--tags" ]
      [ tagsLink tags ]
    , readMoreLink article
    ]

shorten : String -> String
shorten string =
  if String.length string > 500 then
    string
      |> String.left 500
      |> flip String.append "…"
  else
    string

tagsLink : List String -> Html Msg
tagsLink tags =
  Html.span []
    [ Html.span
      [ Html.Attributes.class "tags-keyword" ]
      [ Html.text "Tags : " ]
    , tags
      |> List.map tagLink
      |> List.intersperse (Html.text ", ")
      |> Html.span []
    ]

tagLink : String -> Html Msg
tagLink tag =
  Html.a
    [ Html.Attributes.href "#" ]
    [ Html.text tag ]

readMoreLink : Article -> Html Msg
readMoreLink { content, uuid } =
  if String.length content > 500 then
    Html.div
      [ Html.Attributes.class "article--read-more" ]
      [ Html.a
        [ Html.Attributes.href <| "/article/" ++ uuid
        , Html.Extra.onPreventClick
          <| Navigation
          <| ChangePage
          <| "/article/" ++ uuid
        ]
        [ Html.text "Read More"]
      ]
  else
    Html.Extra.none
