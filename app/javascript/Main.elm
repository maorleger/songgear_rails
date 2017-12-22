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
            { model | song = Just song }
                ! [ Maybe.withDefault "" (Song.videoId song)
                        |> Youtube.loadVideo
                  ]

        SeekTo seconds ->
            model ! [ Youtube.seekTo seconds ]

        AddBookmark ->
            model ! [ Youtube.getYTPlayerTime () ]

        EditBookmark id ->
            let
                newSong =
                    Song.setBookmarks (Bookmark.edit id) model.song
            in
                { model | song = newSong } ! []

        CurrentPlayerTime currentTime ->
            let
                newSong =
                    Maybe.map
                        (Song.addBookmark currentTime)
                        model.song
            in
                { model | song = newSong }
                    ! [ Http.send AddBookmarkResponse
                            (Bookmark.addRequest
                                model.songId
                                (Bookmark.init 0 "New bookmark" currentTime)
                            )
                      ]

        AddBookmarkResponse (Err error) ->
            Debug.crash <| toString error

        AddBookmarkResponse (Ok responseBookmark) ->
            let
                bookmarks =
                    Maybe.map Song.bookmarks model.song |> Maybe.withDefault []

                newSong =
                    Song.setBookmarks (Bookmark.handleUpdateResponse responseBookmark 0) model.song
            in
                { model | song = newSong } ! []

        SetBookmarkName newName ->
            let
                newSong =
                    Song.setBookmarks (Bookmark.updateName newName) model.song
            in
                { model | song = newSong } ! []

        SetBookmarkSeconds newSeconds ->
            let
                newSong =
                    Song.setBookmarks (Bookmark.updateSeconds newSeconds) model.song
            in
                { model | song = newSong } ! []

        SaveBookmark bookmark ->
            model
                ! [ Bookmark.updateRequest model.songId bookmark
                        |> Http.send SaveBookmarkResponse
                  ]

        SaveBookmarkResponse (Err error) ->
            Debug.crash <| toString error

        SaveBookmarkResponse (Ok responseBookmark) ->
            let
                newSong =
                    Song.setBookmarks
                        (Bookmark.handleUpdateResponse
                            responseBookmark
                            (Bookmark.id responseBookmark)
                        )
                        model.song
            in
                { model | song = newSong } ! []

        DeleteBookmark bookmarkId ->
            let
                newSong =
                    Song.setBookmarks
                        (List.filter <| (/=) bookmarkId << Bookmark.id)
                        model.song
            in
                { model | song = newSong }
                    ! [ Bookmark.deleteRequest model.songId bookmarkId
                            |> Http.send DeleteBookmarkResponse
                      ]

        DeleteBookmarkResponse (Err error) ->
            Debug.crash <| toString error

        DeleteBookmarkResponse (Ok _) ->
            model ! []

        SetPlayerSpeed newSpeed ->
            { model | song = Song.setPlayerSpeed newSpeed model.song } ! [ Youtube.setYTPlayerSpeed newSpeed ]

        AvailablePlayerSpeeds playerSpeeds ->
            { model | song = Song.setAvailablePlayerSpeeds playerSpeeds model.song } ! []

        UpdateStartLoop seconds ->
            let
                endSeconds =
                    Maybe.map Song.loopEnd model.song
                        |> Maybe.withDefault ""
            in
                { model | song = Song.setLoop seconds endSeconds model.song } ! []

        UpdateEndLoop seconds ->
            let
                startSeconds =
                    Maybe.map Song.loopStart model.song
                        |> Maybe.withDefault ""
            in
                { model | song = Song.setLoop startSeconds seconds model.song } ! []

        StartLoop ->
            let
                loop =
                    Maybe.map Song.loop model.song

                cmd =
                    case loop of
                        Just loop ->
                            Youtube.startLoop loop

                        _ ->
                            Cmd.none
            in
                model ! [ cmd ]

        EndLoop ->
            model ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Youtube.currentPlayerTimeReceived CurrentPlayerTime
        , Youtube.playerSpeedsReceived AvailablePlayerSpeeds
        ]


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
