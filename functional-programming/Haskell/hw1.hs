-- Gerald Brown
-- gemabrow@ucsc.edu

-- Problem 1 :: Write a function which puts first name and last name
-- in reverse order
citeAuthor :: String -> String -> String
citeAuthor firstname lastname = lastname ++ ", " ++ firstname
-- citeAuthor "Herman" "Melville" -- -> "Melville, Herman"

-- Problem 2 :: Write a function which returns the initials of the
-- provided first and last name.
initials :: String -> String -> String
initials (frst:_) (lst:_) = [frst] ++ ". " ++ [lst] ++ "."
-- initials "Herman" "Melville" -- -> "H.M."

-- Problem 3 :: Write a function which returns the title of a book
-- from a tuple. HINT: USE PATTERN MATCHING
title :: (String,String,Int) -> String
title (_, title, _) = title

-- Problem 4 :: Write a function which returns a citation in the
-- format title (author, year)
citeBook :: (String,String,Int) -> String
citeBook (author, title, year) = citation
  where citation = title ++ " (" ++ author ++ ", " ++ show year ++ ")"

-- Problem 5 :: Write a function which returns the string containing all
-- the books as citations in the form returned by citeBook in part 4,
-- separated by newlines. Use recursion to build up the result
bibliography_rec :: [(String,String,Int)] -> String
bibliography_rec [] = ""
bibliography_rec (x:xs) = citeBook x ++ "\n" ++ bibliography_rec xs

-- Problem 6 :: Write a function which returns the average year of the
-- provided books. HINT: DIV PERFORMS INTEGER DIVISION, SUM COMPUTES
-- THE SUM OF A LIST OF NUMBERS, AND MAP TAKES A FUNCTION AND A LIST
-- AND RETURNS A LIST WITH ALL THE ELEMENTS MAPPED TO A FUNCTION.
averageYear :: [(String,String,Int)] -> Int
averageYear [] = 0
averageYear xs = sumYears xs `div` length xs

sumYears :: [(String,String,Int)] -> Int
sumYears [] = 0
sumYears [x] = year x
sumYears xs = sum (map year xs)

-- helper function for stripping tuples to year
year :: (String,String,Int) -> Int
year (_, _, year) = year

-- list of tuples for testing purposes
books :: [(String,String,Int)]
books = [("F. Scott Fitzgerald","Great Gatsby",1925),
        ("Herman Melville","Moby Dick",1851),
        ("Gerald Brown","A Hard Day's Haskell",2016),
        ("Dr. Suess","Hop on Pop",1963),
        ("Dr. Suess","The Cat in the Hat",1957),
        ("Mamie Hunter","A Tale of Two Circuses",2001)]

-- Problem 7 :: Write a function which takes a text with references
-- in the format [n] and returns the total number of references.
references :: String -> Int
references xs =
  let wordList = words xs
      references = filter validReference wordList
  in length references

-- Checks String for '[' at head and ']' at tail
validReference :: String -> Bool
validReference text
  | head text == '['  = last text == ']'
  | otherwise         = False

txt :: String
txt = "[1] and [2] both feature characters who will do whatever it takes to " ++
      "get to their goal, and in the end the thing they want the most ends " ++
      "up destroying them.  In the case of [2] this is a whale. Furthermore, " ++
      "exploring the work of [3] and [6] relates how, on occasion, " ++
      "taking life easier -- echoed in the hits [4] and [5] -- " ++
      "is simply the better route to go..."

-- Problem 8 :: Write a function which takes a list of books and a
-- text with references in the form [n] and returns a text with all
-- references replaced by a citation of the n'th book using the citeBook
-- function from problem 5. HINT: UNWORDS IS THE OPPOSITE OF WORDS
citeText :: [(String, String, Int)] -> String -> String
citeText list text =
  let citedList = [if validReference entry then citeBook (list !! refStringToIndex entry)
                   else entry | entry <- words text]
  in unwords citedList

-- for debugging purposes
getReferences :: String -> [Int]
getReferences [] = error "Need valid input"
getReferences xs =
  let wordList   = words xs
      references = filter validReference wordList
  in map refStringToIndex references

-- PRE-CONDITION: String passes validReference
-- POST-CONDITION: Returns an int of index (reference num - 1)
-- after stripping away '[' and ']' brackets
refStringToIndex :: String -> Int
refStringToIndex [] = error "No valid references"
refStringToIndex x =
  let strippedNum = init (tail x)
  in read strippedNum - 1
