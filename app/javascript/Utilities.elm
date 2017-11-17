module Utilities exposing (..)

import Html.Attributes exposing (classList, type_)
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


radio : msg -> String -> Html msg
radio msg name =
    label []
        [ input [ type_ "radio", onClick msg ] []
        , text name
        ]
