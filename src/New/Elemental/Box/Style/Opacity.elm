module New.Elemental.Box.Style.Opacity exposing
    ( Opacity
    , opacity
    , opaque
    , toCssStyle
    , transparent
    )

import Css


type Opacity
    = Opacity Float


opacity : Float -> Opacity
opacity =
    max 0 >> min 1 >> Opacity


transparent : Opacity
transparent =
    Opacity 0


opaque : Opacity
opaque =
    Opacity 1


toCssStyle : Opacity -> Css.Style
toCssStyle (Opacity n) =
    Css.opacity <| Css.num n
