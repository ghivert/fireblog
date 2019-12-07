module View.Article exposing (view, preview, archivesLink, articleUrl)

import Html exposing (Html)
import Html.Attributes
import Html.Extra
import Markdown
import Time exposing (Posix)

import Article exposing (Article)
import Types exposing (..)
import Styles.Neptune.Main as Styles
import Styles.Neptune.Markdown as MdStyles

view : Article -> Html Msg
view { title, content, tags, date } =
  Html.div
    [ Html.Attributes.class Styles.articles ]
    [ Html.div
      [ Html.Attributes.class Styles.article ]
      [ Html.h1
        [ Html.Attributes.class Styles.articleTitle ]
        [ Html.text title ]
      , Html.img
        [ Html.Attributes.src "/img/neptune/separator.png"
        , Html.Attributes.style "align-self" "flex-start"
        ] []
      , Html.p
          [ Html.Attributes.class Styles.articleContent ]
          [ Markdown.toHtml [ Html.Attributes.class MdStyles.markdownContent ] content ]
      , articleDateView date
      -- , Html.div
      --   [ Html.Attributes.class "article--tags" ]
      --   [ tagsLink tags ]
      ]
    ]

preview : Article -> Html Msg
preview ({ title, content, uuid, tags, date } as article) =
  Html.div
    [ Html.Attributes.class Styles.article ]
    [ Html.h1
      [ Html.Attributes.class Styles.articleTitle ]
      [ articleLink article ]
    , Html.img
      [ Html.Attributes.src "/img/neptune/separator.png"
      , Html.Attributes.style "align-self" "flex-start"
      ] []
    , Html.p
      [ Html.Attributes.class Styles.articleContent ]
      [ Markdown.toHtml [ Html.Attributes.class MdStyles.markdownContent ] <| shorten content ]
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
  "/article/" ++ Html.Extra.createUrl title

archivesLink : Article -> Html Msg
archivesLink ({ date } as article) =
    Html.div
      [ Html.Attributes.class Styles.archivesMetadata ]
      [ Html.div
        [ Html.Attributes.class Styles.archivesArticle ]
        [ Html.h4
          [ Html.Attributes.class Styles.archivesTitle ]
          [ articleLink article ]
        ]
      , archivesDateView date
      ]

shorten : String -> String
shorten string =
  if String.length string > 500 then
    string
    |> String.left 500
    |> \e -> String.append e "…"
  else
    string

dateView : String -> Posix -> Html Msg
dateView class date =
  Html.div
    [ Html.Attributes.class class ]
    [ Html.text "" ]
    --   <| Date.Extra.Format.format
    --     Date.Extra.Config.Config_fr_fr.config
    --     frenchDateFormat
    --     date
    -- ]

articleDateView : Posix -> Html Msg
articleDateView =
  dateView Styles.articleDate

archivesDateView : Posix -> Html Msg
archivesDateView =
  dateView Styles.archivesDate

{-| Unused while I18n not activated. -}
englishDateFormat : String
englishDateFormat =
  "Posted on %d %B %Y"

frenchDateFormat : String
frenchDateFormat =
  "Posté le %d %B %Y"

tagLink : String -> Html Msg
tagLink tag =
  Html.a
    [ Html.Attributes.href "#" ]
    [ Html.text tag ]

readMoreLink : Article -> Html Msg
readMoreLink ({ content, title, uuid } as article) =
  if String.length content > 500 then
    Html.div
      [ Html.Attributes.class Styles.articleReadMore ]
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
