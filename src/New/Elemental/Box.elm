module New.Elemental.Box exposing
    ( Box
    , appendChild
    , appendChildren
    , consChild
    , defaultColumn
    , defaultRow
    , mapChildren
    , mapCompatibility
    , mapEachChild
    , mapInteraction
    , mapStructure
    , mapStyle
    , prependChildren
    , setChildren
    , setCompatibility
    , setInteraction
    , setStructure
    , setStyle
    , toHtml
    )

import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Html
import Lib.Function as Function
import New.Elemental.Box.Compatibility as Compatibility exposing (Compatibility)
import New.Elemental.Box.Interaction as Interaction exposing (Interaction)
import New.Elemental.Box.Structure as Structure exposing (Structure)
import New.Elemental.Box.Style as Style exposing (Style)


type alias Box child msg =
    { compatibility : Compatibility msg
    , structure : Structure
    , style : Style
    , interaction : Interaction msg
    , children : List child
    }


defaultRow : Structure.Dimension -> Structure.Dimension -> Box child msg
defaultRow width height =
    { compatibility = Compatibility.fromTag "div"
    , structure = Structure.defaultRow width height
    , style = Style.none
    , interaction = Interaction.none
    , children = []
    }


defaultColumn : Structure.Dimension -> Structure.Dimension -> Box child msg
defaultColumn width height =
    { compatibility = Compatibility.fromTag "div"
    , structure = Structure.defaultColumn width height
    , style = Style.none
    , interaction = Interaction.none
    , children = []
    }


toHtml : (child -> Html msg) -> Box child msg -> Html msg
toHtml childToHtml box =
    let
        styles =
            Structure.toCssStyle box.structure
                :: Style.toCssStyle box.style
                :: box.compatibility.extraStyles

        attributes =
            Html.css styles
                :: Interaction.toHtmlAttributes box.interaction
                |> Function.flip List.append box.compatibility.extraAttributes
    in
    Html.node
        box.compatibility.tag
        attributes
        (List.map childToHtml box.children)


mapCompatibility : (Compatibility msg -> Compatibility msg) -> Box child msg -> Box child msg
mapCompatibility f box =
    { box | compatibility = f box.compatibility }


setCompatibility : Compatibility msg -> Box child msg -> Box child msg
setCompatibility a box =
    mapCompatibility (always a) box


mapStructure : (Structure -> Structure) -> Box child msg -> Box child msg
mapStructure f box =
    { box | structure = f box.structure }


setStructure : Structure -> Box child msg -> Box child msg
setStructure a box =
    mapStructure (always a) box


mapStyle : (Style -> Style) -> Box child msg -> Box child msg
mapStyle f box =
    { box | style = f box.style }


setStyle : Style -> Box child msg -> Box child msg
setStyle a box =
    mapStyle (always a) box


mapInteraction : (Interaction msg -> Interaction msg) -> Box child msg -> Box child msg
mapInteraction f box =
    { box | interaction = f box.interaction }


setInteraction : Interaction msg -> Box child msg -> Box child msg
setInteraction a box =
    mapInteraction (always a) box


mapChildren : (List child -> List child) -> Box child msg -> Box child msg
mapChildren f box =
    { box | children = f box.children }


mapEachChild : (child -> child) -> Box child msg -> Box child msg
mapEachChild f box =
    mapChildren (List.map f) box


setChildren : List child -> Box child msg -> Box child msg
setChildren a box =
    mapChildren (always a) box


appendChildren : List child -> Box child msg -> Box child msg
appendChildren a box =
    mapChildren (Function.flip List.append a) box


appendChild : child -> Box child msg -> Box child msg
appendChild a box =
    appendChildren [ a ] box


consChild : child -> Box child msg -> Box child msg
consChild a box =
    mapChildren ((::) a) box


prependChildren : List child -> Box child msg -> Box child msg
prependChildren a box =
    mapChildren (List.append a) box
