module Example.Form.Field.Switch exposing (..)

import Elemental.Form.Field.Switch as Field exposing (Msg_)
import Elemental.View.Form.Field exposing (Support)
import Elemental.View.Form.Field.Switch as Switch
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)


toOptions :
    { theme : Theme
    , disabled : Bool
    , size : Switch.Size
    , label : String
    , switchText : String
    , support : Support Msg_
    , required : Bool
    , spacerMultiples :
        { y : Switch.Size -> Float
        , text : Switch.Size -> Float
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

        switchColors =
            options.theme.colors.switch

        widgetTheme =
            { colors =
                { background =
                    { disabled = switchColors.background.disabled
                    , off = switchColors.background.off
                    , on = switchColors.background.on
                    }
                , border =
                    { disabled = switchColors.border.disabled
                    , off = switchColors.border.off
                    , on = switchColors.border.on
                    }
                , foreground =
                    { enabled = options.theme.colors.foreground.regular
                    , disabled = options.theme.colors.foreground.soft
                    }
                , handle =
                    { background =
                        { disabled = switchColors.handle.background.disabled
                        , off = switchColors.handle.background.off
                        , on = switchColors.handle.background.on
                        }
                    , border =
                        { disabled = switchColors.handle.border.disabled
                        , off = switchColors.handle.border.off
                        , on = switchColors.handle.border.on
                        }
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
    , switchText = options.switchText
    , support = options.support
    , required = options.required
    }
