module Example.Component.Buttons exposing (..)

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


view : Theme -> msg -> H.Html msg
view theme noOp =
    L.viewColumn L.Normal
        []
        [ viewGroup { theme = theme, name = "Primary", toColors = .primary, noOp = noOp }
        , L.layout.spacerY 2
        , viewGroup { theme = theme, name = "Secondary", toColors = .secondary, noOp = noOp }
        ]


viewGroup { theme, name, toColors, noOp } =
    L.viewColumn L.Normal
        []
        [ H.h6 [] [ H.text name ]
        , H.text "Medium Size"
        , viewSizedGroup
            { theme = theme
            , toColors = toColors
            , toSize = .medium
            , toSizeBorder = .medium
            , noOp = noOp
            }
        , L.layout.spacerY 2
        , H.text "Small Size"
        , viewSizedGroup
            { theme = theme
            , toColors = toColors
            , toSize = .small
            , toSizeBorder = .small
            , noOp = noOp
            }
        , L.layout.spacerY 2
        ]


viewSizedGroup { theme, toColors, toSize, toSizeBorder, noOp } =
    L.viewColumn L.Normal
        []
        [ L.viewRow L.Normal
            []
            [ ThemeButton.view
                { onClick = noOp
                , disabled = False
                , borderRadius = theme.borderRadius.button |> toSizeBorder
                , theme = theme
                , colors = toColors
                , typography = theme.typography.button |> toSize
                , isLoading = False
                }
                { name = "Action"
                , icon = Button.RightIcon (Icons.view Icons.Download 18)
                }
            , L.layout.spacerX 2
            , ThemeButton.view
                { onClick = noOp
                , disabled = False
                , borderRadius = theme.borderRadius.button |> toSizeBorder
                , theme = theme
                , colors = toColors
                , typography = theme.typography.button |> toSize
                , isLoading = False
                }
                { name = "Action"
                , icon = Button.NoIcon
                }
            , L.layout.spacerX 2
            , ThemeButton.view
                { onClick = noOp
                , disabled = False
                , borderRadius = theme.borderRadius.button |> toSizeBorder
                , theme = theme
                , colors = toColors
                , typography = theme.typography.button |> toSize
                , isLoading = False
                }
                { name = "Action"
                , icon = Button.LeftIcon (Icons.view Icons.Download 18)
                }
            , L.layout.spacerX 2
            , ThemeButton.view
                { onClick = noOp
                , disabled = False
                , borderRadius = theme.borderRadius.button |> toSizeBorder
                , theme = theme
                , colors = toColors
                , typography = theme.typography.button |> toSize
                , isLoading = False
                }
                { name = ""
                , icon = Button.RightIcon (Icons.view Icons.Download 18)
                }
            , L.layout.spacerX 2
            , ThemeButton.view
                { onClick = noOp
                , disabled = False
                , borderRadius = theme.borderRadius.button |> toSizeBorder
                , theme = theme
                , colors = toColors
                , typography = theme.typography.button |> toSize
                , isLoading = True
                }
                { name = "Loading"
                , icon = Button.RightIcon (Icons.view Icons.Download 18)
                }
            ]
        , L.layout.spacerY 2
        , L.viewRow L.Normal
            []
            [ ThemeButton.view
                { onClick = noOp
                , disabled = True
                , borderRadius = theme.borderRadius.button |> toSizeBorder
                , theme = theme
                , colors = toColors
                , typography = theme.typography.button |> toSize
                , isLoading = False
                }
                { name = "Disabled"
                , icon = Button.RightIcon (Icons.view Icons.Download 18)
                }
            , L.layout.spacerX 2
            , ThemeButton.view
                { onClick = noOp
                , disabled = True
                , borderRadius = theme.borderRadius.button |> toSizeBorder
                , theme = theme
                , colors = toColors
                , typography = theme.typography.button |> toSize
                , isLoading = False
                }
                { name = "Disabled"
                , icon = Button.NoIcon
                }
            , L.layout.spacerX 2
            , ThemeButton.view
                { onClick = noOp
                , disabled = True
                , borderRadius = theme.borderRadius.button |> toSizeBorder
                , theme = theme
                , colors = toColors
                , typography = theme.typography.button |> toSize
                , isLoading = False
                }
                { name = "Disabled"
                , icon = Button.LeftIcon (Icons.view Icons.Download 18)
                }
            , L.layout.spacerX 2
            , ThemeButton.view
                { onClick = noOp
                , disabled = True
                , borderRadius = theme.borderRadius.button |> toSizeBorder
                , theme = theme
                , colors = toColors
                , typography = theme.typography.button |> toSize
                , isLoading = False
                }
                { name = ""
                , icon = Button.RightIcon (Icons.view Icons.Download 18)
                }
            ]
        ]
