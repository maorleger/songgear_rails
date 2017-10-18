module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Youtube exposing (view, loadVideo)
import Request
import Http


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        songId =
            Result.withDefault 0 <| String.toInt flags.songId
    in
        ( Model songId Nothing, Http.send SongResponse (Request.getSong songId) )


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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
