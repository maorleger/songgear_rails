module Request exposing (getSong)

import Types exposing (..)
import Json.Decode as Decode
import Http


getSong : Int -> Http.Request Song
getSong songId =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "Content-Type" "application/json"
            ]
        , url = "http://localhost:5000/api/v1/songs/" ++ toString songId
        , body = Http.emptyBody
        , expect = Http.expectJson songDecoder
        , timeout = Nothing
        , withCredentials = False
        }


songDecoder : Decode.Decoder Song
songDecoder =
    Decode.map3
        Song
        (Decode.field "title" Decode.string)
        (Decode.field "video_id" Decode.string)
        (Decode.field "note" Decode.string)
