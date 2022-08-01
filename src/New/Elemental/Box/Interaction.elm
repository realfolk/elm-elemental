module New.Elemental.Box.Interaction exposing
    ( Interaction
    , none, onBlur, onCheck, onClick, onDoubleClick, onFocus, onInput, onMouseDown, onMouseEnter, onMouseLeave, onMouseOut, onMouseOver, onMouseUp, onSubmit, onTouchEnd, onTouchMove, onTouchStart
    , cancelClick
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

TODO remaining cancel functions

@docs cancelClick


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


{-| Emit a `msg` on "click" interactions.
-}
onClick : msg -> Interaction msg
onClick msg =
    { none | click = Just msg }


{-| Listen for "doubleclick" interactions.
-}
onDoubleClick : msg -> Interaction msg
onDoubleClick msg =
    { none | doubleClick = Just msg }


{-| Listen for "mouseenter" interactions.
-}
onMouseEnter : msg -> Interaction msg
onMouseEnter msg =
    { none | mouseEnter = Just msg }


{-| Listen for "mouseleave" interactions.
-}
onMouseLeave : msg -> Interaction msg
onMouseLeave msg =
    { none | mouseLeave = Just msg }


{-| Listen for "mouseover" interactions.
-}
onMouseOver : msg -> Interaction msg
onMouseOver msg =
    { none | mouseOver = Just msg }


{-| Listen for "mouseout" interactions.
-}
onMouseOut : msg -> Interaction msg
onMouseOut msg =
    { none | mouseOut = Just msg }


{-| Listen for "mousedown" interactions.
-}
onMouseDown : msg -> Interaction msg
onMouseDown msg =
    { none | mouseDown = Just msg }


{-| Listen for "mouseup" interactions.
-}
onMouseUp : msg -> Interaction msg
onMouseUp msg =
    { none | mouseUp = Just msg }


{-| Listen for "touchstart" interactions.
-}
onTouchStart : msg -> Interaction msg
onTouchStart msg =
    { none | touchStart = Just msg }


{-| Listen for "touchend" interactions.
-}
onTouchEnd : msg -> Interaction msg
onTouchEnd msg =
    { none | touchEnd = Just msg }


{-| Listen for "touchmove" interactions.
-}
onTouchMove : msg -> Interaction msg
onTouchMove msg =
    { none | touchMove = Just msg }


{-| Listen for "focus" interactions.
-}
onFocus : msg -> Interaction msg
onFocus msg =
    { none | focus = Just msg }


{-| Listen for "blur" interactions.
-}
onBlur : msg -> Interaction msg
onBlur msg =
    { none | blur = Just msg }


{-| Listen for String input interactions. You will normally use `onInput` functions
exported by individual view or component modules instead of using this function directly.
-}
onInput : (String -> msg) -> Interaction msg
onInput toMsg =
    { none | input = Just toMsg }


{-| Listen for checkbox interactions.
-}
onCheck : (Bool -> msg) -> Interaction msg
onCheck toMsg =
    { none | check = Just toMsg }


{-| Listen for form submission interactions.
-}
onSubmit : msg -> Interaction msg
onSubmit toMsg =
    { none | submit = Just toMsg }


{-| Cancel listening for "click" interactions.
-}
cancelClick : Interaction msg -> Interaction msg
cancelClick interaction =
    { interaction | click = Nothing }


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
