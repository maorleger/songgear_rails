module Types exposing (..)

import Song exposing (Song)
import Bookmark exposing (Bookmark)
import Http


type Msg
    = SongResponse (Result Http.Error Song)
    | SeekTo Int
    | AddBookmark
    | EditBookmark Int
    | CurrentPlayerTime Int
    | AddBookmarkResponse (Result Http.Error Bookmark)
    | SetBookmarkName String


type alias Model =
    { songId : Int
    , song : Maybe Song
    }


type alias Flags =
    { songId : String
    }
