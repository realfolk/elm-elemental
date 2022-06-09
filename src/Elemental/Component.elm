module Elemental.Component exposing
    ( Component
    , Init
    , PureComponent
    , PureInit
    , PureUpdate
    , PureView
    , Update
    , View
    , indexedInit
    , indexedInitWithData
    , indexedUpdate
    , indexedUpdateWithData
    )

import Html.Styled as H
import Lib.Function exposing (flip)
import Lib.List



-- COMPONENTS


type alias Component flags model msg options =
    { init : flags -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , view : options -> model -> H.Html msg
    }


type alias Init flags model msg =
    flags -> ( model, Cmd msg )


indexedInit : (Int -> childMsg -> parentMsg) -> Init childFlags childModel childMsg -> List childFlags -> ( List childModel, Cmd parentMsg )
indexedInit mapMsg init flags =
    List.map init flags
        |> List.unzip
        |> Tuple.mapSecond (List.indexedMap (mapMsg >> Cmd.map) >> Cmd.batch)


indexedInitWithData : (Int -> childMsg -> parentMsg) -> Init childFlags childModel childMsg -> List ( childFlags, data ) -> ( List ( childModel, data ), Cmd parentMsg )
indexedInitWithData mapMsg init flagsAndData =
    let
        ( flags, data ) =
            List.unzip flagsAndData
    in
    indexedInit mapMsg init flags
        |> Tuple.mapFirst (flip Lib.List.zip data)


type alias Update model msg =
    msg -> model -> ( model, Cmd msg )


indexedUpdate : (Int -> childMsg -> parentMsg) -> Update childModel childMsg -> Int -> childMsg -> List childModel -> ( List childModel, Cmd parentMsg )
indexedUpdate mapMsg update index msg models =
    let
        f i model =
            if index == i then
                update msg model
                    |> Tuple.mapSecond (Cmd.map (mapMsg i))

            else
                ( model, Cmd.none )
    in
    models
        |> List.indexedMap f
        |> List.unzip
        |> Tuple.mapSecond Cmd.batch


indexedUpdateWithData : (Int -> childMsg -> parentMsg) -> Update childModel childMsg -> Int -> childMsg -> List ( childModel, data ) -> ( List ( childModel, data ), Cmd parentMsg )
indexedUpdateWithData mapMsg update index msg modelsAndData =
    let
        ( models, data ) =
            List.unzip modelsAndData
    in
    indexedUpdate mapMsg update index msg models
        |> Tuple.mapFirst (flip Lib.List.zip data)


type alias View model msg options =
    options -> model -> H.Html msg



-- PURE COMPONENTS


type alias PureComponent flags model msg options =
    { init : flags -> model
    , update : msg -> model -> model
    , view : options -> model -> H.Html msg
    }


type alias PureInit flags model =
    flags -> model


type alias PureUpdate model msg =
    msg -> model -> model


type alias PureView model msg options =
    View model msg options
