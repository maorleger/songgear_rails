module Utilities exposing (..)

import Html.Attributes exposing (classList, type_, name, checked)
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


radio : msg -> Float -> Float -> Html msg
radio msg value currentValue =
    let
        isChecked =
            value == currentValue
    in
        label []
            [ input [ type_ "radio", onClick msg, checked isChecked, name "player-speed" ] []
            , text <| toString value
            ]
