module Example.View.ThemeControls.ColorControls exposing (..)

import Css
import Elemental.Layout as L
import Elemental.Typography as Typography
import Example.Colors exposing (Colors)
import Example.Layout as L
import Example.Theme exposing (Theme)
import Example.Typography as Typography
import Example.View.Codeblock as Codeblock
import Html.Styled as H
import Html.Styled.Attributes as HA
import Html.Styled.Events as HE


type ColorTree msg
    = ColorTree
        { id : String
        , name : String
        , codeName : String
        }
        (List (ColorTree msg))
    | Node (ColorSet msg)


type alias ColorSet msg =
    { styleName : String
    , colorSet : List (ColorItem msg)
    }


type alias ColorItem msg =
    { color : Css.Color
    , intoSet : Css.Color -> msg
    , name : String
    }



-- VIEW


type alias Options msg =
    { theme : Theme
    , onUpdateColors : Colors -> msg
    }


view : Options msg -> Colors -> H.Html msg
view { theme, onUpdateColors } themeColors =
    H.map onUpdateColors <|
        L.viewColumn L.Normal
            []
            [ foregroundTree theme themeColors
            , L.layout.spacerY 8
            , backgroundTree theme themeColors
            , L.layout.spacerY 8
            , borderTree theme themeColors
            , L.layout.spacerY 8
            , buttonTree theme themeColors
            , L.layout.spacerY 8
            , switchTree theme themeColors
            , L.layout.spacerY 8
            , checkboxTree theme themeColors
            , L.layout.spacerY 8
            , formTree theme themeColors
            , L.layout.spacerY 8
            ]


viewColorTree : Theme -> Bool -> ColorTree msg -> H.Html msg
viewColorTree theme showCode colorTree =
    case colorTree of
        ColorTree { id, name } children ->
            H.div [ HA.id id ]
                [ L.viewColumn L.Normal [] <|
                    ((if String.isEmpty name then
                        H.text ""

                      else
                        H.h6
                            [ HA.css
                                [ Css.display Css.inline ]
                            ]
                            [ H.text name ]
                     )
                        :: L.layout.spacerY 4
                        :: (children
                                |> List.map (viewColorTree theme False)
                           )
                    )
                , if showCode then
                    Codeblock.view theme
                        [ viewTreeCode theme True colorTree
                        , H.pre [] [ H.text "}" ]
                        ]

                  else
                    H.text ""
                ]

        Node colorSet ->
            viewColorSet theme colorSet


viewColorSet : Theme -> ColorSet msg -> H.Html msg
viewColorSet theme { styleName, colorSet } =
    let
        children =
            colorSet
                |> List.map (viewColor theme)
    in
    L.viewColumn L.Normal
        []
        [ H.div
            [ HA.css
                [ Typography.toStyle <| Typography.bold theme.typography.body.medium
                ]
            ]
            [ H.text <| String.toUpper styleName ]
        , L.viewColumn
            L.Normal
            []
            children
        , L.layout.spacerY 2
        ]


viewColor : Theme -> ColorItem msg -> H.Html msg
viewColor theme { color, intoSet, name } =
    let
        input =
            viewColorInput color
                (String.replace "#" ""
                    >> Css.hex
                    >> intoSet
                )
    in
    if String.isEmpty name then
        L.viewColumn L.Normal
            []
            [ input ]

    else
        L.viewColumn L.Normal
            []
            [ L.viewRow L.Normal
                []
                [ H.div
                    [ HA.css
                        [ Css.minWidth <| Css.px 80
                        , Typography.toStyle <| theme.typography.body.small
                        ]
                    ]
                    [ H.text name ]
                , L.layout.spacerX 4
                , input
                ]
            , L.layout.spacerX 2
            ]


viewColorInput color onChangeColor =
    H.input
        [ HA.type_ "color"
        , HA.css
            [ Css.width (Css.px 30)
            , Css.height (Css.px 32)
            ]
        , HE.onInput onChangeColor
        , HA.value (colorToHexWithAlpha color)
        ]
        []


