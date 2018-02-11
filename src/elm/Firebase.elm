port module Firebase exposing (..)

{-| Handle everything related with Firebase. Firebase works with the JS
SDK, which should be included in the generated `bundle.js`. Everything
flow through ports and are processed in JS. The elm side does not handle
anything side-effect related, like database, or authentication yet. Firebase
effect manager should be used in the future, in order to remove entirely JS
from the project.

Port names should respect a simple convention: commands (orders to Firebase)
should be imperative, where subscriptions (responses from Firebase) should
be either past indicating what happened or what's happening now to respect
actual elm conventions. -}

import Json.Decode exposing (Value)

{-| Accept a username and an article. The article takes form of
`{ title, uuid, content, date, tags }`. It creates a post on the database.
Should be used with `Article.Encoder.encodeArticle`. -}
port createPost : (String, Value) -> Cmd msg

{-| Give answer whether post has been accepted (pushed in the database) or
not. Will be used to process errors in future. -}
port createdPost : (Bool -> msg) -> Sub msg


{-| Request all posts of a user (provided username). Posts are fetched in Firebase
once. Response comes in `requestedPosts` port. It is impossible to select only
some posts to fetch at the moment. -}
port requestPosts : String -> Cmd msg

{-| Receive all fetched posts, requested by `requestPosts`. They come in an
assoc JSON. They should be processed with `Article.Decoder.decodePosts`. -}
port requestedPosts : (Value -> msg) -> Sub msg


{-| Accept username and password, and sign in or log in the user to the
site. All changes on the user are sent in `authChanges`. -}
port signInUser : (String, String) -> Cmd msg

{-| Accept a username and logout the user. All changes on the user are
sent in `authChanges`. -}
port logoutUser : String -> Cmd msg


{-| Send all authentication changes. Should be processed with
`User.Decoder.decodeUser`. If a user is connected, forward a user to elm,
otherwise it forward an error JSON, i.e. `{disconnected: true}`. -}
port authChanges : (Value -> msg) -> Sub msg
