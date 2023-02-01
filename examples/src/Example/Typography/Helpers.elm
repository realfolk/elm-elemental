module Example.Typography.Helpers exposing (..)

import Elemental.Typography exposing (FontFamilies)



-- FONT FAMILIES
-- MONOSPACE


ibmPlexMono : FontFamilies
ibmPlexMono =
    [ "IBM Plex Mono", "monospace" ]



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
    , ( "Della Respira", cardo )
    , ( "MedievalSharp", medievalSharp )
    , ( "Rancho", rancho )
    , ( "Vollkorn", vollkorn )
    ]



-- FONT WEIGHTS


type FontWeight
    = Thin
    | ExtraLight
    | Light
    | Normal
    | Medium
    | SemiBold
    | Bold
    | ExtraBold
    | Black


allWeights =
    [ Thin
    , ExtraLight
    , Light
    , Normal
    , Medium
    , SemiBold
    , Bold
    , ExtraBold
    , Black
    ]


weightToInt weight =
    case weight of
        Thin ->
            100

        ExtraLight ->
            200

        Light ->
            300

        Normal ->
            400

        Medium ->
            500

        SemiBold ->
            600

        Bold ->
            700

        ExtraBold ->
            800

        Black ->
            900


weightIntToName int =
    case int of
        100 ->
            weightToName Thin

        200 ->
            weightToName ExtraLight

        300 ->
            weightToName Light

        400 ->
            weightToName Normal

        500 ->
            weightToName Medium

        600 ->
            weightToName SemiBold

        700 ->
            weightToName Bold

        800 ->
            weightToName ExtraBold

        900 ->
            weightToName Black

        _ ->
            String.fromInt int


weightToName weight =
    case weight of
        Thin ->
            "Thin"

        ExtraLight ->
            "Extra Light"

        Light ->
            "Light"

        Normal ->
            "Normal"

        Medium ->
            "Medium"

        SemiBold ->
            "Semi Bold"

        Bold ->
            "Bold"

        ExtraBold ->
            "Extra Bold"

        Black ->
            "Black"


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
