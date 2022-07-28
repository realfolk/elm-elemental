module New.Elemental.Box.Style.Cursor exposing
    ( Axis(..)
    , Cursor(..)
    , Direction(..)
    , toCssStyle
    )

import Css


type Cursor
    = None
    | Default
    | Pointer
    | NotAllowed
    | Grab
    | Grabbing
    | Resize Axis
    | Zoom Direction


toCssStyle : Cursor -> Css.Style
toCssStyle cursor =
    case cursor of
        None ->
            Css.cursor Css.none

        Default ->
            Css.cursor Css.default

        Pointer ->
            Css.cursor Css.pointer

        NotAllowed ->
            Css.cursor Css.notAllowed

        Grab ->
            Css.cursor Css.grab

        Grabbing ->
            Css.cursor Css.grabbing

        Resize X ->
            Css.cursor Css.colResize

        Resize Y ->
            Css.cursor Css.rowResize

        Zoom In ->
            Css.cursor Css.zoomIn

        Zoom Out ->
            Css.cursor Css.zoomOut


type Axis
    = X
    | Y


type Direction
    = In
    | Out
