module Elemental.View.Button exposing
    ( Colors
    , Icon(..)
    , Options
    , Spacers
    , Style
    , Target(..)
    , viewCustom
    )

import Css
import Elemental.Css as LibCss
import Elemental.Css.BorderRadius as BorderRadius
import Elemental.Layout as L
import Elemental.Typography as Typography exposing (Typography)
import Html.Styled as H
import Html.Styled.Attributes as HA
import Html.Styled.Events as HE
import Json.Decode as JD


type alias Options msg =
    { layout : L.Layout msg
    , style : Style
    , text : String
    , icon : Icon msg
    , loadingSpinner : H.Html msg
    , target : Target msg
    }


type alias Style =
    { typography : Typography
    , colors : Colors
    , spacers : Spacers
    , borderRadius : BorderRadius.Style
    }


type alias Colors =
    { foreground :
        { normal : Css.Color
        , disabled : Css.Color
        }
    , background :
        { normal : Css.Color
        , disabled : Css.Color
        , hover : Css.Color
        , pressed : Css.Color
        }
    , focus : Css.Color
    }


type alias Spacers =
    { x : Float
    , y : Float
    , icon : Float
    }


type Icon msg
    = NoIcon
    | LeftIcon (H.Html msg)
    | RightIcon (H.Html msg)



-- VIEW


viewCustom : Options msg -> H.Html msg
viewCustom options =
    let
        ( isDisabled, isLoading ) =
            case options.target of
                Disabled ->
                    ( True, False )

                Loading ->
                    ( False, True )

                _ ->
                    ( False, False )

        normalStyles =
            [ Css.color options.style.colors.foreground.normal
            , Css.backgroundColor options.style.colors.background.normal
            ]

        hoverStyles =
            [ Css.backgroundColor options.style.colors.background.hover
            ]

        focusStyles =
            [ Css.backgroundColor options.style.colors.background.hover
            , LibCss.focusHighlight options.style.colors.focus
            ]

        pressedStyles =
            [ Css.backgroundColor options.style.colors.background.pressed
            ]

        outerCssStyle =
            if isDisabled || isLoading then
                Css.batch
                    [ Css.color options.style.colors.foreground.disabled
                    , Css.backgroundColor options.style.colors.background.disabled
                    , Css.cursor Css.notAllowed
                    ]

            else
                Css.batch
                    [ Css.batch normalStyles
                    , Css.hover hoverStyles
                    , Css.focus focusStyles
                    , Css.active pressedStyles
                    , Css.cursor Css.pointer
                    ]

        outerCss =
            HA.css
                [ Typography.toStyle options.style.typography
                , BorderRadius.toCssStyle options.style.borderRadius
                , Css.displayFlex
                , Css.flexFlow2 Css.noWrap Css.row
                , Css.alignItems Css.center
                , Css.justifyContent Css.center
                , Css.whiteSpace Css.noWrap
                , outerCssStyle
                ]

        ( element, targetAttributes ) =
            targetToElementAndAttributes options.target

        viewInnerContent cssStyles =
            L.viewRow L.Center cssStyles <|
                case options.icon of
                    NoIcon ->
                        [ H.text options.text ]

                    LeftIcon viewIcon ->
                        [ viewIcon
                        , options.layout.spacerX options.style.spacers.icon
                        , H.text options.text
                        ]

                    RightIcon viewIcon ->
                        [ H.text options.text
                        , options.layout.spacerX options.style.spacers.icon
                        , viewIcon
                        ]

        content =
            if isLoading then
                H.div []
                    [ viewInnerContent [ Css.opacity Css.zero ]
                    , options.loadingSpinner
                        |> List.singleton
                        |> H.div
                            [ HA.css
                                [ Css.position Css.absolute
                                , Css.top <| Css.pct 50
                                , Css.left <| Css.pct 50
                                , Css.transform <| Css.translate2 (Css.pct -50) (Css.pct -50)
                                , Css.displayFlex
                                , Css.justifyContent Css.center
                                , Css.alignItems Css.center
                                , Css.flexFlow2 Css.row Css.noWrap
                                ]
                            ]
                    ]

            else
                viewInnerContent []
    in
    element
        (outerCss :: targetAttributes)
        [ options.layout.spacerX options.style.spacers.x
        , H.div
            [ HA.css
                [ Css.flexShrink Css.zero
                , Css.position Css.relative
                ]
            ]
            [ options.layout.spacerY options.style.spacers.y
            , content
            , options.layout.spacerY options.style.spacers.y
            ]
        , options.layout.spacerX options.style.spacers.x
        ]



-- TARGET


type Target msg
    = Disabled
    | Loading
    | UrlTarget Bool String
    | ClickTarget msg
    | SubmitTarget


type alias Element msg =
    List (H.Attribute msg) -> List (H.Html msg) -> H.Html msg


targetToElementAndAttributes : Target msg -> ( Element msg, List (H.Attribute msg) )
targetToElementAndAttributes target =
    case target of
        Disabled ->
            ( H.div, [] )

        Loading ->
            ( H.div, [] )

        UrlTarget newTab url ->
            let
                baseAttrs =
                    [ HA.href url
                    , HA.attribute "role" "button"
                    ]

                attrs =
                    baseAttrs
                        ++ (if newTab then
                                [ HA.target "_blank" ]

                            else
                                []
                           )
            in
            ( H.a, attrs )

        ClickTarget msg ->
            ( H.button, [ HA.type_ "button", HE.stopPropagationOn "click" (JD.map alwaysPreventDefault (JD.succeed msg)) ] )

        SubmitTarget ->
            ( H.button, [ HA.type_ "submit" ] )


alwaysPreventDefault : msg -> ( msg, Bool )
alwaysPreventDefault msg =
    ( msg, True )
