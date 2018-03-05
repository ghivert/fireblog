module LocalStorage exposing (encodeModel, decodeModel)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import Types exposing (..)
import Article exposing (Article)
import Article.Encoder
import Article.Decoder

encodeModel : Model -> Encode.Value
encodeModel { articles } =
  encodeArticles
    <| case articles of
      Just articles ->
        articles
          |> List.map Article.Encoder.encodeArticle
          |> Encode.list
      Nothing ->
        Encode.null

encodeArticles : Encode.Value -> Encode.Value
encodeArticles content =
  Encode.object [ ("articles", content) ]

decodeModel : Decoder (Maybe (List Article))
decodeModel =
  Decode.field "articles" decodeMaybeArticles

decodeMaybeArticles : Decoder (Maybe (List Article))
decodeMaybeArticles =
  Decode.nullable (Decode.list Article.Decoder.decodePost)
