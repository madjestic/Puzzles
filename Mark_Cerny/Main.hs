{-# LANGUAGE FlexibleContexts #-}

module Main where

import Data.List
import Data.Set    hiding (filter, (\\))

combinations :: Int -> [a] -> [[a]]
combinations size set =
  [ x |  x <- cs size set, (length x) == size]
  where
    cs size xs = [1..size] >>= \n -> mapM (const xs) [1..n]

interleave :: [a] -> [a] -> [a]
interleave xs ys = concat (transpose [xs, ys])

compose :: [Char] -> t -> [[Char]]
compose p cs =
  fmap (interleave p) $ combinations ((length p)-1) "+-*/"

solve :: [Char] -> [Int]
solve s =
  filter (>0) $ toList.fromList $ filter (/=0) $ fmap parse $ concat [ compose x $ combinations ((length s) -1 ) "+-*/" | x <- permutations s]

----------------------------------------------------------------------------------
-- | Parser | --------------------------------------------------------------------
----------------------------------------------------------------------------------
value :: [Char] -> Int -> Int
value s n =
  case s!!n of
    '1' -> 1
    '2' -> 2
    '3' -> 3
    '4' -> 4
    '5' -> 5
    '6' -> 6
    _   -> error "non integer"

operator :: Integral a => [Char] -> Int -> a -> a -> a
operator c n =
    case c!!n of
    '+' -> (+)
    '-' -> (-)
    '*' -> (*)
    '/' -> (div)
    _   -> error "non operator"

-- | solves the formula as a sequence, where position order defines operation order
-- | , hence "2+2*3" == ((2+2)*3) = 12
parse :: [Char] -> Int
parse f =
  case (length f) of
    3 -> v1 `op1` v2
    5 -> v1 `op1` v2 `op2` v3
    7 -> v1 `op1` v2 `op2` v3 `op3` v4
    9 -> v1 `op1` v2 `op2` v3 `op3` v4 `op4` v5
    11-> v1 `op1` v2 `op2` v3 `op3` v4 `op4` v5 `op5` v6
    _ -> error "formula is too long"
  where
    v1  = value    f 0
    v2  = value    f 2
    v3  = value    f 4
    v4  = value    f 6
    v5  = value    f 8
    v6  = value    f 10
    op1 = operator f 1
    op2 = operator f 3
    op3 = operator f 5
    op4 = operator f 7
    op5 = operator f 9
    
----------------------------------------------------------------------------------
-- | Test | --------------------------------------------------------------------
----------------------------------------------------------------------------------
test :: [Char] -> Int -> IO ()
test set val = do
  let listOfSolutions = solutions set
  let idx = elemIndex val listOfSolutions
  let listOfFormulas  = concat [ compose x $ combinations ((length set) -1 ) "+-*/" | x <- permutations set]
  print $ case idx of
            (Just idx) -> "formula for " ++ (show val) ++ "is: " ++ (listOfFormulas !! idx)
            (Nothing)  -> (show val) ++ " has solution"

-- | raw unfiltered solutions for debugging
solutions :: [Char] -> [Int]
solutions s =
   fmap parse $ concat [ compose x $ combinations ((length s) -1 ) "+-*/" | x <- permutations s]


main =
  do
    let set         = "123"
    let ss          = solve set
    let diff        = ([1..(maximum ss)+1] \\ ss)
    print $ solve set
    print $ diff
    putStrLn $ "diff for \"123\" is: " ++ (show $ head diff) ++ "\n"

    let set         = "1234"
    let ss          = solve set
    let diff        = ([1..(maximum ss)+1] \\ ss)
    print $ ss
    print $ diff
    putStrLn $ "diff for " ++ set ++ " is: " ++ (show $ head diff) ++ "\n"

    let set         = "12345"
    let ss          = solve set
    let diff        = ([1..(maximum ss)+1] \\ ss)
    print $ ss
    print $ diff
    putStrLn $ "diff for " ++ set ++ " is: " ++ (show $ head diff) ++ "\n"

    let set         = "123456"
    let ss          = solve set
    let diff        = ([1..(maximum ss)+1] \\ ss)
    print $ ss
    print $ diff
    putStrLn $ "diff for " ++ set ++ " is: " ++ (show $ head diff) ++ "\n"

-- demonstrate that 283 is in the solution set, that will prove that 284 is not the lowest natural number:
    
