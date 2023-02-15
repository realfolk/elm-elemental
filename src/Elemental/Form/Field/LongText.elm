module Elemental.Form.Field.LongText exposing
    ( Flags
    , Model
    , Msg
    , Msg_
    , Options
    , field
    )

import Elemental.Form.Field as Field
import Elemental.Form.Interaction as Interaction exposing (Interaction)
import Elemental.View.Form.Field.Textarea as Textarea
import Html.Styled as H


type alias Field msg =
    Field.Field {} {} Msg_ msg Options_ String


field : Field msg
field =
    Field.build
        { init = init
        , update = update
        , view = view
        }



-- MODEL


type alias Flags =
    Field.Flags {} String


type alias Model =
    Field.Model {} String


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
    = ChangedInput String


update : Msg_ -> Model -> ( Model, Cmd Msg_ )
update msg model =
    case msg of
        ChangedInput newValue ->
            ( { model | value = newValue }, Cmd.none )



-- VIEW


type alias Options msg =
    Field.Options Msg_ msg Options_


type alias Options_ =
    { widgetTheme : Textarea.Theme
    , placeholder : String
    , height : Float
    }


view : Options msg -> Model -> H.Html msg
view options model =
    let
        fieldColors =
            options.widgetTheme.colors
    in
    Textarea.view
        { theme =
            { colors =
                { background = fieldColors.background
                , border = fieldColors.border
                , focusHighlight = fieldColors.focusHighlight
                , foreground = fieldColors.foreground
                }
            , borderRadius = options.widgetTheme.borderRadius
            , spacerMultiples = options.widgetTheme.spacerMultiples
            }
        , layout = options.layout
        , disabled = options.disabled
        , error = Field.hasError model
        , placeholder = options.placeholder
        , height = options.height
        , onInput = ChangedInput >> Field.toFieldMsg >> options.onChange
        , interaction = options.interaction
        }
        model.value
