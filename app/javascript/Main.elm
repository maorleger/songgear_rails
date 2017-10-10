module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Youtube exposing (view)


-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model "Hey Joe" "9hD44jOQG4Q" "my note here", Cmd.none )



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
update message model =
    ( model, Cmd.none )



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
