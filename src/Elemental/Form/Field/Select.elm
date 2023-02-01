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


type alias Field value =
    Field.Field {} {} (Msg_ value) (Options_ value) value


field : Field value
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
    | UserInteracted Interaction


update : Msg_ value -> Model value -> ( Model value, Cmd (Msg_ value), Maybe Interaction )
update msg model =
    case msg of
        ChangedInput Nothing ->
            ( model, Cmd.none, Nothing )

        ChangedInput (Just newValue) ->
            ( { model | value = newValue }, Cmd.none, Nothing )

        UserInteracted interaction ->
            ( model, Cmd.none, Just interaction )



-- VIEW


type alias Options value =
    Field.Options (Msg_ value) (Options_ value)


type alias Options_ value =
    { widgetTheme : Select.Theme
    , autofocus : Bool
    , viewCaret : Html (Msg_ value)
    , choices : List (Select.Choice value)
    }


view : Options value -> Model value -> Html (Msg_ value)
view options model =
    Select.view
        { theme = options.widgetTheme
        , layout = options.layout
        , autofocus = options.autofocus
        , disabled = options.disabled
        , error = Field.hasError model
        , onInput = ChangedInput
        , maybeOnInteraction =
            Just <| Interaction.config UserInteracted options.userInteractions
        , viewCaret = options.viewCaret
        , choices = options.choices
        , customAttrs = []
        }
        model.value
