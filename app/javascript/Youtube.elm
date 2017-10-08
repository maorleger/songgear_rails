module Youtube exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)


youtube : String -> Html Msg
youtube videoId =
    div [ class "embed-responsive embed-responsive-16by9" ]
        [ iframe
            [ class "embed-responsive-item"
            , src <| "https://www.youtube.com/embed/" ++ videoId
            ]
            []
        ]
