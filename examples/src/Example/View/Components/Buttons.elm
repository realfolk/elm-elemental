module Example.View.Components.Buttons exposing (..)

import Elemental.Layout as L
import Elemental.Typography
import Elemental.View.Button as Button
import Example.Colors
import Example.Icons as Icons
import Example.Layout as L
import Example.Theme exposing (Theme)
import Example.Typography
import Example.View.ThemeButton as ThemeButton
import Html.Styled as H



-- VIEW


type Msg
    = NoOp


view : Theme -> Bool -> msg -> H.Html msg
view theme complex noOp =
    if complex then
        L.viewColumn L.Normal
            []
            [ viewGroup { theme = theme, name = "Primary", toColors = .primary, noOp = noOp }
            , L.layout.spacerY 2
            , viewGroup { theme = theme, name = "Secondary", toColors = .secondary, noOp = noOp }
            ]

    else
        L.viewRow L.Normal
            []
            [ ThemeButton.view
                { onClick = noOp
                , disabled = False
                , borderRadius = theme.borderRadius.button.medium
                , colors = theme.colors.button.primary
                , typography = theme.typography.button.medium
                }
                { name = "Enabled"
                , icon = Button.NoIcon
                }
            , L.layout.spacerX 2
            , ThemeButton.view
                { onClick = noOp
                , disabled = True
                , borderRadius = theme.borderRadius.button.medium
                , colors = theme.colors.button.primary
                , typography = theme.typography.button.medium
                }
                { name = "Disabled"
                , icon = Button.NoIcon
                }
            ]


viewGroup { theme, name, toColors, noOp } =
    L.viewColumn L.Normal
        []
        [ H.h6 [] [ H.text name ]
        , H.text "Medium Size"
        , viewSizedGroup { theme = theme, toColors = toColors, toSize = .medium, noOp = noOp }
        , L.layout.spacerY 2
        , H.text "Small Size"
        , viewSizedGroup { theme = theme, toColors = toColors, toSize = .small, noOp = noOp }
        , L.layout.spacerY 2
        ]


viewSizedGroup { theme, toColors, toSize, noOp } =
    L.viewColumn L.Normal
        []
        [ L.viewRow L.Normal
            []
            [ ThemeButton.view
                { onClick = noOp
                , disabled = False
                , borderRadius = theme.borderRadius.button.medium
                , colors = theme.colors.button |> toColors
                , typography = theme.typography.button |> toSize
                }
                { name = "Enabled"
                , icon = Button.LeftIcon (Icons.view Icons.Send 18)
                }
            , L.layout.spacerX 2
            , ThemeButton.view
                { onClick = noOp
                , disabled = False
                , borderRadius = theme.borderRadius.button.medium
                , colors = theme.colors.button |> toColors
                , typography = theme.typography.button |> toSize
                }
                { name = "Enabled"
                , icon = Button.NoIcon
                }
            , L.layout.spacerX 2
            , ThemeButton.view
                { onClick = noOp
                , disabled = False
                , borderRadius = theme.borderRadius.button.medium
                , colors = theme.colors.button |> toColors
                , typography = theme.typography.button |> toSize
                }
                { name = "Enabled"
                , icon = Button.RightIcon (Icons.view Icons.Send 18)
                }
            ]
        , L.layout.spacerY 2
        , L.viewRow L.Normal
            []
            [ ThemeButton.view
                { onClick = noOp
                , disabled = True
                , borderRadius = theme.borderRadius.button.medium
                , colors = theme.colors.button |> toColors
                , typography = theme.typography.button |> toSize
                }
                { name = "Disabled"
                , icon = Button.LeftIcon (Icons.view Icons.Send 18)
                }
            , L.layout.spacerX 2
            , ThemeButton.view
                { onClick = noOp
                , disabled = True
                , borderRadius = theme.borderRadius.button.medium
                , colors = theme.colors.button |> toColors
                , typography = theme.typography.button |> toSize
                }
                { name = "Disabled"
                , icon = Button.NoIcon
                }
            , L.layout.spacerX 2
            , ThemeButton.view
                { onClick = noOp
                , disabled = True
                , borderRadius = theme.borderRadius.button.medium
                , colors = theme.colors.button |> toColors
                , typography = theme.typography.button |> toSize
                }
                { name = "Disabled"
                , icon = Button.RightIcon (Icons.view Icons.Send 18)
                }
            ]
        ]
