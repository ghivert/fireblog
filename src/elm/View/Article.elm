module View.Article exposing (view, preview, archivesLink, articleUrl)

import Html exposing (Html)
import Html.Attributes
import Html.Extra
import Date exposing (Date)
import Date.Extra.Format
import Date.Extra.Config.Config_fr_fr
import Markdown

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
      , Html.img
        [ Html.Attributes.src "/static/img/neptune/separator.png"
        , Html.Attributes.style
          [ ("align-self", "flex-start") ]
        ] []
      , Html.p
          [ Html.Attributes.class "article--content" ]
          [ Markdown.toHtml [ Html.Attributes.class "markdown--content" ] content ]
      , articleDateView date
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
      [ articleLink article ]
    , Html.img
      [ Html.Attributes.src "/static/img/neptune/separator.png"
      , Html.Attributes.style
        [ ("align-self", "flex-start") ]
      ] []
    , Html.p
      [ Html.Attributes.class "article--content" ]
      [ Markdown.toHtml [ Html.Attributes.class "markdown--content" ] <| shorten content ]
    , articleDateView date
    -- , Html.div
    --   [ Html.Attributes.class "article--tags" ]
    --   [ tagsLink tags ]
    , readMoreLink article
    ]

articleLink : Article -> Html Msg
articleLink ({ title } as article) =
  Html.a
    [ Html.Attributes.href <| articleUrl article
    , Html.Extra.onPreventClick
      <| Navigation
      <| ChangePage
      <| articleUrl article
    ]
    [ Html.text title ]

articleUrl : Article -> String
articleUrl { title, uuid } =
  "/article/" ++ Html.Extra.correctUrlString title ++ "-" ++ uuid

archivesLink : Article -> Html Msg
archivesLink ({ date } as article) =
    Html.div
      [ Html.Attributes.class "archives--metadata" ]
      [ Html.div
        [ Html.Attributes.class "archives-article" ]
        [ Html.h4
          [ Html.Attributes.class "archives-article--title" ]
          [ articleLink article ]
        ]
      , archivesDateView date
      ]

shorten : String -> String
shorten string =
  if String.length string > 500 then
    string
      |> String.left 500
      |> flip String.append "…"
  else
    string

dateView : String -> Date -> Html Msg
dateView class date =
  Html.div
    [ Html.Attributes.class class ]
    [ Html.text <|
      Date.Extra.Format.format
        Date.Extra.Config.Config_fr_fr.config
        frenchDateFormat
        date
    ]

articleDateView : Date -> Html Msg
articleDateView =
  dateView "article--date"

archivesDateView : Date -> Html Msg
archivesDateView =
  dateView "archives--date"

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
readMoreLink ({ content, title, uuid } as article) =
  if String.length content > 500 then
    Html.div
      [ Html.Attributes.class "article--read-more" ]
      [ Html.a
        [ Html.Attributes.href <| articleUrl article
        , Html.Extra.onPreventClick
          <| Navigation
          <| ChangePage
          <| articleUrl article
        ]
        [ Html.text "Lire la suite" ]
      ]
  else
    Html.Extra.none
