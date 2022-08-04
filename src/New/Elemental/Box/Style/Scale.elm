module New.Elemental.Box.Style.Scale exposing
    ( Scale
    , scale
    , toCssStyle
    , toCssTransform
    )

import Css


type Scale
    = Scale Float


scale : Float -> Scale
scale =
    max 0 >> Scale


toCssTransform : Scale -> Css.Transform {}
toCssTransform (Scale n) =
    Css.scale n


toCssStyle : Scale -> Css.Style
toCssStyle =
    toCssTransform >> Css.transform
