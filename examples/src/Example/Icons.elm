module Example.Icons exposing (..)

import Css
import Html.Styled as H
import Html.Styled.Attributes as HA


type Icons
    = CheckCircle
    | ChevronLeft
    | ChevronRight
    | Edit
    | Palette
    | Send


view icon size =
    H.span
        [ HA.class "material-symbols-outlined"
        , HA.css
            [ Css.fontSize <| Css.px size
            ]
        ]
    <|
        List.singleton <|
            case icon of
                CheckCircle ->
                    H.text "check_circle"

                ChevronLeft ->
                    H.text "chevron_left"

                ChevronRight ->
                    H.text "chevron_right"

                Edit ->
                    H.text "edit"

                Palette ->
                    H.text "palette"

                Send ->
                    H.text "send"
