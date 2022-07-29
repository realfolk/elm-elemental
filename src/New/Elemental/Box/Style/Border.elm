module New.Elemental.Box.Style.Border exposing
    ( Border
    , BorderStyle(..)
    , border
    , solid
    , toCssStyle
    )

import Css
import New.Elemental.Lib.Color as Color exposing (Color)
import New.Elemental.Lib.Size as Size


type Border
    = Border
        { style : BorderStyle
        , width : Size.Px
        , color : Color
        }


border : BorderStyle -> Size.Px -> Color -> Border
border style width color =
    Border
        { style = style
        , width = width
        , color = color
        }


solid : Size.Px -> Color -> Border
solid =
    border Solid


toCssStyle : Border -> Css.Style
toCssStyle (Border border_) =
    Css.batch
        [ Css.borderWidth <| Size.pxToCssValue border_.width
        , Css.borderColor <| Color.toCssValue border_.color
        , borderStyleToCssStyle border_.style
        ]


type BorderStyle
    = Solid


borderStyleToCssStyle : BorderStyle -> Css.Style
borderStyleToCssStyle style =
    case style of
        Solid ->
            Css.borderStyle Css.solid
