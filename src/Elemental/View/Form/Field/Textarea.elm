module Elemental.View.Form.Field.Textarea exposing (Options, Theme, view)

import Css
import Elemental.Css as LibCss
import Elemental.Css.BorderRadius as BorderRadius
import Elemental.Form.Interaction as Interaction exposing (Interaction)
import Elemental.Layout as L
import Html.Styled as H
import Html.Styled.Attributes as HA
import Html.Styled.Events as HE


type alias Options msg =
    { theme : Theme
    , layout : L.Layout msg
    , disabled : Bool
    , error : Bool
    , placeholder : String
    , height : Float
    , onInput : String -> msg
    , interaction : Interaction msg
    }


type alias Theme =
    { colors :
        { background :
            { disabled : Css.Color
            , normal : Css.Color
            }
        , border :
            { error : Css.Color
            , focus : Css.Color
            , normal : Css.Color
            }
        , focusHighlight :
            { error : Css.Color
            , normal : Css.Color
            }
        , foreground :
            { disabled : Css.Color
            , placeholder : Css.Color
            , value : Css.Color
            }
        }
    , borderRadius : BorderRadius.Style
    , spacerMultiples :
        { y : Float
        , x : Float
        }
    }


view : Options msg -> String -> H.Html msg
view options value =
    let
        fieldColors =
            options.theme.colors

        hasError =
            options.error

        border fallbackColor =
            LibCss.borderAll <|
                if hasError then
                    fieldColors.border.error

                else
                    fallbackColor

        normalStyle =
            Css.batch
                [ border fieldColors.border.normal
                , Css.backgroundColor fieldColors.background.normal
                , Css.color fieldColors.foreground.value
                , LibCss.placeholder
                    [ Css.color fieldColors.foreground.placeholder ]
                ]

        focusStyle =
            Css.focus
                [ border fieldColors.border.focus
                , Css.outline Css.none
                , LibCss.focusHighlight <|
                    if hasError then
                        fieldColors.focusHighlight.error

                    else
                        fieldColors.focusHighlight.normal
                ]

        disabledStyle =
            Css.batch
                [ border fieldColors.border.normal
                , Css.backgroundColor fieldColors.background.disabled
                , Css.color fieldColors.foreground.disabled
                , LibCss.placeholder
                    [ Css.opacity Css.zero ]
                ]

        style =
            if options.disabled then
                disabledStyle

            else
                Css.batch
                    [ normalStyle
                    , focusStyle
                    ]

        css =
            HA.css
                [ Css.width <| Css.pct 100
                , Css.height <| Css.px options.height
                , Css.resize Css.vertical
                , Css.padding2
                    (options.layout.computeSpacerPx options.theme.spacerMultiples.y)
                    (options.layout.computeSpacerPx options.theme.spacerMultiples.x)
                , BorderRadius.toCssStyle options.theme.borderRadius
                , style
                ]

        baseAttrs =
            [ HA.placeholder options.placeholder
            , HA.disabled options.disabled
            , HA.value value
            , css
            ]

        additionalAttrs =
            if options.disabled then
                []

            else
                Interaction.toAttrs options.interaction
                    ++ [ HE.onInput options.onInput ]

        attrs =
            baseAttrs ++ additionalAttrs
    in
    H.textarea attrs []
