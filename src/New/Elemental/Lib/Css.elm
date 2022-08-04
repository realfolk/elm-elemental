module New.Elemental.Lib.Css exposing (maybe)

import Css


maybe : Maybe Css.Style -> Css.Style
maybe =
    Maybe.withDefault (Css.batch [])
