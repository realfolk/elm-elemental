module New.Elemental.Box.Interaction exposing
    ( Interaction
    , none, onBlur, onCheck, onClick, onDoubleClick, onFocus, onInput, onMouseDown, onMouseEnter, onMouseLeave, onMouseOut, onMouseOver, onMouseUp, onSubmit, onTouchEnd, onTouchMove, onTouchStart
    , cancelBlur, cancelCheck, cancelClick, cancelDoubleClick, cancelFocus, cancelInput, cancelMouseDown, cancelMouseEnter, cancelMouseLeave, cancelMouseOut, cancelMouseOver, cancelMouseUp, cancelSubmit, cancelTouchEnd, cancelTouchMove, cancelTouchStart
    , and
    , toHtmlAttributes
    )

{-| This library exports an Interaction type and a set of functions to manage interactions.


# Definition

@docs Interaction


# Constructors

@docs none, onBlur, onCheck, onClick, onDoubleClick, onFocus, onInput, onMouseDown, onMouseEnter, onMouseLeave, onMouseOut, onMouseOver, onMouseUp, onSubmit, onTouchEnd, onTouchMove, onTouchStart


# Cancellation

Use these functions if you want to cancel listening for a particular event on an `Interaction`.

@docs cancelBlur, cancelCheck, cancelClick, cancelDoubleClick, cancelFocus, cancelInput, cancelMouseDown, cancelMouseEnter, cancelMouseLeave, cancelMouseOut, cancelMouseOver, cancelMouseUp, cancelSubmit, cancelTouchEnd, cancelTouchMove, cancelTouchStart


# Combinators

@docs and


# Converters

@docs toHtmlAttributes

-}

import Html.Styled as Html
import Html.Styled.Events as Html
import Json.Decode as Decode


{-| Represents an Interaction to listen for. An Interaction may have an `input` and produces a `msg`.
-}
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


{-| Emit a `msg` on `click` events.
-}
onClick : msg -> Interaction msg
onClick msg =
    { none | click = Just msg }


{-| Listen for `dblclick` events.
-}
onDoubleClick : msg -> Interaction msg
onDoubleClick msg =
    { none | doubleClick = Just msg }


{-| Listen for `mouseenter` events.
-}
onMouseEnter : msg -> Interaction msg
onMouseEnter msg =
    { none | mouseEnter = Just msg }


{-| Listen for `mouseleave` events.
-}
onMouseLeave : msg -> Interaction msg
onMouseLeave msg =
    { none | mouseLeave = Just msg }


{-| Listen for `mouseover` events.
-}
onMouseOver : msg -> Interaction msg
onMouseOver msg =
    { none | mouseOver = Just msg }


{-| Listen for `mouseout` events.
-}
onMouseOut : msg -> Interaction msg
onMouseOut msg =
    { none | mouseOut = Just msg }


{-| Listen for `mousedown` events.
-}
onMouseDown : msg -> Interaction msg
onMouseDown msg =
    { none | mouseDown = Just msg }


{-| Listen for `mouseup` events.
-}
onMouseUp : msg -> Interaction msg
onMouseUp msg =
    { none | mouseUp = Just msg }


{-| Listen for `touchstart` events.
-}
onTouchStart : msg -> Interaction msg
onTouchStart msg =
    { none | touchStart = Just msg }


{-| Listen for `touchend` events.
-}
onTouchEnd : msg -> Interaction msg
onTouchEnd msg =
    { none | touchEnd = Just msg }


{-| Listen for `touchmove` events.
-}
onTouchMove : msg -> Interaction msg
onTouchMove msg =
    { none | touchMove = Just msg }


{-| Listen for `focus` events.
-}
onFocus : msg -> Interaction msg
onFocus msg =
    { none | focus = Just msg }


{-| Listen for `blur` events.
-}
onBlur : msg -> Interaction msg
onBlur msg =
    { none | blur = Just msg }


{-| Listen for `String` input interactions. You will normally use `onInput` functions
exported by individual view or component modules instead of using this function directly.
-}
onInput : (String -> msg) -> Interaction msg
onInput toMsg =
    { none | input = Just toMsg }


{-| Listen for checkbox toggle events.
-}
onCheck : (Bool -> msg) -> Interaction msg
onCheck toMsg =
    { none | check = Just toMsg }


{-| Listen for form submission events.
-}
onSubmit : msg -> Interaction msg
onSubmit toMsg =
    { none | submit = Just toMsg }


