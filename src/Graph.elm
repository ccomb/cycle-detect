module Graph exposing (isCycle)

{-| Your graph is defined by a type `a` and a function that give the next element in the graph, if any.
`isCycle` tells you wether the graph is a cycle.


# Cycle detection

@docs isCycle

-}


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


step : (a -> Maybe a) -> ( Maybe a, Maybe a ) -> ( Maybe a, Maybe a )
step next ( slow, fast ) =
    ( slow |> Maybe.andThen next, fast |> Maybe.andThen next |> Maybe.andThen next )


{-| Takes a function that gives the possible next element in the graph and the first element,
returns True if the graph is a cycle

Example usage:

Here is a function that takes an integer and gives the next integer. The
cycle loops for positive numbers and not for negative ones.

    intCycle : Int -> Maybe Int
    intCycle n =
        if n > 5 then
            Just 1

        else if n == 0 then
            Nothing

        else
            Just (n + 1)

We can check that the graph is a cycle if we start from above 0:

    isCycle intCycle 2
    --> True

    isCycle intCycle -5
    --> False

-}
isCycle : (a -> Maybe a) -> a -> Bool
isCycle f x =
    cycle f (Just x) (Just x)
