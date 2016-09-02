-- Gerald Brown
-- gemabrow@ucsc.edu

{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE OverlappingInstances #-}
{-# LANGUAGE UndecidableInstances #-}
import           Control.Monad
import           Data.Int
import           System.Random

--------------------------------------------------------------------------------

-- 1. The following skeleton code includes the Gen typeclass for any test input
-- that can be generated. Anything in the typeclass Random can be generated
-- using randomIO. However, you still need to make Lists and Pairs (tuples with
-- two elements) an instance of the Gen type class. The generated list should
-- have a random length between 0 (empty) and 10 (inclusive).

class (Show a) => Gen a where
    gen :: IO a

instance (Show a, Random a) => Gen a where
    gen = randomIO

instance (Gen a, Gen b) => Gen (a, b) where
    gen = liftM2 (,) gen gen

instance (Gen a) => Gen [a] where
    gen = do
        y <- randomRIO (1,10)
        replicateM y gen

--------------------------------------------------------------------------------

-- 2. As a next step, add the Testable typeclass which will be used to test
-- predicates. These predicates are functions from an arbitary number of
-- arguments to a boolean value.
--
-- You have to complete the missing implementation of the test function, which
-- will generate a random input and pass it to the function until the resulting
-- boolean value indicates whether the test predicate holds or not.

class Testable a where
    test :: a -> String -> IO (Bool, String)

instance Testable Bool where
    test b str =
        if b then return (b, "")
        else return (b, str)

instance (Gen a, Testable b) => Testable (a -> b) where
    test t str = do
        x <- gen
        test (t x) (str ++ show x ++ " ")

--------------------------------------------------------------------------------

-- 3. Finally, implement a quickCheck method. Given a number n and a Testable,
-- it will perform up to n tests with random inputs, repeated calling test.
-- Once a failing test was encountered, it will print an error and stop testing.

-- quickCheck :: (Testable a) => Int -> a -> IO ()
-- quickCheck n t = do
--     testResult <- test t
--     unless (n < 1) $
--         if testResult then quickCheck (n-1) t
--         else putStrLn "Failing"

--------------------------------------------------------------------------------

-- 4. In order to improve the test output, quickCheck should also print a
-- string representation of the counterexample.
--
-- You may have to change the definition of test in order to return a string in
-- addition to the boolean value.  (You only need to submit the extended version
-- in your final program.) For curried, multi argument functions, the string
-- will include all arguments in the right order.

quickCheck :: (Testable a) => Int -> a -> IO ()
quickCheck n t = do
    (testPassed, inputs) <- test t ""
    unless (n < 1) $
      if testPassed then quickCheck (n-1) t
      else putStr "Failing Inputs = ";
           putStrLn inputs;

--------------------------------------------------------------------------------

-- 5. The following two sorting algorithms (insertion sort and quick sort) both
-- have a bug:

isort :: [Int8] -> [Int8]
isort [] = []
isort (x:xs) = insert (isort xs)
  where insert [] = [x]
        insert (h:t) | x > h  = h:insert t
                     | x <= h = x:h:t

qsort :: [Int8] -> [Int8]
qsort [] = []
qsort (x:xs) = qsort [a | a <- xs, a <= x] ++ [x] ++ qsort [a | a <- xs, a > x]

-- Write a comprehensive test for sorting algorithms like qsort and isort which
-- describes exactly the expected behavior. Your function should include tests
-- for what it means to be sorted, so you cannot simply define it in terms of
-- another sort function (like the built-in sort from Data.List). Using
-- quickCheck with this test should give you a counterexample for both qsort
-- and isort.

testSort :: ([Int8] -> [Int8]) -> [Int8] -> Bool
testSort sort lst =
    isSorted modLst
    && sameLength modLst lst
    && sameLength modLst [x | x <- modLst, x `elem` lst]
    where modLst = sort lst

-- a helper function which checks that the length of two lists is
-- equal. This is to check that the contents were not altered e.g.
-- duplicates were removed. For readability.
sameLength :: [Int8] -> [Int8] -> Bool
sameLength x y = length x == length y

-- a helper function that calls on increasingSort and decreasingSort
-- and returns true if either sort is true
isSorted ::[Int8] -> Bool
isSorted [] = True
isSorted [x] = True
isSorted x = increasingSort x || decreasingSort x

-- a recursive helper function for checking a list
-- if smallest-to-largest holds throughout the list
increasingSort :: [Int8] -> Bool
increasingSort [x] = True
increasingSort (x:xs) = (x <= head xs) && increasingSort xs

-- a recursive helper function for checking a list
-- if largest-to-smallest holds throughout the list
decreasingSort :: [Int8] -> Bool
decreasingSort [x] = True
decreasingSort (x:xs) = (x >= head xs) && decreasingSort xs

--------------------------------------------------------------------------------

-- 6. Fix the two functions isort and qsort above.
-- Changed 'h:x:t' to 'x:h:t' at 97:33. Added '=' at 101:39.
