module View.Dashboard exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Markdown

import Types exposing (..)

view : Model -> Html Msg
view { newArticleWriting } =
  Html.map NewArticleForm <|
    case newArticleWriting of
      NewArticle ({ focused, previewed } as fields) ->
        viewInternal Nothing
          (if focused then
            [ ("flex-direction", "column") ]
          else
            [])
          (if previewed then
              newArticlePreview fields
            else
              newArticleEdition fields)
      SentArticle ->
        viewInternal (Just "sent") []
          [ Html.h1 [] [ Html.text "Article envoyé !" ]
          , Html.button
            [ Html.Attributes.value "Envoyer un autre article ?"
            , Html.Events.onClick NewArticleWrite
            ]
            [ Html.text "Envoyer un autre article ?" ]
          ]

viewInternal : Maybe String -> List (String, String) -> List (Html NewArticleAction) -> Html NewArticleAction
viewInternal extraClass style content =
  Html.div
    [ Html.Attributes.class "dashboard"
    , Html.Attributes.style style
    ]
    [ Html.div
      [ Html.Attributes.class <| "dashboard-left" ++ (Maybe.withDefault "" extraClass) ]
      content
    , Html.div
      [ Html.Attributes.class "dashboard-right" ] []
    ]


newArticlePreview : NewArticleFields -> List (Html NewArticleAction)
newArticlePreview ({ title, content } as newArticleFields) =
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
  , buttonRow newArticleFields
  ]

newArticleEdition : NewArticleFields -> List (Html NewArticleAction)
newArticleEdition ({ title, content, focused } as newArticleFields) =
  [ Html.h2 []
    [ Html.text "Nouvel article | Édition" ]
  , Html.input
    [ Html.Attributes.type_ "text"
    , Html.Attributes.placeholder "Titre…"
    , Html.Attributes.value title
    , Html.Events.onInput NewArticleTitle
    , Html.Events.onFocus NewArticleToggler
    , Html.Events.onBlur NewArticleToggler
    ] []
  , Html.textarea
    [ Html.Attributes.placeholder "Votre contenu en Markdown…"
    , Html.Attributes.value content
    , Html.Events.onInput NewArticleContent
    , Html.Events.onFocus NewArticleToggler
    , Html.Events.onBlur NewArticleToggler
    , Html.Attributes.style <|
      if focused then
        [ ("min-height", "200px") ]
      else
        []
    ] []
  , buttonRow newArticleFields
  ]

buttonRow : NewArticleFields -> Html NewArticleAction
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
      , onClick = NewArticleSubmit
      }
    , genericButton
      { value = previewButtonText
      , flex = 1.0
      , disabled = activatedButton
      , onClick = NewArticlePreview
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
