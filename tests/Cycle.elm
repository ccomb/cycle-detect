module Cycle exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Graph
import Test exposing (..)


intCycle : Int -> Maybe Int
intCycle n =
    if n > 5 then
        Just 1

    else if n == 0 then
        Nothing

    else
        Just (n + 1)


suite : Test
suite =
    describe "basic Cycle detection"
        [ test "is a cycle" <| \_ -> Graph.isCycle intCycle 3 |> Expect.equal True
        , test "is not a cycle" <| \_ -> Graph.isCycle intCycle -3 |> Expect.equal False
        ]
