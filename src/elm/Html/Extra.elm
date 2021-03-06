module Html.Extra exposing (..)

{-| Provides some helpers for the Html module, not included by default, but
necessary. Contains both structure and attributes/events. -}

import Char
import Html exposing (Html)
import Html.Events
import Json.Decode

{-| Replaces `Html.text ""`. It allows better reading and better semantic. -}
none : Html msg
none = Html.text ""

{-| Prevent default behavior when clicking on an element. Used mainly with a
elements to intercept the hard page reload to send instead message in order to
have proper SPA behavior. -}
onPreventClick : msg -> Html.Attribute msg
onPreventClick message =
  Html.Events.custom "click"
  <| Json.Decode.succeed
    { stopPropagation = True
    , preventDefault = True
    , message = message
    }

{-| Filter a string to ensure legit characters in URL. Replaces whitespaces with
dash and lower every character. -}
createUrl : String -> String
createUrl =
  String.toLower
  >> String.split " "
  >> List.map (String.filter acceptedUrlChars)
  >> List.map replaceHyphen
  >> String.join "-"

acceptedUrlChars : Char -> Bool
acceptedUrlChars char = Char.isDigit char || Char.isLower char

replaceHyphen : String -> String
replaceHyphen = String.map (\char -> if char == '-' then '_' else char)

replaceUnderscore : String -> String
replaceUnderscore = String.map (\char -> if char == '_' then '-' else char)

{-| Get UUID part of an article URL. An article URL always takes shape
`domain-name.com/article-title-uuid` where uuid correspond to the UUID of the
article. Do not handle parameters (& and ?) yet.
Not used anymore for the moment. -}
getUuidPart : String -> Maybe String
getUuidPart complete =
  complete
  |> String.split "-"
  |> List.reverse
  |> List.head
