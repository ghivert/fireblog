module View.Static.Footer exposing (view)

import Html exposing (Html)
import Html.Attributes
import Html.Extra

import Types exposing (..)

view : Model -> Html Msg
view model =
  Html.div []
    [ disclaimer model ]

disclaimer : Model -> Html Msg
disclaimer { user } =
  Html.div
    [ Html.Attributes.class "legal-disclaimer" ]
    [ Html.div
      [ Html.Attributes.class "legal-disclaimer--item" ]
      [ Html.text "Photo de bannière par "
      , blankLink "https://unsplash.com/photos/5AiWn2U10cw" "Aaron Burden"
      , Html.text " sur "
      , blankLink "https://unsplash.com/" "Unsplash"
      ]
    , Html.div
      [ Html.Attributes.class "legal-disclaimer--item" ]
      [ Html.a
        [ Html.Attributes.href "https://github.com/afnizarnur/saturn" ]
        [ Html.text "Design fortement inspiré de Saturn, de Afnizar Nur Ghifari" ]
      ]
    , Html.div
      [ Html.Attributes.class "legal-disclaimer--item" ]
      [ case user of
        Just { email } ->
          Html.a
            [ Html.Extra.onPreventClick
              <| LoginForm
              <| LogoutUser
            , Html.Attributes.href "/logout"
            ]
            [ Html.text "Se déconnecter" ]
        Nothing ->
          Html.a
            [ Html.Extra.onPreventClick
              <| Navigation
              <| ChangePage "/login"
            , Html.Attributes.href "/login"
            ]
            [ Html.text "Aller au formulaire de connexion" ]
      ]
    ]

blankLink : String -> String -> Html msg
blankLink url content =
  Html.a
    [ Html.Attributes.href url
    , Html.Attributes.target "_blank"
    , Html.Attributes.rel "noopener"
    ]
    [ Html.text content ]
