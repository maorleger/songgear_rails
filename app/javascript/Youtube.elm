port module Youtube
    exposing
        ( currentYTPlayerTime
        , getYTPlayerTime
        , setYTPlayerSpeed
        , loadVideo
        , seekTo
        , view
        )

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (classList, class, id, href, type_)
import Html.Keyed as Keyed
import Song exposing (Song)
import Bookmark exposing (Bookmark)
import Utilities as U
import Types exposing (..)


port loadVideo : String -> Cmd msg


port seekTo : Int -> Cmd msg


port getYTPlayerTime : () -> Cmd msg


port currentYTPlayerTime : (Int -> msg) -> Sub msg


port setYTPlayerSpeed : Float -> Cmd msg


view : Song -> Html Msg
view song =
    let
        bookmarkEvents =
            { addBookmark = AddBookmark
            , seekTo = SeekTo
            , editBookmark = EditBookmark
            , setBookmarkName = SetBookmarkName
            , setBookmarkSeconds = SetBookmarkSeconds
            , saveBookmark = SaveBookmark
            , deleteBookmark = DeleteBookmark
            }

        videoRenderer videoId =
            div [ class "row" ]
                [ div [ class "col-md-8 video-wrapper" ]
                    [ youtube videoId ]
                , div
                    [ class "col-md-4" ]
                    [ div []
                        [ playerSpeedControls song
                        , Bookmark.view (Song.bookmarks song) bookmarkEvents
                        ]
                    ]
                ]
    in
        Song.videoId song
            |> Maybe.map videoRenderer
            |> Maybe.withDefault (div [] [])


playerSpeedControls : Song -> Html Msg
playerSpeedControls song =
    let
        speeds =
            [ 0.25, 0.5, 0.75, 1.0 ]

        classes =
            [ "card-body"
            , "form-check"
            , "form-check-inline"
            , "d-flex"
            , "justify-content-center"
            , "btn-group"
            ]
                |> U.toClassList

        toClassList speed =
            classList
                [ ( "btn", True )
                , ( "btn-dark", True )
                , ( "active", Song.playerSpeed song == speed )
                ]
    in
        div [ class "card d-none d-lg-block" ]
            [ div [ class "card-header" ] [ text "Speed controls" ]
            , div [ classes ] <|
                List.map
                    (\speed ->
                        button
                            [ type_ "button"
                            , toClassList speed
                            , onClick <| SetPlayerSpeed speed
                            ]
                            [ text <| toString speed ]
                    )
                    speeds
            ]


youtube : String -> Html msg
youtube videoId =
    let
        classList =
            [ "embed-responsive"
            , "embed-responsive-16by9"
            ]
                |> U.toClassList
    in
        Keyed.node "div"
            [ classList ]
            [ ( "div", div [ id "player" ] [] )
            ]
