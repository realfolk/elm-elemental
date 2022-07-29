module New.Elemental.Element exposing
    ( Element
    , toHtml
    )

import Html.Styled exposing (Html)
import New.Elemental.Box as Box exposing (Box)
import Svg.Styled exposing (Svg)


type Element msg
    = Box (Box (Element msg) msg)
    | Html (Html msg)
    | Svg (Svg msg)


toHtml : Element msg -> Html msg
toHtml element =
    case element of
        Box box ->
            Box.toHtml toHtml box

        Html html ->
            html

        Svg svg ->
            svg
