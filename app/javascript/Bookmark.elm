module Bookmark
    exposing
        ( Bookmark
        , BookmarkEvents
        , addRequest
        , updateRequest
        , deleteRequest
        , handleUpdateResponse
        , updateName
        , updateSeconds
        , edit
        , decoder
        , init
        , view
        , id
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


type alias BookmarkEvents msg =
    { addBookmark : msg
    , seekTo : Int -> msg
    , editBookmark : Int -> msg
    , setBookmarkName : String -> msg
    , setBookmarkSeconds : String -> msg
    , saveBookmark : Bookmark -> msg
    , deleteBookmark : Int -> msg
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
            >> update updaterFn id


handleUpdateResponse : Bookmark -> Int -> List Bookmark -> List Bookmark
handleUpdateResponse responseBookmark id =
    let
        updaterFn bookmark =
            responseBookmark
    in
        update updaterFn id


activeBookmark : List Bookmark -> Maybe Bookmark
activeBookmark =
    List.head << List.filter isEditing



-- TODO: there's an abstraction here, I just havent found it yet... maybe more operations on an editing bookmark?


updateSeconds : String -> List Bookmark -> List Bookmark
updateSeconds newSeconds bookmarks =
    let
        parsedSeconds original =
            String.toInt newSeconds
                |> Result.withDefault original

        updaterFn (Bookmark bookmark) =
            Bookmark { bookmark | seconds = parsedSeconds bookmark.seconds }
    in
        activeBookmark bookmarks
            |> Maybe.map id
            |> Maybe.map (\id -> update updaterFn id bookmarks)
            |> Maybe.withDefault bookmarks


updateName : String -> List Bookmark -> List Bookmark
updateName newName bookmarks =
    let
        updaterFn (Bookmark bookmark) =
            Bookmark { bookmark | name = newName }
    in
        activeBookmark bookmarks
            |> Maybe.map id
            |> Maybe.map (\id -> update updaterFn id bookmarks)
            |> Maybe.withDefault bookmarks


update : (Bookmark -> Bookmark) -> Int -> List Bookmark -> List Bookmark
update f bookmarkId bookmarks =
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


seconds : Bookmark -> Int
seconds (Bookmark bookmark) =
    bookmark.seconds


isEditing : Bookmark -> Bool
isEditing (Bookmark bookmark) =
    bookmark.isEditing


name : Bookmark -> String
name (Bookmark bookmark) =
    bookmark.name


decoder : Decode.Decoder Bookmark
decoder =
    Decode.map3
        init
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
        (Decode.field "seconds" Decode.int)


addRequest : Int -> Bookmark -> Http.Request Bookmark
addRequest songId (Bookmark bookmark) =
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
        Http.post postUrl body decoder


updateRequest : Int -> Bookmark -> Http.Request Bookmark
updateRequest songId (Bookmark bookmark) =
    let
        bookmarkId =
            toString <| bookmark.id

        bookmarkEncoder =
            Encode.object
                [ ( "seconds", Encode.int bookmark.seconds )
                , ( "name", Encode.string bookmark.name )
                ]

        body =
            Encode.object
                [ ( "bookmark", bookmarkEncoder )
                ]
                |> Http.jsonBody
    in
        Http.request
            { method = "PUT"
            , headers =
                [ Http.header "Content-Type" "application/json"
                ]
            , url = U.serverUrl ++ "songs/" ++ toString songId ++ "/bookmarks/" ++ bookmarkId
            , body = body
            , expect = Http.expectJson decoder
            , timeout = Nothing
            , withCredentials = False
            }


deleteRequest : Int -> Int -> Http.Request ()
deleteRequest songId bookmarkId =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = U.serverUrl ++ "songs/" ++ toString songId ++ "/bookmarks/" ++ toString bookmarkId
        , body = Http.emptyBody
        , expect = Http.expectStringResponse << always <| Ok ()
        , timeout = Nothing
        , withCredentials = False
        }


readonlyView : Bookmark -> BookmarkEvents msg -> Html msg
readonlyView bookmark events =
    let
        editButton =
            a
                [ onClick <| events.editBookmark <| id bookmark
                ]
                [ i [ class "edit-button clickable-icon fa fa-edit fa-lg" ] [] ]

        seekToButton =
            a
                [ onClick <| events.seekTo <| seconds bookmark
                ]
                [ i [ class "seek-to-button clickable-icon fa fa-bullseye fa-lg" ] [] ]

        removeButton =
            a [ onClick <| events.deleteBookmark <| id bookmark ]
                [ i [ class "remove-button clickable-icon fa fa-times-circle-o fa-lg" ] []
                ]

        rowOne =
            div [ class "d-flex" ]
                [ seekToButton
                , span [ class "bookmark-name" ] [ text <| name bookmark ]
                , editButton
                , removeButton
                ]

        rowTwo =
            div [ class "bookmark-details-row" ]
                [ span [ class "bookmark-timestamp" ] [ text <| toTimeFmt <| seconds bookmark ]
                ]
    in
        span [ class "list-group-item bookmark-row" ]
            [ rowOne
            , rowTwo
            ]


editView : Bookmark -> BookmarkEvents msg -> Html msg
editView bookmark events =
    let
        saveButton =
            a []
                [ i
                    [ class "save-button clickable-icon fa fa-check-circle-o fa-lg"
                    , onClick <| events.saveBookmark bookmark
                    ]
                    []
                ]

        nameEditor =
            div []
                [ input [ class "form-control", value <| name bookmark, onInput events.setBookmarkName ] []
                ]

        secondsEditor =
            div []
                [ input [ class "form-control", value <| toString <| seconds bookmark, onInput events.setBookmarkSeconds ] []
                ]

        editors =
            div [ class "col" ]
                [ nameEditor
                , secondsEditor
                ]
    in
        span [ class "list-group-item d-flex align-items-center" ] [ editors, saveButton ]


view : List Bookmark -> BookmarkEvents msg -> Html msg
view bookmarks events =
    let
        bookmarkFooter =
            [ div [ class "card-body" ]
                [ button [ class "btn btn-link card-link", onClick events.addBookmark ] [ text "Add" ]
                ]
            ]

        bookmarkRenderer bookmark =
            if isEditing bookmark then
                editView bookmark events
            else
                readonlyView bookmark events
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
