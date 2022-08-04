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


view : Model -> Element Msg
view (Counter n) =
    Box.defaultRow
        |> Box.setChildren [ viewButton Decrement, viewCount n, viewButton Increment ]
        |> box


viewCount : Int -> Element msg
viewCount n =
    let
        padding =
            Sides.leftAndRight (Size.px 0) (Size.px 24)
    in
    Box.defaultRow
        |> Box.setChildren [ text <| String.fromInt n ]
        |> Box.mapStructure (Structure.setPadding padding)
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
    in
    Box.defaultRow
        |> Box.setChildren [ text text_ ]
        |> Box.setInteraction (Interaction.onClick msg)
        |> Box.setCompatibility (Compatibility.fromTag "button")
        |> box
