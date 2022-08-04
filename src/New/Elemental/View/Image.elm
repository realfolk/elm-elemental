module New.Elemental.View.Image exposing
    ( Dimensions
    , Options
    , Source(..)
    , SourcesByPixelDensity
    , defaultOptions
    , fillHeight
    , fillWidth
    , fixed
    , fixedHeight
    , fixedWidth
    , sourceToUrl
    , viewElement
    )

import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attributes
import New.Elemental exposing (Element, html)
import New.Elemental.Box.Style as Style exposing (Style)
import New.Elemental.Lib.Css as Css
import New.Elemental.Lib.Size as Size


type alias Options =
    { alt : String
    , dimensions : Maybe Dimensions
    , style : Style
    }


defaultOptions : String -> Options
defaultOptions alt =
    { alt = alt
    , dimensions = Nothing
    , style = Style.none
    }


viewElement : Options -> Source -> Element msg
viewElement options source =
    let
        sourceAttributes =
            case source of
                Single url ->
                    [ Attributes.src url ]

                Responsive sources ->
                    sourcesByPixelDensityToAttributes sources
    in
    html <|
        Html.img
            (List.append sourceAttributes
                [ Attributes.alt options.alt
                , Attributes.css
                    [ Css.maybe <| Maybe.map dimensionsToCssStyle options.dimensions
                    , Style.toCssStyle options.style
                    ]
                ]
            )
            []


type Source
    = Single String
    | Responsive SourcesByPixelDensity


sourceToUrl : Source -> String
sourceToUrl source =
    case source of
        Single url ->
            url

        Responsive { x3 } ->
            x3


type alias SourcesByPixelDensity =
    { x1 : String
    , x2 : String
    , x3 : String
    }


sourcesByPixelDensityToAttributes : SourcesByPixelDensity -> List (Html.Attribute msg)
sourcesByPixelDensityToAttributes { x1, x2, x3 } =
    [ Attributes.src x1
    , Attributes.attribute "srcset" <|
        String.join ", "
            [ x2 ++ " 2x"
            , x3 ++ " 3x"
            ]
    ]


type Dimensions
    = Fixed
        { width : Size.Px
        , height : Size.Px
        }
    | FixedWidth Size.Px
    | FixedHeight Size.Px
    | FillWidth (MinMax (Maybe Size.Px))
    | FillHeight (MinMax (Maybe Size.Px))


fixed : Size.Px -> Size.Px -> Dimensions
fixed width height =
    Fixed
        { width = width
        , height = height
        }


fixedWidth : Size.Px -> Dimensions
fixedWidth =
    FixedWidth


fixedHeight : Size.Px -> Dimensions
fixedHeight =
    FixedHeight


fillWidth : Maybe Size.Px -> Maybe Size.Px -> Dimensions
fillWidth min_ max_ =
    FillWidth
        { min = min_
        , max = max_
        }


fillHeight : Maybe Size.Px -> Maybe Size.Px -> Dimensions
fillHeight min_ max_ =
    FillHeight
        { min = min_
        , max = max_
        }


dimensionsToCssStyle : Dimensions -> Css.Style
dimensionsToCssStyle dimensions =
    let
        maybePxToStyle toStyle =
            Maybe.map (Size.pxToCssValue >> toStyle) >> Css.maybe

        minMaxToCssStyle_ minToStyle maxToStyle =
            minMaxToCssStyle
                (maybePxToStyle minToStyle)
                (maybePxToStyle maxToStyle)
    in
    Css.batch <|
        case dimensions of
            Fixed { width, height } ->
                [ Css.width <| Size.pxToCssValue width
                , Css.height <| Size.pxToCssValue height
                ]

            FixedWidth width ->
                [ Css.width <| Size.pxToCssValue width
                , Css.height Css.auto
                ]

            FixedHeight height ->
                [ Css.height <| Size.pxToCssValue height
                , Css.width Css.auto
                ]

            FillWidth minMax ->
                [ minMaxToCssStyle_ Css.minWidth Css.maxWidth minMax
                , Css.width <| Css.pct 100
                , Css.height Css.auto
                ]

            FillHeight minMax ->
                [ minMaxToCssStyle_ Css.minHeight Css.maxHeight minMax
                , Css.height <| Css.pct 100
                , Css.width Css.auto
                ]


type alias MinMax a =
    { min : a
    , max : a
    }


minMaxToCssStyle : (a -> Css.Style) -> (a -> Css.Style) -> MinMax a -> Css.Style
minMaxToCssStyle minToStyle maxToStyle { min, max } =
    Css.batch
        [ minToStyle min
        , maxToStyle max
        ]
