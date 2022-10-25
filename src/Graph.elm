module Graph exposing
    ( isCycle
    , endOrCycle
    )

{-| Your graph is defined by a type `a` and a function that give the next element in the graph, if any.
`isCycle` tells you wether the graph is a cycle.


# Cycle detection

@docs isCycle

-}


{-| Takes a function that gives the possible next element in the graph and the first element,
returns True if the graph is a cycle

Example usage:

Here is a function that takes an integer and gives the next integer. The
cycle loops for numbers above 5 and not for negative ones.

    next : Int -> Maybe Int
    next n = if n > 10 then Just 5 else if n == 0 then Nothing else Just (n + 1)

We can check that the graph is a cycle if we start from above 0:

    isCycle next 2
    --> True

    isCycle next -5
    --> False

-}
isCycle : (a -> Maybe a) -> a -> Bool
isCycle f x =
    let
        run : (a -> Maybe a) -> Maybe a -> Maybe a -> Bool
        run next turtle hare =
            let
                nextTurtle =
                    turtle |> Maybe.andThen next

                nextHare =
                    hare |> Maybe.andThen next |> Maybe.andThen next
            in
            if nextTurtle == nextHare then
                True

            else if nextHare == Nothing then
                False

            else
                run next nextTurtle nextHare
    in
    run f (Just x) (Just x)


{-| Takes a function that gives the possible next element in the graph and the first element,
and returns:

    - (Ok x) if x is the output of the path
    - (Err x) if x is the entry of a cycle

Example usage:

Here is a function that takes an integer and gives the next integer. The
cycle loops for numbers above 5 and not for negative ones.

    next : Int -> Maybe Int
    next n = if n > 10 then Just 5 else if n == 0 then Nothing else Just (n + 1)

The output of the graph is at number 0:

    endOrCycle next -5
    --> Ok 0

There is a cycle, we can find the entry point of the cycle:

    endOrCycle next 2
    --> Err 5

-}
endOrCycle : (a -> Maybe a) -> a -> Result a a
endOrCycle f x =
    let
        firstRun : (a -> Maybe a) -> Result a a -> Result a a -> Result a a
        firstRun next rTurtle rHare =
            let
                nextTurtle =
                    rTurtle |> Result.toMaybe |> Maybe.andThen next

                nextHare =
                    rHare |> Result.toMaybe |> Maybe.andThen next |> Maybe.andThen next
            in
            case nextTurtle of
                Just turtle ->
                    case nextHare of
                        Just hare ->
                            if turtle == hare then
                                -- we found a cycle. Now find the cycle entry
                                secondRun f (Ok x) (Ok hare)

                            else
                                -- continue until the turtle meet the hare
                                firstRun f (Ok turtle) (Ok hare)

                        Nothing ->
                            -- The hare has found the output but not yet the turtle
                            firstRun f (Ok turtle) (Err turtle)

                Nothing ->
                    -- The turtle has finally found the exit
                    rTurtle

        secondRun : (a -> Maybe a) -> Result a a -> Result a a -> Result a a
        secondRun next rTurtle rHare =
            let
                nextTurtle =
                    rTurtle |> Result.toMaybe |> Maybe.andThen next

                nextHare =
                    rHare |> Result.toMaybe |> Maybe.andThen next
            in
            case nextTurtle of
                Just turtle ->
                    case nextHare of
                        Just hare ->
                            if turtle == hare then
                                -- The turtle meet the hare again, we found the cycle entry!
                                Err turtle

                            else
                                -- Continue until the turtle meet the hare again
                                secondRun f (Ok turtle) (Ok hare)

                        Nothing ->
                            -- The hare found the exit? This can't happen
                            rHare

                Nothing ->
                    -- The turtle found the exit? This can't happen
                    rTurtle
    in
    firstRun f (Ok x) (Ok x)
