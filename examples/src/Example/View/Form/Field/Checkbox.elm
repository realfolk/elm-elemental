module Example.View.Form.Field.Checkbox exposing (..)

import Elemental.Css.BorderRadius as BorderRadius
import Elemental.Layout as L
import Elemental.View.Form.Field.Checkbox as Checkbox exposing (Options)
import Example.Icons as Icons
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)


toOptions :
    { theme : Theme.Theme
    , layout : L.Layout msg
    , text : String
    , disabled : Bool
    , size : Checkbox.Size
    , spacerMultiples :
        { y : Checkbox.Size -> Float
        , text : Checkbox.Size -> Float
        }
    , onToggle : Bool -> msg
    }
    -> Options msg
toOptions options =
    let
        checkboxColors =
            options.theme.colors.checkbox

        widgetTheme =
            { colors =
                { background =
                    { disabled = checkboxColors.background.disabled
                    , checked = checkboxColors.background.checked
                    , unchecked = checkboxColors.background.unchecked
                    }
                , border =
                    { disabled = checkboxColors.border.disabled
                    , checked = checkboxColors.border.checked
                    , unchecked = checkboxColors.border.unchecked
                    }
                , foreground =
                    { disabled = checkboxColors.foreground.disabled
                    , normal = checkboxColors.foreground.normal
                    }
                , label =
                    { disabled = checkboxColors.label.disabled
                    , normal = checkboxColors.label.normal
                    }
                }
            , typography =
                { label = options.theme.typography.form.field.label
                }
            , transitionDuration = 400
            , spacerMultiples =
                { y = options.spacerMultiples.y
                , text = options.spacerMultiples.text
                }
            }
    in
    { theme = widgetTheme
    , layout = options.layout
    , text = options.text
    , disabled = options.disabled
    , size = options.size
    , onToggle = options.onToggle
    , icon =
        \size _ ->
            case size of
                Checkbox.Small ->
                    Icons.view Icons.Check 20

                Checkbox.Medium ->
                    Icons.view Icons.Check 24
    , maybeOnInteraction = Nothing
    }
