port module Firebase exposing (..)

import Json.Decode as Decode

-- Ask to create a post in database and respond confirmation.
port createPost : (String, Decode.Value) -> Cmd msg
port createdPost : (Bool -> msg) -> Sub msg

-- Ask to get all posts in database and send them back to elm.
port requestPosts : String -> Cmd msg
port requestedPosts : (Decode.Value -> msg) -> Sub msg

-- Sign in, log in or log out user.
port signInUser : (String, String) -> Cmd msg
port logoutUser : String -> Cmd msg

-- Get all authentication changes.
port authChanges : (Decode.Value -> msg) -> Sub msg