foregroundTree theme themeColors =
    let
        foreground =
            themeColors.foreground
    in
    H.map (\newForeground -> { themeColors | foreground = newForeground }) <|
        viewColorTree theme True <|
            ColorTree
                { id = ""
                , name = ""
                , codeName = ""
                }
                [ Node
                    { styleName = "Foreground"
                    , colorSet =
                        [ { name = "Regular"
                          , intoSet =
                                \color -> { foreground | regular = color }
                          , color = themeColors.foreground.regular
                          }
                        , { name = "Soft"
                          , intoSet =
                                \color -> { foreground | soft = color }
                          , color = themeColors.foreground.soft
                          }
                        , { name = "Code"
                          , intoSet =
                                \color -> { foreground | code = color }
                          , color = themeColors.foreground.code
                          }
                        ]
                    }
                ]


backgroundTree theme themeColors =
    let
        background =
            themeColors.background
    in
    H.map (\newBackground -> { themeColors | background = newBackground }) <|
        viewColorTree theme True <|
            ColorTree
                { id = ""
                , name = ""
                , codeName = ""
                }
                [ Node
                    { styleName = "Background"
                    , colorSet =
                        [ { name = "Normal"
                          , intoSet =
                                \color -> { background | normal = color }
                          , color = background.normal
                          }
                        , { name = "Alternate"
                          , intoSet = \color -> { background | alternate = color }
                          , color = background.alternate
                          }
                        , { name = "Code"
                          , intoSet = \color -> { background | code = color }
                          , color = background.code
                          }
                        ]
                    }
                ]


borderTree theme themeColors =
    viewColorTree theme True <|
        ColorTree
            { id = ""
            , name = ""
            , codeName = ""
            }
            [ Node
                { styleName = ""
                , colorSet =
                    [ { name = "Border"
                      , intoSet =
                            \color ->
                                { themeColors | border = color }
                      , color = themeColors.border
                      }
                    ]
                }
            ]


switchSectionId =
    "switch-colors-section"


