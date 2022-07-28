module New.Elemental.Box.Style.Opacity exposing
    ( Opacity
    , fromFloat
    , opaque
    , toCssStyle
    , transparent
    )

import Css


type Opacity
    = Opacity Float


transparent : Opacity
transparent =
    Opacity 0


opaque : Opacity
opaque =
    Opacity 1


fromFloat : Float -> Opacity
fromFloat =
    max 0 >> min 1 >> Opacity


toCssStyle : Opacity -> Css.Style
toCssStyle (Opacity n) =
    Css.opacity <| Css.num n
