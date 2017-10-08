module Main exposing (..)

import Html exposing (..)
import Types exposing (..)
import Youtube exposing (youtube)


-- MODEL


type alias Model =
    { title : String
    , videoId : String
    , note : String
    }



-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model "Hey Joe" "9hD44jOQG4Q" "my note here", Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    youtube model.videoId



-- The inline style is being used for example purposes in order to keep this example simple and
-- avoid loading additional resources. Use a proper stylesheet when building your own app.
-- h1
-- [ style
--     [ ( "display", "flex" ), ( "justify-content", "center" ) ]
-- ]
-- [ text "Hello, Elm!" ]
-- MESSAGE
-- UPDATE


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
