module Requests exposing (updateBookmarks)

import Types exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Http


-- TODO: instead of requests module make a Song module and Bookmark module. Consider making them opaque even
-- TODO: do something with the response
-- TODO: implement the API endpoint
-- TODO: handle errors more gracefully (story in PT)


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
