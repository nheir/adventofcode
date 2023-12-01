import Data.Char (digitToInt, isDigit)
import Data.List (isPrefixOf, tails)
import qualified Data.Maybe
import System.IO ()

main :: IO ()
main = do
  handle <- getContents
  print $
    solve
      handle

data CalibrationNumber = Digit Int | SpelledDigit Int deriving (Show)

digitStrings :: [String]
digitStrings = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

parsePrefix :: String -> Maybe CalibrationNumber
parsePrefix s
  | null s = Nothing
  | isDigit (head s) = Just (Digit (digitToInt (head s)))
  | otherwise = findPrefix 1 digitStrings s
  where
    findPrefix n [] _ = Nothing
    findPrefix n (p : q) s
      | p `isPrefixOf` s = Just (SpelledDigit n)
      | otherwise = findPrefix (n + 1) q s

parseLine :: [Char] -> [CalibrationNumber]
parseLine line = [i | (Just i) <- map parsePrefix $ tails line]

solve :: String -> (Int, Int)
solve input = (solve1 l, solve2 l)
  where
    l = map parseLine $ lines input

solve1 :: [[CalibrationNumber]] -> Int
solve1 input = sum $ map (\(a, b) -> a * 10 + b) pairs
  where
    pairs = map (extractDigits . intOnly) input
    extractDigits line = (head line, last line)
    intOnly lst = [i | (Digit i) <- lst]

solve2 :: [[CalibrationNumber]] -> Int
solve2 input = sum $ map (\(a, b) -> a * 10 + b) pairs
  where
    pairs = map (extractDigits . all) input
    extractDigits line = (head line, last line)
    all = map unwrap
    unwrap (Digit i) = i
    unwrap (SpelledDigit i) = i