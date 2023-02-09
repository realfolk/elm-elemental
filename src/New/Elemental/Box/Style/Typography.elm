module New.Elemental.Box.Style.Typography exposing
    ( Family
    , LetterSpacing
    , LineHeight
    , Size
    , Transformation(..)
    , Typography
    , Weight(..)
    , addOverline
    , addStrikethrough
    , addUnderline
    , capitalize
    , italicize
    , lowercase
    , noTransformation
    , removeOverline
    , removeStrikethrough
    , removeUnderline
    , setDecorationColor
    , setFamilies
    , setLetterSpacing
    , setLineHeight
    , setSize
    , setWeight
    , toCssStyle
    , unitalicize
    , unsetDecorationColor
    , uppercase
    )

import Css
import New.Elemental.Lib.Color as Color exposing (Color)
import New.Elemental.Lib.Size as Size


type alias Typography =
    { families : List Family
    , size : Size
    , weight : Weight
    , lineHeight : LineHeight
    , letterSpacing : LetterSpacing
    , italic : Bool
    , underline : Bool
    , overline : Bool
    , strikethrough : Bool
    , decorationColor : Maybe Color
    , transformation : Transformation
    }


type alias Family =
    String


type alias Size =
    Size.Px


type alias LineHeight =
    Size.Px


type alias LetterSpacing =
    Size.Em


setFamilies : List Family -> Typography -> Typography
setFamilies families t =
    { t | families = families }


setSize : Size -> Typography -> Typography
setSize size t =
    { t | size = size }


setWeight : Weight -> Typography -> Typography
setWeight weight t =
    { t | weight = weight }


setLineHeight : LineHeight -> Typography -> Typography
setLineHeight lineHeight t =
    { t | lineHeight = lineHeight }


setLetterSpacing : LetterSpacing -> Typography -> Typography
setLetterSpacing letterSpacing t =
    { t | letterSpacing = letterSpacing }


italicize : Typography -> Typography
italicize t =
    { t | italic = True }


unitalicize : Typography -> Typography
unitalicize t =
    { t | italic = False }


addUnderline : Typography -> Typography
addUnderline t =
    { t | underline = True }


removeUnderline : Typography -> Typography
removeUnderline t =
    { t | underline = False }


addOverline : Typography -> Typography
addOverline t =
    { t | overline = True }


removeOverline : Typography -> Typography
removeOverline t =
    { t | overline = True }


addStrikethrough : Typography -> Typography
addStrikethrough t =
    { t | strikethrough = True }


removeStrikethrough : Typography -> Typography
removeStrikethrough t =
    { t | strikethrough = True }


setDecorationColor : Color -> Typography -> Typography
setDecorationColor color t =
    { t | decorationColor = Just color }


unsetDecorationColor : Typography -> Typography
unsetDecorationColor t =
    { t | decorationColor = Nothing }


noTransformation : Typography -> Typography
noTransformation t =
    { t | transformation = NoTransformation }


uppercase : Typography -> Typography
uppercase t =
    { t | transformation = Uppercase }


lowercase : Typography -> Typography
lowercase t =
    { t | transformation = Lowercase }


capitalize : Typography -> Typography
capitalize t =
    { t | transformation = Capitalize }


toCssStyle : Typography -> Css.Style
toCssStyle t =
    let
        consWhen bool item acc =
            if bool then
                item :: acc

            else
                acc

        hasDecoration =
            t.underline || t.overline || t.strikethrough

        textDecorationLine =
            consWhen t.underline Css.underline []
                |> consWhen t.overline Css.overline
                |> consWhen t.strikethrough Css.lineThrough
                |> Css.textDecorationLines

        textDecorationColor =
            Maybe.map (Color.toCssValue >> .value) t.decorationColor
                |> Maybe.map (Css.property "text-decoration-color")
                |> Maybe.withDefault (Css.batch [])

        textDecoration =
            Css.batch <|
                if hasDecoration then
                    [ textDecorationLine, textDecorationColor ]

                else
                    []

        fontStyle =
            if t.italic then
                Css.fontStyle Css.italic

            else
                Css.fontStyle Css.normal

        textTransform =
            transformationToCssStyle t.transformation
    in
    Css.batch
        [ Css.fontFamilies t.families
        , Css.fontSize <| Size.pxToCssValue t.size
        , Css.lineHeight <| Size.pxToCssValue t.lineHeight
        , Css.letterSpacing <| Size.emToCssValue t.letterSpacing
        , weightToCssStyle t.weight
        , fontStyle
        , textDecoration
        , textTransform
        ]


type Weight
    = W100
    | W200
    | W300
    | W400
    | W500
    | W600
    | W700
    | W800
    | W900


weightToCssStyle : Weight -> Css.Style
weightToCssStyle weight =
    Css.fontWeight <|
        Css.int <|
            case weight of
                W100 ->
                    100

                W200 ->
                    200

                W300 ->
                    300

                W400 ->
                    400

                W500 ->
                    500

                W600 ->
                    600

                W700 ->
                    700

                W800 ->
                    800

                W900 ->
                    900


type Transformation
    = NoTransformation
    | Uppercase
    | Lowercase
    | Capitalize


transformationToCssStyle : Transformation -> Css.Style
transformationToCssStyle t =
    case t of
        NoTransformation ->
            Css.textTransform Css.none

        Uppercase ->
            Css.textTransform Css.uppercase

        Lowercase ->
            Css.textTransform Css.lowercase

        Capitalize ->
            Css.textTransform Css.capitalize
