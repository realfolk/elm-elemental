module Example.View.ThemeControls.BorderRadiusControls exposing (..)

import Css
import Elemental.Css.BorderRadius exposing (BorderRadius)
import Elemental.Layout as L
import Elemental.Typography as Typography
import Elemental.View.Form.Field.Input as Input
import Example.Colors exposing (Colors)
import Example.Layout as L
import Example.Theme exposing (Theme, ThemeBorderRadius, ThemeBorderRadiusGenerator)
import Example.Typography as Typography
import Example.View.Codeblock as Codeblock
import Example.View.Form.Field.Input as Input
import Html.Styled as H
import Html.Styled.Attributes as HA
import Html.Styled.Events as HE


type Tree msg
    = Tree
        { id : String
        , name : String
        , codeName : String
        }
        (List (Tree msg))
    | Node (Set msg)


type alias Set msg =
    { styleName : String
    , radiusSet : List (SetItem msg)
    }


type alias SetItem msg =
    { value : Float
    , intoSet : Float -> msg
    , name : String
    }



-- VIEW


type alias Options msg =
    { theme : Theme
    , onUpdateRadii : ThemeBorderRadiusGenerator -> msg
    }


view : Options msg -> ThemeBorderRadiusGenerator -> H.Html msg
view { theme, onUpdateRadii } radius =
    let
        button =
            radius.button

        global =
            radius.global
    in
    H.map onUpdateRadii <|
        L.viewColumn L.Normal
            []
            [ viewTree theme True <|
                Tree
                    { id = ""
                    , name = ""
                    , codeName = ""
                    }
                    [ Node
                        { styleName = "Button"
                        , radiusSet =
                            [ { name = "Small"
                              , intoSet =
                                    \value -> { radius | button = { button | small = value } }
                              , value = radius.button.small
                              }
                            , { name = "Medium"
                              , intoSet =
                                    \value -> { radius | button = { button | medium = value } }
                              , value = radius.button.medium
                              }
                            ]
                        }
                    , Node
                        { styleName = "Global"
                        , radiusSet =
                            [ { name = "Small"
                              , intoSet =
                                    \value -> { radius | global = { global | small = value } }
                              , value = radius.global.small
                              }
                            , { name = "Medium"
                              , intoSet =
                                    \value -> { radius | global = { global | medium = value } }
                              , value = radius.global.medium
                              }
                            , { name = "Large"
                              , intoSet =
                                    \value -> { radius | global = { global | large = value } }
                              , value = radius.global.large
                              }
                            ]
                        }
                    ]
            ]


viewTree : Theme -> Bool -> Tree msg -> H.Html msg
viewTree theme showCode colorTree =
    case colorTree of
        Tree { id, name } children ->
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
                                |> List.map (viewTree theme False)
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

        Node radiusSet ->
            viewColorSet theme radiusSet


viewColorSet : Theme -> Set msg -> H.Html msg
viewColorSet theme { styleName, radiusSet } =
    let
        children =
            radiusSet
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


viewColor : Theme -> SetItem msg -> H.Html msg
viewColor theme { value, intoSet, name } =
    let
        input =
            viewInput theme
                value
                (String.toFloat
                    >> Maybe.withDefault 0
                    >> max 0
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


viewInput theme value onChangeValue =
    let
        options =
            Input.toOptions
                { theme = theme
                , type_ = Input.Text
                , disabled = False
                , autofocus = False
                , placeholder = ""
                , icon = Nothing
                , onInput = onChangeValue
                , customAttrs =
                    [ HA.type_ "number"
                    ]
                , maybeOnInteraction = Nothing
                }
    in
    Input.view options (String.fromFloat value)


viewTreeCode theme firstItem colorTree =
    case colorTree of
        Tree { name, codeName } children ->
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
                            , Css.overflowX Css.auto
                            ]
                        ]
                        [ Codeblock.customView1 theme
                            [ innerBlock
                            , H.pre [] [ H.text "}" ]
                            ]
                        ]
                    ]

        Node radiusSet ->
            viewCode theme firstItem radiusSet


viewCode : Theme -> Bool -> Set msg -> H.Html msg
viewCode theme firstItem { radiusSet, styleName } =
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

        viewColorCode index { value, name } =
            H.pre [] [ H.text (leading index ++ toCamelCase name ++ " = BorderRadius.borderRadius " ++ String.fromFloat value ++ "") ]

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
                ++ (radiusSet
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
