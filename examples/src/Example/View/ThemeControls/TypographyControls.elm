module Example.View.ThemeControls.TypographyControls exposing (..)

import Css
import Dict
import Elemental.Css.BorderRadius as BorderRadius
import Elemental.Form.Field.Select as Select
import Elemental.Form.Field.Switch as Switch
import Elemental.Form.Validate as V
import Elemental.Layout as L
import Elemental.Typography as Typography exposing (Typography)
import Elemental.View.Form.Field as Support
import Elemental.View.Form.Field.Input as Input
import Elemental.View.Form.Field.Switch as Switch
import Elm
import Elm.ToString
import Example.Colors as Colors
import Example.Gen.Tree
import Example.Gen.Typography as GenTypo exposing (TypographyTree)
import Example.Layout as L
import Example.Port
import Example.Theme as Theme exposing (Theme)
import Example.Typography as Typography exposing (ThemeTypography)
import Example.Typography.Helpers as Typography exposing (..)
import Example.View.Codeblock as Codeblock
import Example.Form.Field.Select as Select
import Example.View.Form.Field.Switch as Switch
import Html.Styled as H
import Html.Styled.Attributes as HA



-- VIEW


type alias Options msg =
    { theme : Theme
    , onUpdateTypography : GenTypo.TypographyTree -> msg
    }


view : Options msg -> List String -> GenTypo.TypographyTree -> H.Html msg
view { theme, onUpdateTypography } customFonts typographyTheme =
    let
        typographyList =
            typographyTheme
                |> Example.Gen.Tree.toList
    in
    L.viewColumn L.Normal [] <|
        List.intersperse
            (H.div [ HA.css [ Css.borderTop3 (Css.px 1) Css.solid theme.colors.border ] ]
                [ L.layout.spacerY 8
                ]
            )
        <|
            List.map
                (\( name, typography ) ->
                    viewTypography
                        theme
                        customFonts
                        { styleName = name
                        , onUpdateTypography =
                            \t ->
                                typographyList
                                    |> List.map
                                        (\( styleName, typography_ ) ->
                                            if styleName == name then
                                                ( styleName, t )

                                            else
                                                ( styleName, typography_ )
                                        )
                                    |> Example.Gen.Tree.fromList "typography"
                                    |> onUpdateTypography
                        , typography = typography
                        }
                )
                typographyList



-- [ L.viewColumn L.Normal
--     []
--     [ H.h6 [] [ H.text "Heading " ]
--     , L.layout.spacerY 4
--     , viewTypography
--         theme
--         customFonts
--         { styleName = "Heading/H4"
--         , onUpdateTypography = onUpdateTypography
--         , intoTypographyTheme =
--             \typography ->
--                 let
--                     heading =
--                         typographyTheme.heading
--                 in
--                 { typographyTheme | heading = { heading | h4 = typography } }
--         , typography = typographyTheme.heading.h4
--         }
--     , viewTypography
--         theme
--         customFonts
--         { styleName = "Heading/H5"
--         , onUpdateTypography = onUpdateTypography
--         , intoTypographyTheme =
--             \typography ->
--                 let
--                     heading =
--                         typographyTheme.heading
--                 in
--                 { typographyTheme | heading = { heading | h5 = typography } }
--         , typography = typographyTheme.heading.h5
--         }
--     , viewTypography
--         theme
--         customFonts
--         { styleName = "Heading/H6"
--         , onUpdateTypography = onUpdateTypography
--         , intoTypographyTheme =
--             \typography ->
--                 let
--                     heading =
--                         typographyTheme.heading
--                 in
--                 { typographyTheme | heading = { heading | h6 = typography } }
--         , typography = typographyTheme.heading.h6
--         }
--     ]
-- , L.viewColumn L.Normal
--     []
--     [ H.h6 [] [ H.text "Body " ]
--     , L.layout.spacerY 4
--     , viewTypography
--         theme
--         customFonts
--         { styleName = "Body/Medium"
--         , onUpdateTypography = onUpdateTypography
--         , intoTypographyTheme =
--             \typography ->
--                 let
--                     body =
--                         typographyTheme.body
--                 in
--                 { typographyTheme | body = { body | medium = typography } }
--         , typography = typographyTheme.body.medium
--         }
--     , viewTypography
--         theme
--         customFonts
--         { styleName = "Body/Small"
--         , onUpdateTypography = onUpdateTypography
--         , intoTypographyTheme =
--             \typography ->
--                 let
--                     body =
--                         typographyTheme.body
--                 in
--                 { typographyTheme | body = { body | small = typography } }
--         , typography = typographyTheme.body.small
--         }
--     ]
-- , viewTypography
--     theme
--     customFonts
--     { styleName = "Code"
--     , onUpdateTypography = onUpdateTypography
--     , intoTypographyTheme =
--         \typography ->
--             { typographyTheme | code = typography }
--     , typography = typographyTheme.code
--     }
-- , L.viewColumn L.Normal
--     []
--     [ H.h6 [] [ H.text "Form Field " ]
--     , L.layout.spacerY 4
--     , viewTypography
--         theme
--         customFonts
--         { styleName = "Label"
--         , onUpdateTypography = onUpdateTypography
--         , intoTypographyTheme =
--             \typography ->
--                 let
--                     formField =
--                         typographyTheme.form.field
--                     newFormField =
--                         { formField | label = typography }
--                     form =
--                         typographyTheme.form
--                     newForm =
--                         { form | field = newFormField }
--                 in
--                 { typographyTheme | form = newForm }
--         , typography = typographyTheme.form.field.label
--         }
--     ]
-- , viewTypography
--     theme
--     customFonts
--     { styleName = "Support"
--     , onUpdateTypography = onUpdateTypography
--     , intoTypographyTheme =
--         \typography ->
--             let
--                 formField =
--                     typographyTheme.form.field
--                 newFormField =
--                     { formField | support = typography }
--                 form =
--                     typographyTheme.form
--                 newForm =
--                     { form | field = newFormField }
--             in
--             { typographyTheme | form = newForm }
--     , typography = typographyTheme.form.field.support
--     }
-- ]


