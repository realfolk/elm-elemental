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
    = Interaction (List (Action msg) -> List (Action msg))


type Action msg
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


none : Interaction msg
none =
    Interaction identity


onClick : msg -> Interaction msg
onClick =
    Interaction << (::) << Click


onDoubleClick : msg -> Interaction msg
onDoubleClick =
    Interaction << (::) << DoubleClick


onMouseEnter : msg -> Interaction msg
onMouseEnter =
    Interaction << (::) << MouseEnter


onMouseLeave : msg -> Interaction msg
onMouseLeave =
    Interaction << (::) << MouseLeave


onMouseOver : msg -> Interaction msg
onMouseOver =
    Interaction << (::) << MouseOver


onMouseOut : msg -> Interaction msg
onMouseOut =
    Interaction << (::) << MouseOut


onMouseDown : msg -> Interaction msg
onMouseDown =
    Interaction << (::) << MouseDown


onMouseUp : msg -> Interaction msg
onMouseUp =
    Interaction << (::) << MouseUp


onTouchStart : msg -> Interaction msg
onTouchStart =
    Interaction << (::) << TouchStart


onTouchEnd : msg -> Interaction msg
onTouchEnd =
    Interaction << (::) << TouchEnd


onTouchMove : msg -> Interaction msg
onTouchMove =
    Interaction << (::) << TouchMove


onFocus : msg -> Interaction msg
onFocus =
    Interaction << (::) << Focus


onBlur : msg -> Interaction msg
onBlur =
    Interaction << (::) << Blur


and : Interaction msg -> Interaction msg -> Interaction msg
and (Interaction b) (Interaction a) =
    Interaction (a >> b)


toAttrs : Interaction msg -> List (H.Attribute msg)
toAttrs (Interaction toActions) =
    List.reverse <| List.map toEvent (toActions [])


toEvent : Action msg -> H.Attribute msg
toEvent action =
    let
        on name =
            JD.succeed >> HE.on name
    in
    case action of
        Click msg ->
            HE.onClick msg

        DoubleClick msg ->
            HE.onDoubleClick msg

        MouseEnter msg ->
            HE.onMouseEnter msg

        MouseLeave msg ->
            HE.onMouseLeave msg

        MouseOver msg ->
            HE.onMouseOver msg

        MouseOut msg ->
            HE.onMouseOut msg

        MouseDown msg ->
            HE.onMouseDown msg

        MouseUp msg ->
            HE.onMouseUp msg

        TouchStart msg ->
            on "touchstart" msg

        TouchEnd msg ->
            on "touchend" msg

        TouchMove msg ->
            on "touchmove" msg

        Focus msg ->
            HE.onFocus msg

        Blur msg ->
            HE.onBlur msg
