module Seeds.Articles exposing (samples)

import Date exposing (Date)
import Article exposing (Article)

lorem : String -> Date -> Article
lorem uuid date =
  { uuid = uuid
  , title = "Lorem ipsum"
  , content = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  , tags = [ "Lorem", "Ipsum" ]
  , date = date
  }

longLorem : String -> Date -> Article
longLorem uuid date =
  { uuid = uuid
  , title = "Lorem ipsum"
  , content = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  , tags = [ "Lorem", "Ipsum", "Dolor", "Sit", "Amet" ]
  , date = date
  }

samples : Date -> List Article
samples date =
  [ lorem "first" date
  , lorem "second" date
  , lorem "third" date
  , longLorem "fourth" date
  ]
