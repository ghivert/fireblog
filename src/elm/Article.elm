module Article exposing (..)

import Date exposing (Date)

type alias Article =
  { uuid : String
  , title : String
  , content : String
  , tags : List String
  , date : Date
  }

isId : String -> Article -> Bool
isId id { uuid } =
  uuid == id || "-" ++ uuid == id

toUnifiedArticle : (String, Article) -> Article
toUnifiedArticle (uuid, article) =
  { article | uuid = uuid }
