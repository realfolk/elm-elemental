module New.Example.Counter exposing (..)

import New.Elemental exposing (..)
import New.Elemental.Box as Box
import New.Elemental.Box.Compatibility as Compatibility
import New.Elemental.Box.Interaction as Interaction
import New.Elemental.Box.Structure as Structure
import New.Elemental.Box.Style as Style
import New.Elemental.Browser as Browser
import New.Elemental.Lib.Sides as Sides
import New.Elemental.Lib.Size as Size


main : Program () Model Msg
main =
    Browser.document
        { init = \_ -> ( init, Cmd.none )
        , update = \msg model -> ( update msg model, Cmd.none )
        , view = view
        , subscriptions = always Sub.none
        }


type Counter
    = Counter Int


type alias Model =
    Counter


init : Model
init =
    Counter 0


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg (Counter n) =
    case msg of
        Increment ->
            Counter <| n + 1

        Decrement ->
            Counter <| n - 1


view : Model -> Browser.Document Msg
view model =
    { title = "Counter"
    , body = viewBody model
    }


viewBody : Model -> Browser.Body Msg
viewBody model =
    { direction = Structure.Column
    , justification = Structure.Packed (Structure.Start (Size.px 48)) False
    , alignment = Structure.Start (Size.px 0)
    , padding = Sides.all (Size.px 32)
    , style = Style.none
    , extraStyles = []
    , children = [ viewCounter model ]
    }


viewCounter : Model -> Element Msg
viewCounter (Counter n) =
    Box.default
        |> Box.mapStructure Structure.row
        |> Box.setChildren [ viewButton Decrement, viewCount n, viewButton Increment ]
        |> box


viewCount : Int -> Element msg
viewCount n =
    let
        padding =
            Sides.leftAndRight (Size.px 0) (Size.px 24)
    in
    Box.default
        |> Box.setChildren [ text <| String.fromInt n ]
        |> Box.mapStructure (Structure.row >> Structure.setPadding padding)
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
    Box.default
        |> Box.setChildren [ text text_ ]
        |> Box.setInteraction (Interaction.onClick msg)
        |> Box.setCompatibility (Compatibility.fromTag "button")
        |> Box.mapStructure Structure.row
        |> box
