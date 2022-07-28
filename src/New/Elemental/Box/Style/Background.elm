module New.Elemental.Box.Style.Background exposing
    ( Background
    , gradient
    , solid
    , tiled
    , toCssStyle
    )

import Css
import New.Elemental.Data.Color as Color exposing (Color)


type Background
    = Solid Color
    | Gradient
    | Tiled


solid : Color -> Background
solid =
    Solid


gradient : Background
gradient =
    Gradient


tiled : Background
tiled =
    Tiled


toCssStyle : Background -> Css.Style
toCssStyle bg =
    case bg of
        Solid color ->
            Css.backgroundColor <| Color.toCssColor color

        Gradient ->
            Debug.todo ""

        Tiled ->
            Debug.todo ""
