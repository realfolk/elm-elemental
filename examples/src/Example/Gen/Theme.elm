module Example.Gen.Theme exposing (..)

import Example.Gen.Typography as Typography exposing (TypographyTree)


type alias Theme =
    { typography : TypographyTree

    -- , colors : Colors
    -- -- , effects : Effects
    -- , borderRadius : ThemeBorderRadius
    -- , borderRadiusG : ThemeBorderRadiusGenerator
    -- , config : Config
    }


baseTheme : Theme
baseTheme =
    { typography = Typography.defaultTypography

    -- , colors = Colors.baseColors
    -- , config = baseConfig
    -- , borderRadius = generatorToBorderRadius baseBorderRadiusG
    -- , borderRadiusG = baseBorderRadiusG
    }


elegantTheme : Theme
elegantTheme =
    { typography = Typography.elegantTypography

    -- , colors = Colors.baseColors
    -- , config = baseConfig
    -- , borderRadius = generatorToBorderRadius baseBorderRadiusG
    -- , borderRadiusG = baseBorderRadiusG
    }


adventureTheme : Theme
adventureTheme =
    { typography = Typography.adventureTypography

    -- , colors = Colors.baseColors
    -- , config = baseConfig
    -- , borderRadius = generatorToBorderRadius baseBorderRadiusG
    -- , borderRadiusG = baseBorderRadiusG
    }
