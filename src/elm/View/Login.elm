module View.Login exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events

import Types exposing (..)

view : Model -> Html LoginAction
view { loginFields } =
  Html.div
    [ Html.Attributes.class "contact" ]
    [ Html.h1
      [ Html.Attributes.class "contact--title" ]
      [ Html.text "Log-In" ]
    , loginForm loginFields
    ]

loginForm : LoginFields -> Html LoginAction
loginForm { email, password } =
  Html.form
    [ Html.Attributes.class "contact--form"
    , Html.Events.onSubmit LoginUser
    ]
    [ emailInput email
    , passwordInput password
    , submitButton
    ]

emailInput : String -> Html LoginAction
emailInput email =
  Html.label
    [ Html.Attributes.class "contact--form-email" ]
    [ Html.span [] [ Html.text "E-mail:" ]
    , Html.input
      [ Html.Attributes.type_ "email"
      , Html.Attributes.name "email"
      , Html.Attributes.autocomplete True
      , Html.Attributes.required True
      , Html.Attributes.placeholder "email@example.com"
      , Html.Attributes.value email
      , Html.Events.onInput LoginEmailInput
      ]
      []
    ]

passwordInput : String -> Html LoginAction
passwordInput password =
  Html.label
    [ Html.Attributes.class "contact--form-content" ]
    [ Html.span [] [ Html.text "Password:" ]
    , Html.input
      [ Html.Attributes.type_ "password"
      , Html.Attributes.name "password"
      , Html.Attributes.autocomplete False
      , Html.Attributes.required True
      , Html.Attributes.value password
      , Html.Events.onInput LoginPasswordInput
      ]
      []
    ]

submitButton : Html LoginAction
submitButton =
  Html.input
    [ Html.Attributes.class "contact--form-submit"
    , Html.Attributes.type_ "submit"
    , Html.Attributes.value "Submit"
    ]
    [ Html.text "Submit" ]
