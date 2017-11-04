module Song
    exposing
        ( Song
        , addBookmark
        , editBookmark
        , bookmarks
        , setBookmarks
        , fetchSong
        , init
        , note
        , title
        , videoId
        )

import Http
import Json.Decode as Decode
import Bookmark exposing (Bookmark)
import Utilities as U


type Song
    = Song
        { title : String
        , videoId : Maybe String
        , note : Maybe String
        , bookmarks : List Bookmark
        }


videoId : Song -> Maybe String
videoId (Song song) =
    song.videoId


bookmarks : Song -> List Bookmark
bookmarks (Song song) =
    song.bookmarks


setBookmarks : (List Bookmark -> List Bookmark) -> Song -> Song
setBookmarks f (Song song) =
    Song { song | bookmarks = f song.bookmarks }


title : Song -> String
title (Song song) =
    song.title


note : Song -> Maybe String
note (Song song) =
    song.note


addBookmark : Int -> Song -> Song
addBookmark time (Song song) =
    Song { song | bookmarks = song.bookmarks ++ [ Bookmark.init 0 "New bookmark" time ] }


editBookmark : Int -> Song -> Song
editBookmark bookmarkId (Song song) =
    let
        newBookmarks =
            bookmarks (Song song)
                |> Bookmark.edit bookmarkId
    in
        Song { song | bookmarks = newBookmarks }


init : String -> Maybe String -> Maybe String -> List Bookmark -> Song
init title videoId note bookmarks =
    Song { title = title, videoId = videoId, note = note, bookmarks = bookmarks }


fetchSong : Int -> Http.Request Song
fetchSong songId =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "Content-Type" "application/json"
            ]
        , url = U.serverUrl ++ "songs/" ++ toString songId
        , body = Http.emptyBody
        , expect = Http.expectJson songDecoder
        , timeout = Nothing
        , withCredentials = False
        }


songDecoder : Decode.Decoder Song
songDecoder =
    Decode.map4
        init
        (Decode.field "title" Decode.string)
        (Decode.field "youtubeVideoId" (Decode.nullable Decode.string))
        (Decode.field "note" (Decode.nullable Decode.string))
        (Decode.field "bookmarks" <| Decode.list Bookmark.bookmarkDecoder)
