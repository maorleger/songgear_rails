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

        body =
            Encode.object
                [ ( "seconds", Encode.int bookmark.seconds )
                , ( "name", Encode.string bookmark.name )
                ]
                |> Http.jsonBody
    in
        Http.post postUrl body <| Decode.succeed ()


view : List Bookmark -> msg -> (Int -> msg) -> Html msg
view bookmarks addBookmark seekTo =
    let
        bookmarkFooter =
            [ div [ class "card-body" ]
                [ button [ class "btn btn-link card-link", onClick addBookmark ] [ text "Add" ]
                ]
            ]

        editButton bookmark =
            a [] [ i [ class "edit-button fa fa-edit fa-lg" ] [] ]

        seekToButton bookmark =
            a [ onClick <| seekTo bookmark.seconds ] [ i [ class "seek-to-button fa fa-bullseye fa-lg" ] [] ]

        rowOne bookmark =
            div [ class "bookmark-actions-row" ]
                [ seekToButton bookmark
                , span [ class "bookmark-name" ] [ text bookmark.name ]
                , editButton bookmark
                ]

        rowTwo bookmark =
            div [ class "bookmark-details-row" ]
                [ span [ class "bookmark-timestamp" ] [ text <| toTimeFmt bookmark.seconds ]
                ]

        bookmarkRenderer (Bookmark bookmark) =
            span [ class "list-group-item bookmark-row" ]
                [ rowOne bookmark
                , rowTwo bookmark
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
            secs // 60 |> toString

        seconds =
            secs % 60 |> toString |> String.padLeft 2 '0'
    in
        minutes ++ ":" ++ seconds
