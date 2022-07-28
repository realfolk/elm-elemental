module New.Elemental.Data.Size exposing
    ( Em
    , Pct
    , Px
    , Rem
    , Vh
    , Vw
    , em
    , emToCssValue
    , pct
    , pctToCssValue
    , px
    , pxToCssValue
    , rem
    , remToCssValue
    , vh
    , vhToCssValue
    , vw
    , vwToCssValue
    )

import Css


type Px
    = Px Float


px =
    Px


pxToCssValue : Px -> Css.Px
pxToCssValue (Px n) =
    Css.px n


type Pct
    = Pct Float


pct =
    Pct


pctToCssValue : Pct -> Css.Pct
pctToCssValue (Pct n) =
    Css.pct n


type Em
    = Em Float


em =
    Em


emToCssValue : Em -> Css.Em
emToCssValue (Em n) =
    Css.em n


type Rem
    = Rem Float


rem =
    Rem


remToCssValue : Rem -> Css.Rem
remToCssValue (Rem n) =
    Css.rem n


type Vh
    = Vh Float


vh =
    Vh


vhToCssValue : Vh -> Css.Vh
vhToCssValue (Vh n) =
    Css.vh n


type Vw
    = Vw Float


vw =
    Vw


vwToCssValue : Vw -> Css.Vw
vwToCssValue (Vw n) =
    Css.vw n
