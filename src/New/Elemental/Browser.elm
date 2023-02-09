module New.Elemental.Browser exposing
    ( Body
    , Document
    , UrlRequest(..)
    , application
    , document
    , toUnstyledDocument
    )

import Browser
import Browser.Navigation
import Css
import Css.Global as CssGlobal
import Css.ModernNormalize as Normalize
import Html.Styled as Html
import New.Elemental as Elemental exposing (Element)
import New.Elemental.Box.Structure as Structure
import New.Elemental.Box.Style as Style exposing (Style)
import Url exposing (Url)



{--sandbox :
    { init : model
    , view : model -> Element msg
    , update : msg -> model -> model
    }
    -> Program () model msg
sandbox options =
    Browser.sandbox
        { init = options.init
        , view = options.view >> Elemental.toUnstyledHtml
        , update = options.update
        }


element :
    { init : flags -> ( model, Cmd msg )
    , view : model -> Element msg
    , update : msg -> model -> ( model, Cmd msg )
    , subscriptions : model -> Sub msg
    }
    -> Program flags model msg
element options =
    Browser.element
        { init = options.init
        , view = options.view >> Elemental.toUnstyledHtml
        , update = options.update
        , subscriptions = options.subscriptions
        }--}


document :
    { init : flags -> ( model, Cmd msg )
    , view : model -> Document msg
    , update : msg -> model -> ( model, Cmd msg )
    , subscriptions : model -> Sub msg
    }
    -> Program flags model msg
document options =
    Browser.document
        { init = options.init
        , view = options.view >> toUnstyledDocument
        , update = options.update
        , subscriptions = options.subscriptions
        }


application :
    { init : flags -> Url -> Browser.Navigation.Key -> ( model, Cmd msg )
    , view : model -> Document msg
    , update : msg -> model -> ( model, Cmd msg )
    , subscriptions : model -> Sub msg
    , onUrlRequest : UrlRequest -> msg
    , onUrlChange : Url -> msg
    }
    -> Program flags model msg
application options =
    Browser.application
        { init = options.init
        , view = options.view >> toUnstyledDocument
        , update = options.update
        , subscriptions = options.subscriptions
        , onUrlRequest = fromExternalUrlRequest >> options.onUrlRequest
        , onUrlChange = options.onUrlChange
        }


type alias Document msg =
    { title : String
    , body : Body msg
    }


toUnstyledDocument : Document msg -> Browser.Document msg
toUnstyledDocument { title, body } =
    let
        css =
            Normalize.snippets
                |> List.append
                    [ CssGlobal.body
                        [ Css.displayFlex
                        , Structure.directionToCssStyle body.direction
                        , Structure.justificationToCssStyle body.direction body.justification
                        , Structure.alignmentToCssStyle body.direction body.alignment
                        , Structure.paddingToCssStyle body.padding
                        , Css.minWidth <| Css.vw 100
                        , Css.minHeight <| Css.vh 100
                        , Style.toCssStyle body.style
                        ]
                    , CssGlobal.body body.extraStyles
                    ]
                |> CssGlobal.global
                |> Html.toUnstyled

        children =
            css :: List.map (Elemental.toUnstyledHtml body.direction) body.children
    in
    { title = title
    , body = children
    }


type alias Body msg =
    { direction : Structure.Direction
    , justification : Structure.Justification
    , alignment : Structure.Alignment
    , padding : Structure.Padding
    , style : Style
    , extraStyles : List Css.Style
    , children : List (Element msg)
    }


type UrlRequest
    = Internal Url
    | External String


fromExternalUrlRequest : Browser.UrlRequest -> UrlRequest
fromExternalUrlRequest request =
    case request of
        Browser.Internal url ->
            Internal url

        Browser.External url ->
            External url
