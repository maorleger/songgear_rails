module Types exposing (..)

import Http


type Msg
    = SongResponse (Result Http.Error Song)


type alias Model =
    { title : String
    , song : Maybe Song
    }


type alias Song =
    { title : String
    , videoId : String
    , note : String
    }
