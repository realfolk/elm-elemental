module Example.Form.Field.Checkbox exposing (..)

import Css
import Elemental.Form.Field.Checkbox as Field exposing (Msg_)
import Elemental.View.Form.Field exposing (Support)
import Elemental.View.Form.Field.Checkbox as Checkbox
import Example.Icons as Icons
import Example.Layout as L
import Example.Theme exposing (Theme)
import Html.Styled as H
import Html.Styled.Attributes as HA


toOptions :
    { theme : Theme
    , disabled : Bool
    , size : Checkbox.Size
    , label : String
    , checkboxText : String
    , support : Support Msg_
    , required : Bool
    , spacerMultiples :
        { y : Checkbox.Size -> Float
        , text : Checkbox.Size -> Float
        }
    }
    -> Field.Options
toOptions options =
    let
        formColors =
            options.theme.colors.form

        fieldColors =
            formColors.field

        fieldTypography =
            options.theme.typography.form.field

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
                    { normal = options.theme.colors.foreground.regular
                    , disabled = options.theme.colors.foreground.soft
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
    { widgetTheme = widgetTheme
    , disabled = options.disabled
    , size = options.size
    , fieldTheme =
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
    , layout = L.layout
    , label = options.label
    , checkboxText = options.checkboxText
    , support = options.support
    , required = options.required
    , icon =
        \size _ ->
            case size of
                Checkbox.Small ->
                    Icons.view Icons.Check 20

                Checkbox.Medium ->
                    Icons.view Icons.Check 24
    , maybeToErrorIcon =
        Just <|
            \color ->
                H.div [ HA.css [ Css.color color, Css.displayFlex ] ]
                    [ Icons.view Icons.WarningTriangle 18
                    ]
    , userInteractions = []
    }
