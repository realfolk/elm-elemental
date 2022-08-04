module New.Elemental.Box.Style.Corners exposing
    ( CornerStyle(..)
    , Corners
    , all
    , corners
    , leftAndRight
    , toCssStyle
    , topAndBottom
    )

import Css
import New.Elemental.Lib.Size as Size


type alias Corners =
    { topLeft : CornerStyle
    , topRight : CornerStyle
    , bottomRight : CornerStyle
    , bottomLeft : CornerStyle
    }


corners : CornerStyle -> CornerStyle -> CornerStyle -> CornerStyle -> Corners
corners topLeft topRight bottomRight bottomLeft =
    { topLeft = topLeft
    , topRight = topRight
    , bottomRight = bottomRight
    , bottomLeft = bottomLeft
    }


topAndBottom : CornerStyle -> CornerStyle -> Corners
topAndBottom top bottom =
    corners top top bottom bottom


leftAndRight : CornerStyle -> CornerStyle -> Corners
leftAndRight left right =
    corners left right right left


all : CornerStyle -> Corners
all style =
    corners style style style style


toCssStyle : Corners -> Css.Style
toCssStyle corners_ =
    Css.batch
        [ cornerStyleToCssStyle Css.borderTopLeftRadius corners_.topLeft
        , cornerStyleToCssStyle Css.borderTopRightRadius corners_.topRight
        , cornerStyleToCssStyle Css.borderBottomLeftRadius corners_.bottomLeft
        , cornerStyleToCssStyle Css.borderBottomRightRadius corners_.bottomRight
        ]


type CornerStyle
    = Sharp
    | Rounded Size.Px


cornerStyleToCssStyle : (Css.Px -> Css.Style) -> CornerStyle -> Css.Style
cornerStyleToCssStyle toStyle cornerStyle =
    toStyle <|
        case cornerStyle of
            Sharp ->
                Css.px 0

            Rounded px ->
                Size.pxToCssValue px
