module Example.View.Form.Field.Switch exposing (..)

import Elemental.Css.BorderRadius as BorderRadius
import Elemental.Layout as L
import Elemental.View.Form.Field.Switch as Switch exposing (Options)
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)


toOptions :
    { theme : Theme.Theme
    , layout : L.Layout msg
    , text : String
    , disabled : Bool
    , size : Switch.Size
    , spacerMultiples :
        { y : Switch.Size -> Float
        , text : Switch.Size -> Float
        }
    , onToggle : Bool -> msg
    }
    -> Options msg
toOptions options =
    let
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
    { theme = widgetTheme
    , layout = options.layout
    , text = options.text
    , disabled = options.disabled
    , size = options.size
    , onToggle = options.onToggle
    }
