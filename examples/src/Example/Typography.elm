module Example.Typography exposing (..)

import Elemental.Typography exposing (FontFamilies, Typography)


type alias ThemeTypography =
    { body :
        { small : Typography
        , medium : Typography
        }
    , form :
        { field :
            { label : Typography
            , support : Typography
            }
        }
    , heading :
        { h4 : Typography
        , h5 : Typography
        , h6 : Typography
        }
    }


sampleTypographies : List ( String, ThemeTypography )
sampleTypographies =
    [ ( "Relaxed", baseTypography )
    ]


baseTypography : ThemeTypography
baseTypography =
    { body =
        { small =
            { families = ibmPlexSans
            , size = 14
            , normalWeight = normal
            , boldWeight = bold
            , lineHeight = 20
            , letterSpacing = 0
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        , medium =
            { families = ibmPlexSans
            , size = 16
            , normalWeight = normal
            , boldWeight = bold
            , lineHeight = 24
            , letterSpacing = 0
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        }
    , form =
        { field =
            { label =
                { families = ibmPlexMono
                , size = 13
                , normalWeight = normal
                , boldWeight = normal
                , lineHeight = 20
                , letterSpacing = 0.08
                , bold = False
                , underline = False
                , italic = False
                , uppercase = True
                }
            , support =
                { families = ibmPlexSans
                , size = 14
                , normalWeight = normal
                , boldWeight = bold
                , lineHeight = 20
                , letterSpacing = 0
                , bold = False
                , underline = False
                , italic = False
                , uppercase = False
                }
            }
        }
    , heading =
        { h4 =
            { families = roboto
            , size = 28
            , normalWeight = medium
            , boldWeight = medium
            , lineHeight = 37
            , letterSpacing = -0.02
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        , h5 =
            { families = roboto
            , size = 24
            , normalWeight = medium
            , boldWeight = medium
            , lineHeight = 32
            , letterSpacing = -0.02
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        , h6 =
            { families = roboto
            , size = 20
            , normalWeight = medium
            , boldWeight = medium
            , lineHeight = 26
            , letterSpacing = -0.02
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        }
    }



-- FONT FAMILIES


ibmPlexMono : FontFamilies
ibmPlexMono =
    [ "IBM Plex Mono", "mono" ]


ibmPlexSans : FontFamilies
ibmPlexSans =
    [ "IBM Plex Sans", "sans-serif" ]


roboto : FontFamilies
roboto =
    [ "Roboto", "serif" ]


namedFontFamilies : List ( String, FontFamilies )
namedFontFamilies =
    [ ( "IBM Plex Mono", ibmPlexMono )
    , ( "IBM Plex Sans", ibmPlexSans )
    , ( "Roboto", roboto )
    ]



-- FONT WEIGHTS


type FontWeight
    = Normal
    | Medium
    | SemiBold
    | Bold


allWeights =
    [ Normal
    , Medium
    , SemiBold
    , Bold
    ]


weightToInt weight =
    case weight of
        Normal ->
            400

        Medium ->
            500

        SemiBold ->
            600

        Bold ->
            700


intToWeight int =
    case int of
        400 ->
            Normal

        500 ->
            Medium

        600 ->
            SemiBold

        _ ->
            Bold


weightToName weight =
    case weight of
        Normal ->
            "Normal"

        Medium ->
            "Medium"

        SemiBold ->
            "SemiBold"

        Bold ->
            "Bold"


normal : Int
normal =
    400


medium : Int
medium =
    500


semiBold : Int
semiBold =
    600


bold : Int
bold =
    700
