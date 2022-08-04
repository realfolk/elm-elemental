module New.Elemental.Box.Style exposing
    ( Style
    , none
    , setBackground
    , setBorder
    , setCorners
    , setCursor
    , setNudge
    , setOpacity
    , setRotate
    , setScale
    , setShadow
    , setTextAlignment
    , setTextColor
    , setTextWrap
    , setTypography
    , toCssStyle
    , unsetBackground
    , unsetBorder
    , unsetCorners
    , unsetCursor
    , unsetNudge
    , unsetOpacity
    , unsetRotate
    , unsetScale
    , unsetShadow
    , unsetTextAlignment
    , unsetTextColor
    , unsetTextWrap
    , unsetTypography
    )

import Css
import New.Elemental.Box.Style.Background as Background exposing (Background)
import New.Elemental.Box.Style.Border as Border exposing (Border)
import New.Elemental.Box.Style.Corners as Corners exposing (Corners)
import New.Elemental.Box.Style.Cursor as Cursor exposing (Cursor)
import New.Elemental.Box.Style.Nudge as Nudge exposing (Nudge)
import New.Elemental.Box.Style.Opacity as Opacity exposing (Opacity)
import New.Elemental.Box.Style.Overflow as Overflow exposing (Overflow)
import New.Elemental.Box.Style.Rotate as Rotate exposing (Rotate)
import New.Elemental.Box.Style.Scale as Scale exposing (Scale)
import New.Elemental.Box.Style.Shadow as Shadow exposing (Shadow)
import New.Elemental.Box.Style.Text.Alignment as TextAlignment exposing (TextAlignment)
import New.Elemental.Box.Style.Text.Wrap as TextWrap exposing (TextWrap)
import New.Elemental.Box.Style.Typography as Typography exposing (Typography)
import New.Elemental.Lib.Color as Color exposing (Color)


type alias Style =
    { background : Maybe Background
    , border : Maybe Border
    , corners : Maybe Corners
    , cursor : Maybe Cursor
    , nudge : Maybe Nudge
    , opacity : Maybe Opacity
    , overflow : Maybe Overflow
    , rotate : Maybe Rotate
    , scale : Maybe Scale
    , shadow : Maybe Shadow
    , textAlignment : Maybe TextAlignment
    , textColor : Maybe Color
    , textWrap : Maybe TextWrap
    , typography : Maybe Typography
    }


none : Style
none =
    { background = Nothing
    , border = Nothing
    , corners = Nothing
    , cursor = Nothing
    , nudge = Nothing
    , opacity = Nothing
    , overflow = Nothing
    , rotate = Nothing
    , scale = Nothing
    , shadow = Nothing
    , textAlignment = Nothing
    , textColor = Nothing
    , textWrap = Nothing
    , typography = Nothing
    }


toCssStyle : Style -> Css.Style
toCssStyle style =
    let
        toOptionalStyle toStyle =
            Maybe.map toStyle >> Maybe.withDefault (Css.batch [])

        transform =
            [ Maybe.map Nudge.toCssTransforms style.nudge
            , Maybe.map (Rotate.toCssTransform >> List.singleton) style.rotate
            , Maybe.map (Scale.toCssTransform >> List.singleton) style.scale
            ]
                |> List.filterMap identity
                |> List.concat
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
        , toOptionalStyle Overflow.toCssStyle style.overflow
        , toOptionalStyle Shadow.toCssStyle style.shadow
        , toOptionalStyle TextAlignment.toCssStyle style.textAlignment
        , toOptionalStyle TextWrap.toCssStyle style.textWrap
        , toOptionalStyle Typography.toCssStyle style.typography
        , transform
        , textColor
        ]


setBackground : Background -> Style -> Style
setBackground a style =
    { style | background = Just a }


unsetBackground : Style -> Style
unsetBackground style =
    { style | background = Nothing }


setBorder : Border -> Style -> Style
setBorder a style =
    { style | border = Just a }


unsetBorder : Style -> Style
unsetBorder style =
    { style | border = Nothing }


setCorners : Corners -> Style -> Style
setCorners a style =
    { style | corners = Just a }


unsetCorners : Style -> Style
unsetCorners style =
    { style | corners = Nothing }


setCursor : Cursor -> Style -> Style
setCursor a style =
    { style | cursor = Just a }


unsetCursor : Style -> Style
unsetCursor style =
    { style | cursor = Nothing }


setNudge : Nudge -> Style -> Style
setNudge a style =
    { style | nudge = Just a }


unsetNudge : Style -> Style
unsetNudge style =
    { style | nudge = Nothing }


setOpacity : Opacity -> Style -> Style
setOpacity a style =
    { style | opacity = Just a }


unsetOpacity : Style -> Style
unsetOpacity style =
    { style | opacity = Nothing }


setRotate : Rotate -> Style -> Style
setRotate a style =
    { style | rotate = Just a }


unsetRotate : Style -> Style
unsetRotate style =
    { style | rotate = Nothing }


setScale : Scale -> Style -> Style
setScale a style =
    { style | scale = Just a }


unsetScale : Style -> Style
unsetScale style =
    { style | scale = Nothing }


setShadow : Shadow -> Style -> Style
setShadow a style =
    { style | shadow = Just a }


unsetShadow : Style -> Style
unsetShadow style =
    { style | shadow = Nothing }


setTextAlignment : TextAlignment -> Style -> Style
setTextAlignment a style =
    { style | textAlignment = Just a }


unsetTextAlignment : Style -> Style
unsetTextAlignment style =
    { style | textAlignment = Nothing }


setTextColor : Color -> Style -> Style
setTextColor a style =
    { style | textColor = Just a }


unsetTextColor : Style -> Style
unsetTextColor style =
    { style | textColor = Nothing }


setTextWrap : TextWrap -> Style -> Style
setTextWrap a style =
    { style | textWrap = Just a }


unsetTextWrap : Style -> Style
unsetTextWrap style =
    { style | textWrap = Nothing }


setTypography : Typography -> Style -> Style
setTypography a style =
    { style | typography = Just a }


unsetTypography : Style -> Style
unsetTypography style =
    { style | typography = Nothing }
