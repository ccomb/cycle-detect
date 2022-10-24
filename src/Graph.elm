module Graph exposing (isCycle)

{-| Your graph is defined by a type `a` and a function that give the next element in the graph, if any.
`isCycle` tells you wether the graph is a cycle.


# Cycle detection

@docs isCycle

-}


{-| Takes a function that gives the possible next element in the graph and the first element,
returns True if the graph is a cycle
-}
isCycle : (a -> Maybe a) -> a -> Bool
isCycle f x =
    let
        cycle : (a -> Maybe a) -> Maybe a -> Maybe a -> Bool
        cycle next slow fast =
            let
                nextSlow =
                    slow |> Maybe.andThen next

                nextFast =
                    fast |> Maybe.andThen next |> Maybe.andThen next
            in
            if nextSlow == nextFast then
                True

            else if nextFast == Nothing then
                False

            else
                cycle next nextSlow nextFast
    in
    cycle f (Just x) (Just x)
