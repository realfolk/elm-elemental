module New.Elemental.Box.Style exposing (Style)


type alias Style =
    { position : Maybe Position
    , background : Maybe Background
    , typography : Maybe Typography
    , textColor : Maybe Color
    , cursor : Maybe Cursor
    }
