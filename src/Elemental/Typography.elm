module Elemental.Typography exposing
    ( FontFamilies
    , Typography
    , bold
    , italic
    , toStyle
    , underline
    , uppercase
    )

import Css


type alias Typography =
    { families : FontFamilies
    , size : Float
    , normalWeight : Int
    , boldWeight : Int
    , lineHeight : Float
    , letterSpacing : Float
    , bold : Bool
    , underline : Bool
    , italic : Bool
    , uppercase : Bool
    }


type alias FontFamilies =
    List String



-- UTILITIES


bold : Typography -> Typography
bold t =
    { t | bold = True }


underline : Typography -> Typography
underline t =
    { t | underline = True }


italic : Typography -> Typography
italic t =
    { t | italic = True }


uppercase : Typography -> Typography
uppercase t =
    { t | uppercase = True }


toStyle : Typography -> Css.Style
toStyle t =
    let
        fontWeight =
            if t.bold then
                Css.fontWeight (Css.int t.boldWeight)

            else
                Css.fontWeight (Css.int t.normalWeight)

        textDecoration =
            if t.underline then
                Css.textDecoration Css.underline

            else
                Css.textDecoration Css.none

        fontStyle =
            if t.italic then
                Css.fontStyle Css.italic

            else
                Css.fontStyle Css.normal

        textTransform =
            if t.uppercase then
                Css.textTransform Css.uppercase

            else
                Css.textTransform Css.none
    in
    Css.batch
        [ Css.fontFamilies t.families
        , Css.fontSize (Css.px t.size)
        , Css.lineHeight (Css.px t.lineHeight)
        , Css.letterSpacing (Css.em t.letterSpacing)
        , fontWeight
        , textDecoration
        , fontStyle
        , textTransform
        ]
