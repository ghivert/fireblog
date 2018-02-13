module Routing exposing (parseLocation)

import Navigation exposing (Location)
import UrlParser exposing (Parser, (</>), map, top, s, string)
import Types exposing (..)

parseRoute : Parser (Route -> a) a
parseRoute =
  UrlParser.oneOf
    [ map Home top
    , map About <| s "about"
    , map Contact <| s "contact"
    , map Archives <| s "archives"
    , map Article <| s "article" </> string
    , map Dashboard <| s "dashboard"
    , map Login <| s "login"
    ]

parseLocation : Location -> Route
parseLocation location =
  case (UrlParser.parsePath parseRoute location) of
    Just route ->
      route
    Nothing ->
      NotFound
