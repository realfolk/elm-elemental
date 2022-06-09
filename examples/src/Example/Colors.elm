module Example.Colors exposing (Colors, baseColors)

import Css exposing (rgb, rgba)


type alias Colors =
    { background :
        { normal : Css.Color
        , alternate : Css.Color
        , code : Css.Color
        }
    , border : Css.Color
    , foreground :
        { regular : Css.Color
        , soft : Css.Color
        , code : Css.Color
        }
    , form :
        { error : Css.Color
        , field :
            { background :
                { disabled : Css.Color
                , focus : Css.Color
                , normal : Css.Color
                }
            , border :
                { error : Css.Color
                , focus : Css.Color
                , normal : Css.Color
                }
            , caret : Css.Color
            , focusHighlight : { error : Css.Color, normal : Css.Color }
            , foreground :
                { disabled : Css.Color
                , placeholder : Css.Color
                , value : Css.Color
                }
            , label : Css.Color
            , required : Css.Color
            , supportText : Css.Color
            }
        }
    , switch :
        { background :
            { disabled : Css.Color
            , off : Css.Color
            , on : Css.Color
            }
        , border : { disabled : Css.Color, off : Css.Color, on : Css.Color }
        , handle :
            { background :
                { disabled : Css.Color, off : Css.Color, on : Css.Color }
            , border :
                { disabled : Css.Color, off : Css.Color, on : Css.Color }
            }
        }
    }


baseColors : Colors
baseColors =
    { background =
        { normal = white
        , alternate = elevated
        , code = Css.hex "2e3440"
        }
    , border = border
    , foreground =
        { regular = rgb 0x00 0x00 0x00
        , soft = Css.hex "7d8493"
        , code = white
        }
    , form =
        { error = rgb 0xEE 0x34 0x34
        , field =
            { background =
                { disabled = rgb 0xEC 0xE5 0xCF
                , focus = rgb 0xFB 0xF9 0xF4
                , normal = white
                }
            , border =
                { error = rgb 0xEE 0x34 0x34
                , focus = rgb 0x34 0x91 0xEE
                , normal = border
                }
            , caret = rgb 0xCC 0xB9 0x7C
            , focusHighlight =
                { error = rgba 0xEE 0x34 0x34 0.4
                , normal = rgba 0x85 0xBD 0xF5 0.65
                }
            , foreground =
                { disabled = rgb 0x44 0x47 0x46
                , placeholder = rgb 0x78 0x7D 0x7B
                , value = rgb 0x00 0x00 0x00
                }
            , label = rgb 0x00 0x00 0x00
            , required = rgb 0xEE 0x91 0x34
            , supportText = rgb 0x44 0x47 0x46
            }
        }
    , switch =
        { background =
            { disabled = Css.hex "#4d91ff"
            , off = lightGray
            , on = blue
            }
        , border =
            { disabled = white
            , off = darkGray
            , on = blue
            }
        , handle =
            { background =
                { disabled = Css.hex "#8ab7ff"
                , off = darkGray
                , on = white
                }
            , border =
                { disabled = white
                , off = lightGray
                , on = white
                }
            }
        }
    }



--  table =
--         { highlight = rgb 0xEC 0xF5 0xFE
--         , red =
--             { background = rgb 0xFD 0xE7 0xE7
--             , foreground = rgb 0x86 0x0B 0x0B
--             }
--         , orange =
--             { background = rgb 0xFD 0xF2 0xE7
--             , foreground = rgb 0x86 0x49 0x0B
--             }
--         , purple =
--             { background = rgb 0xF2 0xE7 0xFD
--             , foreground = rgb 0x48 0x0B 0x86
--             }
--         , green =
--             { background = rgb 0xE5 0xFB 0xF5
--             , foreground = rgb 0x10 0x6E 0x56
--             }


white : Css.Color
white =
    Css.hex "ffffff"


darkGray =
    Css.hex "74796e"


lightGray =
    Css.hex "dfe4d6"


blue : Css.Color
blue =
    Css.hex "0b57d0"


darkBlue : Css.Color
darkBlue =
    Css.hex "253d88"


orange : Css.Color
orange =
    Css.hex "ec672c"


elevated : Css.Color
elevated =
    Css.hex "f1f1f3"


border : Css.Color
border =
    Css.hex "cfd5e8"
