import Data.Function (on)
import Data.List (delete, elemIndex, group, sort, sortBy)
import Data.Maybe (fromJust)

main = interact $ show . (\x -> (solve1 x, solve2 x)) . hands
  where
    hands :: String -> [(String, Int)]
    hands input = [(h, read b) | [h, b] <- map words (lines input)]

solve1 = totalSorted . sortBy (compare `on` handValue)
  where
    handValue (hand, _) = (kind, map rewrite hand)
      where
        kind = reverse . sort . map length . group $ sort hand
        rewrite c = fromJust $ elemIndex c "AKQJT98765432"

solve2 = totalSorted . sortBy (compare `on` handValue)
  where
    handValue (hand, _) = (kind, map rewrite hand)
      where
        jless = filter (/= 'J') hand
        jcount = length hand - length jless
        kind = case reverse . sort . map length . group $ sort jless of
          a : q -> (a + jcount) : q
          _ -> [jcount]
        rewrite c = fromJust $ elemIndex c "AKQT98765432J"

totalSorted = sum . zipWith (*) [1, 2 ..] . map snd