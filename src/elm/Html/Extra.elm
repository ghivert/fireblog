module Html.Extra exposing (..)

import Html exposing (Html)
import Html.Events
import Json.Decode

none : Html msg
none =
  Html.text ""

onPreventClick : msg -> Html.Attribute msg
onPreventClick message =
  Html.Events.onWithOptions "click"
    { stopPropagation = True
    , preventDefault = True
    } (Json.Decode.succeed message)
