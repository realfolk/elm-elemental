module Elemental.View.Form.Field.Checkbox exposing
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
    , onToggle : Bool -> msg
    , icon : Size -> Css.Color -> H.Html msg
    }


type Size
    = Small
    | Medium


type alias Theme =
    { colors :
        { background :
            { disabled : Css.Color
            , unchecked : Css.Color
            , checked : Css.Color
            }
        , border :
            { disabled : Css.Color
            , unchecked : Css.Color
            , checked : Css.Color
            }
        , foreground :
            { normal : Css.Color
            , disabled : Css.Color
            }
        , label :
            { normal : Css.Color
            , disabled : Css.Color
            }
        }
    , spacerMultiples :
        { y : Size -> Float
        , text : Size -> Float
        }
    , transitionDuration : Float
    , typography :
        { label : Typography
        }
    }


view : Options msg -> Bool -> H.Html msg
view options isSelected =
    let
        ( width, height ) =
            case options.size of
                Small ->
                    ( 20, 20 )

                Medium ->
                    ( 24, 24 )

        dimensions =
            ( width, height )

        attrs =
            [ HA.css
                [ Css.width <| Css.px width
                , Css.height <| Css.px height
                , Css.position Css.relative
                , Css.displayFlex
                , Css.flexWrap Css.noWrap
                , Css.justifyContent Css.center
                , Css.alignItems Css.center
                ]
            ]
    in
    L.viewColumn
        L.Normal
        []
        [ options.layout.spacerY <|
            options.theme.spacerMultiples.y options.size
        , L.viewRow
            L.Normal
            []
            [ H.div attrs
                [ viewInput options dimensions isSelected
                , viewCheck options isSelected
                ]
            , viewLabel options isSelected
            ]
        , options.layout.spacerY <|
            options.theme.spacerMultiples.y options.size
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
                        fieldColors.background.checked

                    else
                        fieldColors.background.unchecked
                , LibCss.borderAll <|
                    if isSelected then
                        fieldColors.border.checked

                    else
                        fieldColors.border.unchecked
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
                , Css.borderRadius <| Css.px 4
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


viewCheck : Options msg -> Bool -> H.Html msg
viewCheck options isSelected =
    let
        checkColor =
            if options.disabled then
                options.theme.colors.foreground.disabled

            else
                options.theme.colors.foreground.normal

        icon =
            options.icon options.size checkColor

        css =
            HA.css
                [ Css.displayFlex
                , Css.flexWrap Css.noWrap
                , Css.justifyContent Css.center
                , Css.alignItems Css.center
                , Css.flexShrink <| Css.int 0
                , Css.flexGrow <| Css.int 0
                , Css.opacity <|
                    Css.int
                        (if isSelected then
                            1

                         else
                            0
                        )
                , Css.position Css.absolute
                , Css.pointerEvents Css.none
                , Css.color checkColor
                ]
    in
    H.div [ css ] [ icon ]


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
            options.theme.colors.label

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
                    , Css.color labelColors.normal
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
            [ options.layout.spacerX <|
                options.theme.spacerMultiples.text options.size
            , H.text options.text
            ]
        ]
