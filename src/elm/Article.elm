module Article exposing (..)

import Html.Extra
import List.Extra
import Time exposing (Posix)

type alias Article =
  { uuid : String
  , title : String
  , content : String
  , tags : List String
  , date : Posix
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

toSubmit : String -> String -> String -> Posix -> String -> Maybe String -> Article
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
  |> \t -> List.Extra.find t articles
