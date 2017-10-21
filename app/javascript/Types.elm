module Types exposing (..)

import Http
import Song exposing (Song)


type Msg
    = SongResponse (Result Http.Error Song)
    | SeekTo Int
    | AddBookmark
    | CurrentPlayerTime Int
    | AddBookmarkResponse (Result Http.Error ())


type alias Model =
    { songId : Int
    , song : Maybe Song
    }


type alias Flags =
    { songId : String
    }
