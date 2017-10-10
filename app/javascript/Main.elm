module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Youtube exposing (view)
import Request
import Http


-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model "" "" "" 1, Http.send SongResponse (Request.getSong 1) )



-- VIEW


view : Model -> Html Msg
view model =
    let
        videoRow =
            Youtube.view model
    in
        div [ class "container" ]
            [ div [ class "row justify-content-center" ]
                [ h1 []
                    [ text model.title
                    ]
                ]
            , videoRow
            , div [ class "row" ]
                [ pre []
                    [ text model.note
                    ]
                ]
            ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SongResponse (Err error) ->
            Debug.crash <| toString error

        SongResponse (Ok song) ->
            { model
                | title = song.title
                , videoId = song.videoId
                , note = song.note
            }
                ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
