module Bookmark
    exposing
        ( Bookmark
        , addBookmarkRequest
        , edit
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
        { id : Maybe Int
        , name : String
        , seconds : Int
        , isEditing : Bool
        }


init : Maybe Int -> String -> Int -> Bookmark
init id name seconds =
    Bookmark { id = id, name = name, seconds = seconds, isEditing = False }


edit : Int -> List Bookmark -> List Bookmark
edit id bookmarks =
    bookmarks
        |> List.map
            (\(Bookmark bookmark) ->
                case bookmark.id of
                    Nothing ->
                        Bookmark bookmark

                    Just bookmarkId ->
                        if bookmarkId == id then
                            Bookmark { bookmark | isEditing = True }
                        else
                            Bookmark bookmark
            )


bookmarkDecoder : Decode.Decoder Bookmark
bookmarkDecoder =
    Decode.map3
        init
        (Decode.field "id" (Decode.maybe Decode.int))
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


readonlyView : Bookmark -> (Int -> msg) -> (Maybe Int -> msg) -> Html msg
readonlyView bookmark seekTo editBookmark =
    let
        editButton bookmark =
            a [ onClick <| editBookmark bookmark.id ] [ i [ class "edit-button clickable-icon fa fa-edit fa-lg" ] [] ]

        seekToButton bookmark =
            a [ onClick <| seekTo bookmark.seconds ] [ i [ class "seek-to-button clickable-icon fa fa-bullseye fa-lg" ] [] ]

        removeButton bookmark =
            a [] [ i [ class "remove-button clickable-icon fa fa-times-circle-o fa-lg" ] [] ]

        rowOne (Bookmark bookmark) =
            div [ class "bookmark-actions-row" ]
                [ seekToButton bookmark
                , span [ class "bookmark-name" ] [ text bookmark.name ]
                , editButton bookmark
                , removeButton bookmark
                ]

        rowTwo (Bookmark bookmark) =
            div [ class "bookmark-details-row" ]
                [ span [ class "bookmark-timestamp" ] [ text <| toTimeFmt bookmark.seconds ]
                ]
    in
        span [ class "list-group-item bookmark-row" ]
            [ rowOne bookmark
            , rowTwo bookmark
            ]


editView : Bookmark -> Html msg
editView bookmark =
    let
        saveButton bookmark =
            a [] [ i [ class "save-button clickable-icon fa fa-check-circle-o fa-lg" ] [] ]

        rowOne (Bookmark bookmark) =
            div [ class "bookmark-actions-row" ]
                [ input [ class "form-control", value bookmark.name ] []
                , saveButton bookmark
                ]
    in
        span [ class "list-group-item bookmark-row" ] [ rowOne bookmark ]


view : List Bookmark -> msg -> (Int -> msg) -> (Maybe Int -> msg) -> Html msg
view bookmarks addBookmark seekTo editBookmark =
    let
        bookmarkFooter =
            [ div [ class "card-body" ]
                [ button [ class "btn btn-link card-link", onClick addBookmark ] [ text "Add" ]
                ]
            ]

        bookmarkRenderer (Bookmark bookmark) =
            if bookmark.isEditing then
                editView (Bookmark bookmark)
            else
                readonlyView (Bookmark bookmark) seekTo editBookmark
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
