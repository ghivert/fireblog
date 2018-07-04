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
  , headline : String
  , headImage : Maybe String
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

toSubmit : String -> String -> String -> Date -> String -> Maybe String -> Article
toSubmit uuid title content date headline headImage =
  { uuid = uuid
  , title = title
  , content = content
  , tags = []
  , date = date
  , headline = headline
  , headImage = headImage
  }

getArticleByHtmlTitle : String -> List Article -> Maybe Article
getArticleByHtmlTitle id articles =
  id
    |> isHtmlTitle
    |> flip List.Extra.find articles
