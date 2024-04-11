module Example.View.ThemeButton exposing (..)

import Elemental.Css.BorderRadius exposing (BorderRadius)
import Elemental.Typography exposing (Typography)
import Elemental.View.Button as Button
import Elemental.View.LoadingSpinner as LoadingSpinner
import Example.Colors as Colors
import Example.Icons as Icons
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)
import Html.Styled as H


view :
    { onClick : msg
    , colors : { primary : Colors.ButtonColors, secondary : Colors.ButtonColors } -> Colors.ButtonColors
    , theme : Theme
    , typography : Typography
    , borderRadius : BorderRadius
    , disabled : Bool
    , isLoading : Bool
    }
    -> { name : String, icon : Button.Icon msg }
    -> H.Html msg
view options { name, icon } =
    let
        buttonColors =
            options.theme.colors.button |> options.colors
    in
    Button.viewCustom
        { layout = L.layout
        , style =
            { typography = options.typography
            , colors =
                { foreground =
                    { normal = buttonColors.foreground.normal
                    , disabled = buttonColors.foreground.disabled
                    }
                , background =
                    { normal = buttonColors.background.normal
                    , disabled = buttonColors.background.disabled
                    , hover = buttonColors.background.hover
                    , pressed = buttonColors.background.pressed
                    }
                , focus = buttonColors.focus
                }
            , spacers =
                { x = 4
                , y = 1
                , icon =
                    if String.isEmpty name then
                        0

                    else
                        2
                }
            , borderRadius = options.borderRadius.all
            }
        , text = name
        , icon = icon
        , loadingSpinner =
            LoadingSpinner.viewCustom
                { size = LoadingSpinner.Small
                , background = buttonColors.loader.background
                , foreground = buttonColors.loader.foreground
                , transitionDuration = 400
                }
        , target =
            if options.disabled then
                Button.Disabled

            else if options.isLoading then
                Button.Loading

            else
                Button.ClickTarget options.onClick
        }


viewChangeTheme currentTheme ( theme, genTheme ) name onSelectTheme =
    view
        { onClick = onSelectTheme ( theme, genTheme )
        , disabled = False
        , borderRadius = theme.borderRadius.button.medium
        , theme = theme
        , colors = .primary
        , typography = theme.typography.button.medium
        , isLoading = False
        }
        { name = name
        , icon =
            if currentTheme == theme then
                Button.RightIcon (Icons.view Icons.CheckCircle 18)

            else
                Button.NoIcon
        }
