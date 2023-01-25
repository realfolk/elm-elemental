module Elemental.View.Form.Field exposing
    ( Options
    , Support(..)
    , Theme
    , view
    )

import Css
import Elemental.Layout as L
import Elemental.Typography as Typography exposing (Typography)
import Html.Styled as H
import Html.Styled.Attributes as HA


type alias Options msg =
    { theme : Theme
    , layout : L.Layout msg
    , label : String
    , support : Support msg
    , required : Bool
    , disabled : Bool
    , errors : List String
    , maybeToErrorIcon : Maybe (Css.Color -> H.Html msg)
    }


type alias Theme =
    { colors :
        { error : Css.Color
        , required : Css.Color
        , support : Css.Color
        }
    , typography :
        { label : Typography
        , support : Typography
        }
    }


type Support msg
    = Text String
    | Custom (H.Html msg)


view : Options msg -> H.Html msg -> H.Html msg
view options viewWidget =
    let
        hasError =
            not <| List.isEmpty options.errors

        viewSupportOrErrorMessages =
            if hasError then
                viewErrorMessages options.theme options.layout options.errors

            else
                viewSupport options.theme options.layout options.support
    in
    L.viewColumn
        L.Normal
        []
        [ viewLabel options.theme options.layout options.required hasError options.maybeToErrorIcon options.label
        , viewWidget
        , viewSupportOrErrorMessages
        ]


viewLabel : Theme -> L.Layout msg -> Bool -> Bool -> Maybe (Css.Color -> H.Html msg) -> String -> H.Html msg
viewLabel theme layout isRequired hasError maybeToErrorIcon text =
    if String.isEmpty text then
        viewEmptyLabel

    else
        L.viewColumn
            L.Normal
            []
            [ viewNonEmptyLabel theme layout isRequired hasError maybeToErrorIcon text
            , layout.spacerY 2
            ]


viewEmptyLabel : H.Html msg
viewEmptyLabel =
    H.text ""


viewNonEmptyLabel : Theme -> L.Layout msg -> Bool -> Bool -> Maybe (Css.Color -> H.Html msg) -> String -> H.Html msg
viewNonEmptyLabel theme layout isRequired hasError maybeToErrorIcon text =
    let
        labelTypographyStyle =
            Typography.toStyle theme.typography.label
                
        labelStyle =
            if hasError then
                [ labelTypographyStyle, Css.color theme.colors.error ]

            else
                [ labelTypographyStyle ]
    in
    H.div
        [ HA.css labelStyle ]
        [ L.viewRow
            L.Left
            []
            [ viewErrorIcon theme layout hasError maybeToErrorIcon
            , H.text text
            , viewStar theme layout isRequired
            ]
        ]


viewStar : Theme -> L.Layout msg -> Bool -> H.Html msg
viewStar theme layout isRequired =
    let
        starStyle =
            Css.color theme.colors.required
    in
    if isRequired then
        L.viewRow
            L.Left
            []
            [ layout.spacerX 1
            , H.span [ HA.css [ starStyle ] ] [ H.text "*" ]
            ]

    else
        H.text ""

viewErrorIcon : Theme -> L.Layout msg -> Bool -> Maybe (Css.Color -> H.Html msg) -> H.Html msg
viewErrorIcon theme layout hasError maybeToErrorIcon =
    case (maybeToErrorIcon, hasError) of
        (Just toErrorIcon, True) ->
            L.viewRow
                L.Center
                []
                [ toErrorIcon theme.colors.error
                , layout.spacerX 1
                ]

        _ ->
            H.text ""


viewSupport : Theme -> L.Layout msg -> Support msg -> H.Html msg
viewSupport theme layout support =
    let
        supportStyle =
            Css.batch
                [ Typography.toStyle theme.typography.support
                , Css.color theme.colors.support
                ]

        viewLayout content =
            L.viewColumn
                L.Normal
                []
                [ layout.spacerY 2
                , H.div [ HA.css [ supportStyle ] ] [ content ]
                ]
    in
    case support of
        Text "" ->
            H.text ""

        Text text ->
            viewLayout <| H.text text

        Custom viewCustom ->
            viewLayout <| viewCustom


viewErrorMessages : Theme -> L.Layout msg -> List String -> H.Html msg
viewErrorMessages theme layout errorMessages =
    if List.isEmpty errorMessages then
        H.text ""

    else
        let
            errorMessageStyle =
                Css.batch
                    [ Typography.toStyle theme.typography.support
                    , Css.color theme.colors.error
                    ]

            spacer =
                layout.spacerY 2

            views =
                errorMessages
                    |> List.map (H.text >> List.singleton >> H.div [])
        in
        H.div
            [ HA.css [ errorMessageStyle ] ]
            [ L.viewColumn L.Normal [] (spacer :: views) ]
