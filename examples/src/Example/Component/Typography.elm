module Example.Component.Typography exposing (..)

import Css
import Css.Transitions
import Elemental.Css.BorderRadius as BorderRadius
import Elemental.Form.Field.ShortText as ShortTextField
import Elemental.Form.Field.Switch as SwitchField
import Elemental.Form.Validate as V
import Elemental.Layout as L
import Elemental.Typography as Typography
import Elemental.View.Button as Button
import Elemental.View.Form.Field as Support
import Elemental.View.Form.Field.Input as Input
import Elemental.View.Form.Field.Switch as Switch
import Example.Form.Field.ShortText as ShortTextField
import Example.Form.Field.Switch as SwitchField
import Example.Gen.Tree
import Example.Gen.Typography as Typography exposing (TypographyTree)
import Example.Icons as Icons
import Example.Layout as L
import Example.Theme exposing (Theme)
import Example.Typography as Typography
import Example.Typography.Helpers as Typography
import Example.View.ThemeButton as Button
import Example.View.TypographyEditor
import Html.Styled as H
import Html.Styled.Attributes as HA
import Html.Styled.Events as HE
import Lib.Function exposing (flip)
import Lib.Task



-- MODEL


type alias Flags =
    ()


type alias Model =
    { showImportedFontsSwitch : SwitchField.Model
    , customFonts : List String
    , importFontInput : ShortTextField.Model
    , loadingFont : Bool
    , createStyleInput : ShortTextField.Model
    , selectedStyle : Maybe ( String, Typography.Typography )
    }


init : Flags -> Model
init _ =
    { showImportedFontsSwitch =
        SwitchField.field.init
            { value = False
            , validator = V.firstError []
            }
            |> Tuple.first
    , customFonts = []
    , loadingFont = False
    , importFontInput =
        ShortTextField.field.init
            { value = ""
            , validator = V.firstError [ V.ifBlank identity "Can't be empty" ]
            }
            |> Tuple.first
    , createStyleInput =
        ShortTextField.field.init
            { value = ""
            , validator = V.firstError []
            }
            |> Tuple.first
    , selectedStyle = Nothing
    }


addCustomFont : String -> Model -> Model
addCustomFont fontName model =
    { model
        | customFonts = model.customFonts ++ [ fontName ]
        , showImportedFontsSwitch = SwitchField.field.setValue True model.showImportedFontsSwitch
    }


finishedLoadingFont : Model -> Model
finishedLoadingFont model =
    { model | loadingFont = False }



-- UPDATE


type Msg
    = NoOp
    | GotSwitchFieldMsg SwitchField.Msg
    | UpdatedAddFontInput ShortTextField.Msg
    | ClickedImportGoogleFontButton
    | UpdatedCreateStyleInput ShortTextField.Msg
    | ClickedCreateStyleButton
    | SelectedStyle (Maybe ( String, Typography.Typography ))
    | UpdatedStyle ( String, Typography.Typography )


type alias Options handler =
    { onImportGoogleFont : String -> handler
    , typographyTree : TypographyTree
    , onUpdateStyle : TypographyTree -> handler
    }


