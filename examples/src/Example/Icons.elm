module Example.Icons exposing (..)

import Css
import Html.Styled as H
import Html.Styled.Attributes as HA


type Icons
    = Palette


view icon size=
    H.span
        [ HA.class "material-symbols-outlined"
        , HA.css
            [ Css.fontSize <| Css.px size
            ]
        ]
    <|
        List.singleton <|
            case icon of
                Palette ->
                    H.text "palette"
