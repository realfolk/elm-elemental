module Main exposing (main)

import Browser as B
import Browser.Dom as BD
import Browser.Navigation as B
import Css
import Css.Global as CssG
import Css.Transitions
import Elemental.Css as LibCss
import Elemental.Css.BorderRadius as BorderRadius
import Elemental.Form.Field.ShortText as ShortTextField
import Elemental.Form.Validate as V
import Elemental.Layout as L
import Elemental.Typography as Typography
import Elemental.View.Button as Button
import Elemental.View.Form.Field as Support
import Elemental.View.Form.Field.Input as Input
import Elm.ToString
import Example.Colors as Colors
import Example.Component.Buttons as Buttons
import Example.Component.Inputs as Inputs
import Example.Component.Switches as Switches
import Example.Component.Typography as Typography
import Example.Form.Field.ShortText as ShortTextField
import Example.Gen.Theme as GenTheme
import Example.Gen.Tree as GenTree
import Example.Gen.Typography as GenTypo exposing (TypographyTree)
import Example.Icons as Icons
import Example.Layout as L
import Example.Port
import Example.Theme as Theme exposing (Theme)
import Example.Typography as Typography exposing (ThemeTypography)
import Example.View.Codeblock as Codeblock
import Example.View.ThemeButton as ThemeButton
import Example.View.ThemeControls.BorderRadiusControls as BorderRadiusControls
import Example.View.ThemeControls.ColorControls as ColorControls
import Example.View.ThemeControls.TypographyControls as TypographyControls
import Html.Styled as H
import Html.Styled.Attributes as HA
import Html.Styled.Events as HE
import Json.Decode as JD
import Json.Encode as JE
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
    , generatedTheme : GenTheme.Theme
    , typography : Typography.Model
    , switches : Switches.Model
    , inputs : Inputs.Model
    , showStyles : Bool
    }


init : () -> Url.Url -> B.Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( { theme = Theme.baseTheme
      , generatedTheme = GenTheme.baseTheme
      , typography = Typography.init ()
      , switches = Switches.init ()
      , inputs = Inputs.init ()
      , showStyles = False
      }
    , Cmd.none
    )



--  UPDATE


