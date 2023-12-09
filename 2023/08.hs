import Data.Bits (Bits (shiftL))
import Data.Char
import Data.Graph
import Data.IntMap
import qualified Data.IntMap as IntMap
import qualified Data.IntSet as IntSet
import Data.List

main :: IO ()
main = interact $ show . solve . readInput . lines
  where
    readInput (path : _ : adj) = (path, graphFrom $ Prelude.map readLine adj)
    readInput _ = ("", graphFrom [])
    readLine l = (slice 0 3 l, slice 7 3 l, slice 12 3 l)
    slice a w = take w . drop a
    graphFrom adj = IntMap.fromList [(id2Int src, [id2Int left, id2Int right]) | (src, left, right) <- adj]

id2Int :: [Char] -> Int
id2Int = sum . zipWith (*) (Prelude.map (26 ^) [0 ..]) . Prelude.map (\x -> ord x - ord 'A')

solve p = (solve1 p, solve2 p)

solve1 (path, adj) = step (cycle path) 0 0
  where
    step [] _ _ = 0
    step _ 17575 n = n
    step (a:q) state n = step q (findWithDefault [0,0] state adj !! if a == 'L' then 0 else 1) (n + 1)


solve2 (path, adj) = Data.List.foldl lcm 1 [step (cycle path) k 0 | k <- [0 .. 675], member k adj]
  where
    step [] _ _ = 0
    step (a:q) state n
        | state >= 16900 && n > 0 = n
        | otherwise = step q (findWithDefault [0,0] state adj !! if a == 'L' then 0 else 1) (n + 1)
