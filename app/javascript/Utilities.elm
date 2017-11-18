module Utilities exposing (..)

import Html.Attributes exposing (classList, type_, name, checked, class, value)
import Html.Events exposing (onClick)
import Html
    exposing
        ( Html
        , Attribute
        , input
        , label
        , text
        )


toClassList : List String -> Attribute msg
toClassList =
    classList << List.map (flip (,) True)


serverUrl : String
serverUrl =
    "/api/v1/"


radioButton : msg -> Float -> Float -> Html msg
radioButton msg buttonValue currentValue =
    let
        isChecked =
            buttonValue == currentValue
    in
        label [ class "form-check-label" ]
            [ input
                [ type_ "radio"
                , onClick msg
                , value <| toString buttonValue
                , checked isChecked
                , name "player-speed"
                , class "form-check-input"
                ]
                []
            , text <| toString buttonValue
            ]
