module Example.Form.Field.LongText exposing (..)

import Elemental.Form.Field.LongText as LongText
import Elemental.View.Form.Field as Field exposing (Support)
import Elemental.View.Form.Field.Input as Input
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)
import Html.Styled as H


toOptions :
    { theme : Theme
    , type_ : Input.Type
    , label : String
    , support : Field.Support LongText.Msg_
    , required : Bool
    , disabled : Bool
    , placeholder : String
    , autofocus : Bool
    }
    -> LongText.Options
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
        , borderRadius =
            options.theme.borderRadius.global.small.all
        , spacerMultiples =
            { x = 4
            , y = 2
            }
        }
    , height = 100
    , layout = L.layout
    , label = options.label
    , support = options.support
    , required = options.required
    , disabled = options.disabled
    , placeholder = options.placeholder
    }
