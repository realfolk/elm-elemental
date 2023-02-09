module Elemental.Form.Interaction exposing
    ( Interaction
    , and
    , none
    , onBlur
    , onClick
    , onDoubleClick
    , onFocus
    , onMouseDown
    , onMouseEnter
    , onMouseLeave
    , onMouseOut
    , onMouseOver
    , onMouseUp
    , onTouchEnd
    , onTouchMove
    , onTouchStart
    , toAttrs
    )

import Html.Styled as H
import Html.Styled.Events as HE
import Json.Decode as JD


type Interaction msg
    = Interaction (Config msg)


type alias Config msg =
    { onClick : Maybe msg
    , onDoubleClick : Maybe msg
    , onMouseEnter : Maybe msg
    , onMouseLeave : Maybe msg
    , onMouseOver : Maybe msg
    , onMouseOut : Maybe msg
    , onMouseDown : Maybe msg
    , onMouseUp : Maybe msg
    , onTouchStart : Maybe msg
    , onTouchEnd : Maybe msg
    , onTouchMove : Maybe msg
    , onFocus : Maybe msg
    , onBlur : Maybe msg
    }


noneConfig : Config msg
noneConfig =
    { onClick = Nothing
    , onDoubleClick = Nothing
    , onMouseEnter = Nothing
    , onMouseLeave = Nothing
    , onMouseOver = Nothing
    , onMouseOut = Nothing
    , onMouseDown = Nothing
    , onMouseUp = Nothing
    , onTouchStart = Nothing
    , onTouchEnd = Nothing
    , onTouchMove = Nothing
    , onFocus = Nothing
    , onBlur = Nothing
    }


none : Interaction msg
none =
    Interaction noneConfig


onClick : msg -> Interaction msg
onClick msg =
    Interaction { noneConfig | onClick = Just msg }


onDoubleClick : msg -> Interaction msg
onDoubleClick msg =
    Interaction { noneConfig | onDoubleClick = Just msg }


onMouseEnter : msg -> Interaction msg
onMouseEnter msg =
    Interaction { noneConfig | onMouseEnter = Just msg }


onMouseLeave : msg -> Interaction msg
onMouseLeave msg =
    Interaction { noneConfig | onMouseLeave = Just msg }


onMouseOver : msg -> Interaction msg
onMouseOver msg =
    Interaction { noneConfig | onMouseOver = Just msg }


onMouseOut : msg -> Interaction msg
onMouseOut msg =
    Interaction { noneConfig | onMouseOut = Just msg }


onMouseDown : msg -> Interaction msg
onMouseDown msg =
    Interaction { noneConfig | onMouseDown = Just msg }


onMouseUp : msg -> Interaction msg
onMouseUp msg =
    Interaction { noneConfig | onMouseUp = Just msg }


onTouchStart : msg -> Interaction msg
onTouchStart msg =
    Interaction { noneConfig | onTouchStart = Just msg }


onTouchEnd : msg -> Interaction msg
onTouchEnd msg =
    Interaction { noneConfig | onTouchEnd = Just msg }


onTouchMove : msg -> Interaction msg
onTouchMove msg =
    Interaction { noneConfig | onTouchMove = Just msg }


onFocus : msg -> Interaction msg
onFocus msg =
    Interaction { noneConfig | onFocus = Just msg }


onBlur : msg -> Interaction msg
onBlur msg =
    Interaction { noneConfig | onBlur = Just msg }


and : Interaction msg -> Interaction msg -> Interaction msg
and (Interaction interaction2) (Interaction interaction1) =
    let
        overrideIfSet fn =
            case fn interaction2 of
                Just i ->
                    Just i

                Nothing ->
                    fn interaction1
    in
    Interaction
        { onClick = overrideIfSet .onClick
        , onDoubleClick = overrideIfSet .onDoubleClick
        , onMouseEnter = overrideIfSet .onMouseEnter
        , onMouseLeave = overrideIfSet .onMouseLeave
        , onMouseOver = overrideIfSet .onMouseOver
        , onMouseOut = overrideIfSet .onMouseOut
        , onMouseDown = overrideIfSet .onMouseDown
        , onMouseUp = overrideIfSet .onMouseUp
        , onTouchStart = overrideIfSet .onTouchStart
        , onTouchEnd = overrideIfSet .onTouchEnd
        , onTouchMove = overrideIfSet .onTouchMove
        , onFocus = overrideIfSet .onFocus
        , onBlur = overrideIfSet .onBlur
        }


toAttrs : Interaction msg -> List (H.Attribute msg)
toAttrs (Interaction interaction) =
    let
        on name =
            JD.succeed >> HE.on name
    in
    [ Maybe.map HE.onClick interaction.onClick
    , Maybe.map HE.onDoubleClick interaction.onDoubleClick
    , Maybe.map HE.onMouseEnter interaction.onMouseEnter
    , Maybe.map HE.onMouseLeave interaction.onMouseLeave
    , Maybe.map HE.onMouseOver interaction.onMouseOver
    , Maybe.map HE.onMouseOut interaction.onMouseOut
    , Maybe.map HE.onMouseDown interaction.onMouseDown
    , Maybe.map HE.onMouseUp interaction.onMouseUp
    , Maybe.map (on "touchstart") interaction.onTouchStart
    , Maybe.map (on "touchend") interaction.onTouchEnd
    , Maybe.map (on "touchmove") interaction.onTouchMove
    , Maybe.map HE.onFocus interaction.onFocus
    , Maybe.map HE.onBlur interaction.onBlur
    ]
        |> List.filterMap identity
