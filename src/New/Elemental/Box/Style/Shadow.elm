module New.Elemental.Box.Style.Shadow exposing
    ( Shadow
    , simpleOutset
    , toCssStyle
    )

import Css
import New.Elemental.Lib.Axis as Axis
import New.Elemental.Lib.Color as Color exposing (Color)
import New.Elemental.Lib.Size as Size


type alias Shadow =
    { color : Color
    , offset : Axis.D2 Size.Px
    , blurRadius : Size.Px
    , spreadRadius : Size.Px
    , inset : Bool
    }


simpleOutset : Color -> Size.Px -> Size.Px -> Size.Px -> Shadow
simpleOutset color offsetX offsetY blurRadius =
    { color = color
    , offset =
        { x = offsetX
        , y = offsetY
        }
    , blurRadius = blurRadius
    , spreadRadius = Size.px 0
    , inset = False
    }


toCssStyle : Shadow -> Css.Style
toCssStyle shadow_ =
    let
        shadowType =
            if shadow_.inset then
                Css.inset

            else
                Css.outset
    in
    Css.boxShadow6
        shadowType
        (Size.pxToCssValue shadow_.offset.x)
        (Size.pxToCssValue shadow_.offset.y)
        (Size.pxToCssValue shadow_.blurRadius)
        (Size.pxToCssValue shadow_.spreadRadius)
        (Color.toCssValue shadow_.color)
