module New.Elemental.Box.Style.Rotate exposing
    ( Rotate
    , rotate
    , toCssStyle
    , toCssTransform
    )

import Css
import New.Elemental.Lib.Size as Size


type Rotate
    = Rotate Size.Deg


rotate : Size.Deg -> Rotate
rotate =
    Rotate


toCssTransform : Rotate -> Css.Transform {}
toCssTransform (Rotate deg) =
    Css.rotate <| Size.degToCssValue deg


toCssStyle : Rotate -> Css.Style
toCssStyle =
    toCssTransform >> Css.transform
