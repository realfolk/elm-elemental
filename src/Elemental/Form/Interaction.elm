module Elemental.Form.Interaction exposing
    ( Config
    , Interaction(..)
    , toAttrs
    , toConfig
    )

import Html.Styled as H
import Html.Styled.Events as HE
import Json.Decode as JD


type Interaction
    = Click
    | DoubleClick
    | MouseEnter
    | MouseLeave
    | MouseOver
    | MouseOut
    | MouseDown
    | MouseUp
    | TouchStart
    | TouchEnd
    | TouchMove
    | Focus
    | Blur


type Config msg
    = Config
        { toMsg : Interaction -> msg
        , interactions : List Interaction
        }


toConfig : (Interaction -> msg) -> List Interaction -> Maybe (Config msg)
toConfig toMsg interactions =
    if List.isEmpty interactions then
        Nothing

    else
        Just <|
            Config
                { toMsg = toMsg
                , interactions = interactions
                }


toAttrs : Config msg -> List (H.Attribute msg)
toAttrs (Config { toMsg, interactions }) =
    List.map (interactionToAttribute toMsg) interactions


interactionToAttribute : (Interaction -> msg) -> Interaction -> H.Attribute msg
interactionToAttribute toMsg interaction =
    let
        on name =
            JD.succeed >> HE.on name

        msg =
            toMsg interaction
    in
    case interaction of
        Click ->
            HE.onClick msg

        DoubleClick ->
            HE.onDoubleClick msg

        MouseEnter ->
            HE.onMouseEnter msg

        MouseLeave ->
            HE.onMouseLeave msg

        MouseOver ->
            HE.onMouseOver msg

        MouseOut ->
            HE.onMouseOut msg

        MouseDown ->
            HE.onMouseDown msg

        MouseUp ->
            HE.onMouseUp msg

        TouchStart ->
            on "touchstart" msg

        TouchEnd ->
            on "touchend" msg

        TouchMove ->
            on "touchmove" msg

        Focus ->
            HE.onFocus msg

        Blur ->
            HE.onBlur msg
