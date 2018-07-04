module Remote exposing (..)

type Remote a
  = Fetched a
  | Absent
  | NotFetched

withDefault : a -> Remote a -> a
withDefault default remote =
  case remote of
    Fetched value -> value
    Absent -> default
    NotFetched -> default

toMaybe : Remote a -> Maybe a
toMaybe remote =
  case remote of
    Fetched value -> Just value
    Absent -> Nothing
    NotFetched -> Nothing

fromMaybe : Maybe a -> Remote a
fromMaybe maybe =
  case maybe of
    Nothing -> Absent
    Just a -> Fetched a

map : (a -> b) -> Remote a -> Remote b
map mapper remote =
  case remote of
    Fetched value -> Fetched (mapper value)
    Absent -> Absent
    NotFetched -> NotFetched

andThen : (a -> Remote b) -> Remote a -> Remote b
andThen mapper remote =
  case remote of
    Fetched value -> mapper value
    Absent -> Absent
    NotFetched -> NotFetched

isFetched : Remote a -> Bool
isFetched remote =
  case remote of
    Fetched _ -> True
    _ -> False
