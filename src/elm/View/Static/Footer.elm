module View.Static.Footer exposing (view)

import Html exposing (Html)
import Html.Attributes

view : Html msg
view =
  Html.div []
    [ disclaimer ]

disclaimer : Html msg
disclaimer =
  Html.div
    [ Html.Attributes.class "legal-disclaimer" ]
    [ Html.div
      [ Html.Attributes.class "legal-disclaimer--item" ]
      [ Html.text "Banner photo by "
      , blankLink "https://unsplash.com/photos/5AiWn2U10cw" "Aaron Burden"
      , Html.text " on "
      , blankLink "https://unsplash.com/" "Unsplash"
      ]
    , Html.div
      [ Html.Attributes.class "legal-disclaimer--item" ]
      [ Html.a
        [ Html.Attributes.href "https://github.com/afnizarnur/saturn" ]
        [ Html.text "Design heavily inspired by Saturn from Afnizar Nur Ghifari" ]
      ]
    ]

blankLink : String -> String -> Html msg
blankLink url content =
  Html.a
    [ Html.Attributes.href url
    , Html.Attributes.target "_blank"
    ]
    [ Html.text content ]