switchTree theme themeColors =
    let
        switch =
            themeColors.switch
    in
    H.map (\newSwitch -> { themeColors | switch = newSwitch }) <|
        viewColorTree theme True <|
            ColorTree
                { id = switchSectionId
                , name = "Switch"
                , codeName = "switch"
                }
                [ Node
                    { styleName = "Background"
                    , colorSet =
                        [ { name = "Disabled"
                          , intoSet =
                                \color ->
                                    let
                                        background =
                                            switch.background
                                    in
                                    { switch | background = { background | disabled = color } }
                          , color = switch.background.disabled
                          }
                        , { name = "On"
                          , intoSet =
                                \color ->
                                    let
                                        background =
                                            switch.background
                                    in
                                    { switch | background = { background | on = color } }
                          , color = switch.background.on
                          }
                        , { name = "Off"
                          , intoSet =
                                \color ->
                                    let
                                        background =
                                            switch.background
                                    in
                                    { switch | background = { background | off = color } }
                          , color = switch.background.off
                          }
                        ]
                    }
                , Node
                    { styleName = "Border"
                    , colorSet =
                        [ { name = "Disabled"
                          , intoSet =
                                \color ->
                                    let
                                        border =
                                            switch.border
                                    in
                                    { switch | border = { border | disabled = color } }
                          , color = switch.border.disabled
                          }
                        , { name = "On"
                          , intoSet =
                                \color ->
                                    let
                                        border =
                                            switch.border
                                    in
                                    { switch | border = { border | on = color } }
                          , color = switch.border.on
                          }
                        , { name = "Off"
                          , intoSet =
                                \color ->
                                    let
                                        border =
                                            switch.border
                                    in
                                    { switch | border = { border | off = color } }
                          , color = switch.border.off
                          }
                        ]
                    }
                , ColorTree
                    { id = ""
                    , name = "Handle"
                    , codeName = "handle"
                    }
                    [ Node
                        { styleName = "Background"
                        , colorSet =
                            [ { name = "Disabled"
                              , intoSet =
                                    \color ->
                                        let
                                            handle =
                                                switch.handle

                                            background =
                                                handle.background
                                        in
                                        { switch | handle = { handle | background = { background | disabled = color } } }
                              , color = switch.handle.background.disabled
                              }
                            , { name = "On"
                              , intoSet =
                                    \color ->
                                        let
                                            handle =
                                                switch.handle

                                            background =
                                                handle.background
                                        in
                                        { switch | handle = { handle | background = { background | on = color } } }
                              , color = switch.handle.background.on
                              }
                            , { name = "Off"
                              , intoSet =
                                    \color ->
                                        let
                                            handle =
                                                switch.handle

                                            background =
                                                handle.background
                                        in
                                        { switch | handle = { handle | background = { background | off = color } } }
                              , color = switch.handle.background.off
                              }
                            ]
                        }
                    , Node
                        { styleName = "Border"
                        , colorSet =
                            [ { name = "Disabled"
                              , intoSet =
                                    \color ->
                                        let
                                            handle =
                                                switch.handle

                                            border =
                                                handle.border
                                        in
                                        { switch | handle = { handle | border = { border | disabled = color } } }
                              , color = switch.handle.border.disabled
                              }
                            , { name = "On"
                              , intoSet =
                                    \color ->
                                        let
                                            handle =
                                                switch.handle

                                            border =
                                                handle.border
                                        in
                                        { switch | handle = { handle | border = { border | on = color } } }
                              , color = switch.handle.border.on
                              }
                            , { name = "Off"
                              , intoSet =
                                    \color ->
                                        let
                                            handle =
                                                switch.handle

                                            border =
                                                handle.border
                                        in
                                        { switch | handle = { handle | border = { border | off = color } } }
                              , color = switch.handle.border.off
                              }
                            ]
                        }
                    ]
                ]


checkboxTree theme themeColors =
    let
        checkbox =
            themeColors.checkbox
    in
    H.map (\newCheckbox -> { themeColors | checkbox = newCheckbox }) <|
        viewColorTree theme True <|
            ColorTree
                { id = ""
                , name = "Checkbox"
                , codeName = "checkbox"
                }
                [ Node
                    { styleName = "Background"
                    , colorSet =
                        [ { name = "Disabled"
                          , intoSet =
                                \color ->
                                    let
                                        background =
                                            checkbox.background
                                    in
                                    { checkbox | background = { background | disabled = color } }
                          , color = checkbox.background.disabled
                          }
                        , { name = "Checked"
                          , intoSet =
                                \color ->
                                    let
                                        background =
                                            checkbox.background
                                    in
                                    { checkbox | background = { background | checked = color } }
                          , color = checkbox.background.checked
                          }
                        , { name = "Unchecked"
                          , intoSet =
                                \color ->
                                    let
                                        background =
                                            checkbox.background
                                    in
                                    { checkbox | background = { background | unchecked = color } }
                          , color = checkbox.background.unchecked
                          }
                        ]
                    }
                , Node
                    { styleName = "Border"
                    , colorSet =
                        [ { name = "Disabled"
                          , intoSet =
                                \color ->
                                    let
                                        border =
                                            checkbox.border
                                    in
                                    { checkbox | border = { border | disabled = color } }
                          , color = checkbox.border.disabled
                          }
                        , { name = "Checked"
                          , intoSet =
                                \color ->
                                    let
                                        border =
                                            checkbox.border
                                    in
                                    { checkbox | border = { border | checked = color } }
                          , color = checkbox.border.checked
                          }
                        , { name = "Unchecked"
                          , intoSet =
                                \color ->
                                    let
                                        border =
                                            checkbox.border
                                    in
                                    { checkbox | border = { border | unchecked = color } }
                          , color = checkbox.border.unchecked
                          }
                        ]
                    }
                , Node
                    { styleName = "Foreground"
                    , colorSet =
                        [ { name = "Normal"
                          , intoSet =
                                \color ->
                                    let
                                        foreground =
                                            checkbox.foreground
                                    in
                                    { checkbox | foreground = { foreground | normal = color } }
                          , color = checkbox.foreground.normal
                          }
                        , { name = "Disabled"
                          , intoSet =
                                \color ->
                                    let
                                        foreground =
                                            checkbox.foreground
                                    in
                                    { checkbox | foreground = { foreground | disabled = color } }
                          , color = checkbox.foreground.disabled
                          }
                        ]
                    }
                ]


