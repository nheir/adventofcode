import Data.List (intersect, isPrefixOf, transpose)
import Data.Maybe (fromJust)

main = interact $ show . solve . parse

parse input = patterns
  where
    patterns = splitList (== "") (lines input)
    splitList sep l
      | null l = []
      | otherwise =
          let (a, b) = break sep l
           in let (c, d) = span sep b in a : splitList sep d

data Reflection = Vert Int | Hori Int deriving (Show, Eq)

solve a = (sum . map (reflValue . score1) $ a, sum . map (reflValue . score2) $ a)
  where
    reflValue (Vert x) = x
    reflValue (Hori x) = 100 * x

score1 pattern = case findReflection pattern of
  Just v -> Vert v
  Nothing -> Hori (fromJust (findReflection (transpose pattern)))

score2 pattern = head [r | r <- vert ++ hori, r /= refl1]
  where
    vert = [Vert v | i <- [0 .. length pattern - 1], j <- [0 .. length (head pattern) - 1], v <- findReflections (edit2 i j pattern)]
    hori = [Hori h | i <- [0 .. length pattern - 1], j <- [0 .. length (head pattern) - 1], h <- findReflections $ transpose (edit2 i j pattern)]
    refl1 = score1 pattern
    edit1 0 (x : xs) = (if x == '#' then '.' else '#') : xs
    edit1 j (x : xs) = x : edit1 (j - 1) xs
    edit1 _ [] = []
    edit2 0 j (s : q) = edit1 j s : q
    edit2 i j (s : q) = s : edit2 (i - 1) j q
    edit2 _ _ [] = []

findReflection [] = Nothing
findReflection (a : q) = case foldr (intersect . reflection) (reflection a) q of
  [] -> Nothing
  (a : q) -> Just a

findReflections [] = []
findReflections (a : q) = foldr (intersect . reflection) (reflection a) q

reflection [] = []
reflection s@(a : q) = reflection_aux 1 [a] q
  where
    reflection_aux _ _ [] = []
    reflection_aux n p s@(x : xs) =
      let rs = reflection_aux (n + 1) (head s : p) (tail s)
       in if p `isPrefixOf` s || s `isPrefixOf` p then n : rs else rs