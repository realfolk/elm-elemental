module Elemental.View.Image exposing (Sources, Src(..), toHref, view)

import Html.Styled as H
import Html.Styled.Attributes as HA


type Src
    = Src String
    | Srcset Sources


type alias Sources =
    { x1 : String
    , x2 : String
    , x3 : String -- 3x is the default pixel density
    }


view : Src -> List (H.Attribute msg) -> H.Html msg
view src attrs =
    case src of
        Src url ->
            H.img (attrs ++ [ HA.src url ]) []

        Srcset sources ->
            let
                srcAttr =
                    HA.src <| toSrc sources

                srcset =
                    HA.attribute "srcset" <| toSrcset sources

                fixedAttrs =
                    [ srcAttr, srcset ]

                allAttrs =
                    attrs ++ fixedAttrs
            in
            H.img allAttrs []


toHref : Src -> String
toHref src =
    case src of
        Src url ->
            url

        Srcset { x3 } ->
            x3


toSrc : Sources -> String
toSrc { x1 } =
    x1


toSrcset : Sources -> String
toSrcset { x2, x3 } =
    String.join ","
        [ x2 ++ " 2x"
        , x3 ++ " 3x"
        ]
