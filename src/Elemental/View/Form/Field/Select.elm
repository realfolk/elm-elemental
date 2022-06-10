module Elemental.View.Form.Field.Select exposing
    ( Choice
    , Options
    , Theme
    , view
    , viewDefaultCaret
    )

import Css
import Dict exposing (Dict)
import Elemental.Css as LibCss
import Elemental.Css.BorderRadius as BorderRadius
import Elemental.Layout as Layout exposing (Layout)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Svg.Styled as Svg
import Svg.Styled.Attributes as SvgAttrs


type alias Options value msg =
    { theme : Theme
    , layout : Layout msg
    , autofocus : Bool
    , disabled : Bool
    , error : Bool
    , onInput : Maybe value -> msg
    , viewCaret : Html msg
    , choices : List (Choice value)
    , customAttrs : List (Html.Attribute msg)
    }


type alias Choice value =
    { text : String
    , placeholder : Bool
    , value : value
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
        , caret : Float
        }
    }


view : Options value msg -> value -> Html msg
view options value =
    let
        accumulate choice ( maybeSelectedChoice_, choiceDict_ ) =
            ( if isSelected value choice then
                Just choice

              else
                maybeSelectedChoice_
            , Dict.insert choice.text choice.value choiceDict_
            )

        ( selectedChoice, choiceTextToValue ) =
            List.foldr accumulate ( Nothing, Dict.empty ) options.choices

        isPlaceholder =
            Maybe.map .placeholder selectedChoice
                |> Maybe.withDefault True

        selectedText =
            Maybe.map .text selectedChoice
                |> Maybe.withDefault " "

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
                , Css.color <|
                    if isPlaceholder then
                        fieldColors.foreground.placeholder

                    else
                        fieldColors.foreground.value
                ]

        focusStyle =
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
                , if isPlaceholder then
                    Css.color Css.transparent

                  else
                    Css.color fieldColors.foreground.disabled
                ]

        interactionStyle =
            if options.disabled then
                disabledStyle

            else
                Css.batch
                    [ normalStyle
                    , focusStyle
                    ]

        topBottomPadding =
            options.layout.computeSpacerSize options.theme.spacerMultiples.y
                -- Reduce Y padding by 1px on each side to match design.
                -- Figma "overlaps" the border on the spacer, losing 1px on both top and bottom.
                |> (+) -1
                |> Css.px

        styles =
            [ Css.width <| Css.pct 100
            , Css.position Css.relative
            , Css.padding2 topBottomPadding (options.layout.computeSpacerPx options.theme.spacerMultiples.x)
            , BorderRadius.toCssStyle options.theme.borderRadius
            , interactionStyle
            ]
    in
    Layout.viewRow Layout.Left
        styles
        [ options.layout.boxNone []
            [ LibCss.grow
            , Css.overflow Css.hidden
            , Css.textOverflow Css.ellipsis
            , Css.whiteSpace Css.noWrap
            ]
            [ Html.text selectedText ]
        , options.layout.spacerX options.theme.spacerMultiples.caret
        , options.viewCaret
        , viewHtmlSelect options value choiceTextToValue
        ]


viewHtmlSelect : Options value msg -> value -> Dict String value -> Html msg
viewHtmlSelect options value choiceTextToValue =
    let
        onInput text =
            Dict.get text choiceTextToValue
                |> options.onInput

        css =
            Attrs.css
                [ Css.position Css.absolute
                , Css.top Css.zero
                , Css.left Css.zero
                , Css.right Css.zero
                , Css.bottom Css.zero
                , Css.opacity Css.zero
                , Css.width <| Css.pct 100
                , LibCss.noAppearance
                ]

        baseAttrs =
            [ css
            , Attrs.autofocus options.autofocus
            , Attrs.disabled options.disabled
            ]

        additionalAttrs =
            if options.disabled then
                []

            else
                [ Events.onInput onInput ]

        attrs =
            options.customAttrs ++ baseAttrs ++ additionalAttrs
    in
    List.map (viewChoice value) options.choices
        |> Html.select attrs


viewChoice : value -> Choice value -> Html msg
viewChoice value choice =
    Html.option
        [ Attrs.value choice.text
        , Attrs.selected <| isSelected value choice
        ]
        [ Html.text choice.text ]


isSelected : value -> Choice value -> Bool
isSelected value choice =
    value == choice.value


viewDefaultCaret : Css.Color -> Html msg
viewDefaultCaret color =
    Svg.svg
        [ SvgAttrs.viewBox "0 0 10 6"
        , SvgAttrs.css
            [ Css.width <| Css.px 10
            , Css.height <| Css.px 6
            , Css.color color
            ]
        ]
        [ Svg.path [ SvgAttrs.fill "currentColor", SvgAttrs.d "M4.73442 5.88906L0.110139 1.26908C-0.036713 1.12116 -0.036713 0.881983 0.110139 0.734068L0.728792 0.110936C0.875644 -0.0369788 1.11311 -0.0369788 1.25996 0.110936L5 3.84028L8.74004 0.110936C8.88689 -0.0369788 9.12436 -0.0369788 9.27121 0.110936L9.88986 0.734068C10.0367 0.881983 10.0367 1.12116 9.88986 1.26908L5.26558 5.88906C5.11873 6.03698 4.88127 6.03698 4.73442 5.88906Z" ] []
        ]
