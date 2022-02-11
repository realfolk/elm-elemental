module Elemental.Form.Validate exposing
    ( Validator
    , all
    , firstError
    , ifBlank
    , ifGreaterThan
    , ifInvalidEmail
    , ifLessThan
    , new
    , validate
    )

import Parser exposing ((|.), Parser)


type Validator error input
    = Validator (input -> List error)



-- VALIDATING AN INPUT


validate : Validator error input -> input -> Result (List error) input
validate (Validator getErrors) input =
    case getErrors input of
        [] ->
            Ok input

        errors ->
            Err errors



-- CONSTRUCTING VALIDATORS


new : (input -> List error) -> Validator error input
new f =
    Validator f


ifBlank : (input -> String) -> error -> Validator error input
ifBlank toString error =
    Validator
        (\input ->
            if isBlank (toString input) then
                [ error ]

            else
                []
        )


ifGreaterThan : (input -> Int) -> Int -> error -> Validator error input
ifGreaterThan toInt n error =
    Validator
        (\input ->
            if toInt input > n then
                [ error ]

            else
                []
        )


ifLessThan : (input -> Int) -> Int -> error -> Validator error input
ifLessThan toInt n error =
    Validator
        (\input ->
            if toInt input < n then
                [ error ]

            else
                []
        )


ifInvalidEmail : (input -> String) -> error -> Validator error input
ifInvalidEmail toString error =
    Validator
        (\input ->
            if isEmail (toString input) then
                []

            else
                [ error ]
        )



-- COMBINING VALIDATORS


all : List (Validator error input) -> Validator error input
all validators =
    let
        newGetErrors input =
            let
                accumulateErrors (Validator getErrors) totalErrors =
                    totalErrors ++ getErrors input
            in
            List.foldl accumulateErrors [] validators
    in
    Validator newGetErrors


firstError : List (Validator error input) -> Validator error input
firstError validators =
    let
        getErrors =
            firstErrorHelper validators
    in
    Validator getErrors


firstErrorHelper : List (Validator error input) -> input -> List error
firstErrorHelper validators input =
    case validators of
        [] ->
            []

        (Validator getError) :: rest ->
            case getError input of
                [] ->
                    firstErrorHelper rest input

                errors ->
                    errors



-- PREDICATES


isBlank : String -> Bool
isBlank =
    String.trim >> String.isEmpty


isEmail : String -> Bool
isEmail s =
    case Parser.run email s of
        Ok _ ->
            True

        _ ->
            False



-- PARSERS
--
--
-- NOTE: These parsers could be extracted into a separate module for the
-- purposes of testing and reuse. The Email type could be exported as an
-- opaque type.


type Email
    = Email String


email : Parser Email
email =
    let
        wordChar c =
            c /= ' ' && c /= '\t' && c /= '\n' && c /= '\u{000D}' && c /= '@'

        domainChar c =
            wordChar c && c /= '.'

        chompMany1 validChar =
            Parser.getChompedString <|
                Parser.chompIf validChar
                    |. Parser.chompWhile validChar

        user =
            chompMany1 wordChar

        domainPrefix =
            chompMany1 domainChar

        domainSuffix parsedSuffixes =
            Parser.oneOf
                [ Parser.succeed (Parser.Loop (() :: parsedSuffixes))
                    |. Parser.symbol "."
                    |. chompMany1 domainChar
                , case parsedSuffixes of
                    [] ->
                        Parser.problem "Invalid domain, not enough suffixes."

                    _ ->
                        Parser.succeed <| Parser.Done ()
                ]

        domainSuffixes =
            Parser.loop [] domainSuffix
    in
    Parser.mapChompedString (\s _ -> Email s) <|
        Parser.succeed ()
            |. user
            |. Parser.symbol "@"
            |. domainPrefix
            |. domainSuffixes
            |. Parser.end
