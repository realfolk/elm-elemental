module Elemental.Css exposing
    ( borderAll
    , borderBottom
    , borderLeft
    , borderRadiusAll
    , borderRadiusBottom
    , borderRadiusLeft
    , borderRadiusRight
    , borderRadiusTop
    , borderRight
    , borderTop
    , buttonReset
    , column
    , fillAvailable
    , focusHighlight
    , fullContainer
    , fullContainerHeight
    , fullViewport
    , fullViewportHeight
    , grow
    , hideScrollBar
    , noAppearance
    , noGrow
    , noShrink
    , objectFitCover
    , overflowScrolling
    , placeholder
    , row
    , scroll
    , shadowNavigation
    , shrink
    , stripUnits
    , userSelect
    )

import Css exposing (px)


borderAll : Css.Color -> Css.Style
borderAll =
    border Css.border3


borderTop : Css.Color -> Css.Style
borderTop =
    border Css.borderTop3


borderRight : Css.Color -> Css.Style
borderRight =
    border Css.borderRight3


borderBottom : Css.Color -> Css.Style
borderBottom =
    border Css.borderBottom3


borderLeft : Css.Color -> Css.Style
borderLeft =
    border Css.borderLeft3


border : (Css.Px -> Css.BorderStyle (Css.TextDecorationStyle {}) -> Css.Color -> Css.Style) -> Css.Color -> Css.Style
border f color =
    f (px 1) Css.solid color


borderRadiusAll =
    makeBorderRadiusSizes [ Css.borderRadius ]


borderRadiusTop =
    makeBorderRadiusSizes [ Css.borderTopLeftRadius, Css.borderTopRightRadius ]


borderRadiusRight =
    makeBorderRadiusSizes [ Css.borderTopRightRadius, Css.borderBottomRightRadius ]


borderRadiusBottom =
    makeBorderRadiusSizes [ Css.borderBottomLeftRadius, Css.borderBottomRightRadius ]


borderRadiusLeft =
    makeBorderRadiusSizes [ Css.borderTopLeftRadius, Css.borderBottomLeftRadius ]


makeBorderRadiusSizes f =
    { small = borderRadius f 4
    , medium = borderRadius f 8
    , large = borderRadius f 16
    }


borderRadius : List (Css.Px -> Css.Style) -> Float -> Css.Style
borderRadius fs size =
    List.map (\f -> f <| px size) fs
        |> Css.batch


buttonReset : Css.Style
buttonReset =
    Css.batch
        [ Css.borderStyle Css.none
        , Css.padding Css.zero
        , Css.backgroundColor Css.initial
        ]


column : Css.Style
column =
    Css.batch
        [ Css.displayFlex
        , Css.flexFlow2 Css.column Css.noWrap
        ]


fillAvailable : Css.Style
fillAvailable =
    Css.property "max-height" "-webkit-fill-available"


focusHighlight : Css.Color -> Css.Style
focusHighlight color =
    Css.boxShadow5 (px 0) (px 0) (px 0) (px 3) color


fullContainer : Css.Style
fullContainer =
    Css.batch
        [ Css.width <| Css.pct 100
        , fullContainerHeight
        ]


fullContainerHeight : Css.Style
fullContainerHeight =
    Css.batch
        [ Css.height <| Css.pct 100
        , fillAvailable
        ]


fullViewport : Css.Style
fullViewport =
    Css.batch
        [ Css.width <| Css.vw 100
        , fullViewportHeight
        ]


fullViewportHeight : Css.Style
fullViewportHeight =
    Css.batch
        [ Css.height <| Css.vh 100
        , fillAvailable
        ]


grow : Css.Style
grow =
    Css.flexGrow <| Css.int 1


hideScrollBar : Css.Style
hideScrollBar =
    Css.batch
        [ Css.pseudoElement "-webkit-scrollbar" [ Css.display Css.none ]
        , Css.property "-ms-overflow-style" "none"
        , Css.property "scrollbar-width" "none"
        ]


noAppearance : Css.Style
noAppearance =
    Css.batch
        [ Css.property "-webkit-appearance" "none"
        , Css.property "-moz-appearance" "none"
        , Css.property "appearance" "none"
        ]


noGrow : Css.Style
noGrow =
    Css.flexGrow Css.zero


noShrink : Css.Style
noShrink =
    Css.flexShrink Css.zero


objectFitCover : Css.Style
objectFitCover =
    Css.property "object-fit" "cover"


overflowScrolling : Bool -> Css.Style
overflowScrolling touch =
    Css.property "-webkit-overflow-scrolling" <|
        if touch then
            "touch"

        else
            "auto"


placeholder : List Css.Style -> Css.Style
placeholder styles_ =
    Css.batch
        [ Css.pseudoElement "-webkit-datetime-edit" styles_
        , Css.pseudoElement "placeholder" styles_
        ]


row : Css.Style
row =
    Css.batch
        [ Css.displayFlex
        , Css.flexFlow2 Css.row Css.noWrap
        ]


scroll : Css.Style
scroll =
    Css.batch
        [ Css.overflowY Css.auto
        , overflowScrolling True
        ]


shadowNavigation : Css.Color -> Css.Style
shadowNavigation color =
    Css.boxShadow5 Css.zero (px 6) (px 8) (px -3) color


shrink : Css.Style
shrink =
    Css.flexShrink <| Css.int 1


{-| Strips the (usually incompatible) `units` field in
`Css.ExplicitLength` values.
-}
stripUnits : Css.ExplicitLength units -> Css.ExplicitLength ()
stripUnits record =
    { units = ()
    , value = record.value
    , numericValue = record.numericValue
    , unitLabel = record.unitLabel
    , length = record.length
    , lengthOrAuto = record.lengthOrAuto
    , lengthOrNumber = record.lengthOrNumber
    , lengthOrNone = record.lengthOrNone
    , lengthOrMinMaxDimension = record.lengthOrMinMaxDimension
    , lengthOrNoneOrMinMaxDimension = record.lengthOrNoneOrMinMaxDimension
    , textIndent = record.textIndent
    , flexBasis = record.flexBasis
    , lengthOrNumberOrAutoOrNoneOrContent = record.lengthOrNumberOrAutoOrNoneOrContent
    , fontSize = record.fontSize
    , absoluteLength = record.absoluteLength
    , lengthOrAutoOrCoverOrContain = record.lengthOrAutoOrCoverOrContain
    , calc = record.calc
    }


userSelect : String -> Css.Style
userSelect value =
    Css.batch
        [ Css.property "user-select" value
        , Css.property "-webkit-user-select" value
        , Css.property "-moz-user-select" value
        , Css.property "-ms-user-select" value
        ]
