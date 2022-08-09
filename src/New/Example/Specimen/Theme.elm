module New.Example.Specimen.Theme exposing (Base16Scheme, Permutation, eighties, permutations, typography)

import New.Elemental.Box.Style.Typography as Typography
import New.Elemental.Lib.Color as Color exposing (Color)
import New.Elemental.Lib.Size as Size


firaMono : List Typography.Family
firaMono =
    [ "Fira Mono", "mono" ]


openSans : List Typography.Family
openSans =
    [ "Open Sans", "sans-serif" ]


typography =
    { section =
        { heading =
            { families = openSans
            , size = Size.px 32
            , weight = Typography.W600
            , lineHeight = Size.px 38
            , letterSpacing = Size.em 0
            , italic = False
            , underline = False
            , overline = False
            , strikethrough = False
            , decorationColor = Nothing
            , transformation = Typography.NoTransformation
            }
        }
    , badge =
        { families = firaMono
        , size = Size.px 12
        , weight = Typography.W500
        , lineHeight = Size.px 18
        , letterSpacing = Size.em 0.12
        , italic = False
        , underline = False
        , overline = False
        , strikethrough = False
        , decorationColor = Nothing
        , transformation = Typography.Uppercase
        }
    }


type alias Base16Scheme =
    { c0 : Color
    , c1 : Color
    , c2 : Color
    , c3 : Color
    , c4 : Color
    , c5 : Color
    , c6 : Color
    , c7 : Color
    , c8 : Color
    , c9 : Color
    , cA : Color
    , cB : Color
    , cC : Color
    , cD : Color
    , cE : Color
    , cF : Color
    }


eighties : Base16Scheme
eighties =
    { c0 = Color.rgb 0x2D 0x2D 0x2D
    , c1 = Color.rgb 0x39 0x39 0x39
    , c2 = Color.rgb 0x51 0x51 0x51
    , c3 = Color.rgb 0x74 0x73 0x69
    , c4 = Color.rgb 0xA0 0x9F 0x93
    , c5 = Color.rgb 0xD3 0xD0 0xC8
    , c6 = Color.rgb 0xE8 0xE6 0xDF
    , c7 = Color.rgb 0xF2 0xF0 0xEC
    , c8 = Color.rgb 0xF2 0x77 0x7A
    , c9 = Color.rgb 0xF9 0x91 0x57
    , cA = Color.rgb 0xFF 0xCC 0x66
    , cB = Color.rgb 0x99 0xCC 0x99
    , cC = Color.rgb 0x66 0xCC 0xCC
    , cD = Color.rgb 0x66 0x99 0xCC
    , cE = Color.rgb 0xCC 0x99 0xCC
    , cF = Color.rgb 0xD2 0x7B 0x53
    }


type alias Permutation =
    { background : Color
    , foreground : Color
    }


permutations : Base16Scheme -> List Permutation
permutations scheme =
    let
        backgrounds =
            [ scheme.c0
            , scheme.c1
            , scheme.c2
            ]

        foregrounds =
            [ scheme.c3
            , scheme.c4
            , scheme.c5
            , scheme.c6
            , scheme.c7
            , scheme.c8
            , scheme.c9
            , scheme.cA
            , scheme.cB
            , scheme.cC
            , scheme.cD
            , scheme.cE
            , scheme.cF
            ]
    in
    List.map (\bg -> List.map (Permutation bg) foregrounds) backgrounds
        |> List.concat
