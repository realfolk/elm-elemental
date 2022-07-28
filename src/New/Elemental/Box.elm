module New.Elemental.Box exposing (..)

import New.Elemental.Box.Compatibility exposing (Compatibility)
import New.Elemental.Box.Interaction exposing (Interaction)
import New.Elemental.Box.Structure exposing (Structure)
import New.Elemental.Box.Style exposing (Style)


type alias Box children msg =
    { compatibility : Compatibility msg
    , structure : Structure
    , style : Style
    , interaction : Interaction msg
    , children : List children
    }
