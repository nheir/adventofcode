import Data.List (nub)

data Spell = Spell { cout :: Int, damage :: Int, heal :: Int, armor :: Int, mana :: Int, duration :: Int } deriving (Eq,Show)

list_spells = [
    Spell 53 4 0 0 0 1,
    Spell 73 2 2 0 0 1,
    Spell 113 0 0 7 0 6,
    Spell 173 3 0 0 0 6,
    Spell 229 0 0 0 101 5
    ]
-- Mana, ma vie, vie du méchant, spell actif
data Jeu = Win (Int,[Spell]) | Lost Int | State { mp :: Int, vie :: Int, boss :: Int, armure :: Int, spells :: [(Int,Spell)], conso :: Int, trace :: [Spell] } deriving (Show)

instance Eq Jeu where
  Win a == Win b = fst a == fst b
  Lost a == Lost b = a == b
  State a b c d e f _ == State g h i j k l _ = (a,b,c,d,e,f) == (g,h,i,j,k,l)
  _ == _ = False

round_spell spell = spell { duration= duration spell -1 }

step_spells :: Jeu -> Jeu
step_spells (Win a) = (Win a)
step_spells (Lost a) = (Lost a)
step_spells state
  | newBoss <= 0 = Win (conso state, trace state)
  | otherwise = state {
      mp= mp state + (sum $ map (mana . snd) spells_state),
      vie= vie state + (sum $ map (heal . snd) spells_state),
      boss= newBoss,
      armure= sum $ map (armor . snd) spells_state,
      spells= filter ((> 0) . duration . snd) $ zip (map fst spells_state) (map (round_spell . snd) spells_state)
    }
    where
      newBoss = boss state - (sum $ map (damage . snd) spells_state)
      spells_state = spells state

step_boss :: Jeu -> Jeu
step_boss (Win a) = (Win a)
step_boss (Lost a) = (Lost a)
step_boss state
  | newVie <= 0 = Lost (conso state)
  | otherwise = state { vie = newVie}
  where
    newVie = vie state - 10 + armure state

step_player :: Jeu -> [Jeu]
step_player (Win a) = [Win a]
step_player (Lost a) = [Lost a]
step_player state
  | null newSpells = [Lost (conso state)]
  | otherwise = [ state { mp = mp state -(cout $ snd $ head l), spells = l, conso = conso state + (cout $ snd $ head l),  trace = (snd $ head l) : trace state} | l <- newSpells ]
  where
    newSpells = [ (newSpell,list_spells !! newSpell):spells_state | newSpell <- manaSpells ]
    manaSpells = filter ((<= (mp state)) . cout . (!!) list_spells) possibleSpells
    possibleSpells = filter (not . (`elem` spells_id)) [0..4]
    spells_id = map fst spells_state
    spells_state = spells state

initState :: Jeu
initState = State { mp=500, vie=50, boss=71, armure=0, spells=[],conso=0,trace=[] }

oneRound :: Jeu -> [Jeu]
oneRound = map (step_boss . step_spells) . step_player . step_spells

isEnded :: [Jeu] -> Bool
isEnded [] = True
isEnded ((Win _):xs) = isEnded xs
isEnded ((Lost _):xs) = isEnded xs
isEnded _ = False

filterWin :: [Jeu] -> [(Int,[Spell])]
filterWin [] = []
filterWin ((Win a):xs) = a : filterWin xs
filterWin (x:xs) = filterWin xs

oneRoundList :: [Jeu] -> [Jeu]
oneRoundList = nub . concat . map oneRound

main :: IO ()
main = do
  let res = head $ filter isEnded $ iterate oneRoundList [initState]
  print $ minimum $ map fst $ filterWin res
  print $ maximum $ map (length . snd) $ filterWin res
