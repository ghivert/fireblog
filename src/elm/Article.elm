module Article exposing (..)

type alias Article =
  { uuid : String
  , title : String
  , content : String
  , tags : List String
  }

empty : Article
empty =
  Article "" "" "" []
