module New.Example.Hello exposing (..)

import New.Elemental exposing (..)
import New.Elemental.Box as Box
import New.Elemental.Box.Structure as Structure
import New.Elemental.Box.Style as Style
import New.Elemental.Box.Style.Background as Background
import New.Elemental.Box.Style.Corners as Corners
import New.Elemental.Browser as Browser
import New.Elemental.Lib.Color as Color
import New.Elemental.Lib.Size as Size


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


init =
    ()


update () () =
    ()


view () =
    viewHello "World"


viewHello : String -> Element msg
viewHello name =
    let
        none =
            Style.none

        style =
            { none
                | background = Just <| Background.solid Color.black
                , textColor = Just <| Color.white
                , corners = Just <| Corners.all <| Corners.Rounded <| Size.px 20
            }

        dimension =
            Structure.Fixed <| Size.px 200
    in
    Box.default
        |> Box.mapStructure (Structure.row >> Structure.setWidth dimension >> Structure.setHeight dimension)
        |> Box.setChildren [ text <| "Hello, " ++ name ++ "!" ]
        |> Box.setStyle style
        |> box
