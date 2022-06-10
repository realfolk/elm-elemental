module Example.Theme exposing (..)

import Css
import Elemental.Css.BorderRadius as BorderRadius exposing (BorderRadius)
import Example.Colors as Colors exposing (Colors)
import Example.Typography as Typography exposing (ThemeTypography)


type alias Theme =
    { colors : Colors
    , typography : ThemeTypography

    -- , effects : Effects
    , borderRadius : ThemeBorderRadius
    , config : Config
    }


baseTheme =
    { colors = Colors.baseColors
    , config = baseConfig
    , typography = Typography.baseTypography
    , borderRadius = baseBorderRadius
    }


elegantTheme =
    { colors = Colors.elegantColors
    , config = baseConfig
    , typography = Typography.elegantTypography
    , borderRadius = baseBorderRadius
    }


partyTheme =
    { colors = Colors.partyColors
    , config = baseConfig
    , typography = Typography.partyTypography
    , borderRadius = baseBorderRadius
    }


adventureTheme =
    { colors = Colors.adventureColors
    , config = baseConfig
    , typography = Typography.adventureTypography
    , borderRadius = baseBorderRadius
    }


type alias Effects =
    { boxShadow : Shadows
    }


type alias Shadows =
    { none : Css.Style
    , light : Css.Style
    , medium : Css.Style
    , heavy : Css.Style
    }



-- Base Config


type alias ThemeBorderRadius =
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


baseBorderRadius =
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


type alias Config =
    { transitionDuration :
        { long : Float
        }
    }


baseConfig : Config
baseConfig =
    { transitionDuration =
        { long = 400
        }
    }
