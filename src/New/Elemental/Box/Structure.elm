module New.Elemental.Box.Structure exposing
    ( Alignment(..)
    , Dimension(..)
    , Direction(..)
    , Distribution(..)
    , Padding
    , Structure
    )

import New.Elemental.Lib.Axis as Axis
import New.Elemental.Lib.Sides exposing (Sides)
import New.Elemental.Lib.Size as Size


type alias Structure =
    { width : Dimension
    , height : Dimension
    , direction : Direction
    , alignment : Axis.D2 Alignment
    , distribution : Distribution
    , padding : Padding
    }



-- Core Box Properties


type Dimension
    = Fixed Size.Px
    | Fill
    | Hug


type Direction
    = Row
    | Column


type Alignment
    = Start
    | Center
    | End


type Distribution
    = Packed
    | SpaceBetween


type alias Padding =
    Sides Size.Px
