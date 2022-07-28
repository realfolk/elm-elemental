module New.Elemental exposing (..)

import Css
import Elemental.Typography exposing (Typography)
import Html.Styled as Html exposing (Attribute, Html)
import Svg.Styled exposing (Svg)



-- Element


type Element msg
    = Box (HtmlCompatibility msg) BoxProperties (List (Interaction msg)) (List (Element msg))
    | Space Float -- pixels
    | Text String
    | Html (Html msg)
    | Svg (Svg msg)


box : BoxProperties -> List (Interaction msg) -> List (Element msg) -> Element msg
box =
    Box { tag = "div", extraAttributes = [] }


customBox : HtmlCompatibility msg -> BoxProperties -> List (Interaction msg) -> List (Element msg) -> Element msg
customBox =
    Box


text : String -> Element msg
text =
    Text


fromHtml : Html msg -> Element msg
fromHtml =
    Html


fromSvg : Svg msg -> Element msg
fromSvg =
    Svg



-- View


toHtml : Element msg -> Html msg
toHtml element =
    case element of
        Box compatibility properties interactions children ->
            -- TODO properties and interactions
            Html.node compatibility.tag compatibility.extraAttributes (List.map toHtml children)

        Text t ->
            Html.text t

        Html html ->
            html

        Svg svg ->
            svg

        _ ->
            Html.text "todo"



-- HTML Compatibility


type alias HtmlCompatibility msg =
    { tag : String
    , extraAttributes : List (Attribute msg)
    }



-- Box Properties


type alias BoxProperties =
    -- Core box properties
    { width : Dimension
    , height : Dimension

    -- Layout
    , direction : Direction
    , alignment : Axis2d Alignment
    , distribution : Distribution
    , padding : Padding

    -- Styles
    , position : Maybe Position
    , background : Maybe Background
    , typography : Maybe Typography
    , textColor : Maybe Color
    , cursor : Maybe Cursor
    }



-- Core Box Properties


type Direction
    = Row
    | Column


type Alignment
    = Start
    | Center
    | End


type Dimension
    = Fixed Size
    | Fill
    | Hug


type alias Padding =
    BoxSides Size


type Distribution
    = Packed
    | SpaceBetween



-- Styles


type Position
    = Nudge (BoxSides Float) --TODO Maybe remove Nudge and use a Transform style type
    | Floating FloatingContainer (BoxSides Float)
    | Sticky (BoxSides Float)


type FloatingContainer
    = Parent
    | Viewport


type Background
    = BGColor Color


type Cursor
    = Pointer



-- Interaction


type Interaction msg
    = Click (InteractionOutcome msg)
    | MouseEnter (InteractionOutcome msg)
    | MouseLeave (InteractionOutcome msg)
    | MouseOver (InteractionOutcome msg)
    | MouseOut (InteractionOutcome msg)
    | MouseDown (InteractionOutcome msg)
    | MouseUp (InteractionOutcome msg)
    | TouchStart (InteractionOutcome msg)
    | TouchEnd (InteractionOutcome msg)
    | TouchMove (InteractionOutcome msg)


type alias InteractionOutcome msg =
    { message : Maybe msg
    , modify : BoxProperties -> BoxProperties
    }



-- General Helper Types


type alias Color =
    Css.Color


type Size
    = Px Float
    | Pct Float
    | Em Float
    | Rem Float
    | Vh Float
    | Vw Float


type alias BoxSides a =
    { top : a
    , right : a
    , bottom : a
    , left : a
    }


type alias Axis2d a =
    { x : a
    , y : a
    }
