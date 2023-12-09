main = interact $ show . solve . map (map read . words) . lines

solve l = (solve1 l, solve2 l)

solve1 = sum . map extrapolate

solve2 = sum . map extrapolateBack

-- extrapolate :: [Int] -> Int
extrapolate l = sum binom
  where
    len = length l
    binom = [(-1) ^ (len - i + 1) * c * binomial len i | (c, i) <- zip l [0 ..]]

extrapolateBack l = sum binom
  where
    len = length l
    binom = [(-1) ^ i * c * binomial len (i + 1) | (c, i) <- zip l [0 ..]]

factorials = 1 : zipWith (*) factorials [1 ..]

binomial n k
  | n < k = 0
  | n == k || k == 0 = 1
  | otherwise = div (factorials !! n) ((factorials !! (n - k)) * (factorials !! k))
