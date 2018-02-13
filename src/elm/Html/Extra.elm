module Html.Extra exposing (..)

{-| Provides some helpers for the Html module, not included by default, but
necessary. Contains both structure and attributes/events. -}

import Html exposing (Html)
import Html.Events
import Json.Decode

{-| Replaces `Html.text ""`. It allows better reading and better semantic. -}
none : Html msg
none =
  Html.text ""

{-| Prevent default behavior when clicking on an element. Used mainly with a
elements to intercept the hard page reload to send instead message in order to
have proper SPA behavior. -}
onPreventClick : msg -> Html.Attribute msg
onPreventClick message =
  Html.Events.onWithOptions "click"
    { stopPropagation = True
    , preventDefault = True
    } (Json.Decode.succeed message)

{-| Filter a string to ensure legit characters in URL. Replaces whitespaces with
dash and lower every character. -}
correctUrlString : String -> String
correctUrlString =
  String.toLower >> String.split " " >> String.join "-"

{-| Get UUID part of an article URL. An article URL always takes shape
`domain-name.com/article-title-uuid` where uuid correspond to the UUID of the
article. Do not handle parameters (& and ?) yet. -}
getUuidPart : String -> Maybe String
getUuidPart complete =
  complete
    |> String.split "-"
    |> List.reverse
    |> List.head
