module View.Article exposing (view, preview, directLink)

import Html exposing (Html)
import Html.Attributes
import Html.Extra
import Date exposing (Date)
import Date.Extra.Format
import Date.Extra.Config.Config_fr_fr

import Article exposing (Article)
import Types exposing (..)

view : Article -> Html Msg
view { title, content, tags, date } =
  Html.div
    [ Html.Attributes.class "articles" ]
    [ Html.div
      [ Html.Attributes.class "article" ]
      [ Html.h1
        [ Html.Attributes.class "article--title" ]
        [ Html.text title ]
      , dateView date
      , Html.p
        [ Html.Attributes.class "article--content" ]
        [ Html.text content ]
      -- , Html.div
      --   [ Html.Attributes.class "article--tags" ]
      --   [ tagsLink tags ]
      ]
    ]

preview : Article -> Html Msg
preview ({ title, content, uuid, tags, date } as article) =
  Html.div
    [ Html.Attributes.class "article" ]
    [ Html.h1
      [ Html.Attributes.class "article--title" ]
      [ Html.a
        [ Html.Attributes.href <| "/article/" ++ Html.Extra.correctUrlString title ++ uuid
        , Html.Extra.onPreventClick
          <| Navigation
          <| ChangePage
          <| "/article/" ++ Html.Extra.correctUrlString title ++ uuid
        ]
        [ Html.text title ]
      ]
    , Html.p
      [ Html.Attributes.class "article--content" ]
      [ Html.text <| shorten content ]
    , dateView date
    -- , Html.div
    --   [ Html.Attributes.class "article--tags" ]
    --   [ tagsLink tags ]
    , readMoreLink article
    ]

directLink : Article -> Html Msg
directLink ({ title, uuid, date } as article) =
  Html.div
    [ Html.Attributes.class "archives-article" ]
    [ Html.h4
      [ Html.Attributes.class "archives-article--title" ]
      [ Html.text title ]
    ]

shorten : String -> String
shorten string =
  if String.length string > 500 then
    string
      |> String.left 500
      |> flip String.append "…"
  else
    string

dateView : Date -> Html Msg
dateView date =
  Html.div
    [ Html.Attributes.class "article--date" ]
    [ Html.text <|
      Date.Extra.Format.format
        Date.Extra.Config.Config_fr_fr.config
        frenchDateFormat
        date
    ]

{-| Unused while I18n not activated. -}
englishDateFormat : String
englishDateFormat =
  "Posted on %d %B %Y"

frenchDateFormat : String
frenchDateFormat =
  "Posté le %d %B %Y"

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
readMoreLink { content, title, uuid } =
  if String.length content > 500 then
    Html.div
      [ Html.Attributes.class "article--read-more" ]
      [ Html.a
        [ Html.Attributes.href <| "/article/" ++ Html.Extra.correctUrlString title ++ uuid
        , Html.Extra.onPreventClick
          <| Navigation
          <| ChangePage
          <| "/article/" ++ Html.Extra.correctUrlString title ++ uuid
        ]
        [ Html.text "Read More"]
      ]
  else
    Html.Extra.none
