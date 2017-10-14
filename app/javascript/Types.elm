module Types exposing (..)

import Http


type Msg
    = SongResponse (Result Http.Error Song)


type alias Model =
    { songId : Int
    , song : Maybe Song
    }


type alias Song =
    { title : String
    , videoId : String
    , note : String
    }
