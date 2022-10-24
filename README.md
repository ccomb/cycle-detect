# Cycle Detection

Your data model has entities that can have references to itself. For instance a
parent which can have a parent, and so on, up to the root. But wait, is there a
root? How can you be sure that you won't fall into an infinite cycle by walking
in the graph? You can answer this question by using the Floyd cycle detection
algorithm.


Example usage:

Here is a function that takes an integer and gives the next integer. The
cycle loops for positive numbers and not for negative ones.

```elm
intCycle : Int -> Maybe Int
intCycle n = if n > 5 then Just 1 else if n == 0 then Nothing else Just (n + 1)
```

We can check that the graph is a cycle if we start from 2:

```
> isCycle intCycle 2
True : Bool

> isCycle intCycle -5
False : Bool
```
