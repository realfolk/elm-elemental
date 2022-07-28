module New.Elemental.Lib.Color exposing
    ( Color
    , black
    , getAlphaChannel
    , getBlueChannel
    , getGreenChannel
    , getRedChannel
    , rgb
    , rgba
    , toCssValue
    , transparent
    , white
    )

import Css


type Color
    = Color
        { red : Int
        , green : Int
        , blue : Int
        , alpha : Float
        }



-- Constructors


rgb : Int -> Int -> Int -> Color
rgb r g b =
    rgba r g b 1


rgba : Int -> Int -> Int -> Float -> Color
rgba r g b a =
    Color
        { red = r
        , green = g
        , blue = b
        , alpha = a
        }


black : Color
black =
    rgb 0 0 0


white : Color
white =
    rgb 255 255 255


transparent : Color
transparent =
    rgba 0 0 0 0



-- Conversion


toCssValue : Color -> Css.Color
toCssValue color =
    Css.rgba
        (getRedChannel color)
        (getGreenChannel color)
        (getBlueChannel color)
        (getAlphaChannel color)



-- Getters


getRedChannel : Color -> Int
getRedChannel (Color { red }) =
    red


getGreenChannel : Color -> Int
getGreenChannel (Color { green }) =
    green


getBlueChannel : Color -> Int
getBlueChannel (Color { blue }) =
    blue


getAlphaChannel : Color -> Float
getAlphaChannel (Color { alpha }) =
    alpha
