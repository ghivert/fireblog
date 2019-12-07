module View.Static.About exposing (view)

import Html exposing (Html)
import Html.Attributes

import Types exposing (..)
import Styles.Neptune.Main as Styles

view : Model -> Html Msg
view model =
  Html.div []
    [ aboutTitle "Qui suis-je ?"
    , aboutParagraph aboutMe
    , aboutTitle "Pourquoi écrire en français ?"
    , aboutParagraph whyFrench
    ]

aboutParagraph : String -> Html Msg
aboutParagraph content =
  Html.p
    [ Html.Attributes.class Styles.aboutParagraph ]
    [ Html.text content ]

aboutTitle : String -> Html Msg
aboutTitle content =
  Html.h1
    [ Html.Attributes.class Styles.aboutTitle ]
    [ Html.text content ]

aboutMe : String
aboutMe =
  "Architecte logiciel polyglotte, je travaille majoritairement avec des langages fonctionnels. Provenant du milieu académique (l'université Paris 6), je travaille aujourd'hui en freelance avec des startups. Passionné de technologie et d'informatique, je souhaite voir le français (et la France) comme la future langue (et le futur pays) de l'informatique moderne !"

whyFrench : String
whyFrench =
  "C'est une question que je me suis posé après avoir découvert les noms de domaines accentués, et la place de la francophonie dans le monde. On estime qu'environ 8 % de la population mondiale parlera français d'ici 2050. Or, les français communiquent majoritairement en anglais, pour des raisons diverses et variées. Je pense qu'il est temps d'inverser la tendance et de créer des contenus français de qualité, y compris sur des sujets qui peuvent être très techniques ! Parce qu'il est toujours plus simple de comprendre des choses compliquées et de réfléchir dans sa langue que dans une langue étrangère !"
