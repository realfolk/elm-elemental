module New.Elemental.Lib.Either exposing
    ( Either(..)
    , mapBoth
    , mapLeft
    , mapRight
    , toMaybe
    , toResult
    , unwrap
    )


type Either a b
    = Left a
    | Right b


mapLeft : (a -> c) -> Either a b -> Either c b
mapLeft f either =
    case either of
        Left a ->
            Left <| f a

        Right b ->
            Right b


mapRight : (b -> c) -> Either a b -> Either a c
mapRight f either =
    case either of
        Left a ->
            Left a

        Right b ->
            Right <| f b


mapBoth : (a -> c) -> (b -> d) -> Either a b -> Either c d
mapBoth f g =
    mapLeft f >> mapRight g


unwrap : Either a a -> a
unwrap either =
    case either of
        Left a ->
            a

        Right a ->
            a


toResult : Either a b -> Result a b
toResult =
    mapBoth Err Ok >> unwrap


toMaybe : Either a b -> Maybe b
toMaybe =
    mapBoth (always Nothing) Just >> unwrap
