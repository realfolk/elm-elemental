module New.Elemental.Box exposing
    ( Box
    , defaultColumn
    , defaultRow
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


defaultRow : Structure.Dimension -> Structure.Dimension -> List child -> Box child msg
defaultRow width height children =
    { compatibility = Compatibility.fromTag "div"
    , structure = Structure.defaultRow width height
    , style = Style.none
    , interaction = Interaction.none
    , children = children
    }


defaultColumn : Structure.Dimension -> Structure.Dimension -> List child -> Box child msg
defaultColumn width height children =
    { compatibility = Compatibility.fromTag "div"
    , structure = Structure.defaultColumn width height
    , style = Style.none
    , interaction = Interaction.none
    , children = children
    }


toHtml : (child -> Html msg) -> Box child msg -> Html msg
toHtml childToHtml box =
    let
        styles =
            Structure.toCssStyle box.structure
                :: Style.toCssStyle box.style
                :: box.compatibility.extraCss

        attributes =
            Html.css styles
                :: Interaction.toHtmlAttributes box.interaction
                |> Function.flip List.append box.compatibility.extraAttributes
    in
    Html.node
        box.compatibility.tag
        attributes
        (List.map childToHtml box.children)