update : Options handler -> Msg -> Model -> ( Model, Cmd Msg, Cmd handler )
update options msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            , Cmd.none
            )

        GotSwitchFieldMsg msg_ ->
            let
                ( switchFieldModel, switchFieldMsg, maybeInteraction ) =
                    SwitchField.field.update msg_ model.showImportedFontsSwitch
            in
            ( { model
                | showImportedFontsSwitch = switchFieldModel
              }
            , Cmd.map GotSwitchFieldMsg switchFieldMsg
            , Cmd.none
            )

        UpdatedAddFontInput msg_ ->
            let
                ( shortTextFieldModel, shortTextFieldMsg, maybeInteraction ) =
                    ShortTextField.field.update msg_ model.importFontInput
            in
            ( { model | importFontInput = shortTextFieldModel }
            , Cmd.map UpdatedAddFontInput shortTextFieldMsg
            , Cmd.none
            )

        ClickedImportGoogleFontButton ->
            let
                fontName =
                    ShortTextField.field.getValue model.importFontInput
            in
            if List.member fontName model.customFonts then
                ( model
                , Cmd.none
                , Cmd.none
                )

            else
                ( { model | loadingFont = True }
                , Cmd.none
                , Lib.Task.dispatch <| options.onImportGoogleFont fontName
                )

        UpdatedCreateStyleInput msg_ ->
            let
                ( shortTextFieldModel, shortTextFieldMsg, maybeInteraction ) =
                    ShortTextField.field.update msg_ model.createStyleInput
            in
            ( { model | createStyleInput = shortTextFieldModel }
            , Cmd.map UpdatedAddFontInput shortTextFieldMsg
            , Cmd.none
            )

        ClickedCreateStyleButton ->
            let
                styleName =
                    ShortTextField.field.getValue model.createStyleInput

                treeList =
                    options.typographyTree
                        |> Example.Gen.Tree.toList
            in
            if List.member styleName (List.map Tuple.first treeList) then
                ( { model
                    | createStyleInput =
                        ShortTextField.field.getErrors model.createStyleInput
                            |> (::) "Already exists"
                            |> flip ShortTextField.field.setErrors model.createStyleInput
                  }
                , Cmd.none
                , Cmd.none
                )

            else
                let
                    ( style, updatedTree ) =
                        Typography.insertStyle styleName options.typographyTree
                in
                ( { model
                    | createStyleInput = ShortTextField.field.setValue "" model.createStyleInput
                    , selectedStyle = Just style
                  }
                , Cmd.none
                , Lib.Task.dispatch <| options.onUpdateStyle updatedTree
                )

        UpdatedStyle ( styleName, typography ) ->
            ( { model | selectedStyle = Just ( styleName, typography ) }
            , Cmd.none
            , Lib.Task.dispatch <| options.onUpdateStyle (Example.Gen.Tree.insert styleName typography options.typographyTree)
            )

        SelectedStyle selectedStyle ->
            ( { model | selectedStyle = selectedStyle }
            , Cmd.none
            , Cmd.none
            )



-- VIEW


