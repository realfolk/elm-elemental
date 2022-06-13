module Example.View.ThemeControls.Colors exposing (..)

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
import Lib


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
            , switchTree theme themeColors
            , L.layout.spacerY 8
            , buttonTree theme themeColors
            , L.layout.spacerY 8
            ]


viewColorTree : Theme -> Bool -> ColorTree msg -> H.Html msg
viewColorTree theme showCode colorTree =
    case colorTree of
        ColorTree { id, name } children ->
            H.div [ HA.id id ]
                [ L.viewColumn L.Normal [] <|
                    (H.h6
                        [ HA.css
                            [ Css.display Css.inline ]
                        ]
                        [ H.text name ]
                        :: L.layout.spacerY 4
                        :: (children
                                |> List.map (viewColorTree theme False)
                           )
                    )
                , if Debug.log "" showCode then
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
                { styleName = "Border"
                , colorSet =
                    [ { name = ""
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
                { styleName = "Border"
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
                _ =
                    Debug.log "Tree" name

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
            let
                _ =
                    Debug.log "Name" colorSet.styleName
            in
            viewCode theme firstItem colorSet


viewCode : Theme -> Bool -> ColorSet msg -> H.Html msg
viewCode theme firstItem { colorSet, styleName } =
    let
        indent =
            String.padLeft 6 ' '

        leading index =
            indent <|
                if index == 0 then
                    "{ "

                else
                    ", "

        viewColorCode index { color, name } =
            H.pre [] [ H.text (leading index ++ String.toLower name ++ " = Css.hex \"" ++ colorToHexWithAlpha color ++ "\"") ]

        children =
            H.pre []
                [ if firstItem then
                    H.text "{ "

                  else
                    H.text ", "
                , H.text (String.toLower styleName ++ " =")
                ]
                :: (colorSet
                        |> List.indexedMap viewColorCode
                        |> Lib.flip (++)
                            [ H.pre [] [ H.text (indent "} ") ]
                            ]
                   )
    in
    children
        |> Codeblock.customView1 theme



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
