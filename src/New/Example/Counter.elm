module New.Example.Counter exposing (..)

import New.Elemental exposing (..)
import New.Elemental.Box as Box
import New.Elemental.Box.Compatibility as Compatibility
import New.Elemental.Box.Interaction as Interaction
import New.Elemental.Box.Structure as Structure
import New.Elemental.Browser as Browser
import New.Elemental.Lib.Sides as Sides
import New.Elemental.Lib.Size as Size


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type Counter
    = Counter Int


type alias Model =
    Counter


init =
    Counter 0


type Msg
    = Increment
    | Decrement


update msg (Counter n) =
    case msg of
        Increment ->
            Counter <| n + 1

        Decrement ->
            Counter <| n - 1


view (Counter n) =
    Box.defaultRow
        Structure.Hug
        Structure.Hug
        [ viewButton Decrement, viewCount n, viewButton Increment ]
        |> box


viewCount : Int -> Element msg
viewCount n =
    let
        setPadding s =
            { s | padding = Sides.leftAndRight (Size.px 0) (Size.px 24) }

        setStructure b =
            { b | structure = setPadding b.structure }
    in
    Box.defaultRow
        Structure.Hug
        Structure.Hug
        [ text <| String.fromInt n
        ]
        |> setStructure
        |> box


viewButton : Msg -> Element Msg
viewButton msg =
    let
        text_ =
            case msg of
                Increment ->
                    "+ Increment"

                Decrement ->
                    "- Decrement"

        setInteraction b =
            { b | interaction = Interaction.onClick msg }

        setCompatibility b =
            { b | compatibility = Compatibility.fromTag "button" }
    in
    Box.defaultRow
        Structure.Hug
        Structure.Hug
        [ text text_ ]
        |> setInteraction
        |> setCompatibility
        |> box
