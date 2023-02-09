module New.Elemental.View.Spinner exposing (Options, viewElement)

import Css
import Css.Animations as Animations
import Html.Styled.Attributes as HtmlAttrs
import Json.Encode as Encode
import New.Elemental exposing (Element, svg)
import New.Elemental.Lib.Color as Color exposing (Color)
import New.Elemental.Lib.Size as Size
import Svg.Styled as Svg
import Svg.Styled.Attributes as SvgAttrs


type alias Options =
    { animationDuration : Float
    , dimensions :
        { outerRadius : Size.Px
        , innerRadius : Size.Px
        , trackWidth : Size.Px
        , trackPadding : Size.Px
        }
    , colors :
        { background : Color
        , foreground : Color
        }
    }


viewElement : Options -> Element msg
viewElement { animationDuration, dimensions, colors } =
    let
        outerRadius =
            Size.pxToFloat dimensions.outerRadius

        innerRadius =
            Size.pxToFloat dimensions.innerRadius

        trackWidth =
            Size.pxToFloat dimensions.trackWidth

        trackPadding =
            Size.pxToFloat dimensions.trackPadding

        outerRadius_ =
            String.fromFloat outerRadius

        innerRadius_ =
            String.fromFloat innerRadius

        trackWidth_ =
            String.fromFloat trackWidth

        width =
            outerRadius_

        height =
            outerRadius_

        halfOuterRadius =
            outerRadius / 2

        halfOuterRadius_ =
            String.fromFloat halfOuterRadius

        oneSixthOuterRadius =
            outerRadius / 6

        oneSixthOuterRadius_ =
            String.fromFloat oneSixthOuterRadius

        fiveSixthsOuterRadius =
            oneSixthOuterRadius * 5

        fiveSixthsOuterRadius_ =
            String.fromFloat fiveSixthsOuterRadius

        cursorWidth =
            trackWidth - (2 * trackPadding)

        cursorWidth_ =
            String.fromFloat cursorWidth

        cursorRadius =
            cursorWidth / 2

        cursorRadius_ =
            String.fromFloat cursorRadius

        background =
            Color.toString colors.background

        foreground =
            Color.toString colors.foreground

        gradientId =
            "loading-spinner-gradient"

        maskId =
            "loading-spinner-mask"
    in
    svg <|
        Svg.svg
            [ SvgAttrs.viewBox <| "0 0 " ++ width ++ " " ++ height
            , SvgAttrs.fill "none"
            , SvgAttrs.css
                [ Css.pointerEvents Css.none
                , Css.width <| Css.px outerRadius
                , Css.height <| Css.px outerRadius
                , Css.flexGrow <| Css.int 0
                , Css.flexShrink <| Css.int 0
                ]
            ]
            [ Svg.defs []
                [ Svg.linearGradient
                    [ SvgAttrs.id gradientId
                    , SvgAttrs.x1 halfOuterRadius_
                    , SvgAttrs.y1 oneSixthOuterRadius_
                    , SvgAttrs.x2 halfOuterRadius_
                    , SvgAttrs.y2 fiveSixthsOuterRadius_
                    , SvgAttrs.gradientUnits "userSpaceOnUse"
                    ]
                    [ Svg.stop
                        [ SvgAttrs.offset "0"
                        , SvgAttrs.stopColor foreground
                        , SvgAttrs.stopOpacity "0"
                        ]
                        []
                    , Svg.stop
                        [ SvgAttrs.offset "0.7"
                        , SvgAttrs.stopColor foreground
                        , SvgAttrs.stopOpacity "1"
                        ]
                        []
                    , Svg.stop
                        [ SvgAttrs.offset "1"
                        , SvgAttrs.stopColor foreground
                        , SvgAttrs.stopOpacity "1"
                        ]
                        []
                    ]
                ]
            , Svg.mask
                [ SvgAttrs.id maskId
                , SvgAttrs.maskUnits "userSpaceOnUse"
                , SvgAttrs.x halfOuterRadius_
                , SvgAttrs.y "1"
                , SvgAttrs.width halfOuterRadius_
                , SvgAttrs.height outerRadius_
                , HtmlAttrs.property "mask-type" <| Encode.string "alpha"
                ]
                [ Svg.rect
                    [ SvgAttrs.width halfOuterRadius_
                    , SvgAttrs.height outerRadius_
                    , SvgAttrs.x halfOuterRadius_
                    , SvgAttrs.y "0"
                    , SvgAttrs.fill "#ffffff"
                    ]
                    []
                ]
            , Svg.circle
                [ SvgAttrs.cx halfOuterRadius_
                , SvgAttrs.cy halfOuterRadius_
                , SvgAttrs.r innerRadius_
                , SvgAttrs.stroke background
                , SvgAttrs.strokeWidth trackWidth_
                ]
                []
            , Svg.g
                [ SvgAttrs.css
                    [ Css.animationName spin
                    , Css.animationDuration <| Css.ms animationDuration
                    , Css.property "animation-iteration-count" "infinite"
                    , Css.property "animation-timing-function" "linear"
                    , Css.property "transform-origin" "50% 50%"
                    ]
                ]
                [ Svg.g [ SvgAttrs.mask <| "url('#" ++ maskId ++ "')" ]
                    [ Svg.circle
                        [ SvgAttrs.cx halfOuterRadius_
                        , SvgAttrs.cy halfOuterRadius_
                        , SvgAttrs.r innerRadius_
                        , SvgAttrs.stroke <| "url('#" ++ gradientId ++ "')"
                        , SvgAttrs.strokeWidth cursorWidth_
                        ]
                        []
                    ]
                , Svg.circle
                    [ SvgAttrs.cx halfOuterRadius_
                    , SvgAttrs.cy <| String.fromFloat <| outerRadius - 3
                    , SvgAttrs.r cursorRadius_
                    , SvgAttrs.fill foreground
                    ]
                    []
                ]
            ]


spin : Animations.Keyframes {}
spin =
    Animations.keyframes
        [ ( 0, [ Animations.transform [ Css.rotate <| Css.deg 0 ] ] )
        , ( 100, [ Animations.transform [ Css.rotate <| Css.deg 360 ] ] )
        ]
