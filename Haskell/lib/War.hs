module War (deal) where

import Data.List

{--
Function stub(s) with type signatures for you to fill in are given below. 
Feel free to add as many additional helper functions as you want. 

The tests for these functions can be found in src/TestSuite.hs. 
You are encouraged to add your own tests in addition to those provided.

Run the tester by executing 'cabal test' from the war directory 
(the one containing war.cabal)
--}


-- deal is the main function receiving the original permutation.
-- deal will call startGame to generate 2 piles, p1 and p2, and let the game begin!
-- The order of p1 and p2 is that the top card of each deck will be the first element in list.
deal :: [Int] -> [Int]
deal shuf = do
 let [p1,p2] = startGame (convertTo14 (shuf, []), [], [])
 myDeal (p1, p2, [])

-- convertTo14 converts number '1', to '14', so that Ace will be the greatest number in the list.
convertTo14 (shuf, res)
 | length shuf == 0 = res
 | head shuf == 1 = convertTo14 (tail shuf, res ++ [14])
 | otherwise = convertTo14 (tail shuf, res ++ [head shuf])

-- After the game comes to an end, convertToAce will recover the correct denomination of Ace, changing 14 to 1.
convertToAce (shuf, res)
 | length shuf == 0 = res
 | head shuf == 14 = convertToAce (tail shuf, res ++ [1])
 | otherwise = convertToAce (tail shuf, res ++ [head shuf])

-- myDeal is the function that implements the game
myDeal (p1, p2, onHold)
 | length p1 == 0 = convertToAce (p2 ++ onHold, [])
 | length p2 == 0 = convertToAce (p1 ++ onHold, [])
 | head p1 == head p2 = warNow (tail p1, tail p2, reverse (sort (onHold ++ [head p1, head p2])))
 | head p1 < head p2 = myDeal (tail p1, tail p2 ++ reverse (sort (onHold ++ [head p1, head p2])), [])
 | head p2 < head p1 = myDeal (tail p1 ++ reverse (sort (onHold ++ [head p1, head p2])), tail p2, [])

-- warNow is the function that deals with War scenarios, i.e, face-up cards are equal.
warNow (p1, p2, onHold)
 | length p1 == 0 = convertToAce (p2 ++ onHold, [])
 | length p2 == 0 = convertToAce (p1 ++ onHold, [])
 | otherwise = myDeal (tail p1, tail p2, reverse (sort (onHold ++ [head p1, head p2])))

-- startGame generates 2 players' piles and let the game begin!
startGame (shuf, p1, p2)
 | length shuf == 0 = [p1, p2]
 | otherwise = startGame (tail (tail shuf), (head shuf) : p1, head (tail shuf) : p2)
 