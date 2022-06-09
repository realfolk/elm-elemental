module Main exposing (main)

import Css
import Css.Global as CssG
import Elemental.Css as ECss
import Elemental.Layout as L
import Elemental.Typography as Typography
import Example.Colors as Colors
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)
import Example.Typography as Typography exposing (ThemeTypography)
import Example.View.ThemeControls.Typography as TypographyControls
import Html.Styled as H
import Html.Styled.Attributes as HA
import Lib
import Lib.Browser as B
import Url


main : Program () Model Msg
main =
    B.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = \_ -> NoOp
        , onUrlChange = \_ -> NoOp
        }



-- MODEL


type alias Model =
    { theme : Theme
    }


init : () -> Url.Url -> B.Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( { theme =
            { colors = Colors.baseColors
            , typography = Typography.baseTypography
            }
      }
    , Cmd.none
    )



--  UPDATE


type Msg
    = NoOp
    | UpdatedTypography ThemeTypography


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UpdatedTypography typography ->
            let
                theme =
                    model.theme
            in
            ( { model | theme = { theme | typography = typography } }, Cmd.none )



--  SUBSCRIPTIONS


subscriptions : Model -> Sub msg
subscriptions _ =
    Sub.none



--  VIEW


view :
    Model
    -> B.Document Msg
view model =
    { title = "Example"
    , body =
        [ themeToCss model.theme
        , L.viewRow
            L.Normal
            [ Css.width <| Css.pct 100, Css.height <| Css.pct 100 ]
            [ L.viewColumn L.Normal
                [ Css.width <| Css.pct 100
                , Css.height <| Css.pct 100
                , Css.padding2 (L.layout.computeSpacerPx 4) (L.layout.computeSpacerPx 4)
                ]
                [ viewTypography model.theme
                , viewComponents
                ]
            , viewThemeControls model.theme
            ]
        ]
    }


viewTypography theme =
    L.viewColumn L.Normal
        []
        [ H.h4 [] [ H.text "Typography" ]
        , L.layout.spacerY 2
        , H.h4 [] [ H.text "H4 Heading" ]
        , L.layout.spacerY 2
        , H.h5 [] [ H.text "H5 Heading" ]
        , L.layout.spacerY 2
        , H.h6 [] [ H.text "H6 Heading" ]
        , L.layout.spacerY 2
        , H.div
            [ HA.css [ Typography.toStyle theme.typography.body.medium ]
            ]
            [ H.text "Body Medium" ]
        , L.layout.spacerY 2
        , H.div
            [ HA.css [ Typography.toStyle theme.typography.body.small ]
            ]
            [ H.text "Body Small" ]
        , L.layout.spacerY 2
        ]


viewComponents =
    H.text ""


viewThemeControls theme =
    L.viewColumn L.Normal
        [ Css.backgroundColor Colors.elevated
        , Css.width <| Css.pct 100
        , Css.height <| Css.vh 100
        , Css.padding2 (L.layout.computeSpacerPx 4) (L.layout.computeSpacerPx 4)
        , Css.borderLeft3 (Css.px 1) Css.solid Colors.border
        , Css.overflowY Css.scroll
        ]
        [ H.h5 [] [ H.text "Customize Typography" ]
        , --
          TypographyControls.view
            { theme = theme
            , onUpdateTypography = UpdatedTypography
            }
            theme.typography
        ]


themeToCss : Theme -> H.Html msg
themeToCss theme =
    CssG.global
        [ CssG.everything
            [ Css.boxSizing Css.borderBox ]
        , CssG.each
            [ CssG.html, CssG.body ]
            [ Css.padding Css.zero
            , Css.margin Css.zero

            -- , Css.backgroundColor theme.colors.background.alternate
            ]
        , CssG.body
            [ ECss.fullViewportHeight

            -- , Css.color theme.colors.foreground.regular
            , Css.minWidth <| Css.px 320
            ]
        , CssG.each
            [ CssG.body, CssG.input, CssG.textarea, CssG.button ]
            [ Typography.toStyle theme.typography.body.medium ]
        , CssG.each
            [ CssG.input, CssG.textarea, CssG.button, CssG.a ]
            [ ECss.noAppearance
            , Css.margin Css.zero
            , Css.padding Css.zero
            , Css.border Css.zero
            , Css.important <| Css.outline Css.none
            ]
        , CssG.each
            [ CssG.input, CssG.textarea ]
            [--  Css.color theme.colors.form.field.foreground.value
            ]
        , CssG.h4 [ Typography.toStyle theme.typography.heading.h4, Css.margin (Css.px 0) ]
        , CssG.h5 [ Typography.toStyle theme.typography.heading.h5, Css.margin (Css.px 0) ]
        , CssG.h6 [ Typography.toStyle theme.typography.heading.h6, Css.margin (Css.px 0) ]
        , CssG.a
            [ Css.color Css.inherit
            , Css.textDecoration Css.inherit
            , Css.property "-webkit-tap-highlight-color" "transparent"
            ]
        , CssG.each
            [ CssG.table, CssG.tr, CssG.th, CssG.td ]
            [ Css.borderCollapse Css.collapse
            , Css.padding Css.zero
            ]
        ]
