module Example.View.Form.Field.Select exposing (..)

import Elemental.Css.BorderRadius as BorderRadius
import Elemental.Form.Field.Select as Select
import Elemental.View.Form.Field as Field
import Elemental.View.Form.Field.Select as SelectView
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)


toOptions options =
    let
        formColors =
            options.theme.colors.form

        fieldColors =
            formColors.field

        fieldTypography =
            options.theme.typography.form.field
    in
    { fieldTheme =
        { colors =
            { error = formColors.error
            , required = fieldColors.required
            , support = fieldColors.supportText
            }
        , typography =
            { label = fieldTypography.label
            , support = fieldTypography.support
            }
        }
    , widgetTheme =
        { colors =
            { background =
                { disabled = fieldColors.background.disabled
                , normal = fieldColors.background.normal
                }
            , border = fieldColors.border
            , focusHighlight = fieldColors.focusHighlight
            , foreground = fieldColors.foreground
            }
        , spacerMultiples =
            { y = 3
            , x = 4
            , caret = 2
            }
        , borderRadius =
            BorderRadius.borderRadius 4
                |> .all
        }
    , autofocus = options.autofocus
    , viewCaret =
        if options.disabled then
            SelectView.viewDefaultCaret fieldColors.foreground.disabled

        else
            SelectView.viewDefaultCaret fieldColors.foreground.value
    , choices = List.map options.toSelectChoice options.choices
    , layout = L.layout
    , label = options.label
    , required = options.required
    , disabled = options.disabled
    , support = options.support
    }
