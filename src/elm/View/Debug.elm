module View.Debug exposing (infoPanel, switch, debugInfosPanel)

import Html exposing (Html)
import Types exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Types exposing (..)
import Navigation exposing (Location)
import Data.Dumper as Dumper

(=>) : a -> b -> (a, b)
(=>) =
  (,)
infixl 0 =>

debugInfosPanel : Model -> Html Msg
debugInfosPanel ({ debugInfos, location, route } as model) =
  Html.div
    [ Html.Attributes.style
      [ ("transition", "max-height .4s")
      , ("overflow", "hidden")
      , ("margin", "6px 12px 12px 12px")
      , ("max-height", if debugInfos then "1200px" else "0px")
      ]
    ]
    [ infoPanel model ]


infoRoute : Route -> Html msg
infoRoute route =
  Html.div []
    [ Html.text <| toString route ]

infoPanel : Model -> Html Msg
infoPanel { location, route } =
  Html.div
    [ Html.Attributes.style
      [ "border" => "1px solid #dadada"
      , "padding" => "0 24px 24px 24px"
      , "box-sizing" => "border-box"
      ]
    ]
    [ Html.h1 [] [ Html.text "Debug infos" ]
    , debugSection "Location object" <| dumpLocation location
    , debugSection "Route object" <| dumpRoute route
    ]

debugSection : String -> Html msg -> Html msg
debugSection label content =
  Html.details
    [ Html.Attributes.attribute "open" ""
    , Html.Attributes.style
      [ "padding-top" => "12px" ]
    ]
    [ Html.summary
      [ Html.Attributes.style
        [ "outline" => "none"
        , "cursor" => "pointer"
        , "font-size" => "1.5em"
        , "font-weight" => "bold"
        , "padding-bottom" => "12px"
        ]
      ]
      [ Html.text label ]
    , content
    ]

switch : Bool -> Html Msg
switch debugInfos =
  Html.div
    []
    [ Html.div
      [ Html.Attributes.style
        [ "background-color" => if debugInfos then "#0096FB" else "#cccccc"
        , "width" => "60px"
        , "height" => "34px"
        , "border-radius" => "50px"
        , "position" => "relative"
        , "cursor" => "pointer"
        , "flex" => "1"
        , "top" => "4px"
        ]
      , Html.Events.onClick ToggleDebugInfos
      ]
      [ Html.div
        [ Html.Attributes.style
          [ "box-sizing" => "border-box"
          , "background-color" => "#ffffff"
          , "width" => "26px"
          , "height" => "26px"
          , "border-radius" => "50px"
          , "position" => "absolute"
          , "top" => "4px"
          , "left" => "4px"
          , "transition" => ".4s"
          , "transform" => if debugInfos then "translateX(26px)" else ""
          ]
        ]
        []
      ]
    ]


-- Dumpers
dumpLocation : Location -> Html msg
dumpLocation =
  Dumper.dumpRecord "Location"
    [ "href"     => .href     >> Dumper.dumpString
    , "host"     => .host     >> Dumper.dumpString
    , "hostname" => .hostname >> Dumper.dumpString
    , "protocol" => .protocol >> Dumper.dumpString
    , "origin"   => .origin   >> Dumper.dumpString
    , "port_"    => .port_    >> Dumper.dumpString
    , "pathname" => .pathname >> Dumper.dumpString
    , "search"   => .search   >> Dumper.dumpString
    , "hash"     => .hash     >> Dumper.dumpString
    ]

dumpRoute : Route -> Html msg
dumpRoute =
  Dumper.dumpUnion "Route" <<
    routeDumper

routeDumper : Route -> (String, Html msg)
routeDumper route =
  case route of
    Home ->
      "Home" => Html.text ""
    About ->
      "About" => Html.text ""
    Article id ->
      "Article" => Dumper.dumpString id
    Contact ->
      "Contact" => Html.text ""
    NotFound ->
      "NotFound" => Html.text ""
