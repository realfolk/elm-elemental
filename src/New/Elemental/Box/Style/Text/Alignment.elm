module New.Elemental.Box.Style.Text.Alignment exposing
    ( TextAlignment(..)
    , toCssStyle
    )

import Css


type TextAlignment
    = Left
    | Center
    | Right
    | Justify


toCssStyle : TextAlignment -> Css.Style
toCssStyle textAlignment =
    case textAlignment of
        Left ->
            Css.textAlign Css.left

        Center ->
            Css.textAlign Css.center

        Right ->
            Css.textAlign Css.right

        Justify ->
            Css.textAlign Css.justify
