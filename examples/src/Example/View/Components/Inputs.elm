module Example.View.Components.Inputs exposing (..)

import Css
import Elemental.Form.Field
import Elemental.Form.Field.LongText as LongTextField
import Elemental.Form.Field.ShortText as ShortTextField
import Elemental.Form.Validate as V
import Elemental.Layout as L
import Elemental.View.Form.Field as Support
import Elemental.View.Form.Field.Input as Input
import Example.Form.Field.LongText as LongTextField
import Example.Form.Field.ShortText as ShortTextField
import Example.Icons as Icons
import Example.Layout as L
import Example.Theme exposing (Theme)
import Html.Styled as H
import Html.Styled.Attributes as HA



-- MODEL


type alias Flags =
    ()


type alias Model =
    { shortTextFieldModel : ShortTextField.Model
    , longTextFieldModel : LongTextField.Model
    }


init : Flags -> Model
init _ =
    let
        shortTextFieldModel =
            ShortTextField.field.init
                { value = ""
                , validator =
                    V.firstError
                        [ V.ifBlank identity "Please provide an input"
                        ]
                }
                |> Tuple.first

        longTextFieldModel =
            LongTextField.field.init
                { value = ""
                , validator =
                    V.firstError
                        [ V.ifBlank identity "Please provide an input"
                        ]
                }
                |> Tuple.first
    in
    { shortTextFieldModel = shortTextFieldModel
    , longTextFieldModel = longTextFieldModel
    }



-- UPDATE


type Msg
    = NoOp
    | GotShortTextFieldMsg ShortTextField.Msg
    | GotLongTextFieldMsg LongTextField.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            )

        GotShortTextFieldMsg msg_ ->
            let
                ( shortTextFieldModel, shortTextFieldMsg ) =
                    ShortTextField.field.update msg_ model.shortTextFieldModel
            in
            ( { model | shortTextFieldModel = shortTextFieldModel }
            , Cmd.map GotShortTextFieldMsg shortTextFieldMsg
            )

        GotLongTextFieldMsg msg_ ->
            let
                ( longTextFieldModel, longTextFieldMsg ) =
                    LongTextField.field.update msg_ model.longTextFieldModel
            in
            ( { model | longTextFieldModel = longTextFieldModel }
            , Cmd.map GotLongTextFieldMsg longTextFieldMsg
            )



-- VIEW


view : Theme -> Model -> H.Html Msg
view theme model =
    L.viewColumn L.Normal
        []
        [ viewShortTextGroup theme model.shortTextFieldModel
            |> H.map GotShortTextFieldMsg
        , L.layout.spacerY 4
        , viewLongTextGroup theme model.longTextFieldModel
            |> H.map GotLongTextFieldMsg
        ]


viewShortTextGroup : Theme -> ShortTextField.Model -> H.Html (Elemental.Form.Field.Msg ShortTextField.Msg_)
viewShortTextGroup theme formModel =
    let
        options =
            ShortTextField.toOptions
                { theme = theme
                , type_ = Input.Text
                , label = "Text Input"
                , support = Support.Text ""
                , disabled = False
                , autofocus = True
                , required = True
                , placeholder = ""
                , icon = Nothing
                }
    in
    L.viewColumn L.Normal
        []
        [ H.h6 [] [ H.text "Short Text" ]
        , L.layout.spacerY 2
        , viewSideBySide
            { left = ShortTextField.field.view options formModel
            , right =
                ShortTextField.field.view
                    { options
                        | label = "With Error"
                        , support = Support.Text ""
                    }
                    { formModel | errors = [ "Something is wrong" ] }
            }
        , L.layout.spacerY 4
        , viewSideBySide
            { left =
                ShortTextField.field.view
                    { options
                        | label = "With Placeholder"
                        , placeholder = "Placeholder"
                    }
                    formModel
            , right =
                ShortTextField.field.view
                    { options
                        | label = "With Support Text"
                        , support = Support.Text "An important note"
                    }
                    formModel
            }
        , L.layout.spacerY 4
        , viewSideBySide
            { left =
                ShortTextField.field.view
                    { options
                        | label = "Disabled"
                        , disabled = True
                    }
                    formModel
            , right =
                ShortTextField.field.view
                    { options
                        | label = "Optional"
                        , required = False
                    }
                    formModel
            }
        , L.layout.spacerY 4
        , viewSideBySide
            { left =
                ShortTextField.field.view
                    { options
                        | label = "With Icon"
                        , icon = Just <| Icons.view Icons.Edit 20
                    }
                    formModel
            , right =
                H.text ""
            }
        ]


viewLongTextGroup : Theme -> LongTextField.Model -> H.Html (Elemental.Form.Field.Msg LongTextField.Msg_)
viewLongTextGroup theme formModel =
    let
        options =
            LongTextField.toOptions
                { theme = theme
                , type_ = Input.Text
                , label = "Text Input"
                , support = Support.Text ""
                , disabled = False
                , autofocus = True
                , required = True
                , placeholder = ""
                }

        viewLongTextField opts model =
            H.div [ HA.css [ Css.minWidth <| Css.px 300 ] ]
                [ LongTextField.field.view opts model
                ]
    in
    L.viewColumn L.Normal
        []
        [ H.h6 [] [ H.text "Long Text" ]
        , L.layout.spacerY 2
        , viewSideBySide
            { left = viewLongTextField options formModel
            , right =
                viewLongTextField
                    { options
                        | label = "With Error"
                        , support = Support.Text ""
                    }
                    { formModel | errors = [ "Something is wrong" ] }
            }
        , L.layout.spacerY 4
        , viewSideBySide
            { left =
                viewLongTextField
                    { options
                        | label = "With Placeholder"
                        , placeholder = "Placeholder"
                    }
                    formModel
            , right =
                viewLongTextField
                    { options
                        | label = "With Support Text"
                        , support = Support.Text "An important note"
                    }
                    formModel
            }
        , L.layout.spacerY 4
        , viewSideBySide
            { left =
                viewLongTextField
                    { options
                        | label = "Disabled"
                        , disabled = True
                    }
                    formModel
            , right =
                viewLongTextField
                    { options
                        | label = "Optional"
                        , required = False
                    }
                    formModel
            }
        , L.layout.spacerY 4
        ]


viewSideBySide : { a | left : H.Html msg, right : H.Html msg } -> H.Html msg
viewSideBySide { left, right } =
    L.viewWrappedRow
        [ Css.alignItems Css.start ]
        [ left
        , L.layout.spacerX 8
        , right
        ]
