module New.Elemental.Box.Structure exposing
    ( Alignment(..)
    , Container(..)
    , Dimension(..)
    , Direction(..)
    , Distribution(..)
    , Padding
    , Position(..)
    , Structure
    , toCssStyle
    )

import Css
import New.Elemental.Lib.Sides as Sides exposing (Sides)
import New.Elemental.Lib.Size as Size


type alias Structure =
    { width : Dimension
    , height : Dimension
    , direction : Direction
    , distribution : Distribution
    , alignment : Alignment
    , padding : Padding
    , position : Position
    }


toCssStyle : Structure -> Css.Style
toCssStyle structure =
    Css.batch
        [ dimensionToCssStyle Css.width structure.width
        , dimensionToCssStyle Css.height structure.height
        , directionToCssStyle structure.direction
        , distributionToCssStyle structure.distribution
        , alignmentToCssStyle structure.alignment
        , paddingToCssStyle structure.padding
        , positionToCssStyle structure.position
        ]


type Dimension
    = Fixed Bool Size.Px
    | Fill Bool
    | Hug


dimensionToCssStyle : (Css.Px -> Css.Style) -> Dimension -> Css.Style
dimensionToCssStyle fixedToStyle dimension =
    let
        wrapStyle wrap =
            if wrap then
                Css.flexWrap Css.noWrap

            else
                Css.flexWrap Css.wrap
    in
    case dimension of
        Fixed wrap px ->
            Css.batch
                [ Css.flexGrow <| Css.int 1
                , Css.flexShrink <| Css.int 0
                , fixedToStyle <| Size.pxToCssValue px
                , wrapStyle wrap
                ]

        Fill wrap ->
            Css.batch
                [ Css.flexGrow <| Css.int 1
                , Css.flexShrink <| Css.int 0
                , wrapStyle wrap
                ]

        Hug ->
            Css.batch
                [ Css.flexGrow <| Css.int 0
                , Css.flexShrink <| Css.int 1
                , Css.flexWrap Css.noWrap
                ]


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
    = Packed Alignment
    | SpaceBetween


distributionToCssStyle : Distribution -> Css.Style
distributionToCssStyle distribution =
    Css.justifyContent <|
        case distribution of
            Packed Start ->
                Css.flexStart

            Packed Center ->
                Css.center

            Packed End ->
                Css.flexEnd

            SpaceBetween ->
                Css.spaceBetween


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
paddingToCssStyle =
    Sides.toCssStyle
        { top = Size.pxToCssValue >> Css.paddingTop
        , right = Size.pxToCssValue >> Css.paddingRight
        , bottom = Size.pxToCssValue >> Css.paddingBottom
        , left = Size.pxToCssValue >> Css.paddingLeft
        }


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
