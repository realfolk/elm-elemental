module Example.Theme exposing (Config, Effects, Shadows, Theme, ThemeBorderRadius, ThemeBorderRadiusGenerator, adventureTheme, baseConfig, baseTheme, elegantTheme, generatorToBorderRadius)

import Css
import Elemental.Css.BorderRadius as BorderRadius exposing (BorderRadius)
import Example.Colors as Colors exposing (Colors)
import Example.Typography as Typography exposing (ThemeTypography)


type alias Theme =
    { colors : Colors
    , typography : ThemeTypography

    -- , effects : Effects
    , borderRadius : ThemeBorderRadius
    , borderRadiusG : ThemeBorderRadiusGenerator
    , config : Config
    }


baseTheme : Theme
baseTheme =
    { colors = Colors.baseColors
    , config = baseConfig
    , typography = Typography.baseTypography
    , borderRadius = generatorToBorderRadius baseBorderRadiusG
    , borderRadiusG = baseBorderRadiusG
    }


elegantTheme =
    let
        customBorderRadiusG =
            { button =
                { small = 3
                , medium = 5
                }
            , global =
                { small = 2
                , medium = 6
                , large = 12
                }
            }
    in
    { colors = Colors.elegantColors
    , config = baseConfig
    , typography = Typography.elegantTypography
    , borderRadius = generatorToBorderRadius customBorderRadiusG
    , borderRadiusG = customBorderRadiusG
    }


adventureTheme =
    let
        customBorderRadiusG =
            { button =
                { small = 1
                , medium = 2
                }
            , global =
                { small = 4
                , medium = 8
                , large = 16
                }
            }
    in
    { colors = Colors.adventureColors
    , config = baseConfig
    , typography = Typography.adventureTypography
    , borderRadius = generatorToBorderRadius customBorderRadiusG
    , borderRadiusG = customBorderRadiusG
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


type alias ThemeBorderRadiusGenerator =
    { button :
        { small : Float
        , medium : Float
        }
    , global :
        { small : Float
        , medium : Float
        , large : Float
        }
    }


generatorToBorderRadius generator =
    { button =
        { small = BorderRadius.borderRadius generator.button.small
        , medium = BorderRadius.borderRadius generator.button.medium
        }
    , global =
        { small = BorderRadius.borderRadius generator.global.small
        , medium = BorderRadius.borderRadius generator.global.medium
        , large = BorderRadius.borderRadius generator.global.large
        }
    }


baseBorderRadiusG : ThemeBorderRadiusGenerator
baseBorderRadiusG =
    { button =
        { small = 20
        , medium = 24
        }
    , global =
        { small = 4
        , medium = 8
        , large = 16
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
