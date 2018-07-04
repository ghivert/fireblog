module View.Article.Edit exposing (view)

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Markdown

import Types exposing (..)
import View.Static.NotFound

view : Model -> Html Msg
view ({ articleWriting } as model) =
    case articleWriting of
      NewArticle ({ focused } as fields) ->
        Html.map ArticleForm
          <| viewInternal Nothing
            (columnIfFocused focused)
            (articleEdit fields)
      EditArticle fields ->
        Html.map ArticleForm
          <| viewInternal Nothing []
            (articleEdit fields)
      SentArticle ->
        Html.map ArticleForm
          <| viewInternal (Just "sent") []
            [ Html.h1 [] [ Html.text "Article envoyé !" ]
            , Html.button
              [ Html.Attributes.value "Envoyer un autre article ?"
              , Html.Events.onClick ArticleWrite
              ]
              [ Html.text "Envoyer un autre article ?" ]
            ]
      NotFoundArticle ->
        View.Static.NotFound.view model

columnIfFocused : Bool -> List (String, String)
columnIfFocused focused =
  if focused then
    [ ("flex-direction", "column") ]
  else
    []

viewInternal : Maybe String -> List (String, String) -> List (Html msg) -> Html msg
viewInternal extraClass style content =
    Html.div
      [ Html.Attributes.class "dashboard"
      , Html.Attributes.style style
      ]
      [ Html.div
        [ Html.Attributes.class
          <| (++) "dashboard-left"
          <| Maybe.withDefault ""
          <| Maybe.map ((++) " ")
          <| extraClass
        ]
        content
      , Html.div
        [ Html.Attributes.class "dashboard-right" ] []
      ]

articleEdit : ArticleFields -> List (Html ArticleAction)
articleEdit ({ previewed } as fields) =
  if previewed then
    articlePreview fields
  else
    articleEdition fields

articlePreview : ArticleFields -> List (Html ArticleAction)
articlePreview ({ title, content } as articleFields) =
  [ Html.h2 []
    [ Html.text "Nouvel article | Prévisualisation" ]
  , Html.h3 []
    [ Html.text title ]
  , Html.img
    [ Html.Attributes.src "/static/img/neptune/separator.png"
    , Html.Attributes.style
      [ ("align-self", "flex-start") ]
    ] []
  , Markdown.toHtml [ Html.Attributes.class "markdown--content" ] content
  , buttonRow articleFields
  ]

articleEdition : ArticleFields -> List (Html ArticleAction)
articleEdition ({ title, content, focused } as articleFields) =
  [ Html.h2 []
    [ Html.text "Nouvel article | Édition" ]
  , Html.input
    [ Html.Attributes.type_ "text"
    , Html.Attributes.placeholder "Titre…"
    , Html.Attributes.value title
    , Html.Events.onInput ArticleTitle
    , Html.Events.onFocus ArticleToggler
    , Html.Events.onBlur ArticleToggler
    ] []
  , Html.textarea
    [ Html.Attributes.placeholder "Votre contenu en Markdown…"
    , Html.Attributes.value content
    , Html.Events.onInput ArticleContent
    , Html.Events.onFocus ArticleToggler
    , Html.Events.onBlur ArticleToggler
    , Html.Attributes.style
      <| if focused then [ ("min-height", "200px") ] else []
    ] []
  , buttonRow articleFields
  ]

buttonRow : ArticleFields -> Html ArticleAction
buttonRow { title, content, previewed } =
  let previewButtonText = if previewed then "Retourner à l'édition" else "Prévisualiser"
      activatedButton = title == "" || content == ""
  in
  Html.div
    [ Html.Attributes.class "dashboard--button-row" ]
    [ genericButton
      { value = "Envoyer"
      , flex = 0.5
      , disabled = activatedButton
      , onClick = ArticleSubmit
      }
    , genericButton
      { value = previewButtonText
      , flex = 1.0
      , disabled = activatedButton
      , onClick = ArticlePreview
      }
    ]

type alias GenericButtonValue msg =
  { value : String
  , flex : Float
  , disabled : Bool
  , onClick : msg
  }

genericButton : GenericButtonValue msg -> Html msg
genericButton { value, flex, disabled, onClick } =
  Html.button
    [ Html.Attributes.value value
    , Html.Attributes.style [ ("flex", (toString flex)) ]
    , Html.Attributes.disabled disabled
    , Html.Events.onClick onClick
    ]
    [ Html.text value ]
