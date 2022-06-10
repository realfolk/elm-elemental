module Main exposing (main)

import Browser.Dom as BD
import Css
import Css.Global as CssG
import Elemental.Css as ECss
import Elemental.Layout as L
import Elemental.Typography as Typography
import Example.Colors as Colors
import Example.Icons as Icons
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)
import Example.Typography as Typography exposing (ThemeTypography)
import Example.View.Components.Switches as Switches
import Example.View.ThemeControls.Colors as ColorControls
import Example.View.ThemeControls.Typography as TypographyControls
import Html.Styled as H
import Html.Styled.Attributes as HA
import Html.Styled.Events as HE
import Lib
import Lib.Browser as B
import Task
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
    , switches : Switches.Model
    , demoStep : DemoStep
    }


type DemoStep
    = ComponentLibrary
    | ConsistentStyling
    | CommunicationTool


stepToShowHide step =
    case step of
        ComponentLibrary ->
            { showStyle = False, showCommunication = False }

        ConsistentStyling ->
            { showStyle = True, showCommunication = False }

        CommunicationTool ->
            { showStyle = True, showCommunication = True }


init : () -> Url.Url -> B.Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( { theme =
            { colors = Colors.baseColors
            , typography = Typography.baseTypography
            , borderRadius = Theme.borderRadius
            }
      , switches = Switches.init ()
      , demoStep = ComponentLibrary
      }
    , Cmd.none
    )



--  UPDATE


type Msg
    = NoOp
    | UpdatedTypography ThemeTypography
    | UpdatedColors Colors.Colors
    | UpdatedSwitches Switches.Msg
    | ScrollTo String


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

        UpdatedColors colors ->
            let
                theme =
                    model.theme
            in
            ( { model | theme = { theme | colors = colors } }, Cmd.none )

        UpdatedSwitches switchesMsg ->
            let
                ( switchesModel, switchesCmd ) =
                    Switches.update switchesMsg model.switches
            in
            ( { model | switches = switchesModel }, Cmd.map UpdatedSwitches switchesCmd )

        ScrollTo id ->
            ( model
            , BD.getElement id
                |> Task.andThen (\info -> BD.setViewportOf themeControlsId 0 info.scene.height)
                |> Task.attempt (always (Debug.log "" NoOp))
            )



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
            [ Css.backgroundColor model.theme.colors.background.normal
            , Css.width <| Css.pct 100
            , Css.height <| Css.pct 100
            ]
            [ L.viewColumn L.Normal
                [ Css.width <| Css.pct 100
                , Css.height <| Css.pct 100
                , Css.padding2 (L.layout.computeSpacerPx 4) (L.layout.computeSpacerPx 4)
                , Css.overflowY Css.auto
                ]
                [ viewTypography model.theme
                , L.layout.spacerY 12
                , viewComponents model
                ]
            , viewThemeControls model.theme
            ]
        ]
    }


viewTypography : Theme -> H.Html msg
viewTypography theme =
    L.viewColumn L.Normal
        []
        [ H.div
            [ HA.css
                [ Typography.toStyle theme.typography.code
                , Css.color theme.colors.foreground.regular
                ]
            ]
            [ H.text (String.toUpper "Typography") ]
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
        , H.div
            [ HA.css
                [ Typography.toStyle theme.typography.code
                , Css.backgroundColor theme.colors.background.code
                , Css.color theme.colors.foreground.code
                , Css.display Css.inlineBlock
                , Css.padding <| L.layout.computeSpacerPx 1
                ]
            ]
            [ H.text "Code" ]
        , L.layout.spacerY 2
        ]


viewComponents ({ theme } as model) =
    L.viewColumn L.Normal
        []
        [ H.h4 [] [ H.text (String.toUpper "Components") ]
        , L.layout.spacerY 2
        , L.viewRow
            L.Normal
            [ Typography.toStyle theme.typography.code
            , Css.color theme.colors.foreground.regular
            ]
            [ H.text (String.toUpper "Switches")
            , L.layout.spacerX 2
            , H.button
                [ HE.onClick (ScrollTo ColorControls.switchSectionId)
                , HA.css
                    [ Css.cursor Css.pointer
                    , Css.backgroundColor theme.colors.background.normal
                    , Css.color theme.colors.foreground.regular
                    , Css.displayFlex
                    ]
                ]
                [ Icons.view Icons.Palette 20 ]
            ]
        , Switches.view theme model.switches
            |> H.map UpdatedSwitches
        ]


themeControlsId =
    "theme-controls"


viewThemeControls theme =
    H.div
        [ HA.id themeControlsId
        , HA.css
            [ Css.minWidth <| Css.px 700
            , Css.maxWidth <| Css.px 700
            , Css.overflowY Css.scroll
            , Css.height <| Css.vh 100
            , Css.backgroundColor theme.colors.background.alternate
            , Css.borderLeft3 (Css.px 1) Css.solid theme.colors.border
            ]
        ]
        [ L.viewColumn L.Normal
            [ Css.width <| Css.pct 100
            , Css.height <| Css.pct 100
            , Css.padding2 (L.layout.computeSpacerPx 6) (L.layout.computeSpacerPx 6)
            ]
            [ H.h5
                [ HA.css
                    [ Typography.toStyle theme.typography.code
                    , Css.color theme.colors.foreground.regular
                    ]
                ]
                [ H.text (String.toUpper "Customize Typography") ]
            , L.layout.spacerY 2
            , TypographyControls.view
                { theme = theme
                , onUpdateTypography = UpdatedTypography
                }
                theme.typography
            , H.h5
                [ HA.css
                    [ Typography.toStyle theme.typography.code
                    , Css.color theme.colors.foreground.regular
                    ]
                ]
                [ H.text (String.toUpper "Customize Colors") ]
            , L.layout.spacerY 2
            , ColorControls.view
                { theme = theme
                , onUpdateColors = UpdatedColors
                }
                theme.colors
            ]
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
            , Css.backgroundColor theme.colors.background.alternate
            ]
        , CssG.body
            [ ECss.fullViewportHeight
            , Css.color theme.colors.foreground.regular
            , Css.minWidth <| Css.px 320
            ]
        , CssG.pre
            [ Css.padding Css.zero
            , Css.margin Css.zero
            , Typography.toStyle theme.typography.code
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
