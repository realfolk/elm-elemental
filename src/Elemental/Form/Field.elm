module Elemental.Form.Field exposing
    ( BuilderOptions
    , Error
    , Field
    , Flags
    , Model
    , Msg
    , Options
    , build
    , hasError
    )

import Elemental.Form.Validate as V exposing (Validator)
import Elemental.Layout as L
import Elemental.View.Form.Field as Field
import Html.Styled as H


type alias Field flags model msg options value =
    { init : Flags flags value -> ( Model model value, Cmd (Msg msg) )
    , update : Msg msg -> Model model value -> ( Model model value, Cmd (Msg msg) )
    , view : Options msg options -> Model model value -> H.Html (Msg msg)
    , getValue : Model model value -> value
    , setValue : value -> Model model value -> Model model value
    , validate : Model model value -> Model model value
    , isValid : Model model value -> Bool
    , getErrors : Model model value -> List Error
    , setErrors : List Error -> Model model value -> Model model value
    }


type alias Flags flags value =
    { flags
        | value : value
        , validator : Validator Error value
    }


type alias Model model value =
    { model
        | value : value
        , validator : Validator Error value
        , errors : List Error
    }


hasError : { a | errors : List Error } -> Bool
hasError r =
    not <| List.isEmpty r.errors


type Msg msg
    = FieldChanged msg


type alias Options msg options =
    { options
        | fieldTheme : Field.Theme
        , layout : L.Layout msg
        , label : String
        , support : Field.Support msg
        , required : Bool
        , disabled : Bool
    }


type alias Error =
    String



-- CREATE A FIELD


type alias BuilderOptions flags model msg options value =
    { init : Flags flags value -> ( Model model value, Cmd msg )
    , update : msg -> Model model value -> ( Model model value, Cmd msg )
    , view : Options msg options -> Model model value -> H.Html msg
    }


build : BuilderOptions flags model msg options value -> Field flags model msg options value
build options =
    let
        getValue : Model model value -> value
        getValue =
            .value

        setValue : value -> Model model value -> Model model value
        setValue value model =
            { model | value = value }

        validate : Model model value -> Model model value
        validate model =
            let
                validator =
                    model.validator

                result =
                    getValue model
                        |> V.validate validator
            in
            case result of
                Ok value ->
                    { model | value = value, errors = [] }

                Err errors ->
                    { model | errors = errors }

        isValid : Model model value -> Bool
        isValid =
            validate >> .errors >> List.isEmpty

        getErrors : Model model value -> List Error
        getErrors =
            .errors

        setErrors : List Error -> Model model value -> Model model value
        setErrors errors model =
            { model | errors = errors }
    in
    { init = init options.init
    , update = update validate options.update
    , view = view options.view
    , getValue = getValue
    , setValue = setValue
    , validate = validate
    , isValid = isValid
    , getErrors = getErrors
    , setErrors = setErrors
    }



-- HELPERS


init : (Flags flags value -> ( Model model value, Cmd msg )) -> Flags flags value -> ( Model model value, Cmd (Msg msg) )
init initField flags =
    initField flags
        |> Tuple.mapSecond (Cmd.map FieldChanged)


update : (Model model value -> Model model value) -> (msg -> Model model value -> ( Model model value, Cmd msg )) -> Msg msg -> Model model value -> ( Model model value, Cmd (Msg msg) )
update validate updateField msg model =
    case msg of
        FieldChanged fieldMsg ->
            updateField fieldMsg model
                |> Tuple.mapBoth validate (Cmd.map FieldChanged)


view : (Options msg options -> Model model value -> H.Html msg) -> Options msg options -> Model model value -> H.Html (Msg msg)
view viewField options model =
    let
        viewWidget =
            viewField options model
    in
    Field.view
        { theme = options.fieldTheme
        , layout = options.layout
        , label = options.label
        , support = options.support
        , required = options.required
        , disabled = options.disabled
        , errors = model.errors
        }
        viewWidget
        |> H.map FieldChanged
