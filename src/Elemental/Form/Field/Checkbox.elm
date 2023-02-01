module Elemental.Form.Field.Checkbox exposing
    ( Flags
    , Model
    , Msg
    , Msg_
    , Options
    , field
    )

import Css
import Elemental.Form.Field as Field
import Elemental.Form.Interaction as Interaction exposing (Interaction)
import Elemental.View.Form.Field.Checkbox as Checkbox
import Html.Styled as H


type alias Field =
    Field.Field {} {} Msg_ Options_ Bool


field : Field
field =
    Field.build
        { init = init
        , update = update
        , view = view
        }



-- MODEL


type alias Flags =
    Field.Flags {} Bool


type alias Model =
    Field.Model {} Bool


init : Flags -> ( Model, Cmd Msg_ )
init flags =
    ( { value = flags.value
      , validator = flags.validator
      , errors = []
      }
    , Cmd.none
    )



-- UPDATE


type alias Msg =
    Field.Msg Msg_


type Msg_
    = ToggledCheckbox Bool
    | UserInteracted Interaction


update : Msg_ -> Model -> ( Model, Cmd Msg_, Maybe Interaction )
update msg model =
    case msg of
        ToggledCheckbox newValue ->
            ( { model | value = newValue }, Cmd.none, Nothing )

        UserInteracted interaction ->
            ( model, Cmd.none, Just interaction )



-- VIEW


type alias Options =
    Field.Options Msg_ Options_


type alias Options_ =
    { widgetTheme : Checkbox.Theme
    , checkboxText : String
    , size : Checkbox.Size
    , icon : Checkbox.Size -> Css.Color -> H.Html Msg_
    }


view : Options -> Model -> H.Html Msg_
view options model =
    Checkbox.view
        { theme = options.widgetTheme
        , layout = options.layout
        , text = options.checkboxText
        , disabled = options.disabled
        , size = options.size
        , onToggle = ToggledCheckbox
        , maybeOnInteraction =
            Just <| Interaction.config UserInteracted options.userInteractions
        , icon = options.icon
        }
        model.value
