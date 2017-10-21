module Bookmark
    exposing
        ( Bookmark
        , addBookmarkRequest
        , bookmarkDecoder
        , init
        , view
        )

import Json.Decode as Decode
import Json.Encode as Encode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Utilities as U
import Http


type Bookmark
    = Bookmark
        { name : String
        , seconds : Int
        }


init : String -> Int -> Bookmark
init name seconds =
    Bookmark { name = name, seconds = seconds }


bookmarkDecoder : Decode.Decoder Bookmark
bookmarkDecoder =
    Decode.map2
        init
        (Decode.field "name" Decode.string)
        (Decode.field "seconds" Decode.int)


addBookmarkRequest : Int -> Bookmark -> Http.Request ()
addBookmarkRequest songId (Bookmark bookmark) =
    let
        postUrl =
            U.serverUrl ++ "songs/" ++ toString songId ++ "/bookmarks"

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


view : List Bookmark -> msg -> (Int -> msg) -> Html msg
view bookmarks addBookmark seekTo =
    let
        listItemClasses =
            [ "list-group-item"
            , "list-group-item-action"
            , "d-flex"
            , "justify-content-between"
            , "bookmarksItem"
            ]
                |> U.toClassList

        listContentClasses =
            [ "d-flex"
            , "align-items-center"
            ]
                |> U.toClassList

        bookmarkFooter =
            [ div [ class "card-body" ]
                [ button [ class "btn btn-link card-link", onClick addBookmark ] [ text "Add" ]
                ]
            ]

        bookmarkRenderer (Bookmark bookmark) =
            a
                [ listItemClasses
                , onClick <| seekTo bookmark.seconds
                ]
                [ text bookmark.name
                , span [ listContentClasses ] [ text <| toTimeFmt bookmark.seconds ]
                ]
    in
        div [ class "card" ]
            [ div [ class "card-header" ] [ text "Bookmarks" ]
            , ul
                [ [ "list-group", "list-group-flush" ]
                    |> U.toClassList
                ]
              <|
                List.map bookmarkRenderer bookmarks
                    ++ bookmarkFooter
            ]


toTimeFmt : Int -> String
toTimeFmt secs =
    let
        minutes =
            flip (//) 60
                >> toString

        seconds =
            flip (%) 60
                >> toString
                >> String.padLeft 2 '0'
    in
        minutes secs ++ ":" ++ seconds secs