{-| Cancel listening for `click` events.
-}
cancelClick : Interaction msg -> Interaction msg
cancelClick interaction =
    { interaction | click = Nothing }


{-| Cancel listening for `dblclick` events.
-}
cancelDoubleClick : Interaction msg -> Interaction msg
cancelDoubleClick interaction =
    { interaction | doubleClick = Nothing }


{-| Cancel listening for `mouseenter` events.
-}
cancelMouseEnter : Interaction msg -> Interaction msg
cancelMouseEnter interaction =
    { interaction | mouseEnter = Nothing }


{-| Cancel listening for `mouseleave` events.
-}
cancelMouseLeave : Interaction msg -> Interaction msg
cancelMouseLeave interaction =
    { interaction | mouseLeave = Nothing }


{-| Cancel listening for `mouseover` events.
-}
cancelMouseOver : Interaction msg -> Interaction msg
cancelMouseOver interaction =
    { interaction | mouseOver = Nothing }


{-| Cancel listening for `mouseout` events.
-}
cancelMouseOut : Interaction msg -> Interaction msg
cancelMouseOut interaction =
    { interaction | mouseOut = Nothing }


{-| Cancel listening for `mousedown` events.
-}
cancelMouseDown : Interaction msg -> Interaction msg
cancelMouseDown interaction =
    { interaction | mouseDown = Nothing }


{-| Cancel listening for `mouseup` events.
-}
cancelMouseUp : Interaction msg -> Interaction msg
cancelMouseUp interaction =
    { interaction | mouseUp = Nothing }


{-| Cancel listening for `touchstart` events.
-}
cancelTouchStart : Interaction msg -> Interaction msg
cancelTouchStart interaction =
    { interaction | touchStart = Nothing }


{-| Cancel listening for `touchend` events.
-}
cancelTouchEnd : Interaction msg -> Interaction msg
cancelTouchEnd interaction =
    { interaction | touchEnd = Nothing }


{-| Cancel listening for `touchmove` events.
-}
cancelTouchMove : Interaction msg -> Interaction msg
cancelTouchMove interaction =
    { interaction | touchMove = Nothing }


{-| Cancel listening for `focus` events.
-}
cancelFocus : Interaction msg -> Interaction msg
cancelFocus interaction =
    { interaction | focus = Nothing }


{-| Cancel listening for `blur` events.
-}
cancelBlur : Interaction msg -> Interaction msg
cancelBlur interaction =
    { interaction | blur = Nothing }


{-| Cancel listening for `String` input events.
-}
cancelInput : Interaction msg -> Interaction msg
cancelInput interaction =
    { interaction | input = Nothing }


{-| Cancel listening for checkbox toggle events.
-}
cancelCheck : Interaction msg -> Interaction msg
cancelCheck interaction =
    { interaction | check = Nothing }


{-| Cancel listening for form submission events.
-}
cancelSubmit : Interaction msg -> Interaction msg
cancelSubmit interaction =
    { interaction | submit = Nothing }


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


{-| Converts an Interaction into a `List (Html.Styled.Attribute msg)`.
-}
toHtmlAttributes : Interaction msg -> List (Html.Attribute msg)
toHtmlAttributes interaction =
    let
        customEvent name =
            Decode.succeed >> Html.on name
    in
    List.filterMap identity
        [ Maybe.map Html.onClick interaction.click
        , Maybe.map Html.onDoubleClick interaction.doubleClick
        , Maybe.map Html.onMouseEnter interaction.mouseEnter
        , Maybe.map Html.onMouseLeave interaction.mouseLeave
        , Maybe.map Html.onMouseOver interaction.mouseOver
        , Maybe.map Html.onMouseOut interaction.mouseOut
        , Maybe.map Html.onMouseDown interaction.mouseDown
        , Maybe.map Html.onMouseUp interaction.mouseUp
        , Maybe.map (customEvent "touchstart") interaction.touchStart
        , Maybe.map (customEvent "touchend") interaction.touchEnd
        , Maybe.map (customEvent "touchmove") interaction.touchMove
        , Maybe.map Html.onFocus interaction.focus
        , Maybe.map Html.onBlur interaction.blur
        , Maybe.map Html.onInput interaction.input
        , Maybe.map Html.onCheck interaction.check
        , Maybe.map Html.onSubmit interaction.submit
        ]
