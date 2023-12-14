import Data.List (intercalate, transpose)
import GHC.Utils.Misc (nTimes)

main = interact $ show . solve . parse

parse = lines

solve a = (solve1 a, solve2 a)

solve1 = sum . map scoreToNorthLine . transpose

scoreToNorthLine line = scoreLine_aux (length line) (length line) line
  where
    scoreLine_aux n m ('#' : q) = scoreLine_aux (m - 1) (m - 1) q
    scoreLine_aux n m ('O' : q) = n + scoreLine_aux (n - 1) (m - 1) q
    scoreLine_aux n m (_ : q) = scoreLine_aux n (m - 1) q
    scoreLine_aux _ _ [] = 0

scoreLine line = sum . map fst . filter ((== 'O') . snd) . zip [length line, length line - 1 .. 0] $ line

rotate :: [[a]] -> [[a]]
rotate = transpose . reverse

solve2 input = case findLoop 1000000000 spin . reverse . transpose $ input of
  Just (i, period, a) ->
    let remain = (1000000000 - i) `mod` period
     in sum . map scoreLine $ iterate spin a !! remain
  Nothing -> 0

findLoop n f start = findLoop_aux f (1, f start) (2, f (f start))
  where
    findLoop_aux f (i, a) (j, b)
      | i > n = Nothing
      | a == b = Just (i, j - i, a)
      | otherwise = findLoop_aux f (i + 1, f a) (j + 2, f (f b))

spin = nTimes 4 (rotate . tilt)

tilt = map (tiltLine "")
  where
    tiltLine buf [] = buf
    tiltLine buf ('O' : q) = 'O' : tiltLine buf q
    tiltLine buf ('#' : q) = buf ++ '#' : tiltLine "" q
    tiltLine buf (c : q) = tiltLine (c : buf) q