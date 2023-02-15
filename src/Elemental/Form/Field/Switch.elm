module Elemental.Form.Field.Switch exposing
    ( Flags
    , Model
    , Msg
    , Msg_
    , Options
    , field
    )

import Elemental.Form.Field as Field
import Elemental.Form.Interaction as Interaction exposing (Interaction)
import Elemental.View.Form.Field.Switch as Switch
import Html.Styled as H


type alias Field msg =
    Field.Field {} {} Msg_ msg Options_ Bool


field : Field msg
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
    = ToggledSwitch Bool


update : Msg_ -> Model -> ( Model, Cmd Msg_ )
update msg model =
    case msg of
        ToggledSwitch newValue ->
            ( { model | value = newValue }, Cmd.none )



-- VIEW


type alias Options msg =
    Field.Options Msg_ msg Options_


type alias Options_ =
    { widgetTheme : Switch.Theme
    , switchText : String
    , size : Switch.Size
    }


view : Options msg -> Model -> H.Html msg
view options model =
    Switch.view
        { theme = options.widgetTheme
        , layout = options.layout
        , text = options.switchText
        , disabled = options.disabled
        , size = options.size
        , onToggle = ToggledSwitch >> Field.toFieldMsg >> options.onChange
        , interaction = options.interaction
        }
        model.value