formTree theme themeColors =
    let
        form =
            themeColors.form
    in
    H.map (\newForm -> { themeColors | form = newForm }) <|
        viewColorTree theme True <|
            ColorTree
                { id = ""
                , name = "Form"
                , codeName = "form"
                }
                [ Node
                    { styleName = ""
                    , colorSet =
                        [ { name = "Error"
                          , intoSet =
                                \color ->
                                    { form | error = color }
                          , color = form.error
                          }
                        ]
                    }
                , ColorTree
                    { id = ""
                    , name = "Field"
                    , codeName = "field"
                    }
                    [ Node
                        { styleName = ""
                        , colorSet =
                            [ { name = "Caret"
                              , intoSet =
                                    \color ->
                                        let
                                            field =
                                                form.field
                                        in
                                        { form | field = { field | caret = color } }
                              , color = form.field.caret
                              }
                            , { name = "Label"
                              , intoSet =
                                    \color ->
                                        let
                                            field =
                                                form.field
                                        in
                                        { form | field = { field | label = color } }
                              , color = form.field.label
                              }
                            , { name = "Required"
                              , intoSet =
                                    \color ->
                                        let
                                            field =
                                                form.field
                                        in
                                        { form | field = { field | required = color } }
                              , color = form.field.required
                              }
                            , { name = "Support Text"
                              , intoSet =
                                    \color ->
                                        let
                                            field =
                                                form.field
                                        in
                                        { form | field = { field | supportText = color } }
                              , color = form.field.supportText
                              }
                            ]
                        }
                    , Node
                        { styleName = "Background"
                        , colorSet =
                            [ { name = "Disabled"
                              , intoSet =
                                    \color ->
                                        let
                                            field =
                                                form.field

                                            background =
                                                field.background
                                        in
                                        { form | field = { field | background = { background | disabled = color } } }
                              , color = form.field.background.disabled
                              }
                            , { name = "Focus"
                              , intoSet =
                                    \color ->
                                        let
                                            field =
                                                form.field

                                            background =
                                                field.background
                                        in
                                        { form | field = { field | background = { background | focus = color } } }
                              , color = form.field.background.focus
                              }
                            , { name = "Normal"
                              , intoSet =
                                    \color ->
                                        let
                                            field =
                                                form.field

                                            background =
                                                field.background
                                        in
                                        { form | field = { field | background = { background | normal = color } } }
                              , color = form.field.background.normal
                              }
                            ]
                        }
                    , Node
                        { styleName = "Border"
                        , colorSet =
                            [ { name = "Error"
                              , intoSet =
                                    \color ->
                                        let
                                            field =
                                                form.field

                                            border =
                                                field.border
                                        in
                                        { form | field = { field | border = { border | error = color } } }
                              , color = form.field.border.error
                              }
                            , { name = "Focus"
                              , intoSet =
                                    \color ->
                                        let
                                            field =
                                                form.field

                                            border =
                                                field.border
                                        in
                                        { form | field = { field | border = { border | focus = color } } }
                              , color = form.field.border.focus
                              }
                            , { name = "Normal"
                              , intoSet =
                                    \color ->
                                        let
                                            field =
                                                form.field

                                            border =
                                                field.border
                                        in
                                        { form | field = { field | border = { border | normal = color } } }
                              , color = form.field.border.normal
                              }
                            ]
                        }
                    , Node
                        { styleName = "Focus Highlight"
                        , colorSet =
                            [ { name = "Error"
                              , intoSet =
                                    \color ->
                                        let
                                            field =
                                                form.field

                                            focusHighlight =
                                                field.focusHighlight
                                        in
                                        { form | field = { field | focusHighlight = { focusHighlight | error = color } } }
                              , color = form.field.focusHighlight.error
                              }
                            , { name = "Normal"
                              , intoSet =
                                    \color ->
                                        let
                                            field =
                                                form.field

                                            focusHighlight =
                                                field.focusHighlight
                                        in
                                        { form | field = { field | focusHighlight = { focusHighlight | normal = color } } }
                              , color = form.field.focusHighlight.normal
                              }
                            ]
                        }
                    , Node
                        { styleName = "foreground"
                        , colorSet =
                            [ { name = "Disabled"
                              , intoSet =
                                    \color ->
                                        let
                                            field =
                                                form.field

                                            foreground =
                                                field.foreground
                                        in
                                        { form | field = { field | foreground = { foreground | disabled = color } } }
                              , color = form.field.foreground.disabled
                              }
                            , { name = "Placeholder"
                              , intoSet =
                                    \color ->
                                        let
                                            field =
                                                form.field

                                            foreground =
                                                field.foreground
                                        in
                                        { form | field = { field | foreground = { foreground | placeholder = color } } }
                              , color = form.field.foreground.placeholder
                              }
                            , { name = "Value"
                              , intoSet =
                                    \color ->
                                        let
                                            field =
                                                form.field

                                            foreground =
                                                field.foreground
                                        in
                                        { form | field = { field | foreground = { foreground | value = color } } }
                              , color = form.field.foreground.value
                              }
                            ]
                        }
                    ]
                ]


