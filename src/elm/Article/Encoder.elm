module Article.Encoder exposing (..)

import Json.Encode as Encode exposing (Value)
import Date.Extra.Format

import Article exposing (Article)

encodeArticle : Article -> Value
encodeArticle { uuid, title, content, date } =
  Encode.object <|
    List.append
      [ ("title", Encode.string title)
      , ("content", Encode.string content)
      , ("date", Encode.string <| Date.Extra.Format.isoString date)
      ] <|
      if uuid == "" then
        []
      else
        [ ("uuid", Encode.string uuid) ]
