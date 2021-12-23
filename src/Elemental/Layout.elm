module Elemental.Layout exposing
    ( Alignment(..)
    , Device
    , DeviceSize(..)
    , DeviceType(..)
    , Layout
    , makeLayout
    , viewColumn
    , viewExpandableColumn
    , viewFullViewportColumn
    , viewGrow
    , viewNoGrow
    , viewPushRight
    , viewRow
    , viewScrollable
    )

import Css exposing (int, pct, px)
import Elemental.Css as LibCss
import Html.Styled as H
import Html.Styled.Attributes as HA


type DeviceType
    = Compact
    | Full


type DeviceSize
    = Small
    | Large


type alias Device =
    ( DeviceType, DeviceSize )


type alias Layout msg =
    { breakpoints : Breakpoints
    , containerMinWidth : Float
    , containerMaxWidth : Float
    , resize : Float -> Device
    , computeSpacerSize : Float -> Float
    , computeSpacerPx : Float -> Css.Px
    , spacer : Float -> Float -> H.Html msg
    , spacerX : Float -> H.Html msg
    , spacerY : Float -> H.Html msg
    , pageSpacer : Device -> H.Html msg
    , box : Float -> Float -> Float -> Float -> List (H.Attribute msg) -> List Css.Style -> List (H.Html msg) -> H.Html msg
    , boxX : Float -> List (H.Attribute msg) -> List Css.Style -> List (H.Html msg) -> H.Html msg
    , boxY : Float -> List (H.Attribute msg) -> List Css.Style -> List (H.Html msg) -> H.Html msg
    , boxXY : Float -> List (H.Attribute msg) -> List Css.Style -> List (H.Html msg) -> H.Html msg
    , boxNone : List (H.Attribute msg) -> List Css.Style -> List (H.Html msg) -> H.Html msg
    , gutter : Device -> Float
    , contentWidth : Device -> Float
    , contentMinWidthStyle : Device -> Css.Style
    , contentMaxWidthStyle : Device -> Css.Style
    , section : Device -> Float -> Float -> List (H.Attribute msg) -> List Css.Style -> List (H.Html msg) -> H.Html msg
    , sectionY : Device -> Float -> List (H.Attribute msg) -> List Css.Style -> List (H.Html msg) -> H.Html msg
    , sectionNone : Device -> List (H.Attribute msg) -> List Css.Style -> List (H.Html msg) -> H.Html msg
    , contentSection : Device -> Float -> Float -> List (H.Attribute msg) -> List Css.Style -> List (H.Html msg) -> H.Html msg
    , contentSectionY : Device -> Float -> List (H.Attribute msg) -> List Css.Style -> List (H.Html msg) -> H.Html msg
    , contentSectionNone : Device -> List (H.Attribute msg) -> List Css.Style -> List (H.Html msg) -> H.Html msg
    , viewportBorder : Css.Color -> H.Html msg
    , containerBorder : Device -> Css.Color -> H.Html msg
    , contentBorder : Device -> Css.Color -> H.Html msg
    }


type alias Breakpoints =
    { compactLarge : Float
    , fullSmall : Float
    , fullLarge : Float
    }


makeLayout :
    { breakpoints : Breakpoints
    , baseSize : Float
    , pageSpacerMultipleY : Device -> Float
    , gutterMultiple : Device -> Float
    , contentWidth : Device -> Float
    }
    -> Layout msg
