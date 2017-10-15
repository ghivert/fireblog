module View.Login exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events

import Types exposing (..)

view : Model -> Html Msg
view { loginFields } =
  Html.div
    [ Html.Attributes.class "contact" ]
    [ Html.h1
      [ Html.Attributes.class "contact--title" ]
      [ Html.text "Log-In" ]
    , loginForm loginFields
    ]

loginForm : LoginFields -> Html Msg
loginForm { email, password } =
  Html.form
    [ Html.Attributes.class "contact--form"
    , Html.Events.onSubmit <| LoginForm LoginUser
    ]
    [ emailInput email
    , passwordInput password
    , submitButton
    ]

emailInput : String -> Html Msg
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
      , Html.Events.onInput (LoginForm << LoginEmailInput)
      ]
      []
    ]

passwordInput : String -> Html Msg
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
      , Html.Events.onInput (LoginForm << LoginPasswordInput)
      ]
      []
    ]

submitButton : Html Msg
submitButton =
  Html.input
    [ Html.Attributes.class "contact--form-submit"
    , Html.Attributes.type_ "submit"
    , Html.Attributes.value "Submit"
    ]
    [ Html.text "Submit" ]
