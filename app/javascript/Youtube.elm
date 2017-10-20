port module Youtube
    exposing
        ( view
        , loadVideo
        , seekTo
        , getYTPlayerTime
        , currentYTPlayerTime
        )

import Html exposing (..)
import Html.Attributes exposing (classList, class, id, href)
import Html.Events exposing (onClick)
import Html.Keyed as Keyed
import Types exposing (..)


port loadVideo : String -> Cmd msg


port seekTo : Int -> Cmd msg


port getYTPlayerTime : () -> Cmd msg


port currentYTPlayerTime : (Int -> msg) -> Sub msg


view : Song -> Html Msg
view song =
    case song.videoId of
        Nothing ->
            div [] []

        Just videoId ->
            div [ class "row" ]
                [ div [ class "col-8" ]
                    [ youtube videoId ]
                , div
                    [ class "col" ]
                    [ bookmarksRenderer song.bookmarks ]
                ]


bookmarksRenderer : List Bookmark -> Html Msg
bookmarksRenderer bookmarks =
    let
        listItemClasses =
            [ "list-group-item"
            , "list-group-item-action"
            , "d-flex"
            , "justify-content-between"
            , "bookmarksItem"
            ]
                |> toClassList

        listContentClasses =
            [ "d-flex"
            , "align-items-center"
            ]
                |> toClassList

        bookmarkFooter =
            [ div [ class "card-body" ]
                [ button [ class "btn btn-link card-link", onClick AddBookmark ] [ text "Add" ]
                ]
            ]

        bookmarkRenderer bookmark =
            a
                [ listItemClasses
                , onClick <| SeekTo bookmark.seconds
                ]
                [ text bookmark.title
                , span [ listContentClasses ] [ text <| toTimeFmt bookmark.seconds ]
                ]
    in
        div [ class "card" ]
            [ div [ class "card-header" ] [ text "Bookmarks" ]
            , ul
                [ [ "list-group", "list-group-flush" ]
                    |> toClassList
                ]
              <|
                List.map bookmarkRenderer bookmarks
                    ++ bookmarkFooter
            ]


youtube : String -> Html Msg
youtube videoId =
    let
        classList =
            [ "embed-responsive"
            , "embed-responsive-16by9"
            ]
                |> toClassList
    in
        Keyed.node "div"
            [ classList ]
            [ ( "div", div [ id "player" ] [] )
            ]


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
