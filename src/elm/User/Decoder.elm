module User.Decoder exposing (..)

import Json.Decode as Decode exposing (Decoder)

import User exposing (User)

decodeUser : Decoder User
decodeUser = Decode.map User (Decode.field "email" Decode.string)
