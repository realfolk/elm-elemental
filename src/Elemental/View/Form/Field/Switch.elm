module Elemental.View.Form.Field.Switch exposing
    ( Options
    , Size(..)
    , Theme
    , view
    )

import Css
import Css.Transitions
import Elemental.Css as LibCss
import Elemental.Layout as L
import Elemental.Typography as Typography exposing (Typography)
import Html.Styled as H
import Html.Styled.Attributes as HA
import Html.Styled.Events as Events


type alias Options msg =
    { theme : Theme
    , layout : L.Layout msg
    , text : String
    , disabled : Bool
    , size : Size
    , verticalPadding : Size -> Float
    , onToggle : Bool -> msg
    }


type Size
    = Small
    | Medium


type alias Theme =
    { colors :
        { background :
            { disabled : Css.Color
            , off : Css.Color
            , on : Css.Color
            }
        , border :
            { disabled : Css.Color
            , off : Css.Color
            , on : Css.Color
            }
        , foreground :
            { enabled : Css.Color
            , disabled : Css.Color
            }
        , handle :
            { background :
                { disabled : Css.Color
                , off : Css.Color
                , on : Css.Color
                }
            , border :
                { disabled : Css.Color
                , off : Css.Color
                , on : Css.Color
                }
            }
        }
    , typography :
        { label : Typography
        }
    , transitionDuration : Float
    }


view : Options msg -> Bool -> H.Html msg
view options isSelected =
    let
        ( width, height ) =
            case options.size of
                Small ->
                    ( 34, 20 )

                Medium ->
                    ( 42, 24 )

        dimensions =
            ( width, height )

        attrs =
            [ HA.css
                [ Css.width <| Css.px width
                , Css.height <| Css.px height
                , Css.position Css.relative
                ]
            ]
    in
    L.viewColumn
        L.Normal
        []
        [ options.layout.spacerY <|
            options.verticalPadding options.size
        , L.viewRow
            L.Normal
            []
            [ H.div attrs
                [ viewInput options dimensions isSelected
                , viewHandle options dimensions isSelected
                ]
            , viewLabel options isSelected
            ]
        , options.layout.spacerY <|
            options.verticalPadding options.size
        ]


viewInput : Options msg -> ( Float, Float ) -> Bool -> H.Html msg
viewInput options ( width, height ) isSelected =
    let
        fieldColors =
            options.theme.colors

        transitionDuration =
            options.theme.transitionDuration

        disabledStyle =
            Css.batch
                [ Css.backgroundColor fieldColors.background.disabled
                , LibCss.borderAll fieldColors.border.disabled
                ]

        normalStyle =
            Css.batch
                [ Css.backgroundColor <|
                    if isSelected then
                        fieldColors.background.on

                    else
                        fieldColors.background.off
                , LibCss.borderAll <|
                    if isSelected then
                        fieldColors.border.on

                    else
                        fieldColors.border.off
                , Css.Transitions.transition
                    [ Css.Transitions.left transitionDuration
                    , Css.Transitions.background transitionDuration
                    , Css.Transitions.borderColor transitionDuration
                    ]
                ]

        interactionStyle =
            if options.disabled then
                disabledStyle

            else
                normalStyle

        css =
            HA.css
                [ Css.width <| Css.px width
                , Css.height <| Css.px height
                , Css.borderRadius <| Css.px (height / 2)
                , interactionStyle
                ]

        baseAttrs =
            [ HA.type_ "checkbox"
            , HA.disabled options.disabled
            , HA.checked isSelected
            , css
            ]

        additionalAttrs =
            if options.disabled then
                [ HA.css
                    [ Css.cursor Css.notAllowed
                    ]
                ]

            else
                [ Events.onCheck options.onToggle
                , HA.css
                    [ Css.cursor Css.pointer
                    ]
                ]

        attrs =
            baseAttrs ++ additionalAttrs
    in
    H.input attrs []


viewHandle : Options msg -> ( Float, Float ) -> Bool -> H.Html msg
viewHandle options ( width, height ) isSelected =
    let
        fieldColors =
            options.theme.colors

        transitionDuration =
            options.theme.transitionDuration

        handlePadding =
            3

        size =
            height - (2 * handlePadding)

        disabledStyle =
            Css.batch
                [ Css.backgroundColor fieldColors.handle.background.disabled
                , LibCss.borderAll fieldColors.handle.border.disabled
                ]

        normalStyle =
            Css.batch
                [ Css.backgroundColor <|
                    if isSelected then
                        fieldColors.handle.background.on

                    else
                        fieldColors.handle.background.off
                , LibCss.borderAll <|
                    if isSelected then
                        fieldColors.handle.border.on

                    else
                        fieldColors.handle.border.off
                , Css.Transitions.transition
                    [ Css.Transitions.left transitionDuration
                    , Css.Transitions.background transitionDuration
                    , Css.Transitions.borderColor transitionDuration
                    ]
                ]

        css =
            Css.batch
                [ Css.width <| Css.px size
                , Css.height <| Css.px size
                , Css.borderRadius (Css.px (size / 2))
                , Css.border2 (Css.px 1) Css.solid
                , Css.left <|
                    if isSelected then
                        Css.px (width - handlePadding - size)

                    else
                        Css.px handlePadding
                , Css.top <| Css.px handlePadding
                , Css.position Css.absolute
                , Css.pointerEvents Css.none
                ]

        handleAttr =
            [ HA.css
                [ css
                , if options.disabled then
                    disabledStyle

                  else
                    normalStyle
                ]
            ]
    in
    H.span handleAttr []


viewLabel : Options msg -> Bool -> H.Html msg
viewLabel options currentValue =
    if String.isEmpty options.text then
        viewEmptyLabel

    else
        viewNonEmptyLabel options currentValue


viewEmptyLabel : H.Html msg
viewEmptyLabel =
    H.text ""


viewNonEmptyLabel : Options msg -> Bool -> H.Html msg
viewNonEmptyLabel options currentValue =
    let
        labelColors =
            options.theme.colors.foreground

        labelTypography =
            Typography.toStyle options.theme.typography.label

        labelStyle =
            [ labelTypography
            , Css.batch <|
                if options.disabled then
                    [ Css.cursor Css.notAllowed
                    , Css.color labelColors.disabled
                    ]

                else
                    [ Css.cursor Css.pointer
                    , Css.color labelColors.enabled
                    ]
            ]

        interactionAttr =
            if options.disabled then
                []

            else
                [ Events.onClick <|
                    options.onToggle (not currentValue)
                ]
    in
    H.div interactionAttr
        [ L.viewRow
            L.Normal
            labelStyle
            [ options.layout.spacerX 2
            , H.text options.text
            ]
        ]
