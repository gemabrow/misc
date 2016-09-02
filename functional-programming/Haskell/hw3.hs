-- Gerald Brown
-- gemabrow@ucsc.edu
import           Data.List

-- Problem 1 :: Suppose we have the following type of binary search trees
-- with keys of type k and values of type v:
data BST k v = Empty
             | Node k v (BST k v) (BST k v)
-- Write a val function that returns Just the stored value at the root node
-- of the tree. If the tree is empty, val returns Nothing.
--
val :: BST k v -> Maybe v
val Empty           = Nothing
val (Node _ v _ _)  = Just v

--------------------------------------------------------------------------------

-- Problem 2 :: Write a size function that returns the
-- number of nodes in the tree.
size :: BST k v -> Int
size Empty          = 0
size (Node k v l r) = 1 + size l  + size r

--------------------------------------------------------------------------------

-- Problem 3 :: Write an ins function that inserts a value v
-- using k as key. If the key is already used in the tree,
-- it just updates the value, otherwise it will add a new node
-- while maintaining the order of the binary search tree.
-- Here, the (Ord k) in the type assignment means that the operators
-- <,> and == can be applied to values of type k.
ins :: (Ord k) => k -> v -> BST k v -> BST k v
ins key newV Empty = Node key newV Empty Empty
ins key newV (Node k v l r)
    | key == k  =  Node k newV l r
    | key <  k  =  Node k v (ins key newV l) r
    | key >  k  =  Node k v l $ ins key newV r

--------------------------------------------------------------------------------

-- Problem 4 :: Make BST an instance of the Show type class. You will have to
-- implement the show function such that the result every node of the tree is
-- shown as "(leftTree value rightTree)".
--
instance (Show v) => Show (BST k v) where
   show Empty          = ""
   show (Node k v l r) = "(" ++ show l ++ show v ++ show r ++ ")"

--------------------------------------------------------------------------------

-- Problem 5 :: Suppose we have the following type
data JSON = JStr String
           | JNum Double
           | JArr [JSON]
           | JObj [(String, JSON)]
-- Make JSON an instance of the Show type class. You will have to implement the
-- show function such that the output looks like normal JSON.
-- Hint: Use intercalate of the module Data.List to join a list of strings
-- with commas
instance Show JSON where
    show = getJSONString

-- helper function that returns string formatted according to input type
getJSONString :: JSON -> String
getJSONString (JStr s) = show s
getJSONString (JNum d) = show d
getJSONString (JArr a)
    | not (null a)     = "[" ++ intercalate "," (map getJSONString a) ++"]"
    | otherwise        = "[]"
getJSONString (JObj o)
    | not (null o)     = "{" ++ intercalate "," (map jObjToString o) ++ "}"
    | otherwise        = "{}"

-- formats string for individual entries of JObj matching output of
-- ""foo":23.0" given "("foo",JNum 23)"
jObjToString :: (String, JSON) -> String
jObjToString (str, x) = "\"" ++ str ++ "\":" ++ getJSONString x

--------------------------------------------------------------------------------

-- Problem 6 :: Suppose we have a type class for everything that can be
-- converted to and from JSON.
class Json a where
   toJson :: a -> JSON
   fromJson :: JSON -> a
-- Make Double and lists of Json-things members of the type class Json.
-- You will have to implement toJson and fromJson for each of these types.
instance Json Double where
    toJson            = JNum
    fromJson (JNum d) = d

instance (Json a) => Json [a] where
    toJson         xs = JArr $ map toJson xs
    fromJson (JArr xs)= map fromJson xs
