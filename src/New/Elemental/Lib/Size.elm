module New.Elemental.Lib.Size exposing
    ( Deg
    , Em
    , Pct
    , Px
    , Rem
    , Vh
    , Vw
    , deg
    , degToCssValue
    , degToFloat
    , em
    , emToCssValue
    , emToFloat
    , pct
    , pctToCssValue
    , pctToFloat
    , px
    , pxToCssValue
    , pxToFloat
    , rem
    , remToCssValue
    , remToFloat
    , vh
    , vhToCssValue
    , vhToFloat
    , vw
    , vwToCssValue
    , vwToFloat
    )

import Css


type Px
    = Px Float


px : Float -> Px
px =
    Px


pxToCssValue : Px -> Css.Px
pxToCssValue (Px n) =
    Css.px n


pxToFloat : Px -> Float
pxToFloat (Px n) =
    n


type Pct
    = Pct Float


pct : Float -> Pct
pct =
    Pct


pctToCssValue : Pct -> Css.Pct
pctToCssValue (Pct n) =
    Css.pct n


pctToFloat : Pct -> Float
pctToFloat (Pct n) =
    n


type Em
    = Em Float


em : Float -> Em
em =
    Em


emToCssValue : Em -> Css.Em
emToCssValue (Em n) =
    Css.em n


emToFloat : Em -> Float
emToFloat (Em n) =
    n


type Rem
    = Rem Float


rem : Float -> Rem
rem =
    Rem


remToCssValue : Rem -> Css.Rem
remToCssValue (Rem n) =
    Css.rem n


remToFloat : Rem -> Float
remToFloat (Rem n) =
    n


type Vh
    = Vh Float


vh : Float -> Vh
vh =
    Vh


vhToCssValue : Vh -> Css.Vh
vhToCssValue (Vh n) =
    Css.vh n


vhToFloat : Vh -> Float
vhToFloat (Vh n) =
    n


type Vw
    = Vw Float


vw : Float -> Vw
vw =
    Vw


vwToCssValue : Vw -> Css.Vw
vwToCssValue (Vw n) =
    Css.vw n


vwToFloat : Vw -> Float
vwToFloat (Vw n) =
    n


type Deg
    = Deg Float


deg : Float -> Deg
deg =
    Deg


degToCssValue : Deg -> Css.AngleOrDirection (Css.Angle {})
degToCssValue (Deg n) =
    Css.deg n


degToFloat : Deg -> Float
degToFloat (Deg n) =
    n
