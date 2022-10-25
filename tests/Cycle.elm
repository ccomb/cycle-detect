module Cycle exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, intRange, list, string)
import Graph
import Test exposing (..)


intCycle : Int -> Maybe Int
intCycle n =
    if n > 10 then
        Just 5
    else if n == 0 then
        Nothing
    else
        Just (n + 1)


suite : Test
suite =
    describe "test Cycles"
        [ describe "isCycle"
            [ fuzz (intRange 0 20) "a cycle" <| \n -> Expect.equal True <| Graph.isCycle intCycle n
            , fuzz (intRange -10 -1) "not a cycle" <| \n -> Expect.equal False <| Graph.isCycle intCycle n
            ]
        , describe "enOrCycle"
            [ test "Start below the output" <| \_ -> Graph.endOrCycle intCycle -3 |> Expect.equal (Ok 0)
            , test "Start again below the output" <| \_ -> Graph.endOrCycle intCycle -1 |> Expect.equal (Ok 0)
            , test "Start between the output and the cycle entry" <| \_ -> Graph.endOrCycle intCycle 3 |> Expect.equal (Err 5)
            , test "Start just before the cycle entry" <| \_ -> Graph.endOrCycle intCycle 4 |> Expect.equal (Err 5)
            , test "Start at the entry, any point is an entry" <| \_ -> Graph.endOrCycle intCycle 5 |> Expect.equal (Err 6)
            , test "Start after the entry, any point is also an entry" <| \_ -> Graph.endOrCycle intCycle 8 |> Expect.equal (Err 9)
            ]
        ]
