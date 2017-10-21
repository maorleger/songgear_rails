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
        ( Model songId Nothing, Http.send SongResponse (Song.fetchSong songId) )


view : Model -> Html Msg
view model =
    let
        videoRow =
            Maybe.map Youtube.view model.song
                |> Maybe.withDefault (div [] [])

        song =
            model.song
                |> Maybe.withDefault (Song.init "" Nothing Nothing [])
    in
        div [ class "container" ]
            [ div [ class "row justify-content-center" ]
                [ h1 []
                    [ text <| Song.title song
                    ]
                ]
            , videoRow
            , div [ class "row" ]
                [ pre []
                    [ text <| Maybe.withDefault "" <| Song.note song
                    ]
                ]
            ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SongResponse (Err error) ->
            Debug.crash <| toString error

        SongResponse (Ok song) ->
            { model | song = Just song } ! [ Youtube.loadVideo <| Maybe.withDefault "" (Song.videoId song) ]

        SeekTo seconds ->
            model ! [ Youtube.seekTo seconds ]

        AddBookmark ->
            model ! [ Youtube.getYTPlayerTime () ]

        CurrentPlayerTime currentTime ->
            let
                newSong =
                    Maybe.map
                        (Song.addBookmark currentTime)
                        model.song
            in
                { model | song = newSong }
                    ! [ Http.send AddBookmarkResponse
                            (Bookmark.addBookmarkRequest
                                model.songId
                                (Bookmark.init "New bookmark" currentTime)
                            )
                      ]

        AddBookmarkResponse (Err error) ->
            Debug.crash <| toString error

        AddBookmarkResponse (Ok _) ->
            model ! []


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
