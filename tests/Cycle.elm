module Cycle exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, intRange, list, string)
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
        [ fuzz (intRange 0 10) "a cycle" <| \n -> Expect.equal True <| Graph.isCycle intCycle n
        , fuzz (intRange -10 -1) "not a cycle" <| \n -> Expect.equal False <| Graph.isCycle intCycle n
        ]
