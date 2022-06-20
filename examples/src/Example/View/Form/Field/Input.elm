module Example.View.Form.Field.Input exposing (..)

import Elemental.View.Form.Field as Field exposing (Support)
import Elemental.View.Form.Field.Input as Input
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)
import Html.Styled as H


toOptions :
    { theme : Theme
    , type_ : Input.Type
    , disabled : Bool
    , placeholder : String
    , autofocus : Bool
    , icon : Maybe (H.Html msg)
    , onInput : String -> msg
    , customAttrs : List (H.Attribute msg)
    }
    -> Input.Options msg
toOptions options =
    let
        formColors =
            options.theme.colors.form

        fieldColors =
            formColors.field

        fieldTypography =
            options.theme.typography.form.field
    in
    { theme =
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
            { x = always 4
            , y = always 2
            }
        }
    , layout = L.layout
    , type_ = options.type_
    , size = Input.Medium
    , icon = options.icon
    , placeholder = options.placeholder
    , autofocus = options.autofocus
    , disabled = options.disabled
    , error = False
    , onInput = options.onInput
    , customAttrs = options.customAttrs
    }
