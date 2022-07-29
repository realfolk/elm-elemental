module New.Elemental.Box.Style exposing
    ( Style
    , toCssStyle
    )

import Css
import New.Elemental.Box.Style.Background as Background exposing (Background)
import New.Elemental.Box.Style.Border as Border exposing (Border)
import New.Elemental.Box.Style.Corners as Corners exposing (Corners)
import New.Elemental.Box.Style.Cursor as Cursor exposing (Cursor)
import New.Elemental.Box.Style.Nudge as Nudge exposing (Nudge)
import New.Elemental.Box.Style.Opacity as Opacity exposing (Opacity)
import New.Elemental.Box.Style.Rotate as Rotate exposing (Rotate)
import New.Elemental.Box.Style.Scale as Scale exposing (Scale)
import New.Elemental.Box.Style.Shadow as Shadow exposing (Shadow)
import New.Elemental.Box.Style.Typography as Typography exposing (Typography)
import New.Elemental.Lib.Color as Color exposing (Color)


type alias Style =
    { background : Maybe Background
    , border : Maybe Border
    , corners : Maybe Corners
    , cursor : Maybe Cursor
    , nudge : Maybe Nudge
    , opacity : Maybe Opacity
    , rotate : Maybe Rotate
    , scale : Maybe Scale
    , shadow : Maybe Shadow
    , textColor : Maybe Color
    , typography : Maybe Typography
    }


toCssStyle : Style -> Css.Style
toCssStyle style =
    let
        toOptionalStyle toStyle =
            Maybe.map toStyle >> Maybe.withDefault (Css.batch [])

        appendMaybeTransforms toTransforms maybeValue acc =
            Maybe.map toTransforms maybeValue
                |> Maybe.withDefault []
                |> List.append acc

        transform =
            appendMaybeTransforms Nudge.toCssTransforms style.nudge []
                |> appendMaybeTransforms (Rotate.toCssTransform >> List.singleton) style.rotate
                |> appendMaybeTransforms (Scale.toCssTransform >> List.singleton) style.scale
                |> Css.transforms

        textColor =
            toOptionalStyle (Color.toCssValue >> Css.color) style.textColor
    in
    Css.batch
        [ toOptionalStyle Background.toCssStyle style.background
        , toOptionalStyle Border.toCssStyle style.border
        , toOptionalStyle Corners.toCssStyle style.corners
        , toOptionalStyle Cursor.toCssStyle style.cursor
        , toOptionalStyle Opacity.toCssStyle style.opacity
        , toOptionalStyle Shadow.toCssStyle style.shadow
        , toOptionalStyle Typography.toCssStyle style.typography
        , transform
        , textColor
        ]
