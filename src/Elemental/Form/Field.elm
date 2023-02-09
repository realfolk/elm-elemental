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
    , toFieldMsg
    )

import Css
import Elemental.Form.Interaction exposing (Interaction)
import Elemental.Form.Validate as V exposing (Validator)
import Elemental.Layout as L
import Elemental.View.Form.Field as Field
import Html.Styled as H


type alias Field flags model fieldMsg msg options value =
    { init : Flags flags value -> ( Model model value, Cmd (Msg fieldMsg) )
    , update : Msg fieldMsg -> Model model value -> ( Model model value, Cmd (Msg fieldMsg) )
    , view : Options fieldMsg msg options -> Model model value -> H.Html msg
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


toFieldMsg : msg -> Msg msg
toFieldMsg =
    FieldChanged


type alias Options fieldMsg msg options =
    { options
        | fieldTheme : Field.Theme
        , onChange : Msg fieldMsg -> msg
        , layout : L.Layout msg
        , label : String
        , support : Field.Support msg
        , required : Bool
        , disabled : Bool
        , maybeToErrorIcon : Maybe (Css.Color -> H.Html msg)
        , interaction : Interaction msg
    }


type alias Error =
    String



-- CREATE A FIELD


type alias BuilderOptions flags model fieldMsg msg options value =
    { init : Flags flags value -> ( Model model value, Cmd fieldMsg )
    , update : fieldMsg -> Model model value -> ( Model model value, Cmd fieldMsg )
    , view : Options fieldMsg msg options -> Model model value -> H.Html msg
    }


build : BuilderOptions flags model fieldMsg msg options value -> Field flags model fieldMsg msg options value
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


init : (Flags flags value -> ( Model model value, Cmd fieldMsg )) -> Flags flags value -> ( Model model value, Cmd (Msg fieldMsg) )
init initField flags =
    initField flags
        |> Tuple.mapSecond (Cmd.map FieldChanged)


update : (Model model value -> Model model value) -> (msg -> Model model value -> ( Model model value, Cmd msg )) -> Msg msg -> Model model value -> ( Model model value, Cmd (Msg msg) )
update validate updateField msg model =
    case msg of
        FieldChanged fieldMsg ->
            updateField fieldMsg model
                |> Tuple.mapFirst validate
                |> Tuple.mapSecond (Cmd.map FieldChanged)


view : (Options fieldMsg msg options -> Model model value -> H.Html msg) -> Options fieldMsg msg options -> Model model value -> H.Html msg
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
        , maybeToErrorIcon = options.maybeToErrorIcon
        }
        viewWidget
