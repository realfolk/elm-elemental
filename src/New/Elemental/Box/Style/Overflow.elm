module New.Elemental.Box.Style.Overflow exposing
    ( Overflow
    , OverflowStyle(..)
    , overflow
    , toCssStyle
    )

import Css
import New.Elemental.Lib.Axis as Axis


type Overflow
    = Overflow (Axis.D2 OverflowStyle)


overflow : OverflowStyle -> OverflowStyle -> Overflow
overflow x y =
    Overflow <| Axis.D2 x y


toCssStyle : Overflow -> Css.Style
toCssStyle (Overflow overflow_) =
    Css.batch
        [ overflowStyleToCssStyle "overflow-x" overflow_.x
        , overflowStyleToCssStyle "overflow-y" overflow_.y
        ]


type OverflowStyle
    = Visible
    | Hidden
    | Scroll


overflowStyleToCssStyle : String -> OverflowStyle -> Css.Style
overflowStyleToCssStyle propertyName overflowStyle =
    Css.property propertyName <|
        case overflowStyle of
            Visible ->
                "visible"

            Hidden ->
                "hidden"

            Scroll ->
                "auto"
