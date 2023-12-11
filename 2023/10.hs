import Data.List (find, sort)
import Data.Map (Map, fromList, lookup, member)
import Data.Maybe

main = interact $ show . solve . parse

data Dir = North | West | East | South deriving (Show, Eq)

parse :: String -> ((Int, Int), Map (Int, Int) Char)
parse input = (start, fromList pipes)
  where
    skew (i, l) = filter (isPipe . snd) $ map (skewl i) l
    skewl i (j, c) = ((i, j), c)
    pipes = concatMap skew . zip [0 ..] . map (zip [0 ..]) . lines $ input
    start = fst . fromJust $ find (\x -> snd x == 'S') pipes

solve input = (solve1 input, solve2 input)

getLoop (start, pipes) = steps (map (step start) (pipe2Dirs 'S')) pipes
  where
    steps ((pos, dir) : q) pipes = case explore pos dir pipes [] of
      Just n -> n
      Nothing -> steps q pipes
    steps [] pipes = []
    explore pos dir pipes path
      | pos == start = Just (dir : path)
      | otherwise = case Data.Map.lookup pos pipes of
          Just c -> case filter (/= dir) (pipe2Dirs c) of
            [dd] ->
              let (next, d) = step pos dd
               in explore next d pipes (dir : path)
            _ -> Nothing
          Nothing -> Nothing

solve1 input = div (length (getLoop input) + 1) 2

solve2 input = max (sum . map snd $ cost loop'' 0 []) (sum . map snd $ cost' loop'' 0 [])
  where
    loop = getLoop input
    loop' = take (length loop + 1) (cycle loop)
    loop'' = pairs loop'
    pairs (a : b : q) = (a, b) : pairs (b : q)
    pairs _ = []
    comb a b = b : a
    start = head loop
    cost (dd : q) col n
      | dd == (North, North) = cost q col (comb n (dd, -col - 1))
      | dd == (South, South) = cost q col (comb n (dd, col))
      | dd == (West, West) = cost q (col - 1) (comb n (dd, 0))
      | dd == (East, East) = cost q (col + 1) (comb n (dd, 0))
      | dd == (East, South) = cost q col (comb n (dd, 0))
      | dd == (South, West) = cost q (col - 1) (comb n (dd, 0))
      | dd == (West, North) = cost q col (comb n (dd, 0))
      | dd == (North, East) = cost q (col + 1) (comb n (dd, 0))
      | dd == (West, South) = cost q col (comb n (dd, col))
      | dd == (South, East) = cost q (col + 1) (comb n (dd, col))
      | dd == (East, North) = cost q col (comb n (dd, -col - 1))
      | dd == (North, West) = cost q (col - 1) (comb n (dd, -col - 1))
    cost _ _ n = n
    cost' l = cost (reverse [(opDir b, opDir a) | (a,b) <- l])

isPipe c = c `elem` "-|FJL7S"

pipe2Dirs '-' = [West, East]
pipe2Dirs '|' = [North, South]
pipe2Dirs 'F' = [South, East]
pipe2Dirs 'J' = [North, West]
pipe2Dirs 'L' = [North, East]
pipe2Dirs '7' = [West, South]
pipe2Dirs 'S' = [West, South, East, West]
pipe2Dirs _ = []

opDir North = South
opDir South = North
opDir West = East
opDir East = West

step (i, j) North = ((i - 1, j), South)
step (i, j) South = ((i + 1, j), North)
step (i, j) East = ((i, j + 1), West)
step (i, j) West = ((i, j - 1), East)