viewTypography theme customFonts { styleName, onUpdateTypography, typography } =
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

        selectModel : input -> Select.Model input
        selectModel initialValue =
            Select.field.init
                { value = initialValue
                , validator = V.firstError []
                }
                |> Tuple.first

        selectView options model intoTypography =
            H.div [ HA.css [ Css.width <| Css.px 200 ] ]
                [ Select.field.view options model
                    |> H.map
                        (\selectMsg ->
                            Select.field.update selectMsg model
                                |> Tuple.first
                                |> Select.field.getValue
                                |> intoTypography
                                |> onUpdateTypography
                        )
                ]

        switchOptions { label, intoTypography } =
            Switch.toOptions
                { theme = theme
                , layout = L.layout
                , text = label
                , disabled = False
                , size = Switch.Small
                , spacerMultiples =
                    { y = always 2
                    , text = always 1
                    }
                , onToggle = intoTypography >> onUpdateTypography
                }
    in
    H.div
        []
        [ H.div
            [ HA.css [ Typography.toStyle typography ] ]
            [ H.text styleName ]
        , L.viewColumn L.Normal
            []
            [ L.layout.spacerY 2
            , L.viewRow L.Normal
                []
                [ selectView
                    (selectOptions
                        { label = "Family"
                        , choices =
                            Typography.namedFontFamilies
                                ++ (customFonts
                                        |> List.map (\font -> ( font, [ font ] ))
                                   )
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
                , L.layout.spacerX 4
                , selectView
                    (selectOptions
                        { label = "Size"
                        , choices = List.range 10 24 ++ [ 28, 32, 36, 40, 48 ]
                        , toSelectChoice =
                            \size ->
                                { text = String.fromInt size
                                , placeholder = False
                                , value = size
                                }
                        }
                    )
                    (selectModel (round typography.size))
                    (\value -> { typography | size = toFloat value })
                ]
            , L.layout.spacerY 2
            , L.viewRow L.Normal
                []
                [ selectView
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
                , L.layout.spacerX 4
                , selectView
                    (selectOptions
                        { label = "Bold Weight"
                        , choices = Typography.allWeights
                        , toSelectChoice =
                            \weight ->
                                { text = Typography.weightToName weight
                                , placeholder = False
                                , value = Typography.weightToInt weight
                                }
                        }
                    )
                    (selectModel typography.boldWeight)
                    (\value -> { typography | boldWeight = value })
                ]
            , L.layout.spacerY 2
            , L.viewWrappedRow
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
            , H.details
                [ HA.css
                    [ Typography.toStyle theme.typography.code
                    , Css.cursor Css.pointer
                    ]
                ]
                [ H.summary [] [ H.text "Code" ]
                , viewTypographyCode theme typography
                ]
            , L.layout.spacerY 4
            ]
        ]


viewTypographyCode : Theme -> Typography -> H.Html msg
viewTypographyCode theme typography =
    Codeblock.view theme
        [ H.div [ HA.css [ Css.whiteSpace Css.preWrap ] ] <|
            List.singleton <|
                H.text <|
                    .body <|
                        Elm.ToString.expression <|
                            Elm.record
                                [ ( "families", Elm.list <| List.map Elm.string typography.families )
                                , ( "size", Elm.float typography.size )
                                , ( "normalWeight", Elm.int typography.normalWeight )
                                , ( "boldWeight", Elm.int typography.boldWeight )
                                , ( "lineHeight", Elm.float typography.lineHeight )
                                , ( "letterSpacing", Elm.float typography.letterSpacing )
                                , ( "bold", Elm.bool typography.bold )
                                , ( "underline", Elm.bool typography.underline )
                                , ( "italic", Elm.bool typography.italic )
                                , ( "uppercase", Elm.bool typography.uppercase )
                                ]
        ]
