import Control.Monad (void)
import Text.Parsec
import Text.Parsec.String

data Almanac = Almanac [Seed] [Transition] deriving (Show)

type Seed = Int

data Transition = Transition [Range] deriving (Show)

data Range = Range Int Int Int deriving (Show)

whitespace :: Parser ()
whitespace = void $ many (char ' ')

parseNumber :: Parser Int
parseNumber = read <$> many1 digit <* whitespace

parseNumbers :: Parser [Int]
parseNumbers = whitespace *> many parseNumber

parseRange :: Parser Range
parseRange = Range <$> parseNumber <*> parseNumber <*> parseNumber <* endOfLine

parseTransition :: Parser Transition
parseTransition = Transition <$> (many1 (noneOf "\n") *> endOfLine *> many parseRange)

parseInput = Almanac <$> (string "seeds: " *> parseNumbers) <* spaces <*> sepBy parseTransition endOfLine

solve1 :: Almanac -> Int
solve1 (Almanac seeds []) = minimum seeds
solve1 (Almanac seeds ((Transition ranges) : q)) = solve1 (Almanac (transSeeds ranges seeds) q)
  where
    transSeeds ranges = map (transSeed ranges)
    transSeed ((Range dst src width) : rs) seed
      | src <= seed && seed < src + width = seed - src + dst
      | otherwise = transSeed rs seed
    transSeed [] seed = seed -- error

-- solve2 :: Almanac -> Int
solve2 (Almanac seeds transitions) = solve2_aux (pairs seeds) transitions
  where
    pairs (a : b : t) = (a, b) : pairs t
    pairs _ = []
    solve2_aux seeds_ranges [] = minimum $ map fst seeds_ranges
    solve2_aux seeds_ranges (Transition ranges : t) = solve2_aux (transSeeds ranges seeds_ranges) t
    transSeeds ranges seed = concatMap (transSeed ranges) [seed]
    transSeed ((Range dst src width) : rs) ((a, b) : ss) =
      interShift (dst - src) (interInter (a, b) (src, width)) ++ transSeed rs (interDiff (a, b) (src, width)) ++ transSeed (Range dst src width : rs) ss
    transSeed [] seeds = seeds
    transSeed _ [] = []
    interShift offset = map (\x -> (fst x + offset, snd x))
    interInter (a, b) (c, d) =
      let (s, e) = (max a c, min (a + b) (c + d))
       in ([(s, e - s) | s < e])
    interDiff (a, b) (c, d)
      | a + b <= c || c + d <= a = [(a, b)]
      | a < c && c + d < a + b = [(a, c - a), (c + d, a + b - c - d)]
      | a < c = [(a, c - a)]
      | c + d < a + b = [(c + d, a + b - c - d)]
      | otherwise = []

main :: IO ()
main = interact $ show . solve . parse parseInput ""

solve parsed = case parsed of
  Right l -> Right (solve1 l, solve2 l)
  Left e -> Left e
