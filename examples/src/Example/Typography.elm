module Example.Typography exposing (ThemeTypography, adventureTypography, baseTypography, elegantTypography)

import Elemental.Typography exposing (Typography)
import Example.Typography.Helpers exposing (..)


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
            , normalWeight = medium
            , boldWeight = medium
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
            , normalWeight = medium
            , boldWeight = medium
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
            , normalWeight = medium
            , boldWeight = medium
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
            , normalWeight = medium
            , boldWeight = medium
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
            , normalWeight = medium
            , boldWeight = medium
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
            , normalWeight = medium
            , boldWeight = medium
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
                { families = cardo
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
                { families = cardo
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
