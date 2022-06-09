module Example.Theme exposing (..)

import Css
import Elemental.Css.BorderRadius as BorderRadius exposing (BorderRadius)
import Example.Colors exposing (Colors)
import Example.Typography as ExampleTypography exposing (ThemeTypography)


type alias Theme =
    { colors : Colors
    , typography : ThemeTypography

    -- , effects : Effects
    , borderRadius :
        { button :
            { small : BorderRadius
            , medium : BorderRadius
            }
        , global :
            { small : BorderRadius
            , medium : BorderRadius
            , large : BorderRadius
            }
        }
    }



-- type alias Colors =
--     { background :
--         { normal : Css.Color
--         , alternate : Css.Color
--         , hover : Css.Color
--         }
--     , foreground :
--         { regular : Css.Color
--         , soft : Css.Color
--         }
--     }


type alias Effects =
    { boxShadow : Shadows
    }


type alias Shadows =
    { none : Css.Style
    , light : Css.Style
    , medium : Css.Style
    , heavy : Css.Style
    }



-- TYPOGRAPHY


borderRadius =
    { button =
        { small = BorderRadius.borderRadius 20
        , medium = BorderRadius.borderRadius 24
        }
    , global =
        { small = BorderRadius.borderRadius 4
        , medium = BorderRadius.borderRadius 8
        , large = BorderRadius.borderRadius 16
        }
    }
