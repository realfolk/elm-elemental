module Example.Colors exposing (Colors, adventureColors, baseColors, elegantColors, partyColors)

import Css exposing (rgb, rgba)
import Elemental.View.Button as Button


type alias Colors =
    { background :
        { normal : Css.Color
        , alternate : Css.Color
        , code : Css.Color
        }
    , border : Css.Color
    , button :
        { primary : Button.Colors
        , secondary : Button.Colors
        }
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
    , button =
        { primary =
            { background =
                { normal = Css.hex "#0b57d0"
                , disabled = Css.hex "#949494"
                , hover = Css.hex "#2c72e2"
                , pressed = Css.hex "#0249bb"
                }
            , foreground =
                { normal = white
                , disabled = white
                }
            , focus = Css.hex "#0b7bd0"
            }
        , secondary =
            { background =
                { normal = Css.hex "#7d0d64"
                , disabled = Css.hex "#949494"
                , hover = Css.hex "#b92d9a"
                , pressed = Css.hex "#600b4e"
                }
            , foreground =
                { normal = white
                , disabled = white
                }
            , focus = Css.hex "#ff85ef"
            }
        }
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


elegantColors : Colors
elegantColors =
    { background =
        { normal = white
        , alternate = elevated
        , code = Css.hex "2e3440"
        }
    , border = Css.hex "#3c539f"
    , button =
        { primary =
            { background =
                { normal = Css.hex "#004f80"
                , disabled = Css.hex "#949494"
                , hover = Css.hex "#0869a6"
                , pressed = Css.hex "#043e62"
                }
            , foreground =
                { normal = white
                , disabled = white
                }
            , focus = Css.hex "#0b7bd0"
            }
        , secondary =
            { background =
                { normal = Css.hex "#0d7d57"
                , disabled = Css.hex "#949494"
                , hover = Css.hex "#06ac75"
                , pressed = Css.hex "#0c694a"
                }
            , foreground =
                { normal = white
                , disabled = white
                }
            , focus = Css.hex "#338e70"
            }
        }
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
            { disabled = Css.hex "#709fbd"
            , on = Css.hex "#004f80"
            , off = Css.hex "#dfe4d6"
            }
        , border =
            { disabled = Css.hex "#575757"
            , on = Css.hex "#004f80"
            , off = Css.hex "#74796e"
            }
        , handle =
            { background =
                { disabled = Css.hex "#3f5b88"
                , on = Css.hex "#ffffff"
                , off = Css.hex "#74796e"
                }
            , border =
                { disabled = Css.hex "#3f5b88"
                , on = Css.hex "#ffffff"
                , off = Css.hex "#dfe4d6"
                }
            }
        }
    }


partyColors : Colors
partyColors =
    { background =
        { normal = Css.hex "#ffffff"
        , alternate = Css.hex "#adffd5"
        , code = Css.hex "#2e3440"
        }
    , border = Css.hex "#1adb40"
    , button =
        { primary =
            { background =
                { normal = Css.hex "#4dd0e1"
                , disabled = Css.hex "#949494"
                , hover = Css.hex "#57e0ff"
                , pressed = Css.hex "#3ba0ae"
                }
            , foreground =
                { normal = Css.hex "#000000"
                , disabled = Css.hex "#ffffff"
                }
            , focus = Css.hex "#0b7bd0"
            }
        , secondary =
            { background =
                { normal = Css.hex "#ffab40"
                , disabled = Css.hex "#cc8833"
                , hover = Css.hex "#efb462"
                , pressed = Css.hex "#ff9f1a"
                }
            , foreground =
                { normal = Css.hex "#000000"
                , disabled = Css.hex "#ffffff"
                }
            , focus = Css.hex "#ffcd1a"
            }
        }
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
            { disabled = Css.hex "#4fd86b"
            , on = Css.hex "#1adb40"
            , off = Css.hex "#dfe4d6"
            }
        , border =
            { disabled = Css.hex "#ffffff"
            , on = Css.hex "#1ad940"
            , off = Css.hex "#74796e"
            }
        , handle =
            { background =
                { disabled = Css.hex "#0ca12a"
                , on = Css.hex "#363636"
                , off = Css.hex "#74796e"
                }
            , border =
                { disabled = Css.hex "#ebebeb"
                , on = Css.hex "#ffffff"
                , off = Css.hex "#dfe4d6"
                }
            }
        }
    }


adventureColors : Colors
adventureColors =
    { background =
        { normal = Css.hex "#ffe7e0"
        , alternate = Css.hex "#ffa18a"
        , code = Css.hex "#2e3440"
        }
    , border = Css.hex "#c37480"
    , button =
        { primary =
            { background =
                { normal = Css.hex "#bb0d27"
                , disabled = Css.hex "#949494"
                , hover = Css.hex "#e31635"
                , pressed = Css.hex "#910d21"
                }
            , foreground =
                { normal = white
                , disabled = white
                }
            , focus = Css.hex "#aa5a66"
            }
        , secondary =
            { background =
                { normal = Css.hex "#f26440"
                , disabled = Css.hex "#949494"
                , hover = Css.hex "#f26440"
                , pressed = Css.hex "#d13b1a"
                }
            , foreground =
                { normal = white
                , disabled = white
                }
            , focus = Css.hex "#ff3300"
            }
        }
    , foreground =
        { regular = rgb 0x00 0x00 0x00
        , soft = Css.hex "#616161"
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
            { disabled = Css.hex "#eab6a9"
            , on = Css.hex "#f26440"
            , off = Css.hex "#dfe4d6"
            }
        , border =
            { disabled = Css.hex "#ffffff"
            , on = Css.hex "#762c19"
            , off = Css.hex "#74796e"
            }
        , handle =
            { background =
                { disabled = Css.hex "#bb9186"
                , on = Css.hex "#ffffff"
                , off = Css.hex "#74796e"
                }
            , border =
                { disabled = Css.hex "#ffffff"
                , on = Css.hex "#ffffff"
                , off = Css.hex "#dfe4d6"
                }
            }
        }
    }



-- HELPERS


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
