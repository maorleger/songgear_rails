module Bookmark
    exposing
        ( Bookmark
        , updateBookmarks
        )

import Json.Decode as Decode
import Json.Encode as Encode
import Http


type alias Bookmark =
    { name : String
    , seconds : Int
    }


bookmarkDecoder : Decode.Decoder Bookmark
bookmarkDecoder =
    Decode.map2
        Bookmark
        (Decode.field "name" Decode.string)
        (Decode.field "seconds" Decode.int)


updateBookmarks : Int -> Bookmark -> Http.Request ()
updateBookmarks songId bookmark =
    let
        postUrl =
            "http://localhost:/api/v1/songs/" ++ toString songId ++ "/bookmarks"

        bookmarkEncoder x =
            Encode.object
                [ ( "seconds", Encode.int bookmark.seconds )
                , ( "name", Encode.string bookmark.name )
                ]

        body =
            bookmark
                |> bookmarkEncoder
                |> Http.jsonBody
    in
        Http.post postUrl body <| Decode.succeed ()
