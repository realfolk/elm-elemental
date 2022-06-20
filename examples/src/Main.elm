module Main exposing (main)

import Browser as B
import Browser.Dom as BD
import Browser.Navigation as B
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
import Example.View.Components.Inputs as Inputs
import Example.View.Components.Switches as Switches
import Example.View.ThemeButton as ThemeButton
import Example.View.ThemeControls.BorderRadiusControls as BorderRadiusControls
import Example.View.ThemeControls.ColorControls as ColorControls
import Example.View.ThemeControls.TypographyControls as TypographyControls
import Example.View.ThemeEditor as ThemeEditor
import Html.Styled as H
import Html.Styled.Attributes as HA
import Html.Styled.Events as HE
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
    , inputs : Inputs.Model
    , showStyles : Bool
    }


init : () -> Url.Url -> B.Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( { theme = Theme.baseTheme
      , switches = Switches.init ()
      , inputs = Inputs.init ()
      , showStyles = True
      }
    , Cmd.none
    )



--  UPDATE


type Msg
    = NoOp
    | UpdatedTypography ThemeTypography
    | UpdatedColors Colors.Colors
    | UpdatedBorderRadius Theme.ThemeBorderRadiusGenerator
    | UpdatedSwitches Switches.Msg
    | UpdatedInputs Inputs.Msg
    | ScrollTo String
    | ToggleShowStyles
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

        UpdatedBorderRadius generator ->
            let
                theme =
                    model.theme
            in
            ( { model
                | theme =
                    { theme
                        | borderRadius = Theme.generatorToBorderRadius generator
                        , borderRadiusG = generator
                    }
              }
            , Cmd.none
            )

        UpdatedSwitches switchesMsg ->
            let
                ( switchesModel, switchesCmd ) =
                    Switches.update switchesMsg model.switches
            in
            ( { model | switches = switchesModel }, Cmd.map UpdatedSwitches switchesCmd )

        UpdatedInputs inputsMsg ->
            let
                ( inputsModel, inputsCmd ) =
                    Inputs.update inputsMsg model.inputs
            in
            ( { model | inputs = inputsModel }, Cmd.map UpdatedInputs inputsCmd )

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

        ToggleShowStyles ->
            ( { model | showStyles = not model.showStyles }, Cmd.none )



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
        List.map H.toUnstyled <|
            [ themeToCss model.theme
            , L.viewRow
                L.Normal
                [ Css.width <| Css.pct 100
                , Css.overflowX Css.hidden
                , Css.position Css.relative
                , Css.height <| Css.pct 100
                ]
                [ L.viewColumn L.Normal
                    [ Css.width <| Css.pct 100
                    , Css.height <| Css.pct 100
                    , if model.showStyles then
                        Css.padding (Css.px 0)

                      else
                        Css.padding2 (L.layout.computeSpacerPx 4) (L.layout.computeSpacerPx 8)
                    ]
                    [ L.viewColumn L.Normal
                        [ Css.backgroundColor model.theme.colors.background.normal
                        , Css.width <| Css.pct 100
                        , Css.height <| Css.pct 100
                        , if model.showStyles then
                            Css.padding2 (L.layout.computeSpacerPx 4) (L.layout.computeSpacerPx 8)

                          else
                            Css.padding2 (L.layout.computeSpacerPx 8) (L.layout.computeSpacerPx 16)
                        , Css.overflowY Css.auto
                        ]
                        [ L.layout.spacerY 8
                        , viewHeader model.theme model.showStyles
                        , L.layout.spacerY 8
                        , viewTypography model.theme
                        , L.layout.spacerY 12
                        , viewComponents model
                        ]
                    ]
                , viewSidebar model.theme model.showStyles <|
                    viewThemeControls model.theme
                ]
            ]
    }


viewHeader : Theme -> Bool -> H.Html Msg
viewHeader theme showingStyles =
    let
        controlsAttrs =
            []
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
                    [ HE.onClick ToggleShowStyles
                    , HA.css
                        [ Css.cursor Css.pointer
                        , Css.backgroundColor theme.colors.background.alternate
                        , Css.color theme.colors.foreground.regular
                        , Css.displayFlex
                        , Css.padding (Css.px 4)
                        , BorderRadius.toCssStyle theme.borderRadius.global.small.all
                        ]
                    ]
                    [ if showingStyles then
                        Icons.view Icons.ChevronRight 24

                      else
                        Icons.view Icons.ChevronLeft 24
                    ]
                ]
            ]
        ]