makeLayout options =
    let
        gutter =
            options.gutterMultiple

        containerMinWidth =
            0

        containerMaxWidth =
            options.breakpoints.fullLarge + 2 * gutter ( Full, Large )

        resize width =
            if width >= options.breakpoints.fullLarge then
                ( Full, Large )

            else if width >= options.breakpoints.fullSmall then
                ( Full, Small )

            else if width >= options.breakpoints.compactLarge then
                ( Compact, Large )

            else
                ( Compact, Small )

        computeSpacerSize multiple =
            options.baseSize * multiple

        computeSpacerPx =
            computeSpacerSize >> px

        spacer multipleX multipleY =
            let
                w =
                    computeSpacerPx multipleX

                h =
                    computeSpacerPx multipleY
            in
            H.div
                [ HA.css
                    [ Css.width w
                    , Css.height h
                    , Css.flexGrow <| int 0
                    , Css.flexShrink <| int 0
                    ]
                ]
                []

        spacerX multipleX =
            spacer multipleX 1

        spacerY multipleY =
            spacer 1 multipleY

        pageSpacer =
            spacerY << options.pageSpacerMultipleY

        box topMultiple rightMultiple bottomMultiple leftMultiple customAttrs styles children =
            let
                t =
                    computeSpacerPx topMultiple

                r =
                    computeSpacerPx rightMultiple

                b =
                    computeSpacerPx bottomMultiple

                l =
                    computeSpacerPx leftMultiple

                layoutStyle =
                    Css.padding4 t r b l

                attrs =
                    HA.css (layoutStyle :: styles) :: customAttrs
            in
            H.div attrs children

        boxX xMultiple =
            box 0 xMultiple 0 xMultiple

        boxY yMultiple =
            box yMultiple 0 yMultiple 0

        boxXY multiple =
            box multiple multiple multiple multiple

        boxNone =
            boxXY 0

        contentWidth =
            options.contentWidth

        contentMinWidthStyle device =
            Css.batch
                [ case device of
                    ( Compact, Small ) ->
                        Css.minWidth <| pct 100

                    _ ->
                        contentWidth device
                            |> px
                            |> Css.minWidth
                , Css.important <| Css.maxWidth <| pct 100
                ]

        contentMaxWidthStyle device =
            Css.batch
                [ Css.width <| pct 100
                , contentWidth device
                    |> px
                    |> Css.maxWidth
                ]

        section device topMultiple bottomMultiple customAttrs styles children =
            let
                boxStyles =
                    [ containerStyle
                    ]

                wrapperStyles =
                    styles
                        ++ [ Css.displayFlex
                           , Css.flexFlow2 Css.row Css.noWrap
                           , Css.justifyContent Css.center
                           , Css.flexGrow <| int 0
                           , Css.flexShrink <| int 0
                           ]
            in
            H.div
                [ HA.css wrapperStyles ]
                [ box topMultiple (gutter device) bottomMultiple (gutter device) customAttrs boxStyles children
                ]

        sectionY device yMultiple =
            section device yMultiple yMultiple

        sectionNone device =
            section device 0 0

        containerStyle =
            Css.batch
                [ Css.flexGrow <| int 0
                , Css.flexShrink <| int 0
                , Css.width <| pct 100
                , Css.minWidth <| px containerMinWidth
                , Css.maxWidth <| px containerMaxWidth
                ]

        contentSection device topMultiple bottomMultiple customAttrs styles children =
            section
                device
                topMultiple
                bottomMultiple
                customAttrs
                styles
                [ H.div
                    [ HA.css
                        [ contentMaxWidthStyle device
                        , Css.margin2 Css.zero Css.auto
                        ]
                    ]
                    children
                ]

        contentSectionY device yMultiple =
            contentSection device yMultiple yMultiple

        contentSectionNone device =
            contentSection device 0 0

        viewportBorder borderBackgroundColor =
            H.div
                [ HA.css
                    [ Css.height <| px 1
                    , Css.width <| pct 100
                    , Css.backgroundColor borderBackgroundColor
                    , Css.flexGrow <| int 0
                    , Css.flexShrink <| int 0
                    ]
                ]
                []

        containerBorder device borderBackgroundColor =
            let
                height =
                    Css.height <| px 1

                styles =
                    [ height
                    , Css.overflow Css.hidden
                    ]

                children =
                    [ H.div
                        [ HA.css
                            [ Css.backgroundColor borderBackgroundColor
                            , height
                            ]
                        ]
                        []
                    ]
            in
            section device 0 0 [] styles children

        contentBorder device borderBackgroundColor =
            let
                height =
                    Css.height <| px 1

                styles =
                    [ height
                    , Css.overflow Css.hidden
                    ]

                children =
                    [ H.div
                        [ HA.css
                            [ Css.backgroundColor borderBackgroundColor
                            , height
                            ]
                        ]
                        []
                    ]
            in
            contentSection device 0 0 [] styles children
    in
    { breakpoints = options.breakpoints
    , containerMinWidth = containerMinWidth
    , containerMaxWidth = containerMaxWidth
    , resize = resize
    , computeSpacerSize = computeSpacerSize
    , computeSpacerPx = computeSpacerPx
    , spacer = spacer
    , spacerX = spacerX
    , spacerY = spacerY
    , pageSpacer = pageSpacer
    , box = box
    , boxX = boxX
    , boxY = boxY
    , boxXY = boxXY
    , boxNone = boxNone
    , gutter = gutter
    , contentWidth = contentWidth
    , contentMinWidthStyle = contentMinWidthStyle
    , contentMaxWidthStyle = contentMaxWidthStyle
    , section = section
    , sectionY = sectionY
    , sectionNone = sectionNone
    , contentSection = contentSection
    , contentSectionY = contentSectionY
    , contentSectionNone = contentSectionNone
    , viewportBorder = viewportBorder
    , containerBorder = containerBorder
    , contentBorder = contentBorder
    }



