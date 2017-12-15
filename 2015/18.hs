import System.IO
import Data.Array

type Grid = Array Int (Array Int Bool)
data Coord = Coord Int Int deriving (Show)
main :: IO ()
main = do
	handle <- openFile "input18" ReadMode
	contents <- hGetContents handle
	let grid = listArray (0,99) $ map (\l -> listArray (0,99) $ map readBool l) $ lines contents
	--print $ loop 100 grid
	print $ sum $ map (length . filter id . elems) $ elems $ loop 100 grid
	hClose handle

rule :: Bool -> Int -> Bool
rule _ 3 = True
rule v 2 = v
rule _ _ = False
directions :: [Coord]
directions = [Coord y x | y <- [-1..1], x <- [-1..1], not (x==0 && y==0)]
sumCoord :: Coord -> Coord -> Coord
sumCoord (Coord a b) (Coord c d) = Coord (a+c) (b+d)
neigh :: Coord -> [Coord]
neigh coord = filter validCoord voisins
	where
		voisins = map (sumCoord coord) directions
validCoord :: Coord -> Bool
validCoord (Coord i j) = i >= 0 && i < 100 && j >= 0 && j < 100
isAlive :: Grid -> Coord -> Bool
isAlive grid (Coord i j) = grid ! i ! j

loop :: Int -> Grid -> Grid
loop 0 g = g
loop i g = loop (i-1) $ step g

local :: Grid -> Int -> Int -> Bool
local grid 0 0 = True
local grid 0 99 = True
local grid 99 0 = True
local grid 99 99 = True
local grid i j = rule (grid ! i ! j) (length (filter (isAlive grid) (neigh (Coord i j))))

step :: Grid -> Grid
step grid = newGrid
	where
		newGrid = listArray (0,99) $ map newRow [0..99]
		newRow i = listArray (0,99) [local grid i j | j <-[0..99] ]

readBool :: Char -> Bool
readBool '#' = True
readBool _ = False
