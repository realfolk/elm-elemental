module New.Elemental.Box.Structure exposing
    ( Alignment(..)
    , Container(..)
    , Dimension(..)
    , Direction(..)
    , Justification(..)
    , Padding
    , Position(..)
    , Spacing
    , Structure
    , alignCenter
    , alignEnd
    , alignStart
    , alignmentToCssStyle
    , block
    , column
    , default
    , directionToCssStyle
    , fixed
    , inline
    , justificationToCssStyle
    , justifyCenter
    , justifyEnd
    , justifySpaceBetween
    , justifyStart
    , noWrap
    , paddingToCssStyle
    , row
    , setAlignmentSpacing
    , setHeight
    , setJustificationSpacing
    , setPadding
    , setPosition
    , setWidth
    , toCssStyle
    , wrap
    )

import Css
import New.Elemental.Lib.Sides as Sides exposing (Sides)
import New.Elemental.Lib.Size as Size


type alias Structure =
    { inline : Bool
    , width : Dimension
    , height : Dimension
    , direction : Direction
    , justification : Justification
    , alignment : Alignment
    , padding : Padding
    , position : Position
    }


default : Structure
default =
    { inline = False
    , width = Hug
    , height = Hug
    , direction = Column
    , justification = Packed (Start (Size.px 0)) False
    , alignment = Start <| Size.px 0
    , padding = Sides.all <| Size.px 0
    , position = Normal
    }


toCssStyle : Direction -> Structure -> Css.Style
toCssStyle parentDirection structure =
    let
        direction =
            structure.direction

        display =
            if structure.inline then
                Css.display Css.inlineFlex

            else
                Css.displayFlex
    in
    Css.batch
        [ display
        , dimensionToCssStyle (parentDirection == Row) Css.width Css.width structure.width
        , dimensionToCssStyle (parentDirection == Column) Css.height Css.height structure.height
        , directionToCssStyle direction
        , justificationToCssStyle direction structure.justification
        , alignmentToCssStyle direction structure.alignment
        , paddingToCssStyle structure.padding
        , positionToCssStyle structure.position
        ]


inline : Structure -> Structure
inline s =
    { s | inline = True }


block : Structure -> Structure
block s =
    { s | inline = False }


setWidth : Dimension -> Structure -> Structure
setWidth a s =
    { s | width = a }


setHeight : Dimension -> Structure -> Structure
setHeight a s =
    { s | height = a }


row : Structure -> Structure
row s =
    { s | direction = Row }


column : Structure -> Structure
column s =
    { s | direction = Column }


justifyStart : Structure -> Structure
justifyStart s =
    { s
        | justification =
            Packed
                (Start (getJustificationSpacing s.justification))
                (getJustificationWrap s.justification)
    }


justifyCenter : Structure -> Structure
justifyCenter s =
    { s
        | justification =
            Packed
                (Center (getJustificationSpacing s.justification))
                (getJustificationWrap s.justification)
    }


justifyEnd : Structure -> Structure
justifyEnd s =
    { s
        | justification =
            Packed
                (End (getJustificationSpacing s.justification))
                (getJustificationWrap s.justification)
    }


justifySpaceBetween : Structure -> Structure
justifySpaceBetween s =
    { s | justification = SpaceBetween }


setJustificationSpacing : Spacing -> Structure -> Structure
setJustificationSpacing a s =
    { s
        | justification =
            case s.justification of
                Packed alignment wrap_ ->
                    Packed (setAlignmentSpacing_ a alignment) wrap_

                _ ->
                    s.justification
    }


wrap : Structure -> Structure
wrap s =
    { s
        | justification =
            case s.justification of
                Packed alignment _ ->
                    Packed alignment True

                _ ->
                    s.justification
    }


noWrap : Structure -> Structure
noWrap s =
    { s
        | justification =
            case s.justification of
                Packed alignment _ ->
                    Packed alignment False

                _ ->
                    s.justification
    }


alignStart : Structure -> Structure
alignStart s =
    { s | alignment = Start (getAlignmentSpacing s.alignment) }


alignCenter : Structure -> Structure
alignCenter s =
    { s | alignment = Center (getAlignmentSpacing s.alignment) }


alignEnd : Structure -> Structure
alignEnd s =
    { s | alignment = End (getAlignmentSpacing s.alignment) }


setAlignmentSpacing : Spacing -> Structure -> Structure
setAlignmentSpacing a s =
    { s | alignment = setAlignmentSpacing_ a s.alignment }


setPadding : Padding -> Structure -> Structure
setPadding a s =
    { s | padding = a }


setPosition : Position -> Structure -> Structure
setPosition a s =
    { s | position = a }


type Dimension
    = Fixed Size.Px
    | Fill
    | Hug


fixed : Float -> Dimension
fixed =
    Size.px >> Fixed


