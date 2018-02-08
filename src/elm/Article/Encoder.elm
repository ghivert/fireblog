module Article.Encoder exposing (..)

import Json.Encode as Encode exposing (Value)
import Date.Extra.Format

import Article exposing (Article)

encodeArticle : Article -> Value
encodeArticle { uuid, title, content, date } =
  Encode.object
    [ ("title", Encode.string title)
    , ("content", Encode.string content)
    , ("date", Encode.string <| Date.Extra.Format.isoString date)
    ]
