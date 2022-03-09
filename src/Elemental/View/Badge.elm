module Elemental.View.Badge exposing (Options, view)

import Css
import Elemental.Css.BorderRadius as BorderRadius
import Elemental.Layout as L
import Elemental.Typography as Typography exposing (Typography)
import Html.Styled as H


type alias Options color msg =
    { layout : L.Layout msg
    , color : color
    , colorToCssColors : color -> { background : Css.Color, foreground : Css.Color }
    , typography : Typography
    , borderRadius : BorderRadius.Style
    }


view : Options color msg -> String -> H.Html msg
view options text =
    let
        { background, foreground } =
            options.colorToCssColors options.color

        styles =
            [ Css.flexGrow <| Css.zero
            , Css.flexShrink <| Css.zero
            , Css.backgroundColor background
            , Css.color foreground
            , BorderRadius.toCssStyle options.borderRadius
            , Typography.toStyle options.typography
            ]
    in
    -- FIXME: Should we abstract these numbers: 1 2 1 2?
    options.layout.box 1 2 1 2 [] styles <| [ H.text text ]
