module Example.Component.Switches exposing (..)

import Css
import Elemental.Form.Field.Checkbox as CheckboxField
import Elemental.Form.Field.Switch as SwitchField
import Elemental.Form.Validate as V
import Elemental.Layout as L
import Elemental.View.Form.Field as Support
import Elemental.View.Form.Field.Checkbox as Checkbox
import Elemental.View.Form.Field.Switch as Switch
import Example.Form.Field.Checkbox as CheckboxField
import Example.Form.Field.Switch as SwitchField
import Example.Layout as L
import Example.Theme exposing (Theme)
import Example.View.Form.Field.Checkbox as Checkbox
import Example.View.Form.Field.Switch as Switch
import Html.Styled as H



-- MODEL


type alias Flags =
    ()


type alias Model =
    { isSwitchOn : Bool
    , isChecked : Bool
    , switchFieldModel : SwitchField.Model
    , checkboxFieldModel : CheckboxField.Model
    }


init : Flags -> Model
init _ =
    let
        switchFieldModel =
            SwitchField.field.init
                { value = False
                , validator = V.firstError []
                }
                |> Tuple.first

        checkboxFieldModel =
            CheckboxField.field.init
                { value = False
                , validator = V.firstError []
                }
                |> Tuple.first
    in
    { isSwitchOn = False
    , isChecked = False
    , switchFieldModel = switchFieldModel
    , checkboxFieldModel = checkboxFieldModel
    }



-- UPDATE


type Msg
    = NoOp
    | ToggledSwitch Bool
    | GotSwitchFieldMsg SwitchField.Msg
    | ToggledCheckbox Bool
    | GotCheckboxFieldMsg CheckboxField.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            )

        ToggledSwitch newValue ->
            ( { model | isSwitchOn = newValue }
            , Cmd.none
            )

        ToggledCheckbox newValue ->
            ( { model | isChecked = newValue }
            , Cmd.none
            )

        GotSwitchFieldMsg msg_ ->
            let
                ( switchFieldModel, switchFieldMsg, maybeInteraction ) =
                    SwitchField.field.update msg_ model.switchFieldModel

                _ =
                    Debug.log "" maybeInteraction
            in
            ( { model | switchFieldModel = switchFieldModel }
            , Cmd.map GotSwitchFieldMsg switchFieldMsg
            )

        GotCheckboxFieldMsg msg_ ->
            let
                ( checkboxFieldModel, checkboxFieldMsg, maybeInteraction ) =
                    CheckboxField.field.update msg_ model.checkboxFieldModel

                _ =
                    Debug.log "" maybeInteraction
            in
            ( { model | checkboxFieldModel = checkboxFieldModel }
            , Cmd.map GotCheckboxFieldMsg checkboxFieldMsg
            )



-- VIEW


view theme model =
    L.viewColumn L.Normal
        []
        (viewSwitchViews theme L.layout model.isSwitchOn
            ++ viewFormSwitches theme model.switchFieldModel
            ++ viewCheckboxViews theme L.layout model.isChecked
            ++ viewFormCheckboxes theme model.checkboxFieldModel
        )


viewSwitchViews : Theme -> L.Layout Msg -> Bool -> List (H.Html Msg)
viewSwitchViews theme layout isSwitchOn =
    let
        switchOptions =
            Switch.toOptions
                { theme = theme
                , layout = layout
                , disabled = False
                , size = Switch.Small
                , onToggle = \_ -> NoOp
                , text = "Switch Text"
                , spacerMultiples =
                    { y = \_ -> 2
                    , text = \_ -> 2
                    }
                }
    in
    [ L.viewRow L.Normal
        []
        [ viewSwitches
            { options = switchOptions
            , size = Switch.Small
            , title = "Small Size"
            , isSwitchOn = isSwitchOn
            }
        , L.layout.spacerX 16
        , viewSwitches
            { options = switchOptions
            , size = Switch.Medium
            , title = "Medium Size"
            , isSwitchOn = isSwitchOn
            }
        ]
    ]


viewSwitches :
    { options : Switch.Options Msg
    , size : Switch.Size
    , title : String
    , isSwitchOn : Bool
    }
    -> H.Html Msg
viewSwitches { options, size, title, isSwitchOn } =
    L.viewColumn L.Normal
        [ Css.alignSelf Css.start ]
        [ H.h6 [] [ H.text title ]
        , Switch.view
            { options
                | disabled = False
                , text = "Interactive"
                , size = size
                , onToggle = ToggledSwitch
            }
            isSwitchOn
        , Switch.view
            { options
                | disabled = False
                , text = "On"
                , size = size
            }
            True
        , Switch.view
            { options
                | disabled = False
                , text = "Off"
                , size = size
            }
            False
        , Switch.view
            { options
                | disabled = True
                , text = "Disabled On"
                , size = size
            }
            True
        , Switch.view
            { options
                | disabled = True
                , text = "Disabled Off"
                , size = size
            }
            False
        ]


