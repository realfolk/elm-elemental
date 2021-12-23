module Elemental.View.Badge exposing (Options, view)

import Css
import Elemental.Css as LibCss
import Elemental.Layout as L
import Elemental.Typography as Typography exposing (Typography)
import Html.Styled as H


type alias Options color msg =
    { layout : L.Layout msg
    , color : color
    , colorToCssColors : color -> { background : Css.Color, foreground : Css.Color }
    , typography : Typography
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
            , LibCss.borderRadiusAll.small
            , Typography.toStyle options.typography
            ]
    in
    options.layout.box 1 2 1 2 [] styles <| [ H.text text ]
