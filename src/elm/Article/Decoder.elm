module Article.Decoder exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra
import Date exposing (Date)

import Article exposing (Article)

decodePosts : Decoder (List (String, Article))
decodePosts =
  Decode.keyValuePairs decodePost

decodePost : Decoder Article
decodePost =
  Decode.map3 article
    (Decode.field "title" Decode.string)
    (Decode.field "content" Decode.string)
    (Decode.field "date" Json.Decode.Extra.date)

article : String -> String -> Date -> Article
article title content date =
  { uuid = ""
  , title = title
  , content = content
  , tags = []
  , date = date
  }
