module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Youtube exposing (view, loadVideo)
import Http
import Song exposing (Song)
import Bookmark exposing (Bookmark)
import Types exposing (..)


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        songId =
            Result.withDefault 0 <| String.toInt flags.songId
    in
        ( Model songId Nothing, Http.send SongResponse (Song.getSong songId) )


view : Model -> Html Msg
view model =
    let
        videoRow =
            Maybe.map Youtube.view model.song
                |> Maybe.withDefault (div [] [])

        song =
            model.song
                |> Maybe.withDefault (Song "" Nothing Nothing [])
    in
        div [ class "container" ]
            [ div [ class "row justify-content-center" ]
                [ h1 []
                    [ text song.title
                    ]
                ]
            , videoRow
            , div [ class "row" ]
                [ pre []
                    [ text <| Maybe.withDefault "" song.note
                    ]
                ]
            ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SongResponse (Err error) ->
            Debug.crash <| toString error

        SongResponse (Ok song) ->
            { model | song = Just song } ! [ Youtube.loadVideo <| Maybe.withDefault "" song.videoId ]

        SeekTo seconds ->
            model ! [ Youtube.seekTo seconds ]

        AddBookmark ->
            model ! [ Youtube.getYTPlayerTime () ]

        CurrentPlayerTime currentTime ->
            let
                newSong =
                    Maybe.map
                        (\song ->
                            { song
                                | bookmarks = song.bookmarks ++ [ Bookmark "New bookmark" currentTime ]
                            }
                        )
                        model.song
            in
                { model | song = newSong } ! [ Http.send AddBookmarkResponse (Bookmark.addBookmarkRequest model.songId (Bookmark "New bookmark" currentTime)) ]

        AddBookmarkResponse response ->
            Debug.crash <| "Not yet implemented" ++ toString response


subscriptions : Model -> Sub Msg
subscriptions model =
    Youtube.currentYTPlayerTime CurrentPlayerTime


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
