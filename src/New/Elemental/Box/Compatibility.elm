module New.Elemental.Box.Compatibility exposing (Compatibility)

import Css
import Html.Styled as Html


type alias Compatibility msg =
    { tag : String
    , extraAttributes : List (Html.Attribute msg)
    , extraCss : List Css.Style
    }