buttonSectionId =
    "button-colors-section"


buttonTree theme themeColors =
    let
        button =
            themeColors.button
    in
    L.viewColumn L.Normal
        []
        [ buttonSetTree buttonSectionId theme "Primary Button" "primary" button.primary
            |> H.map (\newColors -> { themeColors | button = { button | primary = newColors } })
        , L.layout.spacerY 4
        , buttonSetTree "" theme "Secondary Button" "secondary" button.secondary
            |> H.map (\newColors -> { themeColors | button = { button | secondary = newColors } })
        ]


buttonSetTree id theme title codeName button =
    viewColorTree theme True <|
        ColorTree
            { id = id
            , name = title
            , codeName = codeName
            }
            [ Node
                { styleName = "Background"
                , colorSet =
                    [ { name = "Normal"
                      , intoSet =
                            \color ->
                                let
                                    background =
                                        button.background
                                in
                                { button | background = { background | normal = color } }
                      , color = button.background.normal
                      }
                    , { name = "Disabled"
                      , intoSet =
                            \color ->
                                let
                                    background =
                                        button.background
                                in
                                { button | background = { background | disabled = color } }
                      , color = button.background.disabled
                      }
                    , { name = "Hover"
                      , intoSet =
                            \color ->
                                let
                                    background =
                                        button.background
                                in
                                { button | background = { background | hover = color } }
                      , color = button.background.hover
                      }
                    , { name = "Pressed"
                      , intoSet =
                            \color ->
                                let
                                    background =
                                        button.background
                                in
                                { button | background = { background | pressed = color } }
                      , color = button.background.pressed
                      }
                    ]
                }
            , Node
                { styleName = ""
                , colorSet =
                    [ { name = "Focus"
                      , intoSet =
                            \color ->
                                { button | focus = color }
                      , color = button.focus
                      }
                    ]
                }
            , Node
                { styleName = "Foreground"
                , colorSet =
                    [ { name = "Normal"
                      , intoSet =
                            \color ->
                                let
                                    foreground =
                                        button.foreground
                                in
                                { button | foreground = { foreground | normal = color } }
                      , color = button.foreground.normal
                      }
                    , { name = "Disabled"
                      , intoSet =
                            \color ->
                                let
                                    foreground =
                                        button.foreground
                                in
                                { button | foreground = { foreground | disabled = color } }
                      , color = button.foreground.disabled
                      }
                    ]
                }
            ]


