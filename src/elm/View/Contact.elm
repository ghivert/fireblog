module View.Contact exposing (view)

import Html exposing (Html)
import Html.Attributes
import Html.Events

import Types exposing (..)
import Styles.Neptune.Main as Styles

view : Model -> Html ContactAction
view { contactFields } =
  Html.div
    [ Html.Attributes.class Styles.contact ]
    [ Html.h1 []
      [ Html.text "Contactez-moi pour n'importe quoi !" ]
    , Html.p
      [ Html.Attributes.class Styles.contactIntroduction ]
      [ Html.text
        "Je serais ravi de discuter avec vous, et très content de lire ce que vous pensez de ce blog." ]
    , Html.p []
      [ Html.text "Écrivez-moi à "
      , Html.a [ Html.Attributes.href "mailto:hivert.is.coming@gmail.com" ]
        [ Html.text "hivert.is.coming@gmail.com" ]
      ]
    ]

contactForm : ContactFields -> Html ContactAction
contactForm { email, message }=
  Html.form
    [ Html.Attributes.class "contact--form"
    , Html.Events.onSubmit SendContactMail
    ]
    [ emailInput email
    , messageInput message
    , submitButton
    ]

emailInput : String -> Html ContactAction
emailInput email =
  Html.label
    [ Html.Attributes.class "contact--form-email" ]
    [ Html.span []
      [ Html.text "Votre e-mail :" ]
    , Html.input
      [ Html.Attributes.type_ "email"
      , Html.Attributes.name "email"
      , Html.Attributes.autocomplete True
      , Html.Attributes.required True
      , Html.Attributes.placeholder "email@exemple.com"
      , Html.Attributes.value email
      , Html.Events.onInput ContactEmailInput
      ]
      []
    ]

messageInput : String -> Html ContactAction
messageInput message =
  Html.label
    [ Html.Attributes.class "contact--form-content" ]
    [ Html.span []
      [ Html.text "Votre message :" ]
    , Html.textarea
      [ Html.Attributes.name "message"
      , Html.Attributes.autocomplete False
      , Html.Attributes.required True
      , Html.Attributes.value message
      , Html.Events.onInput ContactMessageInput
      ]
      []
    ]

submitButton : Html ContactAction
submitButton =
  Html.input
    [ Html.Attributes.class "contact--form-submit"
    , Html.Attributes.type_ "submit"
    , Html.Attributes.value "Envoyer"
    ]
    [ Html.text "Envoyer" ]