viewTypography : Theme -> H.Html msg
viewTypography theme =
    let
        themeTypography =
            theme.typography

        typographySpec =
            [ ( "Heading H4", themeTypography.heading.h4, [] )
            , ( "Heading H5", themeTypography.heading.h5, [] )
            , ( "Body Medium", themeTypography.body.medium, [] )
            , ( "Body Small", themeTypography.body.small, [] )
            , ( "Code"
              , themeTypography.code
              , [ Css.backgroundColor theme.colors.background.code
                , Css.color theme.colors.foreground.code
                , Css.display Css.inlineBlock
                , Css.padding <| L.layout.computeSpacerPx 1
                ]
              )
            ]

        viewTypographySpec ( name, typography, attrs ) =
            viewRow
                { typography = typography
                , attrs = attrs
                , name = name
                , family =
                    typography.families
                        |> List.head
                        |> Maybe.withDefault ""
                , fontSize =
                    String.fromFloat typography.size ++ "px"
                , lineHeight =
                    String.fromFloat typography.lineHeight ++ "px"
                }

        rowHeight =
            typographySpec
                |> List.map
                    (\( _, t, _ ) ->
                        t.size
                    )
                |> List.maximum
                |> Maybe.withDefault 20

        viewRow { typography, attrs, name, family, fontSize, lineHeight } =
            H.tr
                [ HA.css
                    [ Css.borderBottom3 (Css.px 1) Css.solid theme.colors.border
                    ]
                ]
                [ H.td
                    [ HA.css
                        [ Css.padding2 (Css.px 8) Css.zero
                        ]
                    ]
                    [ H.div
                        [ HA.css
                            ([ Typography.toStyle <| typography
                             , Css.minWidth <| Css.px 200
                             , Css.minHeight <| Css.px rowHeight
                             , Css.display Css.inlineFlex
                             , Css.alignItems Css.center
                             ]
                                ++ attrs
                            )
                        ]
                        [ H.text name ]
                    ]
                , H.td
                    [ HA.css
                        [ Css.padding2 (Css.px 4) Css.zero
                        ]
                    ]
                    [ H.div
                        [ HA.css
                            [ Css.minWidth <| Css.px 200 ]
                        ]
                        [ H.text family
                        ]
                    ]
                , H.td
                    [ HA.css
                        [ Css.padding2 (Css.px 4) Css.zero
                        ]
                    ]
                    [ H.div
                        [ HA.css
                            [ Css.minWidth <| Css.px 100 ]
                        ]
                        [ H.text fontSize
                        ]
                    ]
                , H.td
                    [ HA.css
                        [ Css.padding2 (Css.px 4) Css.zero
                        ]
                    ]
                    [ H.div
                        [ HA.css
                            [ Css.minWidth <| Css.px 40 ]
                        ]
                        [ H.text lineHeight
                        ]
                    ]
                ]
    in
    L.viewColumn L.Normal
        []
        [ H.h5 []
            [ H.text (String.toUpper "Typography")
            ]
        , L.viewColumn L.Normal
            []
            [ typographySpec
                |> List.map viewTypographySpec
                |> (::)
                    (viewRow
                        { typography = theme.typography.body.medium
                        , attrs = []
                        , name = "Category"
                        , family = "Family"
                        , fontSize = "Font Size"
                        , lineHeight = "Line Height"
                        }
                    )
                |> H.table []
            ]
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
                [ -- H.h4 [ HA.css [ Css.backgroundColor theme.colors.background.alternate ] ]
                  -- [
                  H.text (String.toUpper options.title)

                -- ]
                , L.layout.spacerX 2
                , H.button
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
        [ H.h4 [] [ H.text "Components" ]
        , L.layout.spacerY 2
        , componentSection
            { title = "Buttons"
            , onClick = ScrollTo ColorControls.buttonSectionId
            }
        , L.layout.spacerY 2
        , Buttons.view theme NoOp
        , L.layout.spacerY 8
        , componentSection
            { title = "Switches"
            , onClick = ScrollTo ColorControls.switchSectionId
            }
        , L.layout.spacerY 2
        , Switches.view theme model.switches
            |> H.map UpdatedSwitches
        , L.layout.spacerY 8
        , componentSection
            { title = "Inputs"

            -- , onClick = ScrollTo ColorControls.buttonSectionId
            , onClick = NoOp
            }
        , L.layout.spacerY 2
        , Inputs.view theme model.inputs
            |> H.map UpdatedInputs
        ]


themeControlsId : String
themeControlsId =
    "theme-controls"


sidebarMaxWidth : number
sidebarMaxWidth =
    500


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


viewThemeControls : Theme -> H.Html Msg
viewThemeControls theme =
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
            , L.viewWrappedRow
                []
                [ ThemeButton.viewChangeTheme theme Theme.baseTheme "Base" SelectTheme
                , L.layout.spacerX 2
                , ThemeButton.viewChangeTheme theme Theme.elegantTheme "Elegant" SelectTheme
                , L.layout.spacerX 2
                , ThemeButton.viewChangeTheme theme Theme.adventureTheme "Adventure" SelectTheme
                , L.layout.spacerX 2
                , ThemeButton.viewChangeTheme theme Theme.partyTheme "Party" SelectTheme
                ]
            , L.viewColumn L.Normal
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
                , L.layout.spacerY 4
                , section "Border Radius"
                    [ BorderRadiusControls.view
                        { theme = theme
                        , onUpdateRadii = UpdatedBorderRadius
                        }
                        theme.borderRadiusG
                    ]
                , L.layout.spacerY 4
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
