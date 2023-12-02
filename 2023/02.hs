import Control.Monad (void)
import System.IO ()
import Text.Parsec
  ( char,
    choice,
    endBy,
    endOfLine,
    eof,
    many1,
    oneOf,
    parse,
    sepBy,
    string,
  )
import Text.Parsec.Char (digit)
import Text.Parsec.String (Parser)

main :: IO ()
main = do
  handle <- getContents
  print $
    solve
      handle

data Tirage = Tirage
  { red :: Int,
    green :: Int,
    blue :: Int
  }

data Game = Game
  { id :: Int,
    tirages :: [Tirage]
  }

integer :: Parser Int
integer = read <$> many1 digit

whitespace :: Parser ()
whitespace = void $ oneOf " \n\t"

cube :: Parser Tirage
cube = toTirage <$> integer <*> (whitespace *> choice [string "red", string "blue", string "green"])
  where
    toTirage a "red" = Tirage a 0 0
    toTirage a "green" = Tirage 0 a 0
    toTirage a "blue" = Tirage 0 0 a
    toTirage a _ = Tirage 0 0 0

tirage :: Parser Tirage
tirage = compact <$> sepBy cube (string ", ")
  where
    compact = compact_aux (Tirage 0 0 0)
    compact_aux a [] = a
    compact_aux (Tirage r g b) ((Tirage rh gh bh) : q) = compact_aux (Tirage (r + rh) (g + gh) (b + bh)) q

tirageParser :: Parser [Tirage]
tirageParser = sepBy tirage (string "; ")

gameIdParser :: Parser Int
gameIdParser = string "Game " *> integer <* string ": "

lineParser :: Parser Game
lineParser = Game <$> gameIdParser <*> tirageParser <* endOfLine

inputParser :: Parser [Game]
inputParser = many1 lineParser <* eof

-- solve :: String -> (Int, Int)
solve input = case parse inputParser "" input of
  Right l -> Right (solve1 l, solve2 l)
  Left e -> Left e

solve1 :: [Game] -> Int
solve1 input = sum $ map Main.id games
  where
    games = filter (all (\x -> (red x <= 12) && (green x <= 13) && (blue x <= 14)) . tirages) input

solve2 :: [Game] -> Int
solve2 input = sum powers
  where
    powers = map ((\t -> red t * green t * blue t) . maxTirages) input
    maxTirages g = foldl maxTirage (Tirage 0 0 0) (tirages g)
    maxTirage (Tirage a b c) (Tirage d e f) =
      Tirage (max a d) (max b e) (max c f)
