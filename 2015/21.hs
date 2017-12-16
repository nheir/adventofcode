w = [ (8,4,0),(10,5,0),(25,6,0),(40,7,0),(74,8,0) ]
a = [ (i,0,j) | (i,j) <- zip [13,31,53,75,102] [1..5] ]
r = [ (25,1,0),(50,2,0),(100,3,0),(20,0,1),(40,0,2),(80,0,3) ]

select [] _ = [[]]
select _ 0 = [[]]
select (x:xs) i = (select xs i) ++ (map (\s -> x:s) $ select xs (i-1))

u = [ [i] ++ as ++ rs | i <- w, as <- select a 1, rs <- select r 2 ]
ssum :: [(Int,Int,Int)] -> (Int,Int,Int)
ssum [] = (0,0,0)
ssum ((i,j,k):xs) = (i+m,j+n,k+o)
	where
		(m,n,o) = ssum xs
main = do
	print (foldr max 10 [ i | (i,j,k) <- map ssum u, j+k<10 ])
