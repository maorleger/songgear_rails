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

                -- working towards an idea of an active bookmark
            in
                { model | song = newSong } ! []

        SetBookmarkSeconds newSeconds ->
            let
                newSong =
                    Song.setBookmarks (Bookmark.updateSeconds newSeconds) model.song

                -- working towards an idea of an active bookmark
            in
                { model | song = newSong } ! []

        SaveBookmark bookmark ->
            model ! [ Http.send SaveBookmarkResponse <| Bookmark.updateRequest model.songId bookmark ]

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
                -- todo: trying to flip the order here, and make server calls synchronous and only update the UI
                -- based on the result. My other calls optimistically update the UI and then crash if a server error happens
                -- decide on an approach, probably when doing #152546716:
                { model | song = newSong } ! [ Http.send DeleteBookmarkResponse <| Bookmark.deleteRequest model.songId bookmarkId ]

        DeleteBookmarkResponse (Err error) ->
            Debug.crash <| toString error

        DeleteBookmarkResponse (Ok _) ->
            model ! []

        SetPlayerSpeed newSpeed ->
            { model | song = Song.setPlayerSpeed newSpeed model.song } ! [ Youtube.setYTPlayerSpeed newSpeed ]

        AvailablePlayerSpeeds playerSpeeds ->
            { model | song = Song.setAvailablePlayerSpeeds playerSpeeds model.song } ! []


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
