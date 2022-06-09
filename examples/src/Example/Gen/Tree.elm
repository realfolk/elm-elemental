module Example.Gen.Tree exposing
    ( Node(..)
    , Tree(..)
    , declarationToExp
    , fromList
    , insert
    , labeledNode
    , leaf
    , root
    , toList
    , treeToDeclaration
    )

import Elm
import Elm.ToString


type Tree t
    = Root String (List (Node t))


type Node t
    = Label String (List (Node t))
    | Leaf String t


labeledNode : String -> List (Node t) -> Node t
labeledNode label children =
    Label label children


leaf : String -> t -> Node t
leaf name t =
    Leaf name t


root : String -> List (Node t) -> Tree t
root name nodes =
    Root name nodes


treeToDeclaration tToCode tree =
    let
        toExpression node =
            case node of
                Label labelStr nodes ->
                    ( labelStr
                    , nodesToExpression nodes
                    )

                Leaf labelStr t ->
                    ( labelStr
                    , tToCode t
                    )

        nodesToExpression nodes =
            Elm.record <|
                List.reverse <|
                    List.map toExpression nodes
    in
    case tree of
        Root name nodes ->
            Elm.declaration name
                (nodes
                    |> nodesToExpression
                )


declarationToExp code =
    code
        |> Elm.ToString.declaration
        |> .body
        |> String.lines
        |> List.foldl
            (\line ( acc, drop ) ->
                if drop then
                    if String.contains "=" line then
                        ( line :: acc, False )

                    else
                        ( acc, True )

                else
                    ( line :: acc, False )
            )
            ( [], True )
        |> Tuple.first
        |> List.reverse
        |> String.join "\n"


toList : Tree t -> List ( String, t )
toList (Root _ nodes) =
    flattenHelper [] nodes
        |> List.sortBy Tuple.first


delimiter =
    "/"


flattenHelper : List String -> List (Node t) -> List ( String, t )
flattenHelper prefix nodes =
    List.concatMap
        (\node ->
            case node of
                Label name children ->
                    flattenHelper (name :: prefix) children

                Leaf name t ->
                    [ ( String.join delimiter (List.reverse (name :: prefix))
                      , t
                      )
                    ]
        )
        nodes


empty name =
    Root name []


fromList : String -> List ( String, t ) -> Tree t
fromList treeName labelledLeaves =
    labelledLeaves
        |> List.foldl
            (\( leafLabel, leafValue ) tree ->
                insert leafLabel leafValue tree
            )
            (empty treeName)


insert : String -> t -> Tree t -> Tree t
insert location value tree =
    let
        path =
            String.split delimiter location

        head =
            List.head path

        tail =
            List.drop 1 path
    in
    case tree of
        Root name [] ->
            Root name [ newTree path value ]

        Root name children ->
            if List.any (\child -> Just (nodeName child) == head) children then
                Root name
                    (List.map
                        (\child ->
                            if Just (nodeName child) == head then
                                if tail == [] then
                                    Leaf (nodeName child) value

                                else
                                    insertAtNode tail value child

                            else
                                child
                        )
                        children
                    )

            else
                Root name (newTree path value :: children)


insertAtNode : List String -> t -> Node t -> Node t
insertAtNode location value node =
    -- If a Label node matches the first part of a multipart,
    --     if next part is in the children, update children
    --     else new tree
    case ( location, node ) of
        ( head :: tail, Label label children ) ->
            if List.any (\child -> nodeName child == head) children then
                Label label
                    (List.map
                        (\child ->
                            if nodeName child == head && tail == [] then
                                Leaf head value

                            else if nodeName child == head && tail /= [] then
                                insertAtNode tail value child

                            else
                                child
                        )
                        children
                    )

            else
                Label label (Leaf head value :: children)

        ( [], Leaf label _ ) ->
            Leaf label value

        ( [ _ ], Leaf label _ ) ->
            Leaf label value

        ( head :: tail, Leaf _ _ ) ->
            Label head [ newTree (head :: tail) value ]

        _ ->
            node


newTree path value =
    case path of
        [] ->
            Leaf "" value

        head :: [] ->
            Leaf head value

        head :: tail ->
            Label head <|
                [ newTree tail value ]


nodeName node =
    case node of
        Label labelStr _ ->
            labelStr

        Leaf labelStr _ ->
            labelStr
