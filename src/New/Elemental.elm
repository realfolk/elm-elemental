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


toHtml : Element msg -> Html msg
toHtml element =
    case element of
        Box box_ ->
            Box.toHtml toHtml box_

        Text text_ ->
            Html.text text_

        Html html_ ->
            html_

        Svg svg_ ->
            svg_


toUnstyledHtml : Element msg -> Unstyled.Html msg
toUnstyledHtml =
    toHtml >> Html.toUnstyled
