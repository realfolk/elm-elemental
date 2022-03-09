module Elemental.Css.BorderRadius exposing
    ( BorderRadius
    , Style
    , borderRadius
    , toCssStyle
    )

import Css


type alias BorderRadius =
    { all : Style
    , top : Style
    , right : Style
    , bottom : Style
    , left : Style
    }


type Style
    = Style Css.Style


borderRadius : Float -> BorderRadius
borderRadius size =
    let
        toStyle =
            Style << Css.batch << List.map ((|>) <| Css.px size)
    in
    { all = toStyle [ Css.borderRadius ]
    , top = toStyle [ Css.borderTopLeftRadius, Css.borderTopRightRadius ]
    , right = toStyle [ Css.borderTopRightRadius, Css.borderBottomRightRadius ]
    , bottom = toStyle [ Css.borderBottomLeftRadius, Css.borderBottomRightRadius ]
    , left = toStyle [ Css.borderTopLeftRadius, Css.borderBottomLeftRadius ]
    }


toCssStyle : Style -> Css.Style
toCssStyle (Style cssStyle) =
    cssStyle
