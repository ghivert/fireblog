module Update exposing (..)

identity : model -> (model, Cmd msg)
identity model = Tuple.pair model Cmd.none
