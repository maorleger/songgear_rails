module Song exposing (..)

import Http
import Json.Decode as Decode
import Types exposing (..)


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
    Decode.map4
        Song
        (Decode.field "title" Decode.string)
        (Decode.field "youtube_video_id" (Decode.nullable Decode.string))
        (Decode.field "note" (Decode.nullable Decode.string))
        (Decode.field "bookmarks" <| Decode.list bookmarkDecoder)


bookmarkDecoder : Decode.Decoder Bookmark
bookmarkDecoder =
    Decode.map2
        Bookmark
        (Decode.field "name" Decode.string)
        (Decode.field "seconds" Decode.int)
