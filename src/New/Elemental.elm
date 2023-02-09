module New.Elemental exposing
    ( Element
    , box
    , html
    , svg
    , text
    , toHtml
    , toUnstyledHtml
    )

import Html as Unstyled
import Html.Styled as Html exposing (Html)
import New.Elemental.Box as Box exposing (Box)
import New.Elemental.Box.Structure as Structure
import Svg.Styled exposing (Svg)


type Element msg
    = Box (Box (Element msg) msg)
    | Text String
    | Html (Html msg)
    | Svg (Svg msg)


box : Box (Element msg) msg -> Element msg
box =
    Box


text : String -> Element msg
text =
    Text


html : Html msg -> Element msg
html =
    Html


svg : Svg msg -> Element msg
svg =
    Svg


toHtml : Structure.Direction -> Element msg -> Html msg
toHtml parentDirection element =
    case element of
        Box box_ ->
            Box.toHtml parentDirection (toHtml box_.structure.direction) box_

        Text text_ ->
            Html.text text_

        Html html_ ->
            html_

        Svg svg_ ->
            svg_


toUnstyledHtml : Structure.Direction -> Element msg -> Unstyled.Html msg
toUnstyledHtml parentDirection =
    toHtml parentDirection >> Html.toUnstyled
