module Utilities exposing (..)

import Html.Attributes exposing (classList)
import Html exposing (Attribute)
import Types exposing (..)


toClassList : List String -> Attribute Msg
toClassList =
    classList << List.map (flip (,) True)


toTimeFmt : Int -> String
toTimeFmt secs =
    let
        minutes =
            flip (//) 60
                >> toString

        seconds =
            flip (%) 60
                >> toString
                >> String.padLeft 2 '0'
    in
        minutes secs ++ ":" ++ seconds secs
