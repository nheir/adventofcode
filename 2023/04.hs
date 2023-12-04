import Control.Monad (void)
import Data.List (intersect)
import Text.Parsec
import Text.Parsec.String
import Text.Parsec.Token

data Card = Card Int [Int] [Int] deriving (Show)

whitespace :: Parser ()
whitespace = void $ many (char ' ')

parseNumber :: Parser Int
parseNumber = read <$> many1 digit

parseNumbers :: Parser [Int]
parseNumbers = whitespace *> sepEndBy parseNumber whitespace

parseCard :: Parser Card
parseCard = Card <$> (string "Card" *> whitespace *> parseNumber) <* char ':' <* whitespace <*> parseNumbers <* char '|' <*> parseNumbers

parseInput :: Parser [Card]
parseInput = sepEndBy parseCard endOfLine <* eof

solve1 input = sum $ map cardValue input
  where
    cardValue (Card _ wining numbers) = score $ length (wining `intersect` numbers)
    score 0 = 0
    score n = 2 ^ (n - 1)

solve2 input = solve2_aux input (repeat 1) 0
  where
    solve2_aux [] _ tot = tot
    solve2_aux _ [] tot = tot
    solve2_aux ((Card _ wining numbers) : t) (a : n) tot = solve2_aux t n' (a + tot)
      where
        n' = map (+ a) ns ++ tail
        (ns, tail) = splitAt wins n
        topLength = length wining
        wins = length (wining `intersect` numbers)

main :: IO ()
main = do
  handle <- getContents
  print $ solve handle

solve input = case parse parseInput "" input of
  Right l -> Right (solve1 l, solve2 l)
  Left e -> Left e