dimensionToCssStyle : Bool -> (Css.Pct -> Css.Style) -> (Css.Px -> Css.Style) -> Dimension -> Css.Style
dimensionToCssStyle followsDirection pctToStyle pxToStyle dimension =
    let
        growAndShrink grow shrink =
            Css.batch <|
                [ Css.flexGrow <| Css.int grow
                , Css.flexShrink <| Css.int shrink
                ]
    in
    Css.batch <|
        case ( followsDirection, dimension ) of
            ( True, Fixed px ) ->
                [ growAndShrink 0 0
                , pxToStyle <| Size.pxToCssValue px
                ]

            ( False, Fixed px ) ->
                [ pxToStyle <| Size.pxToCssValue px
                ]

            ( True, Fill ) ->
                [ growAndShrink 1 0
                , Css.flexBasis <| Css.px 0 -- Ensures all "Fill" siblings consume space equally.
                ]

            ( False, Fill ) ->
                [ pctToStyle <| Css.pct 100 ]

            ( True, Hug ) ->
                [ growAndShrink 0 0 ]

            ( False, Hug ) ->
                []


type Direction
    = Row
    | Column


directionToCssStyle : Direction -> Css.Style
directionToCssStyle direction =
    case direction of
        Row ->
            Css.flexDirection Css.row

        Column ->
            Css.flexDirection Css.column


type Justification
    = Packed Alignment Bool
    | SpaceBetween


getJustificationSpacing : Justification -> Spacing
getJustificationSpacing justification =
    case justification of
        Packed alignment _ ->
            getAlignmentSpacing alignment

        SpaceBetween ->
            Size.px 0


getJustificationWrap : Justification -> Bool
getJustificationWrap justification =
    case justification of
        Packed _ wrap_ ->
            wrap_

        SpaceBetween ->
            False


justificationToCssStyle : Direction -> Justification -> Css.Style
justificationToCssStyle direction justification =
    let
        spacingToStyle_ =
            spacingToStyle <|
                case direction of
                    Row ->
                        "column-gap"

                    Column ->
                        "row-gap"
    in
    Css.batch <|
        case justification of
            Packed alignment wrap_ ->
                [ if wrap_ then
                    Css.flexWrap Css.wrap

                  else
                    Css.flexWrap Css.noWrap
                , Css.batch <|
                    case alignment of
                        Start spacing ->
                            [ Css.justifyContent Css.flexStart
                            , spacingToStyle_ spacing
                            ]

                        Center spacing ->
                            [ Css.justifyContent Css.center
                            , spacingToStyle_ spacing
                            ]

                        End spacing ->
                            [ Css.justifyContent Css.flexEnd
                            , spacingToStyle_ spacing
                            ]
                ]

            SpaceBetween ->
                [ Css.flexWrap Css.noWrap
                , Css.justifyContent Css.spaceBetween
                ]


type Alignment
    = Start Spacing
    | Center Spacing
    | End Spacing


getAlignmentSpacing : Alignment -> Spacing
getAlignmentSpacing alignment =
    case alignment of
        Start spacing ->
            spacing

        Center spacing ->
            spacing

        End spacing ->
            spacing


setAlignmentSpacing_ : Spacing -> Alignment -> Alignment
setAlignmentSpacing_ spacing alignment =
    case alignment of
        Start _ ->
            Start spacing

        Center _ ->
            Center spacing

        End _ ->
            End spacing


alignmentToCssStyle : Direction -> Alignment -> Css.Style
alignmentToCssStyle direction alignment =
    let
        alignContent value =
            Css.batch
                [ Css.property "align-content" value
                , Css.property "align-items" value
                ]

        spacingToStyle_ =
            spacingToStyle <|
                case direction of
                    Row ->
                        "row-gap"

                    Column ->
                        "column-gap"
    in
    Css.batch <|
        case alignment of
            Start spacing ->
                [ alignContent "flex-start"
                , spacingToStyle_ spacing
                ]

            Center spacing ->
                [ alignContent "center"
                , spacingToStyle_ spacing
                ]

            End spacing ->
                [ alignContent "flex-end"
                , spacingToStyle_ spacing
                ]


type alias Spacing =
    Size.Px


type alias Padding =
    Sides Size.Px


paddingToCssStyle : Padding -> Css.Style
paddingToCssStyle padding_ =
    Css.padding4
        (Size.pxToCssValue padding_.top)
        (Size.pxToCssValue padding_.right)
        (Size.pxToCssValue padding_.bottom)
        (Size.pxToCssValue padding_.left)


type Position
    = Normal
    | Floating Container (Sides (Maybe Size.Px))


positionToCssStyle : Position -> Css.Style
positionToCssStyle position_ =
    let
        offsetToStyle toStyle =
            Maybe.map (Size.pxToCssValue >> toStyle)
                >> Maybe.withDefault (Css.batch [])

        offsetSidesToStyle =
            Sides.sides
                (offsetToStyle Css.top)
                (offsetToStyle Css.right)
                (offsetToStyle Css.bottom)
                (offsetToStyle Css.left)

        sidesToStyle =
            Sides.toCssStyle offsetSidesToStyle
    in
    case position_ of
        Normal ->
            Css.position Css.relative

        Floating FirstNormalParent sides ->
            Css.batch
                [ Css.position Css.absolute
                , sidesToStyle sides
                ]

        Floating Viewport sides ->
            Css.batch
                [ Css.position Css.fixed
                , sidesToStyle sides
                ]


type Container
    = FirstNormalParent
    | Viewport


spacingToStyle : String -> Size.Px -> Css.Style
spacingToStyle propertyName spacing =
    if Size.pxToFloat spacing == 0 then
        Css.batch []

    else
        Css.property propertyName <|
            String.fromFloat (Size.pxToFloat spacing)
                ++ "px"
