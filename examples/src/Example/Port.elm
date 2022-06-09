port module Example.Port exposing
    ( receiveMessage
    , sendMessage
    )

import Json.Encode as JE


port sendMessage : JE.Value -> Cmd msg


port receiveMessage : (JE.Value -> msg) -> Sub msg
