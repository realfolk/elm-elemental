module New.Elemental.Lib.Sides exposing
    ( Sides
    , all
    , bottom
    , left
    , leftAndRight
    , right
    , setBottom
    , setLeft
    , setLeftAndRight
    , setRight
    , setTop
    , setTopAndBottom
    , sides
    , toCssStyle
    , top
    , topAndBottom
    )

import Css


type alias Sides a =
    { top : a
    , right : a
    , bottom : a
    , left : a
    }



-- Constructors


sides : a -> a -> a -> a -> Sides a
sides top_ right_ bottom_ left_ =
    Sides top_ right_ bottom_ left_


top : a -> a -> Sides a
top none a =
    sides a none none none


right : a -> a -> Sides a
right none a =
    sides none a none none


bottom : a -> a -> Sides a
bottom none a =
    sides none none a none


left : a -> a -> Sides a
left none a =
    sides none none none a


all : a -> Sides a
all a =
    sides a a a a


leftAndRight : a -> a -> Sides a
leftAndRight none a =
    sides none a none a


topAndBottom : a -> a -> Sides a
topAndBottom none a =
    sides a none a none



-- Converters


toCssStyle : Sides (a -> Css.Style) -> Sides a -> Css.Style
toCssStyle toStyle sides_ =
    Css.batch
        [ toStyle.top sides_.top
        , toStyle.right sides_.right
        , toStyle.bottom sides_.bottom
        , toStyle.left sides_.left
        ]



-- Setters


setTop : a -> Sides a -> Sides a
setTop a sides_ =
    { sides_ | top = a }


setRight : a -> Sides a -> Sides a
setRight a sides_ =
    { sides_ | right = a }


setBottom : a -> Sides a -> Sides a
setBottom a sides_ =
    { sides_ | bottom = a }


setLeft : a -> Sides a -> Sides a
setLeft a sides_ =
    { sides_ | left = a }


setTopAndBottom : a -> Sides a -> Sides a
setTopAndBottom a =
    setTop a >> setBottom a


setLeftAndRight : a -> Sides a -> Sides a
setLeftAndRight a =
    setLeft a >> setRight a
