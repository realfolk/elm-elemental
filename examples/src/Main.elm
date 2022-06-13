module Main exposing (main)

import Browser.Dom as BD
import Css
import Css.Global as CssG
import Css.Transitions
import Elemental.Css as ECss
import Elemental.Css.BorderRadius as BorderRadius
import Elemental.Layout as L
import Elemental.Typography as Typography
import Elemental.View.Button as Button
import Example.Colors as Colors
import Example.Icons as Icons
import Example.Layout as L
import Example.Theme as Theme exposing (Theme)
import Example.Typography as Typography exposing (ThemeTypography)
import Example.View.Components.Buttons as Buttons
import Example.View.Components.Switches as Switches
import Example.View.ThemeButton as ThemeButton
import Example.View.ThemeControls.Colors as ColorControls
import Example.View.ThemeControls.Typography as TypographyControls
import Example.View.ThemeEditor as ThemeEditor
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
    | CompleteControl


init : () -> Url.Url -> B.Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( { theme = Theme.baseTheme
      , switches = Switches.init ()
      , demoStep = CompleteControl
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
    | ClickedDemoPrev
    | ClickedDemoNext
    | SelectTheme Theme
    | UpdatedTheme Theme


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

        SelectTheme theme ->
            ( { model | theme = theme }, Cmd.none )

        UpdatedTheme theme ->
            ( { model | theme = theme }, Cmd.none )

        ScrollTo id ->
            ( model
            , BD.getElement id
                |> Task.andThen (\info -> BD.setViewportOf themeControlsId 0 (info.element.y - 20))
                |> Task.attempt (always NoOp)
            )

        ClickedDemoPrev ->
            ( { model | demoStep = prevDemoStep model.demoStep }, Cmd.none )

        ClickedDemoNext ->
            ( { model | demoStep = nextDemoStep model.demoStep }, Cmd.none )



--  SUBSCRIPTIONS


subscriptions : Model -> Sub msg
subscriptions _ =
    Sub.none



--  VIEW


view :
    Model
    -> B.Document Msg
view model =
    let
        showHide =
            stepToShowHide model.demoStep
    in
    { title = "Example"
    , body =
        [ themeToCss model.theme
        , L.viewRow
            L.Normal
            [ Css.backgroundColor model.theme.colors.background.normal
            , Css.width <| Css.vw 100
            , Css.overflowX Css.hidden
            , Css.position Css.relative
            , Css.height <| Css.pct 100
            ]
            [ L.viewColumn L.Normal
                [ Css.width <| Css.pct 100
                , Css.height <| Css.pct 100
                , Css.padding2 (L.layout.computeSpacerPx 4) (L.layout.computeSpacerPx 8)
                , Css.overflowY Css.auto
                ]
                [ L.layout.spacerY 8
                , viewHeader model.theme model.demoStep
                , if model.demoStep == ComponentLibrary then
                    H.text ""

                  else
                    viewTypography model.theme
                , if model.demoStep == ComponentLibrary then
                    H.text ""

                  else
                    L.layout.spacerY 12
                , viewComponents model
                ]
            , viewSidebar model.theme showHide.showStyle <|
                viewThemeControls model.theme showHide.showControls
            ]
        ]
    }


viewHeader : Theme -> DemoStep -> H.Html Msg
viewHeader theme demoStep =
    let
        controlsAttrs =
            [ Css.opacity (Css.num 0.1)
            , Css.hover
                [ Css.opacity (Css.num 1)
                ]
            ]
    in
    L.viewRow L.Normal
        []
        [ H.h4 []
            [ H.text "elm-elemental"
            ]
        , L.layout.spacerY 2
        , L.viewPushRight
            [ L.viewRow L.Normal
                controlsAttrs
                [ H.button
                    [ HE.onClick ClickedDemoPrev
                    , HA.css
                        [ Css.cursor Css.pointer
                        , Css.backgroundColor theme.colors.background.normal
                        , Css.color theme.colors.foreground.regular
                        , Css.displayFlex
                        ]
                    ]
                    [ Icons.view Icons.ChevronLeft 20
                    ]
                , L.layout.spacerY 2
                , H.button
                    [ HE.onClick ClickedDemoNext
                    , HA.css
                        [ Css.cursor Css.pointer
                        , Css.backgroundColor theme.colors.background.normal
                        , Css.color theme.colors.foreground.regular
                        , Css.displayFlex
                        ]
                    ]
                    [ Icons.view Icons.ChevronRight 20
                    ]
                ]
            ]
        ]


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


viewComponents : Model -> H.Html Msg
viewComponents ({ theme } as model) =
    let
        componentSection options =
            L.viewRow
                L.Normal
                [ Typography.toStyle theme.typography.code
                , Css.color theme.colors.foreground.regular
                ]
                [ H.text (String.toUpper options.title)
                , L.layout.spacerX 2
                , if model.demoStep == ComponentLibrary then
                    H.text ""

                  else
                    H.button
                        [ HE.onClick options.onClick
                        , HA.css
                            [ Css.cursor Css.pointer
                            , Css.backgroundColor theme.colors.background.normal
                            , Css.color theme.colors.foreground.regular
                            , Css.displayFlex
                            ]
                        ]
                        [ Icons.view Icons.Palette 20 ]
                ]
    in
    L.viewColumn L.Normal
        []
        [ if model.demoStep == ComponentLibrary then
            H.text ""

          else
            H.h4 [] [ H.text "Components" ]
        , L.layout.spacerY 2
        , componentSection
            { title = "Switches"
            , onClick = ScrollTo ColorControls.switchSectionId
            }
        , L.layout.spacerY 2
        , Switches.view theme model.switches
            |> H.map UpdatedSwitches
        , L.layout.spacerY 8
        , componentSection
            { title = "Buttons"
            , onClick = ScrollTo ColorControls.buttonSectionId
            }
        , L.layout.spacerY 2
        , Buttons.view theme (model.demoStep /= ComponentLibrary) NoOp
        ]


themeControlsId =
    "theme-controls"


sidebarMaxWidth =
    700


viewSidebar : Theme -> Bool -> H.Html msg -> H.Html msg
viewSidebar theme show child =
    let
        transition =
            Css.Transitions.transition
                [ Css.Transitions.transform3 theme.config.transitionDuration.long 0 Css.Transitions.easeOut
                , Css.Transitions.width3 theme.config.transitionDuration.long 0 Css.Transitions.easeOut
                , Css.Transitions.minWidth3 theme.config.transitionDuration.long 0 Css.Transitions.easeOut
                ]

        showHideStyle =
            Css.batch <|
                if show then
                    [ Css.maxWidth <| Css.px sidebarMaxWidth
                    , Css.minWidth <| Css.px sidebarMaxWidth
                    ]

                else
                    [ Css.maxWidth <| Css.px 0
                    , Css.minWidth <| Css.px 0
                    ]

        -- settingsShowHideStyle =
        --     Css.batch <|
        --         if show then
        --             [ Css.width <| Css.px sidebarMaxWidth
        --             ]
        --         else
        --             [ Css.width <| Css.px 0
        --             ]
    in
    H.div
        [ HA.css
            [ transition
            , showHideStyle
            , Css.position Css.relative
            , Css.height <| Css.vh 100
            , Css.overflowX Css.hidden
            ]
        ]
        [ child ]


viewThemeControls theme showControls =
    let
        section title children =
            H.details
                [ HA.css
                    [ Css.backgroundColor theme.colors.background.normal
                    , BorderRadius.toCssStyle theme.borderRadius.global.small.all
                    , Css.border3 (Css.px 1) Css.solid theme.colors.border
                    ]
                ]
                [ H.summary
                    [ HA.css
                        [ Css.cursor Css.pointer

                        -- , Typography.toStyle theme.typography.heading.h6
                        , Css.padding2 (Css.px 10) (Css.px 10)
                        ]
                    ]
                    [ H.text title ]
                , L.viewColumn L.Normal
                    [ Css.width <| Css.pct 100
                    , Css.height <| Css.pct 100
                    , Css.padding2 (L.layout.computeSpacerPx 6) (L.layout.computeSpacerPx 6)
                    , Css.borderTop3 (Css.px 1) Css.solid theme.colors.border
                    ]
                    children
                ]
    in
    H.div
        [ HA.id themeControlsId
        , HA.css
            [ Css.maxWidth <| Css.px sidebarMaxWidth
            , Css.minWidth <| Css.px sidebarMaxWidth
            , Css.width <| Css.px sidebarMaxWidth
            , Css.overflowY Css.scroll
            , Css.height <| Css.vh 100
            , Css.backgroundColor theme.colors.background.alternate
            , Css.borderLeft3 (Css.px 1) Css.solid theme.colors.border
            , Css.position Css.absolute
            , Css.top <| Css.px 0
            , Css.left <| Css.px 0
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
                [ H.text (String.toUpper "Choose A Template") ]
            , L.layout.spacerY 2
            , L.viewWrappedRow []
                [ ThemeButton.viewChangeTheme theme Theme.baseTheme "Base" SelectTheme
                , L.layout.spacerX 2
                , ThemeButton.viewChangeTheme theme Theme.elegantTheme "Elegant" SelectTheme
                , L.layout.spacerX 2
                , ThemeButton.viewChangeTheme theme Theme.adventureTheme "Adventure" SelectTheme
                , L.layout.spacerX 2
                , ThemeButton.viewChangeTheme theme Theme.partyTheme "Party" SelectTheme
                ]
            , if not showControls then
                H.text ""

              else
                L.viewColumn L.Normal
                    []
                    [ L.layout.spacerY 6
                    , section "Typography"
                        [ TypographyControls.view
                            { theme = theme
                            , onUpdateTypography = UpdatedTypography
                            }
                            theme.typography
                        ]
                    , L.layout.spacerY 4
                    , section "Colors"
                        [ ColorControls.view
                            { theme = theme
                            , onUpdateColors = UpdatedColors
                            }
                            theme.colors
                        ]
                    ]
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



-- HELPERS


stepToShowHide : DemoStep -> { showTypography : Bool, showStyle : Bool, showControls : Bool }
stepToShowHide step =
    case step of
        ComponentLibrary ->
            { showTypography = False, showStyle = False, showControls = False }

        ConsistentStyling ->
            { showTypography = True, showStyle = False, showControls = False }

        CommunicationTool ->
            { showTypography = True, showStyle = True, showControls = False }

        CompleteControl ->
            { showTypography = True, showStyle = True, showControls = True }


prevDemoStep step =
    case step of
        ComponentLibrary ->
            ComponentLibrary

        ConsistentStyling ->
            ComponentLibrary

        CommunicationTool ->
            ConsistentStyling

        CompleteControl ->
            CommunicationTool


nextDemoStep step =
    case step of
        ComponentLibrary ->
            ConsistentStyling

        ConsistentStyling ->
            CommunicationTool

        CommunicationTool ->
            CompleteControl

        CompleteControl ->
            CompleteControl
