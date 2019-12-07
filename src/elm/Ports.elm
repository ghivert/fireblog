module Ports exposing (..)

import Json.Decode as Decode exposing (Decoder)

import Article exposing (Article)
import Article.Decoder exposing (decodePosts)

type FromJsMsg
  = FirebaseRequestPosts Decode.Value
  | CreatePost Bool
  | UpdatePost Bool
  | SaveToLocalStorage
  | ReadFromLocalStorage String

requestPosts : String
requestPosts = "REQUEST_POSTS"

createPost : String
createPost = "CREATE_POST"

updatePost : String
updatePost = "UPDATE_POST"

signinUser : String
signinUser = "SIGNIN_USER"

logoutUser : String
logoutUser = "LOGOUT_USER"

saveToLocalStorage : String
saveToLocalStorage = "SAVE_TO_LOCAL_STORAGE"

changeStructuredData : String
changeStructuredData = "CHANGE_STRUCTURED_DATA"

changeOpenGraphData : String
changeOpenGraphData = "CHANGE_OPEN_GRAPH_DATA"

readFromLocalStorage : String
readFromLocalStorage = "READ_FROM_LOCAL_STORAGE"

decodeFromJs : Decoder FromJsMsg
decodeFromJs =
  Decode.field "type" Decode.string
  |> Decode.andThen (\type_ ->
    case type_ of
      "REQUEST_POSTS" -> Decode.map FirebaseRequestPosts (Decode.field "posts" Decode.value)
      "CREATE_POST" -> Decode.map CreatePost (Decode.field "res" Decode.bool)
      "UPDATE_POST" -> Decode.map UpdatePost (Decode.field "res" Decode.bool)
      "SAVE_TO_LOCAL_STORAGE" -> Decode.succeed SaveToLocalStorage
      "READ_FROM_LOCAL_STORAGE" -> Decode.map ReadFromLocalStorage (Decode.field "articles" Decode.string)
      _ -> Decode.fail (String.join " " [ "Type", type_, "unsupported." ])
  )
