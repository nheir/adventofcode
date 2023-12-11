import Data.Tuple (swap)
import Data.List (sort)
main = interact $ show . solve . parse

parse :: String -> [(Int, Int)]
parse input = sort coords
  where
    skew (i, l) = map (skewl i) $ filter ((== '#') . snd) l
    skewl i (j, _) = (i, j)
    coords = concatMap skew . zip [0 ..] . map (zip [0 ..]) . lines $ input

solve l = (solve1 l, solve2 l)

expand last offset coef [] = []
expand last offset coef ((i, j) : q) 
  | i <= last + 1 = (i + offset, j) : expand i offset coef q
  | otherwise = expand (last + 1) (offset + coef - 1) coef ((i, j) : q) 

solve1 coords = sum dists
  where
    expandXY = map swap . expand 0 0 2. sort . map swap . expand 0 0 2 $ coords
    dists = [dist a b | a <- expandXY, b <- expandXY, a < b]
    dist (x1,y1) (x2,y2) = abs (x1 - x2) + abs (y1 - y2)

solve2 coords = sum dists
  where
    expandXY = map swap . expand 0 0 1000000. sort . map swap . expand 0 0 1000000 $ coords
    dists = [dist a b | a <- expandXY, b <- expandXY, a < b]
    dist (x1,y1) (x2,y2) = abs (x1 - x2) + abs (y1 - y2)