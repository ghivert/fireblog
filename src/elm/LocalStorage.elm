module LocalStorage exposing (encodeModel, decodeModel)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode

import Types exposing (..)
import Article exposing (Article)
import Article.Encoder
import Article.Decoder
import Remote

encodeModel : Model -> Encode.Value
encodeModel { articles } =
  encodeArticles
  <| case articles of
    Remote.Fetched fetchedArticles ->
      fetchedArticles
        |> Encode.list Article.Encoder.encodeArticle
    _ ->
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