viewFormSwitches : Theme -> SwitchField.Model -> List (H.Html Msg)
viewFormSwitches theme switchFieldModel =
    let
        switchOptions : SwitchField.Options
        switchOptions =
            SwitchField.toOptions
                { theme = theme
                , disabled = False
                , size = Switch.Small
                , label = "Enable 2FA?"
                , switchText = "Disabled Switch Form Field"
                , support = Support.Text ""
                , required = True
                , spacerMultiples =
                    { y = \_ -> 2
                    , text = \_ -> 2
                    }
                }
    in
    [ H.h6 [] [ H.text "Form Switches" ]
    , L.layout.spacerY 2
    , H.form []
        [ SwitchField.field.view
            { switchOptions
                | switchText = "Switch Form Field"
            }
            switchFieldModel
            |> H.map GotSwitchFieldMsg
        , L.layout.spacerY 4
        , SwitchField.field.view
            { switchOptions
                | disabled = True
                , switchText = "Disabled Switch Form Field"
            }
            switchFieldModel
            |> H.map GotSwitchFieldMsg
        , L.layout.spacerY 4
        , SwitchField.field.view
            { switchOptions
                | switchText = "Switch with Error"
            }
            { switchFieldModel
                | errors =
                    if SwitchField.field.getValue switchFieldModel then
                        []

                    else
                        [ "Two-factor authentication is required for admin accounts" ]
            }
            |> H.map GotSwitchFieldMsg
        , L.layout.spacerY 4
        , SwitchField.field.view
            { switchOptions
                | switchText = "Switch with Support Text"
                , support = Support.Text "Some support text"
            }
            switchFieldModel
            |> H.map GotSwitchFieldMsg
        ]
    , L.layout.spacerY 2
    ]


viewCheckboxViews : Theme -> L.Layout Msg -> Bool -> List (H.Html Msg)
viewCheckboxViews theme layout isCheckboxOn =
    let
        checkboxOptions =
            Checkbox.toOptions
                { theme = theme
                , layout = layout
                , disabled = False
                , size = Checkbox.Small
                , onToggle = \_ -> NoOp
                , text = "Checkbox Text"
                , spacerMultiples =
                    { y = \_ -> 2
                    , text = \_ -> 2
                    }
                }
    in
    [ L.viewRow L.Normal
        []
        [ viewCheckboxes
            { options = checkboxOptions
            , size = Checkbox.Small
            , title = "Small Size"
            , isCheckboxOn = isCheckboxOn
            }
        , L.layout.spacerX 16
        , viewCheckboxes
            { options = checkboxOptions
            , size = Checkbox.Medium
            , title = "Medium Size"
            , isCheckboxOn = isCheckboxOn
            }
        ]
    ]


viewCheckboxes :
    { options : Checkbox.Options Msg
    , size : Checkbox.Size
    , title : String
    , isCheckboxOn : Bool
    }
    -> H.Html Msg
viewCheckboxes { options, size, title, isCheckboxOn } =
    L.viewColumn L.Normal
        [ Css.alignSelf Css.start ]
        [ H.h6 [] [ H.text title ]
        , Checkbox.view
            { options
                | disabled = False
                , text = "Interactive"
                , size = size
                , onToggle = ToggledCheckbox
            }
            isCheckboxOn
        , Checkbox.view
            { options
                | disabled = False
                , text = "Selected"
                , size = size
            }
            True
        , Checkbox.view
            { options
                | disabled = False
                , text = "Unselected"
                , size = size
            }
            False
        , Checkbox.view
            { options
                | disabled = True
                , text = "Disabled Selected"
                , size = size
            }
            True
        , Checkbox.view
            { options
                | disabled = True
                , text = "Disabled Unselected"
                , size = size
            }
            False
        ]


viewFormCheckboxes : Theme -> CheckboxField.Model -> List (H.Html Msg)
viewFormCheckboxes theme checkboxFieldModel =
    let
        checkboxOptions : CheckboxField.Options
        checkboxOptions =
            CheckboxField.toOptions
                { theme = theme
                , disabled = False
                , size = Checkbox.Small
                , label = "Enable 2FA?"
                , checkboxText = "Disabled Checkbox Form Field"
                , support = Support.Text ""
                , required = True
                , spacerMultiples =
                    { y = \_ -> 2
                    , text = \_ -> 2
                    }
                }
    in
    [ H.h6 [] [ H.text "Form Checkboxes" ]
    , L.layout.spacerY 2
    , H.form []
        [ CheckboxField.field.view
            { checkboxOptions
                | checkboxText = "Checkbox Form Field"
            }
            checkboxFieldModel
            |> H.map GotCheckboxFieldMsg
        , L.layout.spacerY 4
        , CheckboxField.field.view
            { checkboxOptions
                | disabled = True
                , checkboxText = "Disabled Checkbox Form Field"
            }
            checkboxFieldModel
            |> H.map GotCheckboxFieldMsg
        , L.layout.spacerY 4
        , CheckboxField.field.view
            { checkboxOptions
                | checkboxText = "Checkbox with Error"
            }
            { checkboxFieldModel
                | errors =
                    if CheckboxField.field.getValue checkboxFieldModel then
                        []

                    else
                        [ "Two-factor authentication is required for admin accounts" ]
            }
            |> H.map GotCheckboxFieldMsg
        , L.layout.spacerY 4
        , CheckboxField.field.view
            { checkboxOptions
                | checkboxText = "Checkbox with Support Text"
                , support = Support.Text "Some support text"
            }
            checkboxFieldModel
            |> H.map GotCheckboxFieldMsg
        ]
    , L.layout.spacerY 2
    ]