type Msg
    = NoOp
    | GotMessage JD.Value
    | UpdatedTypography GenTypo.TypographyTree
    | AddCustomGoogleFont String
    | UpdatedColors Colors.Colors
    | UpdatedBorderRadius Theme.ThemeBorderRadiusGenerator
    | UpdatedSwitches Switches.Msg
    | UpdatedTypographyComponent Typography.Msg
    | UpdatedInputs Inputs.Msg
    | ScrollTo String
    | ToggleShowStyles
    | SelectTheme ( Theme, GenTheme.Theme )
    | UpdatedTheme Theme


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotMessage value ->
            case decodeEvent value of
                Ok (LoadGoogleFont (Ok fontName)) ->
                    ( { model
                        | typography =
                            Typography.addCustomFont fontName model.typography
                                |> Typography.finishedLoadingFont
                      }
                    , Cmd.none
                    )

                Ok (LoadGoogleFont (Err ())) ->
                    ( { model
                        | typography =
                            model.typography
                                |> Typography.finishedLoadingFont
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        UpdatedTypography typography ->
            let
                { generatedTheme } =
                    model
            in
            ( { model | generatedTheme = { generatedTheme | typography = typography } }, Cmd.none )

        AddCustomGoogleFont fontName ->
            ( model
            , Example.Port.sendMessage <| addCustomFontMessage fontName
            )

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

        UpdatedTypographyComponent typographyMsg ->
            let
                ( typographyModel, typographyCmd, pageCmd ) =
                    Typography.update
                        { onImportGoogleFont = AddCustomGoogleFont
                        , typographyTree = model.generatedTheme.typography
                        , onUpdateStyle = UpdatedTypography
                        }
                        typographyMsg
                        model.typography
            in
            ( { model | typography = typographyModel }
            , Cmd.batch
                [ Cmd.map UpdatedTypographyComponent typographyCmd
                , pageCmd
                ]
            )

        UpdatedInputs inputsMsg ->
            let
                ( inputsModel, inputsCmd ) =
                    Inputs.update inputsMsg model.inputs
            in
            ( { model | inputs = inputsModel }, Cmd.map UpdatedInputs inputsCmd )

        SelectTheme ( theme, generatedTheme ) ->
            ( { model | theme = theme, generatedTheme = generatedTheme }, Cmd.none )

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


subscriptions : Model -> Sub Msg
subscriptions _ =
    Example.Port.receiveMessage GotMessage



-- OUTGOING MESSAGES


addCustomFontMessage fontName =
    JE.object
        [ ( "tag", JE.string "addCustomFont" )
        , ( "value", JE.string fontName )
        ]



-- INCOMING MESSAGES


decodeEvent value =
    JD.decodeValue eventDecoder value


type IncomingMessage
    = LoadGoogleFont (Result () String)


eventDecoder =
    JD.field "tag" JD.string
        |> JD.andThen
            (\tag ->
                case tag of
                    "loadGoogleFont.loaded" ->
                        JD.map (LoadGoogleFont << Ok)
                            (JD.field "value" JD.string)

                    "loadGoogleFont.error" ->
                        JD.succeed (LoadGoogleFont <| Err ())

                    _ ->
                        JD.fail <| "Unexpected tag: " ++ tag
            )



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
                        , Typography.view model.theme model.generatedTheme.typography model.typography
                            |> H.map UpdatedTypographyComponent
                        , L.layout.spacerY 12
                        , viewComponents model
                        ]
                    ]
                , viewSidebar model.theme model.showStyles <|
                    viewThemeControls model.theme model model.typography.customFonts
                ]

            -- , H.div [ HA.css [ Css.padding <| Css.px 16 ] ]
            --     [ viewSection model.theme
            --         "Typography"
            --         [ Codeblock.view model.theme
            --             [ H.div [ HA.css [ Css.whiteSpace Css.preWrap ] ] <|
            --                 [ H.text
            --                     (model.generatedTheme.typography
            --                         |> GenTree.toList
            --                         |> GenTree.fromList "typography"
            --                         |> GenTree.treeToDeclaration GenTypo.typographyToExpression
            --                         |> GenTree.declarationToExp
            --                     )
            --                 ]
            --             ]
            --         ]
            --     ]
            ]
    }


viewHeader : Theme -> Bool -> H.Html Msg
viewHeader theme showingStyles =
    let
        controlsAttrs =
            []
    in
    L.viewColumn L.Normal
        [ Css.width <| Css.pct 100
        ]
        [ L.viewRow L.Normal
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

        -- , H.h5
        --     [ HA.css
        --         [ Typography.toStyle theme.typography.code
        --         , Css.color theme.colors.foreground.regular
        --         ]
        --     ]
        --     [ H.text (String.toUpper "Choose A Template") ]
        , L.layout.spacerY 2
        , L.viewWrappedRow
            []
            [ ThemeButton.viewChangeTheme theme ( Theme.baseTheme, GenTheme.baseTheme ) "Base" SelectTheme
            , L.layout.spacerX 2
            , ThemeButton.viewChangeTheme theme ( Theme.elegantTheme, GenTheme.elegantTheme ) "Elegant" SelectTheme
            , L.layout.spacerX 2
            , ThemeButton.viewChangeTheme theme ( Theme.adventureTheme, GenTheme.adventureTheme ) "Adventure" SelectTheme
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
        [ L.viewSectionHeader theme "Components" <|
            []
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


viewSection theme title children =
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


viewThemeControls : Theme -> Model -> List String -> H.Html Msg
viewThemeControls theme model customFonts =
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
            [ L.viewColumn L.Normal
                []
                [ L.layout.spacerY 6
                , viewSection theme
                    "Typography"
                    [ TypographyControls.view
                        { theme = theme
                        , onUpdateTypography = UpdatedTypography
                        }
                        customFonts
                        model.generatedTheme.typography
                    ]
                , L.layout.spacerY 4
                , viewSection theme
                    "Colors"
                    [ ColorControls.view
                        { theme = theme
                        , onUpdateColors = UpdatedColors
                        }
                        theme.colors
                    ]
                , L.layout.spacerY 4
                , viewSection theme
                    "Border Radius"
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
            [ LibCss.fullViewportHeight
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
            [ LibCss.noAppearance
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
