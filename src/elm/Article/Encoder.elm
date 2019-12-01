module Article.Encoder exposing (..)

import Json.Encode as Encode exposing (Value)
import Iso8601

import Article exposing (Article)

encodeArticle : Article -> Value
encodeArticle { uuid, title, content, date, headline, headImage } =
  Encode.object <|
    List.append
      [ ("title", Encode.string title)
      , ("content", Encode.string content)
      , ("date", Encode.string <| Iso8601.fromTime date)
      , ("headline", Encode.string headline)
      , ("headImage", Maybe.withDefault Encode.null (Maybe.map Encode.string headImage))
      ] <|
      if uuid == "" then
        []
      else
        [ ("uuid", Encode.string uuid) ]
