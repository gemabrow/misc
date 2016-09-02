-- Gerald Brown
-- gemabrow@ucsc.edu

-- Problem 1 :: Using recursion, write a function which behaves
-- just like the standard foldl
myFoldl :: (a -> b -> a) -> a -> [b] -> a
myFoldl f z [] = z
myFoldl f z (x:xs) = myFoldl f (f z x) xs

-- Problem 2 :: Using the standard foldl (not myFoldl), write
-- a function which behaves just like the standard reverse
myReverse :: [a] -> [a]
myReverse = foldl (flip (:)) []

-- Problem 3 :: Using the standard foldl (not myFoldl), write
-- a function which behaves just like the standard foldr.
myFoldr :: (a -> b -> a) -> a -> [b] -> a
myFoldr f z xs = foldl f z (reverse xs)

-- Problem 4 :: Using the standard foldr (not myFoldr), write
-- a function which behaves just like the standard foldl.
myFoldl2 :: (a -> b -> a) -> a -> [b] -> a
myFoldl2 f z xs = foldr (\b g x -> g (f x b)) id xs z

-- Problem 5 :: Write a function which returns true if the
-- provided character is in the range 'A' to 'Z'.
-- HINT: ELEM CHECKS WHETHER AN ELEMENT IS IN A SET.
-- RANGES (like [1...3]) also work on characters.
isUpper :: Char -> Bool
isUpper x = x `elem` ['A'..'Z']

-- Problem 6 :: Using the standard filter, write a function
-- which returns only the capital letters of the provided
-- string. HINT: USE THE isUpper FUNCTION FROM Q5.
onlyCapitals1 :: String -> String
onlyCapitals1 = filter isUpper

-- Problem 7 :: Using list comprehension, write a function
-- which returns only the capital letters of the provided
-- string. HINT: Use the isUpper function from Q5.
onlyCapitals2 :: String -> String
onlyCapitals2 xs = [ x | x <- xs, isUpper x]

-- Problem 8 :: Using recursion, write a function which
-- returns only the capital letters of the provided string.
-- HINT: Use pattern matching, guards, and the isUpper function.
onlyCapitals3 :: String -> String
onlyCapitals3 [] = ""
onlyCapitals3 (x:xs)
    | isUpper x = x:onlyCapitals3 xs
    | otherwise = onlyCapitals3 xs

-- Problem 9 :: Write a function which returns a tuple with the
-- quotient and the remainder of an integer division of the
-- provided two numbers.
-- HINT: div performs integer division.
-- mod returns the modulus of an integer division.
divRemainder :: Int -> Int -> (Int, Int)
divRemainder x y = (div x y, mod x y)

-- Problem 10 :: Write a function which returns the sum of the
-- digits of the given integer.
-- HINT: Use recursion, guards, and what you learned in Q9.
digitSum :: Int -> Int
digitSum 0 = 0
digitSum x = x `mod` 10 + digitSum (x `div` 10)

-- Problem 11 :: Write a function which takes a string of digits
-- and spells out the number as a string in English.
sayNum :: Integer -> String
sayNum x
    | x == 0    = "zero"
    | x < 0     = "negative" ++ sayNumReiter 1 (abs x)
    | otherwise = sayNumReiter 1 x

sayNumReiter :: Integer -> Integer -> String
sayNumReiter count x
    | thousands > 0  = sayNumReiter (count+1) thousands ++
                       thousandPowers !! fromIntegral count ++
                       lastThree
    | otherwise      = lastThree
    where thousands = x `div` 1000
          hundreds  = x `mod` 1000 `div` 100
          remainder = x `mod` 100
          lastThree = hundredNumbers !! fromIntegral hundreds ++
                             if remainder < 20 && remainder > 9
                             then low !! fromIntegral remainder
                             else midNumbers !! (fromIntegral remainder `quot` 10) ++
                             low !! (fromIntegral remainder `mod` 10)

-- write out LOW with hundred appended, blank for 0
low :: [String]
low = ["", " one", " two", " three", " four", " five",
       " six", " seven", " eight", " nine",
       " ten", " eleven", " twelve", " thirteen", " fourteen",
       " fifteen", " sixteen", " seventeen", " eighteen",
       " nineteen"]

midNumbers :: [String]
midNumbers = ["", "", " twenty", " thirty", " forty", " fifty",
              " sixty", " seventy", " eighty", " ninety"]

hundredNumbers :: [String]
hundredNumbers = ["", " one hundred", " two hundred", " three hundred",
                  " four hundred", " five hundred"," six hundred",
                  " seven hundred", " eight hundred", " nine hundred"]

thousandPowers :: [String]
thousandPowers = ["", " thousand", " million", " billion", " trillion",
              " quadrillion", " quintillion", " sextillion",
              " septillion", " octillion", " nonillion", " decillion",
              " undecillion", " duodecillion", " tredecillion",
              " quattuordecillion", " quindecillion", " sexdecillion",
              " septendecillion", " octodecillion", " novemdecillion",
              " vigintillion"]
