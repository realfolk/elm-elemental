module New.Elemental.Box.Structure exposing
    ( Alignment(..)
    , Container(..)
    , Dimension(..)
    , Direction(..)
    , Distribution(..)
    , Padding
    , Position(..)
    , Structure
    , defaultColumn
    , defaultRow
    , fixed
    , setAlignment
    , setDirection
    , setDistribution
    , setHeight
    , setInline
    , setPadding
    , setPosition
    , setWidth
    , toCssStyle
    )

import Css
import New.Elemental.Lib.Sides as Sides exposing (Sides)
import New.Elemental.Lib.Size as Size


type alias Structure =
    { inline : Bool
    , width : Dimension
    , height : Dimension
    , direction : Direction
    , distribution : Distribution
    , alignment : Alignment
    , padding : Padding
    , position : Position
    }


defaultRow : Structure
defaultRow =
    { inline = False
    , width = Hug
    , height = Hug
    , direction = Row
    , distribution = Packed Start False
    , alignment = Start
    , padding = Sides.all <| Size.px 0
    , position = Normal
    }


defaultColumn : Structure
defaultColumn =
    { inline = False
    , width = Hug
    , height = Hug
    , direction = Column
    , distribution = Packed Start False
    , alignment = Start
    , padding = Sides.all <| Size.px 0
    , position = Normal
    }


toCssStyle : Structure -> Css.Style
toCssStyle structure =
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
        , dimensionToCssStyle (direction == Row) Css.width Css.width structure.width
        , dimensionToCssStyle (direction == Column) Css.height Css.height structure.height
        , directionToCssStyle direction
        , distributionToCssStyle structure.distribution
        , alignmentToCssStyle structure.alignment
        , paddingToCssStyle structure.padding
        , positionToCssStyle structure.position
        ]


setInline : Bool -> Structure -> Structure
setInline a s =
    { s | inline = a }


setWidth : Dimension -> Structure -> Structure
setWidth a s =
    { s | width = a }


setHeight : Dimension -> Structure -> Structure
setHeight a s =
    { s | height = a }


setDirection : Direction -> Structure -> Structure
setDirection a s =
    { s | direction = a }


setDistribution : Distribution -> Structure -> Structure
setDistribution a s =
    { s | distribution = a }


setAlignment : Alignment -> Structure -> Structure
setAlignment a s =
    { s | alignment = a }


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
                [ growAndShrink 0 1 ]

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


type Distribution
    = Packed Alignment Bool
    | SpaceBetween


distributionToCssStyle : Distribution -> Css.Style
distributionToCssStyle distribution =
    Css.batch <|
        case distribution of
            Packed alignment wrap ->
                [ if wrap then
                    Css.flexWrap Css.noWrap

                  else
                    Css.flexWrap Css.wrap
                , Css.justifyContent <|
                    case alignment of
                        Start ->
                            Css.flexStart

                        Center ->
                            Css.center

                        End ->
                            Css.flexEnd
                ]

            SpaceBetween ->
                [ Css.flexWrap Css.noWrap
                , Css.justifyContent Css.spaceBetween
                ]


type Alignment
    = Start
    | Center
    | End


alignmentToCssStyle : Alignment -> Css.Style
alignmentToCssStyle alignment =
    Css.justifyContent <|
        case alignment of
            Start ->
                Css.flexStart

            Center ->
                Css.center

            End ->
                Css.flexEnd


type alias Padding =
    Sides Size.Px


paddingToCssStyle : Padding -> Css.Style
paddingToCssStyle padding =
    Css.padding4
        (Size.pxToCssValue padding.top)
        (Size.pxToCssValue padding.right)
        (Size.pxToCssValue padding.bottom)
        (Size.pxToCssValue padding.left)


type Position
    = Normal
    | Floating Container (Sides (Maybe Size.Px))


positionToCssStyle : Position -> Css.Style
positionToCssStyle position =
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
    case position of
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
