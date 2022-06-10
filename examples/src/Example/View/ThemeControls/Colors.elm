module Example.View.ThemeControls.Colors exposing (..)

import Css
import Elemental.Css.BorderRadius as BorderRadius
import Elemental.Form.Field.Select as Select
import Elemental.Form.Field.Switch as Switch
import Elemental.Form.Validate as V
import Elemental.Layout as L
import Elemental.Typography as Typography exposing (Typography)
import Elemental.View.Form.Field as Support
import Elemental.View.Form.Field.Input as Input
import Elemental.View.Form.Field.Switch as Switch
import Example.Colors as Colors exposing (Colors)
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)
import Example.Typography as Typography exposing (ThemeTypography)
import Example.View.Codeblock as Codeblock
import Example.View.Form.Field.Select as Select
import Html.Styled as H
import Html.Styled.Attributes as HA
import Html.Styled.Events as HE
import Lib


type ColorTree msg
    = ColorTree String String (List (ColorTree msg))
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


viewColorTree : Theme -> ColorTree msg -> H.Html msg
viewColorTree theme colorTree =
    case colorTree of
        ColorTree id name colorTrees ->
            H.div [ HA.id id ]
                [ L.viewColumn L.Normal [] <|
                    (H.h6
                        [ HA.css
                            [ Css.display Css.inline ]
                        ]
                        [ H.text name ]
                        :: (colorTrees
                                |> List.map (viewColorTree theme)
                                |> List.intersperse (L.layout.spacerY 8)
                           )
                    )
                ]

        Node colorSet ->
            viewColorSet theme colorSet


viewColorSet : Theme -> ColorSet msg -> H.Html msg
viewColorSet theme { styleName, colorSet } =
    let
        children =
            colorSet
                |> List.map viewColor
    in
    L.viewColumn L.Normal
        []
        [ H.div
            [ HA.css
                [ Css.display Css.inline ]
            ]
            [ H.text styleName ]
        , H.div
            [ HA.css
                [ Css.displayFlex
                , Css.flexFlow2 Css.row Css.wrap
                , Css.alignItems Css.center
                , Css.justifyContent Css.flexStart
                ]
            ]
            children
        , L.layout.spacerY 2
        , viewCode theme styleName colorSet
        ]


viewColor : ColorItem msg -> H.Html msg
viewColor { color, intoSet, name } =
    L.viewRow L.Normal
        []
        [ L.viewColumn L.Normal
            []
            [ H.text name
            , viewColorInput color
                (String.replace "#" ""
                    >> Css.hex
                    >> intoSet
                )
            ]
        , L.layout.spacerX 4
        ]


viewColorInput color onChangeColor =
    H.input
        [ HA.type_ "color"
        , HA.css
            [ Css.width (Css.px 80)
            , Css.height (Css.px 40)
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
        viewColorTree theme <|
            Node
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


backgroundTree theme themeColors =
    let
        background =
            themeColors.background
    in
    H.map (\newBackground -> { themeColors | background = newBackground }) <|
        viewColorTree theme <|
            Node
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


borderTree theme themeColors =
    viewColorTree theme <|
        Node
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


switchSectionId =
    "switch-colors-section"


switchTree theme themeColors =
    let
        switch =
            themeColors.switch
    in
    H.map (\newSwitch -> { themeColors | switch = newSwitch }) <|
        viewColorTree theme <|
            ColorTree switchSectionId
                "Switch"
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
                , ColorTree ""
                    "Switch Handle"
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
        [ buttonSetTree buttonSectionId theme "Primary Button" button.primary
            |> H.map (\newColors -> { themeColors | button = { button | primary = newColors } })
        , L.layout.spacerY 4
        , buttonSetTree "" theme "Secondary Button" button.secondary
            |> H.map (\newColors -> { themeColors | button = { button | secondary = newColors } })
        ]


buttonSetTree id theme title button =
    viewColorTree theme <|
        ColorTree id
            title
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


viewCode theme setName colorSet =
    let
        indent =
            String.padLeft 4 ' '

        leading index =
            indent <|
                if index == 0 then
                    "{ "

                else
                    ", "

        viewColorCode index { color, name } =
            H.pre [] [ H.text (leading index ++ String.toLower name ++ " = Css.hex \"" ++ colorToHexWithAlpha color ++ "\"") ]

        children =
            H.pre [] [ H.text (String.toLower setName ++ " =") ]
                :: (colorSet
                        |> List.indexedMap viewColorCode
                        |> Lib.flip (++) [ H.pre [] [ H.text (indent "} ") ] ]
                   )
    in
    children
        |> Codeblock.view theme



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
