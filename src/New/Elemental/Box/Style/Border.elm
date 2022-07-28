module New.Elemental.Box.Style.Border exposing
    ( Border
    , BorderStyle(..)
    , solid
    , toCssStyle
    )

import Css
import New.Elemental.Lib.Color as Color exposing (Color)
import New.Elemental.Lib.Size as Size


type Border
    = Border
        { style : BorderStyle
        , thickness : Size.Px
        , color : Color
        }


solid : Size.Px -> Color -> Border
solid thickness color =
    Border
        { style = Solid
        , thickness = thickness
        , color = color
        }


toCssStyle : Border -> Css.Style
toCssStyle (Border border) =
    Css.batch
        [ Css.borderWidth <| Size.pxToCssValue border.thickness
        , Css.borderColor <| Color.toCssValue border.color
        , borderStyleToCssStyle border.style
        ]


type BorderStyle
    = Solid


borderStyleToCssStyle : BorderStyle -> Css.Style
borderStyleToCssStyle style =
    case style of
        Solid ->
            Css.borderStyle Css.solid