view : Theme -> TypographyTree -> Model -> H.Html Msg
view theme typography model =
    let
        switchOptions : SwitchField.Options
        switchOptions =
            SwitchField.toOptions
                { theme = theme
                , disabled = False
                , size = Switch.Small
                , label = ""
                , switchText = "Show unused fonts"
                , support = Support.Text ""
                , required = True
                , spacerMultiples =
                    { y = \_ -> 2
                    , text = \_ -> 2
                    }
                }
    in
    L.viewColumn L.Normal
        []
        [ L.viewSectionHeader theme "Typography" <|
            [ SwitchField.field.view
                switchOptions
                model.showImportedFontsSwitch
                |> H.map GotSwitchFieldMsg
            ]
        , L.layout.spacerY 4
        , L.viewColumn L.Normal [] <|
            (Typography.fontFamilies typography
                |> (\usedFontFamilies ->
                        if SwitchField.field.getValue model.showImportedFontsSwitch then
                            usedFontFamilies ++ List.map (\font -> ( font, [] )) model.customFonts

                        else
                            usedFontFamilies
                   )
                |> List.map
                    (\( name, fallbackFonts ) ->
                        L.viewWrappedRow
                            [ Css.fontFamilies (name :: fallbackFonts)
                            , Css.width <| Css.pct 100
                            ]
                            [ H.div [ HA.css [ Css.fontSize (Css.px 32) ] ] [ H.text name ]
                            , L.layout.spacerX 4
                            , L.viewGrow
                                [ L.viewColumn L.Right
                                    [ Css.fontSize (Css.px 16) ]
                                    [ H.div [] [ H.text "0123456789" ]
                                    , H.div [] [ H.text "abcdefghijklmnopqrstuvwxyz" ]
                                    , H.div [] [ H.text <| String.toUpper "abcdefghijklmnopqrstuvwxyz" ]
                                    ]
                                ]
                            ]
                    )
                |> List.intersperse (L.layout.spacerY 8)
            )
        , L.layout.spacerY 4
        , L.viewRow L.Normal
            [ Css.alignItems Css.end ]
            [ ShortTextField.field.view
                (ShortTextField.toOptions
                    { theme = theme
                    , type_ = Input.Text
                    , label = "Add New Font"
                    , support = Support.Text ""
                    , disabled = False
                    , autofocus = False
                    , required = True
                    , placeholder = ""
                    , icon = Nothing
                    }
                )
                model.importFontInput
                |> H.map UpdatedAddFontInput
            , L.layout.spacerX 2
            , L.layout.boxY 2
                []
                []
                [ Button.view
                    { onClick = ClickedImportGoogleFontButton
                    , colors = .secondary
                    , theme = theme
                    , typography = theme.typography.button.medium
                    , borderRadius = theme.borderRadius.button.medium
                    , disabled = False
                    , isLoading = model.loadingFont
                    }
                    { name = "Import Google Font", icon = Button.NoIcon }
                ]
            ]
        , L.viewColumn L.Normal
            []
            []
        , L.layout.spacerY 4
        , L.viewGrow
            [ L.viewRow L.Normal
                [ Css.important (Css.alignItems Css.stretch)
                , Css.minHeight <| Css.px 420
                , Css.border3 (Css.px 1) Css.solid theme.colors.border
                ]
                [ viewList theme model.selectedStyle typography
                , case model.selectedStyle of
                    Just ( styleName, t ) ->
                        H.div
                            [ HA.css
                                [ Css.overflowY Css.auto
                                , Css.borderLeft3 (Css.px 1) Css.solid theme.colors.border
                                ]
                            ]
                            [ L.viewColumn L.Normal
                                [ Css.minHeight <| Css.pct 100
                                , Css.height <| Css.px 420
                                , Css.maxWidth (Css.px 420)
                                , Css.padding2 (Css.px 16) (Css.px 16)
                                ]
                                [ Example.View.TypographyEditor.viewTypography theme
                                    model.customFonts
                                    { styleName = styleName
                                    , onUpdateTypography = Tuple.pair styleName >> UpdatedStyle
                                    , typography = t
                                    }
                                ]
                            ]

                    Nothing ->
                        H.text ""
                ]
            ]

        -- , viewTable theme typography
        , L.layout.spacerY 2
        , L.viewRow L.Normal
            [ Css.alignItems Css.end ]
            [ ShortTextField.field.view
                (ShortTextField.toOptions
                    { theme = theme
                    , type_ = Input.Text
                    , label = "Add New Style"
                    , support = Support.Text ""
                    , disabled = False
                    , autofocus = False
                    , required = True
                    , placeholder = ""
                    , icon = Nothing
                    }
                )
                model.createStyleInput
                |> H.map UpdatedCreateStyleInput
            , L.layout.spacerX 2
            , L.layout.boxY 2
                []
                []
                [ Button.view
                    { onClick = ClickedCreateStyleButton
                    , colors = .secondary
                    , theme = theme
                    , typography = theme.typography.button.medium
                    , borderRadius = theme.borderRadius.button.medium
                    , disabled =
                        model.createStyleInput
                            |> ShortTextField.field.getValue
                            |> (==) ""
                    , isLoading = model.loadingFont
                    }
                    { name = "Create", icon = Button.NoIcon }
                ]
            ]
        ]


viewList : Theme -> Maybe ( String, Typography.Typography ) -> Typography.TypographyTree -> H.Html Msg
viewList theme selectedStyle tree =
    let
        treeList =
            tree
                |> Example.Gen.Tree.toList

        viewTypographySpec ( name, typography ) =
            viewListRow theme (Just name == (selectedStyle |> Maybe.map Tuple.first)) name typography
    in
    L.viewGrow
        [ L.viewColumn L.Normal
            []
            (treeList
                |> List.map viewTypographySpec
            )
        ]


