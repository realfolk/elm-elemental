module New.Elemental.Box.Style.Text.Wrap exposing
    ( Preservation(..)
    , TextWrap(..)
    , toCssStyle
    )

import Css


type TextWrap
    = Wrap
    | NoWrap
    | PreserveWhiteSpace Preservation


toCssStyle : TextWrap -> Css.Style
toCssStyle textWrap =
    case textWrap of
        Wrap ->
            Css.whiteSpace Css.normal

        NoWrap ->
            Css.whiteSpace Css.noWrap

        PreserveWhiteSpace All ->
            Css.whiteSpace Css.pre

        PreserveWhiteSpace AllAndSoftWrap ->
            Css.whiteSpace Css.preWrap

        PreserveWhiteSpace NewLines ->
            Css.whiteSpace Css.preLine


type Preservation
    = All
    | AllAndSoftWrap
    | NewLines
