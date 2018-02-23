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

getArticleById : String -> List Article -> Maybe Article
getArticleById id articles =
  id
    |> Html.Extra.replaceUnderscore
    |> isId
    |> flip List.Extra.find articles
