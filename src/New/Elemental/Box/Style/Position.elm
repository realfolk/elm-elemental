module New.Elemental.Box.Style.Position exposing
    ( Container(..)
    , Position(..)
    , toCssStyle
    )

import Css
import New.Elemental.Data.Sides as Sides exposing (Sides)
import New.Elemental.Data.Size as Size


type Position
    = Normal
    | Floating Container (Sides (Maybe Size.Px))


toCssStyle : Position -> Css.Style
toCssStyle position =
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
