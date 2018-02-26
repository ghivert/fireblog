module Article exposing (..)

import Date exposing (Date)
import Html.Extra
import List.Extra

type alias Article =
  { uuid : String
  , title : String
  , content : String
  , tags : List String
  , date : Date
  }

isId : String -> Article -> Bool
isId id { uuid } =
  uuid == id

isHtmlTitle : String -> Article -> Bool
isHtmlTitle id { title } =
  Html.Extra.createUrl title == id

toUnifiedArticle : (String, Article) -> Article
toUnifiedArticle (uuid, article) =
  { article | uuid = uuid }

toSubmit : String -> String -> Date -> Article
toSubmit title content date =
  { uuid = ""
  , title = title
  , content = content
  , tags = []
  , date = date
  }

getArticleByHtmlTitle : String -> List Article -> Maybe Article
getArticleByHtmlTitle id articles =
  id
    |> isHtmlTitle
    |> flip List.Extra.find articles
