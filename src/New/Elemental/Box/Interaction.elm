module New.Elemental.Box.Interaction exposing
    ( Interaction
    , onBlur, onCheck, onClick, onDoubleClick, onFocus, onInput, onMouseDown, onMouseEnter, onMouseLeave, onMouseOut, onMouseOver, onMouseUp, onSubmit, onTouchEnd, onTouchMove, onTouchStart
    , toHtmlAttribute
    )

{-| This library exports an Interaction type and a set of functions to manage interactions.


# Definition

@docs Interaction


# Constructors

@docs onBlur, onCheck, onClick, onDoubleClick, onFocus, onInput, onMouseDown, onMouseEnter, onMouseLeave, onMouseOut, onMouseOver, onMouseUp, onSubmit, onTouchEnd, onTouchMove, onTouchStart


# Converters

@docs toHtmlAttribute

-}

import Html.Styled as Html
import Html.Styled.Events as Html
import Json.Decode as Decode


{-| Represents an Interaction to listen for. An Interaction may have an `input` and produces a `msg`.
-}



{--type Interaction msg
    = Click msg
    | DoubleClick msg
    | MouseEnter msg
    | MouseLeave msg
    | MouseOver msg
    | MouseOut msg
    | MouseDown msg
    | MouseUp msg
    | TouchStart msg
    | TouchEnd msg
    | TouchMove msg
    | Focus msg
    | Blur msg
    | Input (String -> msg)
    | Check (Bool -> msg)
    | Submit msg--}


type alias Interaction msg =
    { click : Maybe msg
    , doubleClick : Maybe msg
    , mouseEnter : Maybe msg
    , mouseLeave : Maybe msg
    , mouseOver : Maybe msg
    , mouseOut : Maybe msg
    , mouseDown : Maybe msg
    , mouseUp : Maybe msg
    , touchStart : Maybe msg
    , touchEnd : Maybe msg
    , touchMove : Maybe msg
    , focus : Maybe msg
    , blur : Maybe msg
    , input : Maybe (String -> msg)
    , check : Maybe (Bool -> msg)
    , submit : Maybe msg
    }


{-| An `Interaction` that does nothing.
-}
none : Interaction msg
none =
    { click = Nothing
    , doubleClick = Nothing
    , mouseEnter = Nothing
    , mouseLeave = Nothing
    , mouseOver = Nothing
    , mouseOut = Nothing
    , mouseDown = Nothing
    , mouseUp = Nothing
    , touchStart = Nothing
    , touchEnd = Nothing
    , touchMove = Nothing
    , focus = Nothing
    , blur = Nothing
    , input = Nothing
    , check = Nothing
    , submit = Nothing
    }


{-| Emit a `msg` on "click" interactions.
-}
onClick : msg -> Interaction msg
onClick msg =
    { none | click = Just msg }


{-| Cancel listening for "click" interactions.
-}
cancelClick : Interaction msg -> Interaction msg
cancelClick interaction =
    { interaction | click = Nothing }


{-| Listen for "doubleclick" interactions.
-}
onDoubleClick : msg -> Interaction msg
onDoubleClick msg =
    { none | doubleClick = Just msg }


{-| Listen for "mouseenter" interactions.
-}
onMouseEnter : msg -> Interaction msg
onMouseEnter =
    MouseEnter


{-| Listen for "mouseleave" interactions.
-}
onMouseLeave : msg -> Interaction msg
onMouseLeave =
    MouseLeave


{-| Listen for "mouseover" interactions.
-}
onMouseOver : msg -> Interaction msg
onMouseOver =
    MouseOver


{-| Listen for "mouseout" interactions.
-}
onMouseOut : msg -> Interaction msg
onMouseOut =
    MouseOut


{-| Listen for "mousedown" interactions.
-}
onMouseDown : msg -> Interaction msg
onMouseDown =
    MouseDown


{-| Listen for "mouseup" interactions.
-}
onMouseUp : msg -> Interaction msg
onMouseUp =
    MouseUp


{-| Listen for "touchstart" interactions.
-}
onTouchStart : msg -> Interaction msg
onTouchStart =
    TouchStart


{-| Listen for "touchend" interactions.
-}
onTouchEnd : msg -> Interaction msg
onTouchEnd =
    TouchEnd


{-| Listen for "touchmove" interactions.
-}
onTouchMove : msg -> Interaction msg
onTouchMove =
    TouchMove


{-| Listen for "focus" interactions.
-}
onFocus : msg -> Interaction msg
onFocus =
    Focus


{-| Listen for "blur" interactions.
-}
onBlur : msg -> Interaction msg
onBlur =
    Blur


{-| Listen for String input interactions. You will normally use `onInput` functions
exported by individual view or component modules instead of using this function directly.
-}
onInput : (String -> msg) -> Interaction msg
onInput =
    Input


{-| Listen for checkbox interactions.
-}
onCheck : (Bool -> msg) -> Interaction msg
onCheck =
    Check


{-| Listen for form submission interactions.
-}
onSubmit : msg -> Interaction msg
onSubmit =
    Submit


{-| Combine two `Interaction`s, preferring the first over the second.
-}
and : Interaction msg -> Interaction msg -> Interaction msg
and a b =
    let
        -- Prefer maybeA over maybeB
        or maybeA maybeB =
            Maybe.map Just maybeA
                |> Maybe.withDefault maybeB
    in
    { click = or a.click b.click
    , doubleClick = or a.doubleClick b.doubleClick
    , mouseEnter = or a.mouseEnter b.mouseEnter
    , mouseLeave = or a.mouseLeave b.mouseLeave
    , mouseOver = or a.mouseOver b.mouseOver
    , mouseOut = or a.mouseOut b.mouseOut
    , mouseDown = or a.mouseDown b.mouseDown
    , mouseUp = or a.mouseUp b.mouseUp
    , touchStart = or a.touchStart b.touchStart
    , touchEnd = or a.touchEnd b.touchEnd
    , touchMove = or a.touchMove b.touchMove
    , focus = or a.focus b.focus
    , blur = or a.blur b.blur
    , input = or a.input b.input
    , check = or a.check b.check
    , submit = or a.submit b.submit
    }


{-| Converts an Interaction into an Html.Styled.Attribute.
-}
toHtmlAttribute : Interaction msg -> Html.Attribute msg
toHtmlAttribute interaction =
    case interaction of
        Click msg ->
            Html.onClick msg

        DoubleClick msg ->
            Html.onDoubleClick msg

        MouseEnter msg ->
            Html.onMouseEnter msg

        MouseLeave msg ->
            Html.onMouseLeave msg

        MouseOver msg ->
            Html.onMouseOver msg

        MouseOut msg ->
            Html.onMouseOut msg

        MouseDown msg ->
            Html.onMouseDown msg

        MouseUp msg ->
            Html.onMouseUp msg

        TouchStart msg ->
            Html.on "touchstart" (Decode.succeed msg)

        TouchEnd msg ->
            Html.on "touchend" (Decode.succeed msg)

        TouchMove msg ->
            Html.on "touchmove" (Decode.succeed msg)

        Focus msg ->
            Html.onFocus msg

        Blur msg ->
            Html.onBlur msg

        Input toMsg ->
            Html.onInput toMsg

        Check toMsg ->
            Html.onCheck toMsg

        Submit msg ->
            Html.onSubmit msg
