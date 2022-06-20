module Example.View.ThemeButton exposing (..)

import Elemental.Css.BorderRadius exposing (BorderRadius)
import Elemental.Typography exposing (Typography)
import Elemental.View.Button as Button
import Example.Colors as Colors
import Example.Icons as Icons
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)
import Html.Styled as H


view :
    { onClick : msg
    , colors : Button.Colors
    , typography : Typography
    , borderRadius : BorderRadius
    , disabled : Bool
    }
    -> { name : String, icon : Button.Icon msg }
    -> H.Html msg
view options { name, icon } =
    Button.viewCustom
        { layout = L.layout
        , style =
            { typography = options.typography
            , colors = options.colors
            , spacers =
                { x = 4
                , y = 1
                , icon = 2
                }
            , borderRadius = options.borderRadius.all
            }
        , text = name
        , icon = icon
        , loadingSpinner = H.text ""
        , target =
            if options.disabled then
                Button.Disabled

            else
                Button.ClickTarget options.onClick
        }


viewChangeTheme currentTheme theme  name onSelectTheme =
    view
        { onClick = onSelectTheme theme
        , disabled = False
        , borderRadius = theme.borderRadius.button.medium
        , colors =
            if currentTheme == theme then
                theme.colors.button.primary

            else
                theme.colors.button.secondary
        , typography = theme.typography.button.medium
        }
        { name = name
        , icon =
            if currentTheme == theme then
                Button.RightIcon (Icons.view Icons.CheckCircle 18)

            else
                Button.NoIcon
        }
