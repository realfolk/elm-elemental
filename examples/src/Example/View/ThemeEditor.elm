module Example.View.ThemeEditor exposing (..)

import Css
import Elemental.Css.BorderRadius as BorderRadius
import Elemental.Form.Field.Select as Select
import Elemental.Form.Field.Switch as Switch
import Elemental.Form.Validate as V
import Elemental.Layout as L
import Elemental.Typography as Typography exposing (Typography)
import Elemental.View.Form.Field as Support
import Elemental.View.Form.Field.Input as Input
import Elemental.View.Form.Field.Switch as Switch
import Example.Colors as Colors
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)
import Example.Typography as Typography exposing (ThemeTypography)
import Example.View.Codeblock as Codeblock
import Example.Form.Field.Select as Select
import Example.View.Form.Field.Switch as Switch
import Html.Styled as H
import Html.Styled.Attributes as HA



-- MODEL


type alias Model =
    {}



-- VIEW


type alias Options msg =
    { theme : Theme
    , onUpdateTheme : Theme -> msg
    }


view : Options msg -> H.Html msg
view { theme, onUpdateTheme } =
    L.viewColumn L.Normal
        []
        []
