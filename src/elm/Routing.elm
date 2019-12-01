module Routing exposing (parseLocation)

import Url exposing (Url)
import Url.Parser exposing (Parser, (</>), map, top, s, string)
import Types exposing (..)

parseRoute : Parser (Route -> a) a
parseRoute =
  Url.Parser.oneOf
    [ map Home top
    , map About <| s "about"
    , map Contact <| s "contact"
    , map Archives <| s "archives"
    , map Edit <| s "article" </> string </> s "edit"
    , map Article <| s "article" </> string
    , map Dashboard <| s "dashboard"
    , map Login <| s "login"
    ]

parseLocation : Url -> Route
parseLocation location =
  case (Url.Parser.parse parseRoute location) of
    Just route ->
      route
    Nothing ->
      NotFound
