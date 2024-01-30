module Elemental.View.Link exposing
    ( Colors
    , Icon(..)
    , Options
    , Style
    , StyleWithTypography
    , Target(..)
    , bold
    , italic
    , noWrap
    , underline
    , uppercase
    , viewCustom
    , wrap
    )

import Css
import Elemental.Css as LibCss
import Elemental.Layout as L
import Elemental.Typography as Typography exposing (Typography)
import Html.Styled as H
import Html.Styled.Attributes as HA
import Html.Styled.Events as HE


type alias Options msg =
    { layout : L.Layout msg
    , style : Style
    , disabled : Bool
    , text : String
    , icon : Icon msg
    , target : Target msg
    , forceHover : Bool -- Force the link to appear in the hover state.
    , tabbable : Bool
    }


type alias Style =
    { typography :
        { normal : Typography
        , interactive : Typography
        , wrap : Bool
        }
    , colors : Colors
    , iconSpacer : Float
    }


type alias Colors =
    { normal : Css.Color
    , hover : Css.Color
    , pressed : Css.Color
    , disabled : Css.Color
    }


viewCustom : Options msg -> H.Html msg
viewCustom options =
    let
        commonStyles =
            [ Typography.toStyle options.style.typography.normal
            , Css.display Css.inlineFlex
            , Css.flexFlow2 Css.noWrap Css.row
            , Css.alignItems Css.center
            , if options.style.typography.wrap then
                Css.whiteSpace Css.normal

              else
                Css.whiteSpace Css.noWrap
            ]

        hoverStyles =
            [ Typography.toStyle options.style.typography.interactive
            , Css.color options.style.colors.hover
            ]

        pressedStyles =
            [ Typography.toStyle options.style.typography.interactive
            , Css.color options.style.colors.pressed
            ]

        css =
            if options.disabled then
                HA.css
                    [ Css.batch commonStyles
                    , Css.color options.style.colors.disabled
                    , Css.cursor Css.notAllowed
                    , Css.pointerEvents Css.none
                    , LibCss.userSelect "none"
                    ]

            else
                HA.css
                    [ Css.batch commonStyles
                    , Css.color options.style.colors.normal
                    , hoverStyles
                        |> (if options.forceHover then
                                Css.batch

                            else
                                Css.hover
                           )
                    , Css.focus hoverStyles
                    , Css.active pressedStyles
                    , Css.cursor Css.pointer
                    ]

        noIcon_ =
            ( H.text "", H.text "" )

        viewIcon icon =
            ( icon
            , if options.text == "" then
                H.text ""

              else
                options.layout.spacerX options.style.iconSpacer
            )

        ( ( leftIcon_, leftSpacer ), ( rightIcon_, rightSpacer ) ) =
            case options.icon of
                NoIcon ->
                    ( noIcon_, noIcon_ )

                LeftIcon icon ->
                    ( viewIcon icon, noIcon_ )

                RightIcon icon ->
                    ( noIcon_, viewIcon icon )

        ( element, targetAttributes ) =
            targetToElementAndAttributes <|
                if options.disabled then
                    NoTarget

                else
                    options.target

        tabIndexAttr =
            if not options.disabled && not options.tabbable then
                [ HA.tabindex -1 ]

            else
                []
    in
    element
        (css :: (tabIndexAttr ++ targetAttributes))
        [ leftIcon_
        , leftSpacer
        , H.text options.text
        , rightSpacer
        , rightIcon_
        ]


type Icon msg
    = NoIcon
    | LeftIcon (H.Html msg)
    | RightIcon (H.Html msg)


type Target msg
    = NoTarget
    | UrlTarget String
    | ClickTarget msg
    | NewTab (Target msg)


type alias Element msg =
    List (H.Attribute msg) -> List (H.Html msg) -> H.Html msg


targetToElementAndAttributes : Target msg -> ( Element msg, List (H.Attribute msg) )
targetToElementAndAttributes target =
    case target of
        NoTarget ->
            ( H.div, [] )

        UrlTarget url_ ->
            ( H.a, [ HA.href url_ ] )

        ClickTarget msg ->
            ( H.div, [ HE.onClick msg ] )

        NewTab t ->
            targetToElementAndAttributes t
                |> Tuple.mapSecond ((::) (HA.target "_blank"))



-- TYPOGRAPHY HELPERS


type alias StyleWithTypography a =
    { a
        | typography :
            { normal : Typography
            , interactive : Typography
            , wrap : Bool
            }
    }


italic : StyleWithTypography a -> StyleWithTypography a
italic =
    mapTypography Typography.italic


bold : StyleWithTypography a -> StyleWithTypography a
bold =
    mapTypography Typography.bold


underline : StyleWithTypography a -> StyleWithTypography a
underline =
    mapTypography Typography.underline


uppercase : StyleWithTypography a -> StyleWithTypography a
uppercase =
    mapTypography Typography.uppercase


mapTypography : (Typography -> Typography) -> StyleWithTypography a -> StyleWithTypography a
mapTypography f style =
    let
        typography =
            { normal = f style.typography.normal
            , interactive = f style.typography.interactive
            , wrap = style.typography.wrap
            }
    in
    { style | typography = typography }


wrap : StyleWithTypography a -> StyleWithTypography a
wrap style =
    let
        typography =
            style.typography

        newTypography =
            { typography | wrap = True }
    in
    { style | typography = newTypography }


noWrap : StyleWithTypography a -> StyleWithTypography a
noWrap style =
    let
        typography =
            style.typography

        newTypography =
            { typography | wrap = False }
    in
    { style | typography = newTypography }
