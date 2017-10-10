module Types exposing (..)

import Http


type Msg
    = SongResponse (Result Http.Error Song)


type alias Model =
    { title : String
    , videoId : String
    , note : String
    , songId : Int
    }


type alias Song =
    { title : String
    , videoId : String
    , note : String
    }
