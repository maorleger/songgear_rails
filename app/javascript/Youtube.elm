port module Youtube
    exposing
        ( currentPlayerTimeReceived
        , getYTPlayerTime
        , playerSpeedsReceived
        , setYTPlayerSpeed
        , startLoop
        , endLoop
        , loadVideo
        , seekTo
        , view
        )

import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (classList, class, id, href, type_, value)
import Html.Keyed as Keyed
import Song exposing (Song, LoopPosition(..))
import Bookmark exposing (Bookmark)
import Utilities as U
import Types exposing (..)


port loadVideo : String -> Cmd msg


port seekTo : Int -> Cmd msg


port getYTPlayerTime : () -> Cmd msg


port currentPlayerTimeReceived : (Int -> msg) -> Sub msg


port setYTPlayerSpeed : Float -> Cmd msg


port playerSpeedsReceived : (List Float -> msg) -> Sub msg


port startLoop : ( Int, Int ) -> Cmd msg


port endLoop : () -> Cmd msg


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
                        [ loopControls song
                        , playerSpeedControls song
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
            Song.availablePlayerSpeeds song

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

        speedButton speed =
            button
                [ type_ "button"
                , toClassList speed
                , onClick <| SetPlayerSpeed speed
                ]
                [ text <| toString speed ]
    in
        case List.length speeds of
            1 ->
                div [] []

            _ ->
                div [ class "card" ]
                    [ div [ class "card-header" ] [ text "Speed controls" ]
                    , div [ classes ] <| List.map speedButton speeds
                    ]


loopControls : Song -> Html Msg
loopControls song =
    let
        bodyClasses =
            [ "form-check"
            , "form-check-inline"
            , "d-flex"
            , "justify-content-center"
            ]
                |> U.toClassList

        headerClasses =
            [ "card-header"
            , "d-flex"
            , "align-items-center"
            , "justify-content-between"
            ]
                |> U.toClassList

        val loopVal =
            Maybe.map toString loopVal
                |> Maybe.withDefault ""
                |> value

        btn onClick_ text_ icon =
            span []
                [ a [ class "btn", onClick onClick_ ]
                    [ i
                        [ class <| "fa " ++ icon
                        , onClick onClick_
                        ]
                        []
                    ]
                ]
    in
        div [ class "card" ]
            [ div [ headerClasses ]
                [ span [] [ text "Loop controls" ]
                , span []
                    [ btn StartLoop "Play" "fa-play"
                    , btn EndLoop "Stop" "fa-stop"
                    ]
                ]
            , div [ class "card-body" ] <|
                [ div [ bodyClasses ]
                    [ div [ class "form-group" ]
                        [ label [] [ text "Start" ]
                        , input
                            [ onInput (UpdateLoop LoopStart)
                            , val <| Song.loopStart song
                            , type_ "number"
                            , class "form-control"
                            ]
                            []
                        ]
                    , div [ class "form-group" ]
                        [ label [] [ text "End" ]
                        , input
                            [ onInput (UpdateLoop LoopEnd)
                            , val <| Song.loopEnd song
                            , type_ "number"
                            , class "form-control"
                            ]
                            []
                        ]
                    ]
                ]
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
