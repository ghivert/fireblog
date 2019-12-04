module View.Dashboard exposing (..)

import Html exposing (Html)

import Types exposing (..)
import View.Article.Edit

view : Model -> Html Msg
view model = View.Article.Edit.view model