viewTreeCode theme firstItem colorTree =
    case colorTree of
        ColorTree { name, codeName } children ->
            let
                innerBlock =
                    L.viewColumn L.Normal
                        []
                        -- H.text name
                        -- ::
                        (children
                            |> List.indexedMap
                                (\i child ->
                                    viewTreeCode theme (i == 0) child
                                )
                        )
            in
            if String.isEmpty codeName then
                innerBlock

            else
                L.viewColumn L.Normal
                    []
                    [ H.pre []
                        [ if firstItem then
                            H.text "{ "

                          else
                            H.text ", "
                        , H.text (String.toLower codeName ++ " =")
                        ]
                    , H.div
                        [ HA.css
                            [ Css.paddingLeft <| Css.px 16
                            ]
                        ]
                        [ Codeblock.customView1 theme
                            [ innerBlock
                            , H.pre [] [ H.text "}" ]
                            ]
                        ]
                    ]

        Node colorSet ->
            viewCode theme firstItem colorSet


viewCode : Theme -> Bool -> ColorSet msg -> H.Html msg
viewCode theme firstItem { colorSet, styleName } =
    let
        indent =
            String.padLeft
                (if includeStyleName then
                    6

                 else
                    0
                )
                ' '

        leading index =
            indent <|
                if index == 0 && (styleName /= "" || firstItem) then
                    "{ "

                else
                    ", "

        viewColorCode index { color, name } =
            H.pre [] [ H.text (leading index ++ toCamelCase name ++ " = Css.hex \"" ++ colorToHexWithAlpha color ++ "\"") ]

        includeStyleName =
            not <| String.isEmpty styleName

        children =
            (if includeStyleName then
                let
                    name =
                        toCamelCase styleName
                in
                [ H.pre []
                    [ if firstItem then
                        H.text "{ "

                      else
                        H.text ", "
                    , H.text (name ++ " =")
                    ]
                ]

             else
                []
            )
                ++ (colorSet
                        |> List.indexedMap viewColorCode
                        |> (\colorCode ->
                                colorCode
                                    ++ (if includeStyleName then
                                            [ H.pre [] [ H.text (indent "} ") ]
                                            ]

                                        else
                                            []
                                       )
                           )
                   )
    in
    children
        |> Codeblock.customView1 theme


toCamelCase styleName =
    styleName
        |> String.uncons
        |> Maybe.map
            (\parts ->
                case parts of
                    ( firstChar, tail ) ->
                        String.cons (Char.toLower firstChar) tail
                            |> String.replace " " ""
            )
        |> Maybe.withDefault ""



-- The MIT License (MIT)
-- Copyright (c) 2016 Andreas Köberle
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
-- https://github.com/eskimoblood/elm-color-extra


colorToHexWithAlpha : Css.Color -> String
colorToHexWithAlpha color =
    let
        toHex : Int -> String
        toHex =
            toRadix >> String.padLeft 2 '0'

        toRadix : Int -> String
        toRadix n =
            let
                getChr c =
                    if c < 10 then
                        String.fromInt c

                    else
                        String.fromChar <|
                            Char.fromCode (87 + c)
            in
            if n < 16 then
                getChr n

            else
                toRadix (n // 16) ++ getChr (modBy 16 n)

        { red, green, blue, alpha } =
            color

        parts =
            if alpha == 1 then
                [ red, green, blue ]

            else
                [ red, green, blue, round (alpha * 255) ]
    in
    List.map toHex parts
        |> (::) "#"
        |> String.join ""
