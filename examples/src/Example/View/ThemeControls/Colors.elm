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
    L.viewColumn L.Normal
        []
        [ viewColorTree theme <|
            Node
                { styleName = "Foreground"
                , colorSet =
                    [ { name = "Regular"
                      , intoSet =
                            \color ->
                                let
                                    foreground =
                                        themeColors.foreground
                                in
                                { themeColors | foreground = { foreground | regular = color } }
                                    |> onUpdateColors
                      , color = themeColors.foreground.regular
                      }
                    , { name = "Soft"
                      , intoSet =
                            \color ->
                                let
                                    foreground =
                                        themeColors.foreground
                                in
                                { themeColors | foreground = { foreground | soft = color } }
                                    |> onUpdateColors
                      , color = themeColors.foreground.soft
                      }
                    , { name = "Code"
                      , intoSet =
                            \color ->
                                let
                                    foreground =
                                        themeColors.foreground
                                in
                                { themeColors | foreground = { foreground | code = color } }
                                    |> onUpdateColors
                      , color = themeColors.foreground.code
                      }
                    ]
                }
        , L.layout.spacerY 8
        , viewColorTree theme <|
            Node
                { styleName = "Background"
                , colorSet =
                    [ { name = "Normal"
                      , intoSet =
                            \color ->
                                let
                                    background =
                                        themeColors.background
                                in
                                { themeColors | background = { background | normal = color } }
                                    |> onUpdateColors
                      , color = themeColors.background.normal
                      }
                    , { name = "Alternate"
                      , intoSet =
                            \color ->
                                let
                                    background =
                                        themeColors.background
                                in
                                { themeColors | background = { background | alternate = color } }
                                    |> onUpdateColors
                      , color = themeColors.background.alternate
                      }
                    , { name = "Code"
                      , intoSet =
                            \color ->
                                let
                                    background =
                                        themeColors.background
                                in
                                { themeColors | background = { background | code = color } }
                                    |> onUpdateColors
                      , color = themeColors.background.code
                      }
                    ]
                }
        , L.layout.spacerY 8
        , viewColorTree theme <|
            Node
                { styleName = "Border"
                , colorSet =
                    [ { name = ""
                      , intoSet =
                            \color ->
                                { themeColors | border = color }
                                    |> onUpdateColors
                      , color = themeColors.border
                      }
                    ]
                }
        , L.layout.spacerY 8
        , viewColorTree theme <|
            ColorTree switchSectionId
                "Switch"
                [ Node
                    { styleName = "Background"
                    , colorSet =
                        [ { name = "Disabled"
                          , intoSet =
                                \color ->
                                    let
                                        switch =
                                            themeColors.switch

                                        background =
                                            switch.background
                                    in
                                    { themeColors | switch = { switch | background = { background | disabled = color } } }
                                        |> onUpdateColors
                          , color = themeColors.switch.background.disabled
                          }
                        , { name = "On"
                          , intoSet =
                                \color ->
                                    let
                                        switch =
                                            themeColors.switch

                                        background =
                                            switch.background
                                    in
                                    { themeColors | switch = { switch | background = { background | on = color } } }
                                        |> onUpdateColors
                          , color = themeColors.switch.background.on
                          }
                        , { name = "Off"
                          , intoSet =
                                \color ->
                                    let
                                        switch =
                                            themeColors.switch

                                        background =
                                            switch.background
                                    in
                                    { themeColors | switch = { switch | background = { background | off = color } } }
                                        |> onUpdateColors
                          , color = themeColors.switch.background.off
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
                                        switch =
                                            themeColors.switch

                                        border =
                                            switch.border
                                    in
                                    { themeColors | switch = { switch | border = { border | disabled = color } } }
                                        |> onUpdateColors
                          , color = themeColors.switch.border.disabled
                          }
                        , { name = "On"
                          , intoSet =
                                \color ->
                                    let
                                        switch =
                                            themeColors.switch

                                        border =
                                            switch.border
                                    in
                                    { themeColors | switch = { switch | border = { border | on = color } } }
                                        |> onUpdateColors
                          , color = themeColors.switch.border.on
                          }
                        , { name = "Off"
                          , intoSet =
                                \color ->
                                    let
                                        switch =
                                            themeColors.switch

                                        border =
                                            switch.border
                                    in
                                    { themeColors | switch = { switch | border = { border | off = color } } }
                                        |> onUpdateColors
                          , color = themeColors.switch.border.off
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
                                            switch =
                                                themeColors.switch

                                            handle =
                                                switch.handle

                                            background =
                                                handle.background
                                        in
                                        { themeColors | switch = { switch | handle = { handle | background = { background | disabled = color } } } }
                                            |> onUpdateColors
                              , color = themeColors.switch.handle.background.disabled
                              }
                            , { name = "On"
                              , intoSet =
                                    \color ->
                                        let
                                            switch =
                                                themeColors.switch

                                            handle =
                                                switch.handle

                                            background =
                                                handle.background
                                        in
                                        { themeColors | switch = { switch | handle = { handle | background = { background | on = color } } } }
                                            |> onUpdateColors
                              , color = themeColors.switch.handle.background.on
                              }
                            , { name = "Off"
                              , intoSet =
                                    \color ->
                                        let
                                            switch =
                                                themeColors.switch

                                            handle =
                                                switch.handle

                                            background =
                                                handle.background
                                        in
                                        { themeColors | switch = { switch | handle = { handle | background = { background | off = color } } } }
                                            |> onUpdateColors
                              , color = themeColors.switch.handle.background.off
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
                                            switch =
                                                themeColors.switch

                                            handle =
                                                switch.handle

                                            border =
                                                handle.border
                                        in
                                        { themeColors | switch = { switch | handle = { handle | border = { border | disabled = color } } } }
                                            |> onUpdateColors
                              , color = themeColors.switch.handle.border.disabled
                              }
                            , { name = "On"
                              , intoSet =
                                    \color ->
                                        let
                                            switch =
                                                themeColors.switch

                                            handle =
                                                switch.handle

                                            border =
                                                handle.border
                                        in
                                        { themeColors | switch = { switch | handle = { handle | border = { border | on = color } } } }
                                            |> onUpdateColors
                              , color = themeColors.switch.handle.border.on
                              }
                            , { name = "Off"
                              , intoSet =
                                    \color ->
                                        let
                                            switch =
                                                themeColors.switch

                                            handle =
                                                switch.handle

                                            border =
                                                handle.border
                                        in
                                        { themeColors | switch = { switch | handle = { handle | border = { border | off = color } } } }
                                            |> onUpdateColors
                              , color = themeColors.switch.handle.border.off
                              }
                            ]
                        }
                    ]
                ]
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


switchSectionId =
    "switch-colors-section"


viewColorSet : Theme -> ColorSet msg -> H.Html msg
viewColorSet theme { styleName, colorSet } =
    let
        children =
            colorSet
                |> List.map viewColor
    in
    L.viewColumn L.Normal
        []
        [ H.h6
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
            H.pre [] [ H.text (leading index ++ String.toLower name ++ ": Css.hex \"" ++ colorToHexWithAlpha color ++ "\"") ]

        children =
            H.pre [] [ H.text (String.toLower setName ++ " :") ]
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