-- CUSTOM LAYOUT VIEWS


type Alignment
    = Normal
    | Left
    | Center
    | Right
    | Stretch


viewRow : Alignment -> List Css.Style -> List (H.Html msg) -> H.Html msg
viewRow alignment additionalStyles =
    let
        mainAlignmentStyle =
            case alignment of
                Normal ->
                    Css.batch []

                Left ->
                    Css.justifyContent Css.flexStart

                Center ->
                    Css.justifyContent Css.center

                Right ->
                    Css.justifyContent Css.flexEnd

                Stretch ->
                    Css.justifyContent Css.stretch

        defaultCrossAlignmentStyle =
            Css.alignItems Css.center

        styles =
            defaultCrossAlignmentStyle :: additionalStyles ++ [ LibCss.row, mainAlignmentStyle ]
    in
    H.div [ HA.css styles ]


viewPushRight : List (H.Html msg) -> H.Html msg
viewPushRight =
    H.div [ HA.css [ Css.marginLeft Css.auto ] ]


viewFullViewportColumn : Bool -> Alignment -> List Css.Style -> List (H.Html msg) -> H.Html msg
viewFullViewportColumn isScrollable alignment additionalStyles =
    let
        fixedStyles =
            if isScrollable then
                [ LibCss.fullViewportHeight
                , LibCss.scroll
                ]

            else
                [ LibCss.fullViewportHeight ]

        styles =
            additionalStyles ++ fixedStyles
    in
    viewColumn alignment styles


viewExpandableColumn : Alignment -> List Css.Style -> List (H.Html msg) -> H.Html msg
viewExpandableColumn alignment additionalStyles =
    let
        styles =
            additionalStyles ++ [ LibCss.grow, LibCss.noShrink ]
    in
    viewColumn alignment styles


viewColumn : Alignment -> List Css.Style -> List (H.Html msg) -> H.Html msg
viewColumn alignment additionalStyles =
    let
        crossAlignmentStyle =
            case alignment of
                Normal ->
                    Css.batch []

                Left ->
                    Css.alignItems Css.flexStart

                Center ->
                    Css.alignItems Css.center

                Right ->
                    Css.alignItems Css.flexEnd

                Stretch ->
                    Css.alignItems Css.stretch

        styles =
            additionalStyles ++ [ LibCss.column, crossAlignmentStyle ]
    in
    H.div [ HA.css styles ]


viewScrollable : List (H.Html msg) -> H.Html msg
viewScrollable children =
    H.div
        [ HA.css
            [ Css.position Css.relative
            , LibCss.fullContainer
            , Css.overflowY Css.hidden
            ]
        ]
        [ H.div
            [ HA.css
                [ Css.position Css.absolute
                , LibCss.fullContainer
                , Css.overflowY Css.auto
                ]
            ]
            children
        ]


viewGrow : List (H.Html msg) -> H.Html msg
viewGrow =
    H.div [ HA.css [ LibCss.grow, LibCss.noShrink ] ]


viewNoGrow : List (H.Html msg) -> H.Html msg
viewNoGrow =
    H.div [ HA.css [ LibCss.noGrow, LibCss.noShrink ] ]
