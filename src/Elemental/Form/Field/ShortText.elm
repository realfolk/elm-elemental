module Elemental.Form.Field.ShortText exposing
    ( Flags
    , Icon
    , Model
    , Msg
    , Msg_
    , Options
    , field
    )

import Elemental.Form.Field as Field
import Elemental.Form.Interaction as Interaction exposing (Interaction)
import Elemental.View.Form.Field.Input as Input
import Html.Styled as H


type alias Field msg =
    Field.Field {} {} Msg_ msg (Options_ msg) String


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
    Field.Options Msg_ msg (Options_ msg)


type alias Icon msg =
    Input.Icon msg


type alias Options_ msg =
    { widgetTheme : Input.Theme
    , type_ : Input.Type
    , size : Input.Size
    , icon : Maybe (Icon msg)
    , placeholder : String
    , autofocus : Bool
    , customAttrs : List (H.Attribute msg)
    }


view : Options msg -> Model -> H.Html msg
view options model =
    let
        fieldColors =
            options.widgetTheme.colors
    in
    Input.view
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
        , type_ = options.type_
        , size = options.size
        , icon = options.icon
        , autofocus = options.autofocus
        , disabled = options.disabled
        , error = Field.hasError model
        , placeholder = options.placeholder
        , onInput = ChangedInput >> Field.toFieldMsg >> options.onChange
        , interaction = options.interaction
        , customAttrs = options.customAttrs
        }
        model.value
