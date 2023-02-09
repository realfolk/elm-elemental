module New.Elemental.Box.Style.Nudge exposing
    ( Distance
    , Nudge
    , pct
    , px
    , toCssStyle
    , toCssTransforms
    , x
    , xy
    , y
    )

import Css
import New.Elemental.Lib.Axis as Axis
import New.Elemental.Lib.Either as Either exposing (Either)
import New.Elemental.Lib.Size as Size


type Nudge
    = Nudge (Axis.D2 Distance)


xy : Distance -> Distance -> Nudge
xy x_ y_ =
    Nudge { x = x_, y = y_ }


x : Distance -> Nudge
x x_ =
    xy x_ (px 0)


y : Distance -> Nudge
y y_ =
    xy (px 0) y_


toCssTransforms : Nudge -> List (Css.Transform {})
toCssTransforms (Nudge axis) =
    [ distanceToCssTransform Css.translateX Css.translateX axis.x
    , distanceToCssTransform Css.translateY Css.translateY axis.y
    ]


toCssStyle : Nudge -> Css.Style
toCssStyle =
    toCssTransforms >> Css.transforms


type alias Distance =
    Either Size.Pct Size.Px


px : Float -> Distance
px =
    Size.px >> Either.Right


pct : Float -> Distance
pct =
    Size.pct >> Either.Left


distanceToCssTransform : (Css.Pct -> Css.Transform {}) -> (Css.Px -> Css.Transform {}) -> Distance -> Css.Transform {}
distanceToCssTransform pctToTransform pxToTransform distance =
    distance
        |> Either.mapBoth
            (Size.pctToCssValue >> pctToTransform)
            (Size.pxToCssValue >> pxToTransform)
        |> Either.unwrap