viewListRow : Theme -> Bool -> String -> Typography.Typography -> H.Html Msg
viewListRow theme isSelected name typography =
    H.button
        ([ HE.onClick
            (if isSelected then
                SelectedStyle Nothing

             else
                SelectedStyle <| Just ( name, typography )
            )
         , HA.css
            [ Css.cursor Css.pointer
            , Css.firstChild [ Css.important (Css.borderTop (Css.px 0)) ]
            , Css.hover
                [ Css.backgroundColor theme.colors.background.alternate
                ]
            ]
         ]
            ++ (if isSelected then
                    [ HA.css
                        [ Css.borderBottom3 (Css.px 1) Css.solid theme.colors.border
                        , Css.borderTop3 (Css.px 1) Css.solid theme.colors.border
                        , Css.backgroundColor theme.colors.background.alternate
                        ]
                    ]

                else
                    [ HA.css [ Css.backgroundColor theme.colors.background.normal ] ]
               )
        )
    <|
        [ L.viewColumn L.Normal
            [ if isSelected then
                Css.padding2 (Css.px 8) (Css.px 16)

              else
                Css.padding2 (Css.px 4) (Css.px 16)
            , Css.Transitions.transition
                [ Css.Transitions.height transitionDuration
                , Css.Transitions.padding transitionDuration
                ]
            ]
            [ H.div
                [ HA.css
                    [ Typography.toStyle <| typography
                    , Css.minWidth <| Css.px 200
                    , Css.minHeight <| Css.px 36
                    , Css.display Css.inlineFlex
                    , Css.alignItems Css.center
                    ]
                ]
                [ H.text name ]
            , viewStyleDetails isSelected typography
            ]
        ]


viewStyleDetails : Bool -> Typography.Typography -> H.Html msg
viewStyleDetails isSelected typography =
    let
        smallCode =
            Typography.baseTypography.code
                |> (\t -> { t | size = 13 })
                |> Typography.toStyle
    in
    L.viewRow
        L.Normal
        [ Css.width (Css.px 550)
        , Css.justifyContent Css.spaceBetween
        , Css.height
            (Css.px
                (if isSelected then
                    48

                 else
                    1
                )
            )
        , Css.opacity
            (Css.num
                (if isSelected then
                    1

                 else
                    0
                )
            )
        , if isSelected then
            Css.padding2 (L.layout.computeSpacerPx 2) Css.zero

          else
            Css.padding2 Css.zero Css.zero
        , Css.Transitions.transition
            [ Css.Transitions.height transitionDuration
            , Css.Transitions.padding transitionDuration
            ]
        ]
        [ L.viewColumn L.Left
            []
            [ H.span
                [ HA.css [ smallCode, Css.opacity <| Css.num 0.6 ]
                ]
                [ H.text "Font" ]

            -- , L.layout.spacerY 1
            , H.span
                [ HA.css [ smallCode ]
                ]
                [ H.text
                    (typography.families
                        |> List.head
                        |> Maybe.withDefault ""
                    )
                ]
            ]
        , L.viewColumn L.Left
            []
            [ H.span
                [ HA.css [ smallCode, Css.opacity <| Css.num 0.6 ]
                ]
                [ H.text "Weight" ]

            -- , L.layout.spacerY 1
            , H.span
                [ HA.css [ smallCode ]
                ]
                [ H.text (Typography.weightIntToName typography.normalWeight) ]
            ]
        , L.viewColumn L.Left
            []
            [ H.span
                [ HA.css [ smallCode, Css.opacity <| Css.num 0.6 ]
                ]
                [ H.text "Bold Weight" ]

            -- , L.layout.spacerY 1
            , H.span
                [ HA.css [ smallCode ]
                ]
                [ H.text (Typography.weightIntToName typography.boldWeight) ]
            ]
        , L.viewColumn L.Left
            []
            [ H.span
                [ HA.css [ smallCode, Css.opacity <| Css.num 0.6 ]
                ]
                [ H.text "Size" ]

            -- , L.layout.spacerY 1
            , H.span
                [ HA.css [ smallCode ]
                ]
                [ H.text (String.fromFloat typography.size ++ "px") ]
            ]
        , L.viewColumn L.Left
            []
            [ H.span
                [ HA.css [ smallCode, Css.opacity <| Css.num 0.6 ]
                ]
                [ H.text "Letter spacing" ]

            -- , L.layout.spacerY 1
            , H.span
                [ HA.css [ smallCode ]
                ]
                [ H.text (String.fromFloat typography.lineHeight ++ "px") ]
            ]
        ]


transitionDuration : Float
transitionDuration =
    200
