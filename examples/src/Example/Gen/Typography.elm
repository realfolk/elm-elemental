module Example.Gen.Typography exposing
    ( TypographyTree
    , adventureTypography
    , defaultTypography
    , elegantTypography
    , fontFamilies
    , insertStyle
    , typographyToExpression
    )

import Elemental.Typography exposing (Typography)
import Elm
import Example.Gen.Tree as Tree exposing (..)
import Example.Typography exposing (..)
import Example.Typography.Helpers exposing (..)
import Set


type alias TypographyTree =
    Tree Typography


defaultStyle =
    Example.Typography.baseTypography.body.medium


insertStyle styleName tree =
    ( ( styleName, defaultStyle )
    , Tree.insert styleName defaultStyle tree
    )


typographyToExpression : Typography -> Elm.Expression
typographyToExpression typography =
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


fontFamilies : TypographyTree -> List ( String, List String )
fontFamilies tree =
    tree
        |> Tree.toList
        |> List.map (Tuple.second >> .families)
        |> Set.fromList
        |> Set.toList
        |> List.filterMap
            (\list ->
                case list of
                    [] ->
                        Nothing

                    head :: tail ->
                        Just ( head, tail )
            )


exampleTreeFromExampleTypography : ThemeTypography -> TypographyTree
exampleTreeFromExampleTypography typography =
    root "typography"
        [ labeledNode "Body" <|
            [ leaf "Small" <| typography.body.small
            , leaf "Medium" <| typography.body.medium
            ]
        , labeledNode "Button"
            [ leaf "Small" <| typography.button.small
            , leaf "Medium" <| typography.button.medium
            ]
        , leaf "Code" <| typography.code
        , labeledNode "Form"
            [ labeledNode "Field"
                [ leaf "Label" <| typography.form.field.label
                , leaf "Support" <| typography.form.field.support
                ]
            ]
        , labeledNode "Heading"
            [ leaf "H4" <| typography.heading.h4
            , leaf "H5" <| typography.heading.h5
            , leaf "H6" <| typography.heading.h6
            ]
        ]


defaultTypography : Tree Typography
defaultTypography =
    exampleTreeFromExampleTypography Example.Typography.baseTypography


elegantTypography : TypographyTree
elegantTypography =
    exampleTreeFromExampleTypography Example.Typography.elegantTypography


adventureTypography : Tree Typography
adventureTypography =
    exampleTreeFromExampleTypography Example.Typography.adventureTypography
