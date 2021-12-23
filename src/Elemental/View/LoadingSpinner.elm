module Elemental.View.LoadingSpinner exposing (Options, Size(..), viewCustom)

import Css exposing (deg, int, ms, px)
import Css.Animations as CssA
import Html.Styled as H
import Html.Styled.Attributes as HA
import Json.Encode as JE
import Svg.Styled as Svg
import Svg.Styled.Attributes as SA


type alias Options =
    { size : Size
    , background : Css.Color
    , foreground : Css.Color
    , transitionDuration : Float
    }


type Size
    = Small
    | Medium
    | Large


viewCustom : Options -> H.Html msg
viewCustom options =
    let
        ( dimension, innerRadius, outerStrokeWidth ) =
            case options.size of
                Small ->
                    ( 20, 6.5, 5 )

                Medium ->
                    ( 24, 8, 6 )

                Large ->
                    ( 30, 11, 6 )

        dimension_ =
            String.fromFloat dimension

        w =
            dimension_

        h =
            dimension_

        half =
            dimension / 2

        half_ =
            String.fromFloat half

        oneSixth =
            dimension / 6

        oneSixth_ =
            String.fromFloat oneSixth

        fiveSixths =
            oneSixth * 5

        fiveSixths_ =
            String.fromFloat fiveSixths

        r =
            String.fromFloat innerRadius

        outerStrokeWidth_ =
            String.fromFloat outerStrokeWidth

        innerStrokeWidth =
            outerStrokeWidth - 2

        innerStrokeWidth_ =
            String.fromFloat innerStrokeWidth

        innerCursorRadius =
            innerStrokeWidth / 2

        innerCursorRadius_ =
            String.fromFloat innerCursorRadius

        background =
            options.background.value

        foreground =
            options.foreground.value

        gradientId =
            "loading-spinner-gradient"

        maskId =
            "loading-spinner-mask"
    in
    Svg.svg
        [ SA.viewBox <| "0 0 " ++ w ++ " " ++ h
        , SA.fill "none"
        , SA.css
            [ Css.pointerEvents Css.none
            , Css.width <| px dimension
            , Css.height <| px dimension
            , Css.flexGrow <| int 0
            , Css.flexShrink <| int 0
            ]
        ]
        [ Svg.defs []
            [ Svg.linearGradient
                [ SA.id gradientId
                , SA.x1 half_
                , SA.y1 oneSixth_
                , SA.x2 half_
                , SA.y2 fiveSixths_
                , SA.gradientUnits "userSpaceOnUse"
                ]
                [ Svg.stop
                    [ SA.offset "0"
                    , SA.stopColor foreground
                    , SA.stopOpacity "0"
                    ]
                    []
                , Svg.stop
                    [ SA.offset "0.7"
                    , SA.stopColor foreground
                    , SA.stopOpacity "1"
                    ]
                    []
                , Svg.stop
                    [ SA.offset "1"
                    , SA.stopColor foreground
                    , SA.stopOpacity "1"
                    ]
                    []
                ]
            ]
        , Svg.mask
            [ SA.id maskId
            , SA.maskUnits "userSpaceOnUse"
            , SA.x half_
            , SA.y "1"
            , SA.width half_
            , SA.height dimension_
            , HA.property "mask-type" <| JE.string "alpha"
            ]
            [ Svg.rect
                [ SA.width half_
                , SA.height dimension_
                , SA.x half_
                , SA.y "0"
                , SA.fill "#ffffff"
                ]
                []
            ]
        , Svg.circle
            [ SA.cx half_
            , SA.cy half_
            , SA.r r
            , SA.stroke background
            , SA.strokeWidth outerStrokeWidth_
            ]
            []
        , Svg.g
            [ SA.css
                [ Css.animationName spin
                , Css.animationDuration <| ms <| options.transitionDuration
                , Css.property "animation-iteration-count" "infinite"
                , Css.property "animation-timing-function" "linear"
                , Css.property "transform-origin" "50% 50%"
                ]
            ]
            [ Svg.g [ SA.mask <| "url('#" ++ maskId ++ "')" ]
                [ Svg.circle
                    [ SA.cx half_
                    , SA.cy half_
                    , SA.r r
                    , SA.stroke <| "url('#" ++ gradientId ++ "')"
                    , SA.strokeWidth innerStrokeWidth_
                    ]
                    []
                ]
            , Svg.circle
                [ SA.cx half_
                , SA.cy <| String.fromFloat <| dimension - 3
                , SA.r innerCursorRadius_
                , SA.fill foreground
                ]
                []
            ]
        ]



-- ANIMATION


spin =
    CssA.keyframes
        [ ( 0, [ CssA.transform [ Css.rotate <| deg 0 ] ] )
        , ( 100, [ CssA.transform [ Css.rotate <| deg 360 ] ] )
        ]
