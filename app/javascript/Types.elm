module Types exposing (..)

import Http


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


type alias Song =
    { title : String
    , videoId : Maybe String
    , note : Maybe String
    , bookmarks : List Bookmark
    }


type alias Flags =
    { songId : String
    }


type alias Bookmark =
    { name : String
    , seconds : Int
    }
