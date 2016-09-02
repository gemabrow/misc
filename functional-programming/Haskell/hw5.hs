---------------------
-- Program: hw5.hs
-- Authors: Gerald Brown and Ivan Alvarado
-- On this homework, we worked together for 6 hours,
-- Gerald worked independently for 12+ hours,
-- and Ivan worked independently for 8+ hours.
----------------------
-- Gerald Brown
-- gemabrow@ucsc.edu
--
-- Ivan Alvarado
-- ivalvara@ucsc.edu
-------------------------------------------------------------------------------

import           Control.Applicative (Applicative, pure, (<*>))
import           Control.Monad
import           Data.Char

-- Parser Framework

data Parser a = Parser (String -> [(a,String)])

run :: Parser a -> String -> [(a,String)]
run (Parser f) = f

satP :: (Char -> Bool) -> Parser Char
satP pred = Parser (\cs -> case cs of
                            []    -> []
                            c:cs' -> [ (c,cs') | pred c ])
digit = satP isDigit

instance Monad Parser where
  return a = Parser (\cs -> [(a,cs)])
  pa >>= fpb = Parser (\cs -> do (a,cs') <- run pa cs
                                 run (fpb a) cs')

instance Functor Parser where
  fmap = liftM

instance Applicative Parser where
  pure = return
  (<*>) = ap

(<|>) :: Parser a -> Parser a -> Parser a
p1 <|> p2 = Parser (\cs -> run p2 cs ++ run p1 cs)

zeroOrMore :: Parser a -> Parser [a]
zeroOrMore p = return [] <|> oneOrMore p

oneOrMore :: Parser a -> Parser [a]
oneOrMore p = do x  <- p
                 xs <- zeroOrMore p
                 return (x:xs)

first :: Parser a -> Parser a
first p = Parser (\cs -> case run p cs of
                          []     -> []
                          (r:rs) -> [r])

chain :: Parser a -> Parser (a -> a -> a) -> Parser a
chain p opp = do x <- p
                 tryMore x
  where tryMore x = first (return x <|> more x)
        more x = do op <- opp
                    y  <- p
                    tryMore (op x y)

intP :: Parser Int
intP = do digits <- first (oneOrMore digit)
          return (read digits)

-- alpha stuff just for funsies
alpha = satP isAlpha

alphaP :: Parser String
alphaP = first (zeroOrMore alpha)

-------------------------------------------------------------------------------
-- Problem 4 ::  Change this calculator's type from Int to Double -------------
-------------------------------------------------------------------------------
-- helper function to check that char input satisfies predicate
char :: Char -> Parser Char
char = satP . (==)

-- parses doubles with input form of exactly [oneOrMore left].[oneOrMore right]
doubleP' :: Parser Double
doubleP' = do left  <- intP
              char '.'
              right <- intP
              return (read (show left ++ "." ++ show right) )

-- parses either doubles of above format, or integers -> doubles
doubleP :: Parser Double
doubleP = first (fmap fromIntegral intP <|> doubleP')

-- Calculator
addOp :: Parser (Double -> Double -> Double)
addOp = do char '+' ; return (+)
    <|> do char '-' ; return (-)

mulOp :: Parser (Double -> Double -> Double)
mulOp = do char '*' ; return (*)
    <|> do char '/' ; return (/)

calc :: Parser Double
calc = let mulExpr = chain doubleP mulOp
       in  chain mulExpr addOp

-------------------------------------------------------------------------------
-- Problem 5 :: Extend this calculator by adding an exponentiation operator ---
-------------------------------------------------------------------------------
expOp :: Parser (Double -> Double -> Double)
expOp = do satP (== '^') ; return (**)

calc2 :: Parser Double
calc2 = let expExpr = chain doubleP expOp
            mulExpr = chain expExpr mulOp
        in  chain mulExpr addOp

-------------------------------------------------------------------------------
-- Problem 6 :: Extend the calculator by adding parentheses to the parser -----
-------------------------------------------------------------------------------
parensP' :: Parser Double
parensP' = do char '('
              middle <- calc3
              char ')'
              return middle

parensP :: Parser Double
parensP = doubleP <|> parensP'

calc3 :: Parser Double
calc3 = let expExpr = chain parensP expOp
            mulExpr = chain expExpr mulOp
        in  chain mulExpr addOp
