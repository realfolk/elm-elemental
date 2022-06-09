module Example.View.ThemeControls.Typography exposing (..)

import Css
import Elemental.Form.Field.Select as Select
import Elemental.Form.Field.Switch as Switch
import Elemental.Form.Validate as V
import Elemental.Layout as L
import Elemental.Typography exposing (Typography)
import Elemental.View.Form.Field as Support
import Elemental.View.Form.Field.Input as Input
import Elemental.View.Form.Field.Switch as Switch
import Example.Colors as Colors
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)
import Example.Typography as Typography exposing (ThemeTypography)
import Example.View.Form.Field.Select as Select
import Example.View.Form.Field.Switch as Switch
import Html.Styled as H


type alias Model =
    {}


type alias TypeConfiguration =
    {}



-- UPDATE


type Msg
    = UpdatedH4 TypeConfiguration


update msg typography =
    typography



-- VIEW


type alias Options msg =
    { theme : Theme
    , onUpdateTypography : ThemeTypography -> msg
    }


view : Options msg -> ThemeTypography -> H.Html msg
view { theme, onUpdateTypography } typographyTheme =
    L.viewColumn L.Normal
        []
        [ viewTypography theme
            { styleName = "H4 Heading"
            , onUpdateTypography = onUpdateTypography
            , intoTypographyTheme =
                \typography ->
                    let
                        heading =
                            typographyTheme.heading
                    in
                    { typographyTheme | heading = { heading | h4 = typography } }
            , typography = typographyTheme.heading.h4
            }
        , L.layout.spacerY 8
        , viewTypography theme
            { styleName = "H5 Heading"
            , onUpdateTypography = onUpdateTypography
            , intoTypographyTheme =
                \typography ->
                    let
                        heading =
                            typographyTheme.heading
                    in
                    { typographyTheme | heading = { heading | h5 = typography } }
            , typography = typographyTheme.heading.h5
            }
        , L.layout.spacerY 8
        , viewTypography theme
            { styleName = "H6 Heading"
            , onUpdateTypography = onUpdateTypography
            , intoTypographyTheme =
                \typography ->
                    let
                        heading =
                            typographyTheme.heading
                    in
                    { typographyTheme | heading = { heading | h6 = typography } }
            , typography = typographyTheme.heading.h6
            }
        , L.layout.spacerY 8
        , viewTypography
            theme
            { styleName = "Body Medium"
            , onUpdateTypography = onUpdateTypography
            , intoTypographyTheme =
                \typography ->
                    let
                        body =
                            typographyTheme.body
                    in
                    { typographyTheme | body = { body | medium = typography } }
            , typography = typographyTheme.body.medium
            }
        , L.layout.spacerY 8
        , viewTypography
            theme
            { styleName = "Body Small"
            , onUpdateTypography = onUpdateTypography
            , intoTypographyTheme =
                \typography ->
                    let
                        body =
                            typographyTheme.body
                    in
                    { typographyTheme | body = { body | small = typography } }
            , typography = typographyTheme.body.small
            }
        , L.layout.spacerY 8

        -- , viewTypographyCode typographyTheme
        ]


