module Elemental.View.Form.Field.Input exposing
    ( Icon
    , Options
    , Size(..)
    , Theme
    , Type(..)
    , view
    )

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
    , type_ : Type
    , size : Size
    , icon : Maybe (Icon msg)
    , autofocus : Bool
    , disabled : Bool
    , error : Bool
    , placeholder : String
    , onInput : String -> msg
    , customAttrs : List (H.Attribute msg)
    , maybeOnInteraction : Maybe (Interaction.Config msg)
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
        { y : Size -> Float
        , x : Size -> Float
        }
    }


type Type
    = Text
    | Email


type Size
    = Small
    | Medium


type alias Icon msg =
    H.Html msg


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

        normalWrapperStyle =
            Css.batch
                [ border fieldColors.border.normal
                , Css.backgroundColor fieldColors.background.normal
                , Css.color fieldColors.foreground.value
                ]

        normalInputStyle =
            Css.batch
                [ Css.backgroundColor fieldColors.background.normal
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

        focusWrapperStyle =
            Css.pseudoClass "focus-within"
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

        disabledWrapperStyle =
            Css.batch
                [ border fieldColors.border.normal
                , Css.backgroundColor fieldColors.background.disabled
                , Css.color fieldColors.foreground.disabled
                ]

        disabledInputStyle =
            Css.batch
                [ Css.backgroundColor fieldColors.background.disabled
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

        wrapperStyle =
            if options.disabled then
                disabledWrapperStyle

            else
                Css.batch
                    [ normalWrapperStyle
                    , focusWrapperStyle
                    ]

        inputStyle =
            if options.disabled then
                disabledInputStyle

            else
                normalInputStyle

        ( topBottomMultiple, leftRightMultiple ) =
            ( options.theme.spacerMultiples.y options.size
            , options.theme.spacerMultiples.x options.size
            )

        topBottomPadding =
            options.layout.computeSpacerSize topBottomMultiple
                -- Reduce Y padding by 1px on each side to match design.
                -- Figma "overlaps" the border on the spacer, losing 1px on both top and bottom.
                |> (+) -1
                |> Css.px

        css =
            HA.css
                [ Css.width <| Css.pct 100
                , Css.padding2 topBottomPadding (options.layout.computeSpacerPx leftRightMultiple)
                , BorderRadius.toCssStyle options.theme.borderRadius
                , style
                ]

        commonAttrs =
            [ HA.type_ <|
                case options.type_ of
                    Text ->
                        "text"

                    Email ->
                        "email"
            , HA.placeholder options.placeholder
            , HA.autofocus options.autofocus
            , HA.disabled options.disabled
            , HA.value value
            ]

        baseAttrs =
            commonAttrs ++ [ css ]

        additionalAttrs =
            if options.disabled then
                []

            else
                Interaction.onInteraction options.maybeOnInteraction
                    ++ [ HE.onInput options.onInput ]

        attrs =
            options.customAttrs ++ baseAttrs ++ additionalAttrs
    in
    case options.icon of
        Just icon ->
            L.viewRow
                L.Normal
                [ Css.width <| Css.pct 100
                , Css.padding2 topBottomPadding (options.layout.computeSpacerPx leftRightMultiple)
                , BorderRadius.toCssStyle options.theme.borderRadius
                , wrapperStyle
                ]
                [ L.viewRow
                    L.Normal
                    []
                    [ icon
                    , options.layout.spacerX 1.5
                    ]
                , H.input
                    (options.customAttrs
                        ++ commonAttrs
                        ++ [ HA.css
                                [ Css.width <| Css.pct 100
                                , inputStyle
                                ]
                           ]
                        ++ additionalAttrs
                    )
                    []
                ]

        Nothing ->
            H.input attrs []
