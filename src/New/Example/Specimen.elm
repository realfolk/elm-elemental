module New.Example.Specimen exposing (..)

import Lib.Function as Function
import New.Elemental exposing (Element, box, text)
import New.Elemental.Box as Box
import New.Elemental.Box.Structure as Structure
import New.Elemental.Box.Style as Style
import New.Elemental.Box.Style.Corners as Corners
import New.Elemental.Browser as Browser
import New.Elemental.Lib.Sides as Sides
import New.Elemental.Lib.Size as Size
import New.Elemental.View.Badge as Badge
import New.Example.Specimen.Theme as Theme


type alias Model =
    { colors : Theme.Base16Scheme
    , permutations : List Theme.Permutation
    }


main : Program () Model ()
main =
    Browser.document
        { init = \_ -> ( init, Cmd.none )
        , view = view
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = always Sub.none
        }


init : Model
init =
    let
        scheme =
            Theme.eighties
    in
    { colors = scheme
    , permutations = Theme.permutations scheme
    }


view : Model -> Browser.Document msg
view model =
    { title = "Elemental Specimen"
    , body = viewBody model
    }


viewBody : Model -> Browser.Body msg
viewBody { permutations } =
    let
        toBadge colors_ =
            { typography = Theme.typography.badge
            , corners = Corners.all <| Corners.Rounded <| Size.px 4
            , padding = Sides.sides (Size.px 4) (Size.px 8) (Size.px 4) (Size.px 8)
            , colors = colors_
            }

        badges =
            List.map toBadge permutations
    in
    { direction = Structure.Column
    , justification = Structure.Packed (Structure.Start (Size.px 48)) False
    , alignment = Structure.Start (Size.px 0)
    , padding = Sides.all (Size.px 32)
    , style = Style.none
    , extraStyles = []
    , children =
        [ viewSection "Badge" (Function.flip Badge.viewElement "Badge") badges
        ]
    }


viewSection : String -> (options -> Element msg) -> List options -> Element msg
viewSection heading viewItem items =
    let
        viewHeading =
            Box.default
                |> Box.setChildren [ text heading ]
                |> Box.mapStyle (Style.setTypography Theme.typography.section.heading)
                |> box

        viewItems =
            Box.default
                |> Box.setChildren (List.map viewItem items)
                |> Box.mapStructure
                    (Structure.setWidth Structure.Fill
                        >> Structure.setHeight Structure.Fill
                        >> Structure.wrap
                        >> Structure.setJustificationSpacing (Size.px 16)
                        >> Structure.setAlignmentSpacing (Size.px 20)
                        >> Structure.row
                    )
                |> box
    in
    Box.default
        |> Box.setChildren [ viewHeading, viewItems ]
        |> Box.mapStructure (Structure.setJustificationSpacing (Size.px 24))
        |> box
