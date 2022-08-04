module New.Example.Specimen exposing (..)

import Html as Unstyled
import New.Elemental as Elemental exposing (text)


main : Unstyled.Html msg
main =
    Elemental.toUnstyledHtml <|
        text "Hello, world!"
