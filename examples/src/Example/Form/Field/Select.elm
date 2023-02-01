module Example.Form.Field.Select exposing (..)

import Css
import Elemental.Form.Field.Select as Select
import Elemental.Layout as L
import Elemental.View.Form.Field as Field
import Elemental.View.Form.Field.Select as SelectView
import Example.Icons as Icons
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)
import Html.Styled as H
import Html.Styled.Attributes as HA


toOptions :
    { theme : Theme
    , autofocus : Bool
    , choices : List choice
    , toSelectChoice : choice -> SelectView.Choice value
    , label : String
    , required : Bool
    , disabled : Bool
    , support : Field.Support (Select.Msg_ value)
    }
    -> Select.Options value
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
            { y = 2
            , x = 2
            , caret = 2
            }
        , borderRadius = options.theme.borderRadius.global.small.all
        }
    , autofocus = options.autofocus
    , viewCaret =
        if options.disabled then
            SelectView.viewDefaultCaret fieldColors.foreground.disabled

        else
            SelectView.viewDefaultCaret fieldColors.caret
    , choices = List.map options.toSelectChoice options.choices
    , layout = L.layout
    , label = options.label
    , required = options.required
    , disabled = options.disabled
    , support = options.support
    , maybeToErrorIcon =
        Just <|
            \color ->
                H.div [ HA.css [ Css.color color, Css.displayFlex ] ]
                    [ Icons.view Icons.WarningTriangle 18
                    ]
    , userInteractions = []
    }
