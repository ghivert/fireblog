module View.Article exposing (..)

import Html exposing (Html)
import Html.Attributes
-- import Html.Events
import Html.Extra as Html

import Article exposing (Article)
import Types exposing (..)

preview : Article -> Html Msg
preview ({ title, content, uuid, tags } as article) =
  Html.div
    [ Html.Attributes.class "article-preview" ]
    [ Html.div
      [ Html.Attributes.class "article-preview--title" ]
      [ Html.text title ]
    , Html.div
      [ Html.Attributes.class "article-preview--content" ]
      [ Html.text <| shorten content ]
    , Html.div
      [ Html.Attributes.class "article-preview--tags" ]
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
      [ Html.Attributes.class "article-preview--read-more" ]
      [ Html.a
        [ Html.Attributes.href <| "/" ++ uuid ]
        [ Html.text "Read More"]
      ]
  else
    Html.none
