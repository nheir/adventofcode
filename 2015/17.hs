import System.IO

main = do
	handle <- openFile "input17" ReadMode
	contents <- hGetContents handle
	let l = map readInt $ rmTail $ lines contents
	print $ length $ filter (\s -> (sum s == 150 && length s == 4)) $ subSeq l
	hClose handle
subSeq [] = [[]]
subSeq (x:xs) = (map (\s -> x:s) k) ++ k 
	where k = subSeq xs
readInt a = read a :: Int
rmTail [x] = []
rmTail (x:xs) = x:rmTail xs
