module Example.Layout exposing (..)

import Css
import Elemental.Layout as L exposing (DeviceSize(..), DeviceType(..))
import Html.Styled as H
import Html.Styled.Attributes as HA


layout : L.Layout msg
layout =
    L.makeLayout
        { breakpoints =
            { compactLarge = 784
            , fullSmall = 1024
            , fullLarge = 1248
            }
        , baseSize = 4
        , pageSpacerMultipleY =
            \device ->
                case device of
                    ( Compact, Small ) ->
                        16

                    ( Compact, Large ) ->
                        20

                    ( Full, Small ) ->
                        24

                    ( Full, Large ) ->
                        28
        , gutterMultiple =
            \device ->
                case device of
                    ( Compact, Small ) ->
                        4

                    ( Compact, Large ) ->
                        8

                    ( Full, Small ) ->
                        8

                    ( Full, Large ) ->
                        8
        , contentWidth =
            \device ->
                case device of
                    ( Full, Large ) ->
                        672

                    _ ->
                        640
        }


viewWrappedRow additionalAttrs children =
    H.div
        [ HA.css
            ([ Css.displayFlex
             , Css.flexFlow2 Css.row Css.wrap
             , Css.alignItems Css.center
             , Css.justifyContent Css.flexStart
             ]
                ++ additionalAttrs
            )
        ]
        children


viewSectionHeader theme title otherChildren =
    L.viewRow L.Stretch
        [ Css.backgroundColor theme.colors.background.alternate
        , Css.padding2 (Css.px 10) (Css.px 16)
        , Css.margin2 (Css.px 0) (Css.px -16)
        ]
        [ H.h5 [] [ H.text title ]
        , L.viewPushRight otherChildren
        ]
