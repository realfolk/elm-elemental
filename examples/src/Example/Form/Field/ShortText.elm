module Example.Form.Field.ShortText exposing (..)

import Css
import Elemental.Form.Field.ShortText as ShortText
import Elemental.View.Form.Field as Field exposing (Support)
import Elemental.View.Form.Field.Input as Input
import Example.Icons as Icons
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)
import Html.Styled as H
import Html.Styled.Attributes as HA


toOptions :
    { theme : Theme
    , type_ : Input.Type
    , label : String
    , support : Field.Support ShortText.Msg_
    , required : Bool
    , disabled : Bool
    , placeholder : String
    , autofocus : Bool
    , icon : Maybe (H.Html ShortText.Msg_)
    }
    -> ShortText.Options
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
            { x = always 4
            , y = always 2
            }
        }
    , layout = L.layout
    , type_ = options.type_
    , size = Input.Medium
    , icon = options.icon
    , label = options.label
    , support = options.support
    , required = options.required
    , disabled = options.disabled
    , placeholder = options.placeholder
    , autofocus = options.autofocus
    , maybeToErrorIcon =
        Just <|
            \color ->
                H.div [ HA.css [ Css.color color, Css.displayFlex ] ]
                    [ Icons.view Icons.WarningTriangle 18
                    ]
    , customAttrs = []
    }
