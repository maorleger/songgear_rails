port module Youtube
    exposing
        ( currentYTPlayerTime
        , getYTPlayerTime
        , loadVideo
        , seekTo
        , view
        )

import Html exposing (..)
import Html.Attributes exposing (classList, class, id, href)
import Html.Keyed as Keyed
import Song exposing (Song)
import Bookmark exposing (Bookmark)
import Utilities as U
import Types exposing (..)


port loadVideo : String -> Cmd msg


port seekTo : Int -> Cmd msg


port getYTPlayerTime : () -> Cmd msg


port currentYTPlayerTime : (Int -> msg) -> Sub msg


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
                        [ Bookmark.view (Song.bookmarks song) bookmarkEvents
                        , div []
                            [ U.radio (SetPlayerSpeed 0.25) "0.25"
                            ]
                        ]
                    ]
                ]
    in
        Song.videoId song
            |> Maybe.map videoRenderer
            |> Maybe.withDefault (div [] [])


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
