module Article exposing (..)

type alias Article =
  { uuid : String
  , title : String
  , content : String
  }

empty : Article
empty =
  Article "" "" ""
