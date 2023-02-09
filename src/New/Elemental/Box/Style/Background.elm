module New.Elemental.Box.Style.Background exposing
    ( Background
    , gradient
    , solid
    , tiled
    , toCssStyle
    )

import Css
import New.Elemental.Lib.Color as Color exposing (Color)


type Background
    = Solid Color
    | Gradient
    | Tiled


solid : Color -> Background
solid =
    Solid



-- TODO


gradient : Background
gradient =
    Gradient



-- TODO


tiled : Background
tiled =
    Tiled


toCssStyle : Background -> Css.Style
toCssStyle bg =
    case bg of
        Solid color ->
            Css.backgroundColor <| Color.toCssValue color

        Gradient ->
            Css.backgroundColor <| Color.toCssValue Color.black

        Tiled ->
            Css.backgroundColor <| Color.toCssValue Color.black
