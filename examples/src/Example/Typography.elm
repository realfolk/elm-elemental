module Example.Typography exposing (ThemeTypography, adventureTypography, allWeights, baseTypography, elegantTypography, intToWeight, namedFontFamilies, partyTypography, weightToInt, weightToName)

import Elemental.Typography exposing (FontFamilies, Typography)


type alias ThemeTypography =
    { body :
        { small : Typography
        , medium : Typography
        }
    , button :
        { small : Typography
        , medium : Typography
        }
    , code : Typography
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
            , boldWeight = medium
            , lineHeight = 24
            , letterSpacing = 0
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        }
    , button =
        { small =
            { families = ibmPlexSans
            , size = 14
            , normalWeight = semiBold
            , boldWeight = semiBold
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
            , normalWeight = semiBold
            , boldWeight = semiBold
            , lineHeight = 24
            , letterSpacing = 0
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        }
    , code =
        { families = ibmPlexMono
        , size = 14
        , normalWeight = normal
        , boldWeight = bold
        , lineHeight = 24
        , letterSpacing = 0
        , bold = False
        , underline = False
        , italic = False
        , uppercase = False
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
            { families = dmSans
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
            { families = dmSans
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
            { families = dmSans
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


elegantTypography : ThemeTypography
elegantTypography =
    { body =
        { small =
            { families = raleway
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
            { families = raleway
            , size = 16
            , normalWeight = normal
            , boldWeight = medium
            , lineHeight = 24
            , letterSpacing = 0
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        }
    , button =
        { small =
            { families = raleway
            , size = 14
            , normalWeight = semiBold
            , boldWeight = semiBold
            , lineHeight = 20
            , letterSpacing = 0
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        , medium =
            { families = raleway
            , size = 16
            , normalWeight = semiBold
            , boldWeight = semiBold
            , lineHeight = 24
            , letterSpacing = 0
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        }
    , code =
        { families = ibmPlexMono
        , size = 14
        , normalWeight = normal
        , boldWeight = bold
        , lineHeight = 24
        , letterSpacing = 0
        , bold = False
        , underline = False
        , italic = False
        , uppercase = False
        }
    , form =
        { field =
            { label =
                { families = ibmPlexSans
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
                { families = raleway
                , size = 13
                , normalWeight = 400
                , boldWeight = 700
                , lineHeight = 20
                , letterSpacing = 0
                , bold = True
                , underline = False
                , italic = False
                , uppercase = False
                }
            }
        }
    , heading =
        { h4 =
            { families = vollkorn
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
            { families = vollkorn
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
            { families = vollkorn
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


partyTypography : ThemeTypography
partyTypography =
    { body =
        { small =
            { families = roboto
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
            { families = roboto
            , size = 16
            , normalWeight = normal
            , boldWeight = medium
            , lineHeight = 24
            , letterSpacing = 0
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        }
    , button =
        { small =
            { families = rancho
            , size = 16
            , normalWeight = normal
            , boldWeight = semiBold
            , lineHeight = 20
            , letterSpacing = 0
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        , medium =
            { families = rancho
            , size = 18
            , normalWeight = normal
            , boldWeight = semiBold
            , lineHeight = 24
            , letterSpacing = 0
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        }
    , code =
        { families = ibmPlexMono
        , size = 14
        , normalWeight = normal
        , boldWeight = bold
        , lineHeight = 24
        , letterSpacing = 0
        , bold = False
        , underline = False
        , italic = False
        , uppercase = False
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
                { families = roboto
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
            { families = rancho
            , size = 32
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
            { families = rancho
            , size = 28
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
            { families = rancho
            , size = 24
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


adventureTypography : ThemeTypography
adventureTypography =
    { body =
        { small =
            { families = cardo
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
            { families = cardo
            , size = 16
            , normalWeight = normal
            , boldWeight = medium
            , lineHeight = 24
            , letterSpacing = 0
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        }
    , button =
        { small =
            { families = cardo
            , size = 14
            , normalWeight = semiBold
            , boldWeight = semiBold
            , lineHeight = 20
            , letterSpacing = 0
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        , medium =
            { families = cardo
            , size = 16
            , normalWeight = semiBold
            , boldWeight = semiBold
            , lineHeight = 24
            , letterSpacing = 0
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        }
    , code =
        { families = ibmPlexMono
        , size = 14
        , normalWeight = normal
        , boldWeight = bold
        , lineHeight = 24
        , letterSpacing = 0
        , bold = False
        , underline = False
        , italic = False
        , uppercase = False
        }
    , form =
        { field =
            { label =
                { families = dellaRespira
                , size = 15
                , normalWeight = 400
                , boldWeight = 400
                , lineHeight = 20
                , letterSpacing = 0.08
                , bold = False
                , underline = False
                , italic = False
                , uppercase = False
                }
            , support =
                { families = dellaRespira
                , size = 14
                , normalWeight = 400
                , boldWeight = 700
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
            { families = medievalSharp
            , size = 32
            , normalWeight = bold
            , boldWeight = bold
            , lineHeight = 37
            , letterSpacing = -0.02
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        , h5 =
            { families = medievalSharp
            , size = 28
            , normalWeight = bold
            , boldWeight = bold
            , lineHeight = 32
            , letterSpacing = -0.02
            , bold = False
            , underline = False
            , italic = False
            , uppercase = False
            }
        , h6 =
            { families = medievalSharp
            , size = 24
            , normalWeight = semiBold
            , boldWeight = semiBold
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
-- MONOSPACE


ibmPlexMono : FontFamilies
ibmPlexMono =
    [ "IBM Plex Mono", "mono" ]



-- SANS-SERIF


ibmPlexSans : FontFamilies
ibmPlexSans =
    [ "IBM Plex Sans", "sans-serif" ]


dmSans : FontFamilies
dmSans =
    [ "DM Sans", "sans-serif" ]


roboto : FontFamilies
roboto =
    [ "Roboto", "sans-serif" ]


raleway : FontFamilies
raleway =
    [ "Raleway", "sans-serif" ]



-- SERIF


vollkorn : FontFamilies
vollkorn =
    [ "Vollkorn", "serif" ]


cardo : FontFamilies
cardo =
    [ "Cardo", "serif" ]


dellaRespira : FontFamilies
dellaRespira =
    [ "Della Respira", "serif" ]


medievalSharp : FontFamilies
medievalSharp =
    [ "MedievalSharp", "serif" ]


rancho : FontFamilies
rancho =
    [ "Rancho", "serif" ]


namedFontFamilies : List ( String, FontFamilies )
namedFontFamilies =
    [ ( "IBM Plex Mono", ibmPlexMono )
    , ( "IBM Plex Sans", ibmPlexSans )
    , ( "DM Sans", dmSans )
    , ( "Raleway", raleway )
    , ( "Roboto", roboto )
    , ( "Cardo", cardo )
    , ( "Della Respira", dellaRespira )
    , ( "MedievalSharp", medievalSharp )
    , ( "Rancho", rancho )
    , ( "Vollkorn", vollkorn )
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
