module View.Contact exposing (view)

import Html exposing (Html)
import Html.Attributes
import Html.Events
-- import Html.Extra

import Types exposing (..)

view : Model -> Html Msg
view { contactFields } =
  Html.div
    [ Html.Attributes.class "contact" ]
    [ Html.h1
      [ Html.Attributes.class "contact--title" ]
      [ Html.text "Contact me for anything!" ]
    , Html.p
      [ Html.Attributes.class "contact--introduction" ]
      [ Html.text "I would be glad to discuss with you, and really happy to read what you think about this blog." ]
    , contactForm contactFields
    ]

contactForm : ContactFields -> Html Msg
contactForm { email, message }=
  Html.form
    [ Html.Attributes.class "contact--form"
    , Html.Events.onSubmit <| ContactForm SendContactMail
    ]
    [ Html.label
      [ Html.Attributes.class "contact--form-email" ]
      [ Html.span [] [ Html.text "Your e-mail:" ]
      , Html.input
        [ Html.Attributes.type_ "email"
        , Html.Attributes.name "email"
        , Html.Attributes.autocomplete True
        , Html.Attributes.required True
        , Html.Attributes.placeholder "email@example.com"
        , Html.Attributes.value email
        , Html.Events.onInput (ContactForm << EmailInput)
        ]
        []
      ]
    , Html.label
      [ Html.Attributes.class "contact--form-content" ]
      [ Html.span [] [ Html.text "Your message:" ]
      , Html.textarea
        [ Html.Attributes.name "message"
        , Html.Attributes.autocomplete False
        , Html.Attributes.required True
        , Html.Attributes.value message
        , Html.Events.onInput (ContactForm << MessageInput)
        ]
        []
      ]
    , Html.input
      [ Html.Attributes.class "contact--form-submit"
      , Html.Attributes.type_ "submit"
      , Html.Attributes.value "Submit"
      ]
      [ Html.text "Submit" ]
    ]
