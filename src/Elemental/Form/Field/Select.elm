module Elemental.Form.Field.Select exposing
    ( Flags
    , Model
    , Msg
    , Msg_
    , Options
    , field
    )

import Elemental.Form.Field as Field
import Elemental.Form.Interaction as Interaction exposing (Interaction)
import Elemental.View.Form.Field.Select as Select
import Html.Styled as Html exposing (Html)


type alias Field msg value =
    Field.Field {} {} (Msg_ value) msg (Options_ msg value) value


field : Field msg value
field =
    Field.build
        { init = init
        , update = update
        , view = view
        }



-- MODEL


type alias Flags value =
    Field.Flags {} value


type alias Model value =
    Field.Model {} value


init : Flags value -> ( Model value, Cmd (Msg_ value) )
init flags =
    ( { value = flags.value
      , validator = flags.validator
      , errors = []
      }
    , Cmd.none
    )



-- UPDATE


type alias Msg value =
    Field.Msg (Msg_ value)


type Msg_ value
    = ChangedInput (Maybe value)


update : Msg_ value -> Model value -> ( Model value, Cmd (Msg_ value) )
update msg model =
    case msg of
        ChangedInput Nothing ->
            ( model, Cmd.none )

        ChangedInput (Just newValue) ->
            ( { model | value = newValue }, Cmd.none )



-- VIEW


type alias Options msg value =
    Field.Options (Msg_ value) msg (Options_ msg value)


type alias Options_ msg value =
    { widgetTheme : Select.Theme
    , autofocus : Bool
    , viewCaret : Html msg
    , choices : List (Select.Choice value)
    }


view : Options msg value -> Model value -> Html msg
view options model =
    Select.view
        { theme = options.widgetTheme
        , layout = options.layout
        , autofocus = options.autofocus
        , disabled = options.disabled
        , error = Field.hasError model
        , onInput = ChangedInput >> Field.toFieldMsg >> options.onChange
        , interaction = options.interaction
        , viewCaret = options.viewCaret
        , choices = options.choices
        , customAttrs = []
        }
        model.value
