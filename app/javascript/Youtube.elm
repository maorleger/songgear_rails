module Youtube exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)


view : Song -> Html Msg
view song =
    case song.videoId of
        Nothing ->
            div [] []

        Just videoId ->
            div [ class "row" ]
                [ div [ class "col-8" ]
                    [ youtube videoId ]
                , div [ class "col" ]
                    [ text "here are my bookmarks" ]
                ]


youtube : String -> Html Msg
youtube videoId =
    div [ class "embed-responsive embed-responsive-16by9" ]
        [ iframe
            [ class "embed-responsive-item"
            , src <| "https://www.youtube.com/embed/" ++ videoId
            ]
            []
        ]
