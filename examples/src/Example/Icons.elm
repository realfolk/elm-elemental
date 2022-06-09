module Example.Icons exposing (..)

import Css
import Html.Styled as H
import Html.Styled.Attributes as HA


type Icon
    = Add
    | Check
    | CheckCircle
    | ChevronLeft
    | ChevronRight
    | Download
    | Edit
    | Palette
    | Send
    | WarningTriangle


view icon size =
    H.span
        [ HA.class "material-symbols-rounded"
        , HA.css
            [ Css.fontSize <| Css.px size
            ]
        ]
    <|
        List.singleton <|
            case icon of
                Add ->
                    H.text "add"

                Check ->
                    H.text "check"

                CheckCircle ->
                    H.text "check_circle"

                ChevronLeft ->
                    H.text "chevron_left"

                ChevronRight ->
                    H.text "chevron_right"

                Download ->
                    H.text "download"

                Edit ->
                    H.text "edit"

                Palette ->
                    H.text "palette"

                Send ->
                    H.text "send"

                WarningTriangle ->
                    H.text "warning"
