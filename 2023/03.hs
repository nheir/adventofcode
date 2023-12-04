import Control.Applicative ((<|>))
import Control.Monad (liftM, void)
import Text.Parsec
  ( State (statePos),
    digit,
    endOfLine,
    eof,
    getParserState,
    getPosition,
    many,
    many1,
    noneOf,
    parse,
    sepBy,
    sepEndBy,
    sourceColumn,
    sourceLine,
  )
import Text.Parsec.Char (char)
import Text.Parsec.Combinator (choice)
import Text.Parsec.String (Parser)

data Position = Position
  { x :: Int,
    y :: Int,
    width :: Int
  }
  deriving (Show)

data Data
  = Number
      { number :: Int,
        pos :: Position
      }
  | Symbol
      { symbol :: Char,
        pos :: Position
      }
  deriving (Show)

type Engine = [Data]

dots :: Parser ()
dots = void $ many (char '.')

parseNumber :: Parser Data
parseNumber = do
  n <- many1 digit
  srcPos <- statePos <$> getParserState
  return $ Number (read n) (Position (sourceColumn srcPos - length n) (sourceLine srcPos) (length n))

parseSymbol :: Parser Data
parseSymbol = do
  n <- noneOf ".\n"
  srcPos <- statePos <$> getParserState
  return $ Symbol n (Position (sourceColumn srcPos - 1) (sourceLine srcPos) 1)

parseLine :: Parser [Data]
parseLine = dots *> sepEndBy (choice [parseNumber, parseSymbol]) dots

parseInput :: Parser Engine
parseInput = concat <$> sepBy parseLine endOfLine <* eof

contact (Position x1 y1 w1) (Position x2 y2 w2) = abs (y1 - y2) <= 1 && x1 <= x2 + w2 && x2 <= x1 + w1

splitData :: [Data] -> ([(Int, Position)], [(Char, Position)])
splitData l = splitData_aux l [] []
  where
    splitData_aux l ns ss = case l of
      (Number n p) : q -> splitData_aux q ((n, p) : ns) ss
      (Symbol c p) : q -> splitData_aux q ns ((c, p) : ss)
      [] -> (ns, ss)

-- solve1 :: Engine -> Int
solve1 l = sum $ map fst $ filter (\x -> any (contact (snd x) . snd) symbols) numbers
  where
    (numbers, symbols) = splitData l

solve2 :: Engine -> Int
solve2 l = sum $ map gearValue gearNumbers
  where
    (numbers, symbols) = splitData l
    maybeGears = map snd $ filter ((==) '*' . fst) symbols
    gearNumbers = map (\x -> map fst (filter (contact x . snd) numbers)) maybeGears
    gearValue [a,b] = a*b
    gearValue _ = 0


main :: IO ()
main = do
  handle <- getContents
  print $ solve handle

solve input = case parse parseInput "" input of
  Right l -> Right (solve1 l, solve2 l)
  Left e -> Left e