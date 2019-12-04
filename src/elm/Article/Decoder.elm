module Article.Decoder exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra
import Time exposing (Posix)
import Iso8601

import Article exposing (Article)

decodePosts : Decoder (List (String, Article))
decodePosts = Decode.keyValuePairs decodePost

decodePost : Decoder Article
decodePost =
  Decode.map5 article
    (Decode.field "title" Decode.string)
    (Decode.field "content" Decode.string)
    (Decode.field "date" Iso8601.decoder)
    (Decode.field "headline" Decode.string)
    (Decode.map
      (Maybe.withDefault Nothing)
      (Decode.maybe (Decode.field "headImage" (Decode.nullable Decode.string)))
    )

article : String -> String -> Posix -> String -> Maybe String -> Article
article title content date headline headImage =
  { uuid = ""
  , title = title
  , content = content
  , tags = []
  , date = date
  , headline = headline
  , headImage = headImage
  }
