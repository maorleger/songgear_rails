module Song
    exposing
        ( Song
        , LoopPosition(..)
        , addBookmark
        , editBookmark
        , bookmarks
        , setBookmarks
        , setPlayerSpeed
        , setAvailablePlayerSpeeds
        , availablePlayerSpeeds
        , fetchSong
        , init
        , note
        , title
        , videoId
        , playerSpeed
        , loopStart
        , loopEnd
        , updateLoop
        )

import Http
import Json.Decode as Decode
import Bookmark exposing (Bookmark)
import Utilities as U


type LoopPosition
    = LoopStart
    | LoopEnd


type Song
    = Song
        { title : String
        , videoId : Maybe String
        , note : Maybe String
        , bookmarks : List Bookmark
        , playerSpeed : Float
        , availableSpeeds : List Float
        , loop : ( Maybe Int, Maybe Int )
        }


init : String -> Maybe String -> Maybe String -> List Bookmark -> Song
init title videoId note bookmarks =
    Song
        { title = title
        , videoId = videoId
        , note = note
        , bookmarks = bookmarks
        , playerSpeed = 1.0
        , availableSpeeds = [ 1.0 ]
        , loop = ( Nothing, Nothing )
        }


videoId : Song -> Maybe String
videoId (Song song) =
    song.videoId


bookmarks : Song -> List Bookmark
bookmarks (Song song) =
    song.bookmarks


availablePlayerSpeeds : Song -> List Float
availablePlayerSpeeds (Song song) =
    song.availableSpeeds


title : Song -> String
title (Song song) =
    song.title


playerSpeed : Song -> Float
playerSpeed (Song song) =
    song.playerSpeed


note : Song -> Maybe String
note (Song song) =
    song.note


loopStart : Song -> Maybe Int
loopStart (Song song) =
    song.loop
        |> Tuple.first


loopEnd : Song -> Maybe Int
loopEnd (Song song) =
    song.loop
        |> Tuple.second


addBookmark : Int -> Maybe Song -> Maybe Song
addBookmark time =
    Maybe.map
        (\(Song song) ->
            Song { song | bookmarks = song.bookmarks ++ [ Bookmark.init 0 "New bookmark" time ] }
        )


editBookmark : Int -> Maybe Song -> Maybe Song
editBookmark bookmarkId =
    Maybe.map
        (\(Song song) ->
            let
                newBookmarks =
                    bookmarks (Song song)
                        |> Bookmark.edit bookmarkId
            in
                Song { song | bookmarks = newBookmarks }
        )


updateLoop : LoopPosition -> Maybe Int -> Maybe Song -> Maybe Song
updateLoop loopPosition newLoopValue song =
    let
        newLoop =
            case loopPosition of
                LoopStart ->
                    ( newLoopValue, Maybe.andThen loopEnd song )

                LoopEnd ->
                    ( Maybe.andThen loopStart song, newLoopValue )
    in
        Maybe.map
            (\(Song song) ->
                Song { song | loop = newLoop }
            )
            song


setPlayerSpeed : Float -> Maybe Song -> Maybe Song
setPlayerSpeed newSpeed =
    Maybe.map
        (\(Song song) ->
            Song { song | playerSpeed = newSpeed }
        )


setBookmarks : (List Bookmark -> List Bookmark) -> Maybe Song -> Maybe Song
setBookmarks f =
    Maybe.map
        (\(Song song) ->
            Song { song | bookmarks = f song.bookmarks }
        )


setAvailablePlayerSpeeds : List Float -> Maybe Song -> Maybe Song
setAvailablePlayerSpeeds speeds =
    let
        neededPlayerSpeeds =
            List.filter ((>=) 1.0) speeds
    in
        Maybe.map
            (\(Song song) ->
                Song { song | availableSpeeds = neededPlayerSpeeds }
            )


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
        (Decode.field "bookmarks" <| Decode.list Bookmark.decoder)
