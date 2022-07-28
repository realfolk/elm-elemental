module New.Elemental.Box.Style.Corners exposing (Corners(..), toCssStyle)

import Css
import New.Elemental.Lib.Size as Size


type Corners
    = Sharp
    | Rounded Size.Px


toCssStyle : Corners -> Css.Style
toCssStyle corners =
    case corners of
        Sharp ->
            Css.borderRadius Css.zero

        Rounded px ->
            Css.borderRadius <| Size.pxToCssValue px
