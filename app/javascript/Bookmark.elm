module Bookmark
    exposing
        ( Bookmark
        , addBookmarkRequest
        , saveBookmarkRequest
        , updateBookmarkFromResponse
        , setActiveBookmarkName
        , edit
        , bookmarkDecoder
        , init
        , view
        )

import Json.Decode as Decode
import Json.Encode as Encode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Utilities as U
import Http


type Bookmark
    = Bookmark
        { id : Int
        , name : String
        , seconds : Int
        , isEditing : Bool
        }


init : Int -> String -> Int -> Bookmark
init id name seconds =
    Bookmark { id = id, name = name, seconds = seconds, isEditing = False }


edit : Int -> List Bookmark -> List Bookmark
edit id =
    let
        updaterFn (Bookmark bookmark) =
            Bookmark { bookmark | isEditing = True }
    in
        List.map (\(Bookmark bookmark) -> Bookmark { bookmark | isEditing = False })
            >> updateBookmark updaterFn id


updateBookmarkFromResponse : Bookmark -> Int -> List Bookmark -> List Bookmark
updateBookmarkFromResponse responseBookmark id =
    let
        updaterFn bookmark =
            responseBookmark
    in
        updateBookmark updaterFn id


setActiveBookmarkName : String -> List Bookmark -> List Bookmark
setActiveBookmarkName newName bookmarks =
    let
        updaterFn (Bookmark bookmark) =
            Bookmark { bookmark | name = newName }

        activeBookmark =
            Maybe.map id << List.head << List.filter isEditing
    in
        case activeBookmark bookmarks of
            Nothing ->
                bookmarks

            Just id ->
                updateBookmark updaterFn id bookmarks


updateBookmark : (Bookmark -> Bookmark) -> Int -> List Bookmark -> List Bookmark
updateBookmark f bookmarkId bookmarks =
    bookmarks
        |> List.map
            (\bookmark ->
                if id bookmark == bookmarkId then
                    f bookmark
                else
                    bookmark
            )


id : Bookmark -> Int
id (Bookmark bookmark) =
    bookmark.id


isEditing : Bookmark -> Bool
isEditing (Bookmark bookmark) =
    bookmark.isEditing


name : Bookmark -> String
name (Bookmark bookmark) =
    bookmark.name


bookmarkDecoder : Decode.Decoder Bookmark
bookmarkDecoder =
    Decode.map3
        init
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
        (Decode.field "seconds" Decode.int)


addBookmarkRequest : Int -> Bookmark -> Http.Request Bookmark
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
        Http.post postUrl body bookmarkDecoder


saveBookmarkRequest : Int -> Bookmark -> Http.Request Bookmark
saveBookmarkRequest songId bookmark =
    let
        bookmarkId =
            toString <| id bookmark
    in
        Http.request
            { method = "PUT"
            , headers =
                [ Http.header "Content-Type" "application/json"
                ]
            , url = U.serverUrl ++ "songs/" ++ toString songId ++ "/bookmarks/" ++ bookmarkId
            , body = Http.emptyBody
            , expect = Http.expectJson bookmarkDecoder
            , timeout = Nothing
            , withCredentials = False
            }


readonlyView : Bookmark -> (Int -> msg) -> (Int -> msg) -> Html msg
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


editView : Bookmark -> (String -> msg) -> (Bookmark -> msg) -> Html msg
editView bookmark setBookmarkName saveBookmark =
    let
        saveButton bookmark =
            a [] [ i [ class "save-button clickable-icon fa fa-check-circle-o fa-lg", onClick <| saveBookmark bookmark ] [] ]

        rowOne bookmark =
            div [ class "bookmark-actions-row" ]
                [ input [ class "form-control", value <| name bookmark, onInput setBookmarkName ] []
                , saveButton bookmark
                ]
    in
        span [ class "list-group-item bookmark-row" ] [ rowOne bookmark ]


view : List Bookmark -> msg -> (Int -> msg) -> (Int -> msg) -> (String -> msg) -> (Bookmark -> msg) -> Html msg
view bookmarks addBookmark seekTo editBookmark setBookmarkName saveBookmark =
    let
        bookmarkFooter =
            [ div [ class "card-body" ]
                [ button [ class "btn btn-link card-link", onClick addBookmark ] [ text "Add" ]
                ]
            ]

        bookmarkRenderer bookmark =
            if isEditing bookmark then
                editView bookmark setBookmarkName saveBookmark
            else
                readonlyView bookmark seekTo editBookmark
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
