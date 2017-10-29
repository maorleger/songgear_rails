module Utilities exposing (..)

import Html.Attributes exposing (classList)
import Html exposing (Attribute)


toClassList : List String -> Attribute msg
toClassList =
    classList << List.map (flip (,) True)


serverUrl : String
serverUrl =
    "/api/v1/"
