readInt :: String -> Integer
readInt = read

part :: Integer -> [Integer] -> [[Integer]]
part _ [] = [[]]
part obj (x:xs) = concat [[x:a,a] | a <- candidat]
  where
    filtreObj a = sum a <= obj
    filtreSize a = length a <= 6
    candidat = filter filtreObj $ filter filtreSize $ part obj xs

correct :: Integer -> [Integer] -> Bool
correct obj a = sum a == obj

valuation :: [Integer] -> (Int,Integer)
valuation a = (length a,  product a)

input :: [Integer]
input = [1,3,5,11,13,17,19,23,29,31,37,41,43,47,53,59,67,71,73,79,83,89,97,101,103,107,109,113]

main = do
  let ssum = div (sum input)  4
  print $  minimum $ map valuation $ filter (correct ssum) $ part ssum input
