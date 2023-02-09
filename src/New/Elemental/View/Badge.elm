module New.Elemental.View.Badge exposing (Options, viewBox, viewElement)

import New.Elemental exposing (Element, box, text)
import New.Elemental.Box as Box exposing (Box)
import New.Elemental.Box.Structure as Structure exposing (Padding)
import New.Elemental.Box.Style as Style
import New.Elemental.Box.Style.Background as Background
import New.Elemental.Box.Style.Corners exposing (Corners)
import New.Elemental.Box.Style.Typography exposing (Typography)
import New.Elemental.Lib.Color exposing (Color)


type alias Options =
    { typography : Typography
    , corners : Corners
    , padding : Padding
    , colors :
        { background : Color
        , foreground : Color
        }
    }


viewBox : Options -> String -> Box (Element msg) msg
viewBox options text_ =
    let
        updateStyle =
            Style.setTypography options.typography
                >> Style.setCorners options.corners
                >> Style.setBackground (Background.solid options.colors.background)
                >> Style.setTextColor options.colors.foreground
    in
    Box.default
        |> Box.mapStructure (Structure.setPadding options.padding)
        |> Box.mapStyle updateStyle
        |> Box.setChildren [ text text_ ]


viewElement : Options -> String -> Element msg
viewElement options text_ =
    box <| viewBox options text_
