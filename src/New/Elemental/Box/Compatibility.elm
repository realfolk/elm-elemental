module New.Elemental.Box.Compatibility exposing
    ( Compatibility
    , appendExtraAttribute
    , appendExtraAttributes
    , appendExtraStyle
    , appendExtraStyles
    , consExtraAttribute
    , consExtraStyle
    , fromTag
    , mapEachExtraAttribute
    , mapEachExtraStyle
    , mapExtraAttributes
    , mapExtraStyles
    , prependExtraAttributes
    , prependExtraStyles
    , setExtraAttributes
    , setExtraStyles
    , setTag
    )

import Css
import Html.Styled as Html
import Lib.Function as Function


type alias Compatibility msg =
    { tag : String
    , extraAttributes : List (Html.Attribute msg)
    , extraStyles : List Css.Style
    }


fromTag : String -> Compatibility msg
fromTag tag =
    { tag = tag
    , extraAttributes = []
    , extraStyles = []
    }


setTag : String -> Compatibility msg -> Compatibility msg
setTag a compat =
    { compat | tag = a }


mapExtraAttributes : (List (Html.Attribute msgA) -> List (Html.Attribute msgB)) -> Compatibility msgA -> Compatibility msgB
mapExtraAttributes f compat =
    { tag = compat.tag
    , extraAttributes = f compat.extraAttributes
    , extraStyles = compat.extraStyles
    }


mapEachExtraAttribute : (Html.Attribute msg -> Html.Attribute msg) -> Compatibility msg -> Compatibility msg
mapEachExtraAttribute f compat =
    mapExtraAttributes (List.map f) compat


setExtraAttributes : List (Html.Attribute msg) -> Compatibility msg -> Compatibility msg
setExtraAttributes a compat =
    mapExtraAttributes (always a) compat


appendExtraAttributes : List (Html.Attribute msg) -> Compatibility msg -> Compatibility msg
appendExtraAttributes a compat =
    mapExtraAttributes (Function.flip List.append a) compat


appendExtraAttribute : Html.Attribute msg -> Compatibility msg -> Compatibility msg
appendExtraAttribute a compat =
    appendExtraAttributes [ a ] compat


consExtraAttribute : Html.Attribute msg -> Compatibility msg -> Compatibility msg
consExtraAttribute a compat =
    mapExtraAttributes ((::) a) compat


prependExtraAttributes : List (Html.Attribute msg) -> Compatibility msg -> Compatibility msg
prependExtraAttributes a compat =
    mapExtraAttributes (List.append a) compat


mapExtraStyles : (List Css.Style -> List Css.Style) -> Compatibility msg -> Compatibility msg
mapExtraStyles f compat =
    { compat | extraStyles = f compat.extraStyles }


mapEachExtraStyle : (Css.Style -> Css.Style) -> Compatibility msg -> Compatibility msg
mapEachExtraStyle f compat =
    mapExtraStyles (List.map f) compat


setExtraStyles : List Css.Style -> Compatibility msg -> Compatibility msg
setExtraStyles a compat =
    mapExtraStyles (always a) compat


appendExtraStyles : List Css.Style -> Compatibility msg -> Compatibility msg
appendExtraStyles a compat =
    mapExtraStyles (Function.flip List.append a) compat


appendExtraStyle : Css.Style -> Compatibility msg -> Compatibility msg
appendExtraStyle a compat =
    appendExtraStyles [ a ] compat


consExtraStyle : Css.Style -> Compatibility msg -> Compatibility msg
consExtraStyle a compat =
    mapExtraStyles ((::) a) compat


prependExtraStyles : List Css.Style -> Compatibility msg -> Compatibility msg
prependExtraStyles a compat =
    mapExtraStyles (List.append a) compat
