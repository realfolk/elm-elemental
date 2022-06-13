module Example.View.Codeblock exposing (..)

import Css
import Elemental.Css.BorderRadius as BorderRadius
import Elemental.Layout as L
import Elemental.Typography as Typography exposing (Typography)
import Example.Colors as Colors exposing (Colors)
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)
import Example.Typography as Typography exposing (ThemeTypography)
import Html.Styled as H


view : Theme -> List (H.Html msg) -> H.Html msg
view theme lines =
    L.viewColumn L.Normal
        [ Css.width <| Css.pct 100
        , Css.backgroundColor theme.colors.background.code
        , BorderRadius.toCssStyle theme.borderRadius.global.small.all
        , Css.color theme.colors.foreground.code
        , Css.padding2 (Css.px 12) (Css.px 24)
        , Typography.toStyle theme.typography.code
        ]
        lines


customView1 : Theme -> List (H.Html msg) -> H.Html msg
customView1 theme lines =
    L.viewColumn L.Normal
        [ Css.width <| Css.pct 100
        , Css.backgroundColor theme.colors.background.code
        , BorderRadius.toCssStyle theme.borderRadius.global.small.all
        , Css.color theme.colors.foreground.code
        , Typography.toStyle theme.typography.code
        ]
        lines