viewTypography theme { styleName, onUpdateTypography, intoTypographyTheme, typography } =
    let
        selectOptions { label, choices, toSelectChoice } =
            Select.toOptions
                { theme = theme
                , choices = choices
                , toSelectChoice = toSelectChoice
                , label = label
                , support = Support.Text ""
                , autofocus = False
                , required = False
                , disabled = False
                }

        selectModel initialValue =
            Select.field.init
                { value = initialValue
                , validator = V.firstError []
                }
                |> Tuple.first

        selectView options model intoTypography =
            Select.field.view options model
                |> H.map
                    (\selectMsg ->
                        Select.field.update selectMsg model
                            |> Tuple.first
                            |> Select.field.getValue
                            |> intoTypography
                            |> intoTypographyTheme
                            |> onUpdateTypography
                    )

        --
        switchOptions { label, intoTypography } =
            Switch.toOptions
                { theme = theme
                , layout = L.layout
                , text = label
                , disabled = False
                , size = Switch.Small
                , spacerMultiples =
                    { y = always 2
                    }
                , onToggle =
                    \value ->
                        value
                            |> intoTypography
                            |> intoTypographyTheme
                            |> onUpdateTypography
                }

        switchModel initialValue =
            Switch.field.init
                { value = initialValue
                , validator = V.firstError []
                }
                |> Tuple.first
    in
    L.viewColumn L.Normal
        []
        [ H.h6 [] [ H.text styleName ]
        , L.layout.spacerY 2
        , selectView
            (selectOptions
                { label = "Family"
                , choices = Typography.namedFontFamilies
                , toSelectChoice =
                    \( name, family ) ->
                        { text = name
                        , placeholder = False
                        , value = family
                        }
                }
            )
            (selectModel typography.families)
            (\value -> { typography | families = value })
        , L.layout.spacerY 2
        , selectView
            (selectOptions
                { label = "Normal Weight"
                , choices = Typography.allWeights
                , toSelectChoice =
                    \weight ->
                        { text = Typography.weightToName weight
                        , placeholder = False
                        , value = Typography.weightToInt weight
                        }
                }
            )
            (selectModel typography.normalWeight)
            (\value -> { typography | normalWeight = value })
        , L.layout.spacerY 2
        , L.viewRow L.Normal
            []
            [ Switch.view
                (switchOptions
                    { label = "Bold"
                    , intoTypography =
                        \value -> { typography | bold = value }
                    }
                )
                typography.bold
            , L.layout.spacerX 4
            , Switch.view
                (switchOptions
                    { label = "Underline"
                    , intoTypography =
                        \value -> { typography | underline = value }
                    }
                )
                typography.underline
            , L.layout.spacerX 4
            , Switch.view
                (switchOptions
                    { label = "Italic"
                    , intoTypography =
                        \value -> { typography | italic = value }
                    }
                )
                typography.italic
            , L.layout.spacerX 4
            , Switch.view
                (switchOptions
                    { label = "Uppercase"
                    , intoTypography =
                        \value -> { typography | uppercase = value }
                    }
                )
                typography.uppercase
            , L.layout.spacerX 4
            , L.layout.spacerX 4
            ]

        -- { families : FontFamilies
        -- , size : Float
        -- , normalWeight : Int
        -- , boldWeight : Int
        -- , lineHeight : Float
        -- , letterSpacing : Float
        -- , bold : Bool
        -- , underline : Bool
        -- , italic : Bool
        -- , uppercase : Bool
        -- }
        , viewTypographyCode typography
        ]


viewTypographyCode typography =
    let
        intToName =
            Typography.intToWeight >> Typography.weightToName
    in
    L.viewColumn L.Normal
        [ Css.width <| Css.pct 100
        , Css.backgroundColor Colors.border
        , Css.padding2 (Css.px 12) (Css.px 24)
        ]
        [ H.div [] [ H.text ("{ families = " ++ Debug.toString typography.families) ]
        , H.div [] [ H.text (", size = " ++ String.fromFloat typography.size) ]
        , H.div [] [ H.text (", normalWeight = " ++ String.fromInt typography.normalWeight ++ " (" ++ intToName typography.normalWeight ++ ")") ]
        , H.div [] [ H.text (", boldWeight = " ++ String.fromInt typography.boldWeight ++ " (" ++ intToName typography.boldWeight ++ ")") ]
        , H.div [] [ H.text (", lineHeight = " ++ String.fromFloat typography.lineHeight) ]
        , H.div [] [ H.text (", letterSpacing = " ++ String.fromFloat typography.letterSpacing) ]
        , H.div [] [ H.text (", bold = " ++ boolToStr typography.bold) ]
        , H.div [] [ H.text (", underline = " ++ boolToStr typography.underline) ]
        , H.div [] [ H.text (", italic = " ++ boolToStr typography.italic) ]
        , H.div [] [ H.text (", uppercase = " ++ boolToStr typography.uppercase) ]
        , H.div [] [ H.text ("}" ++ "") ]
        ]


boolToStr bool =
    if bool then
        "True"

    else
        "False"
