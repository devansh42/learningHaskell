-- import Data.List
-- histogram:: [Integer] -> String
import Data.Text (Text, intercalate)

atMay :: [a] -> Int -> Maybe a
atMay list index
  | index >= length list = Nothing
  | otherwise =
      let x = drop index . take (index + 1) $ list
       in case x of
            [a] -> Just a
            _ -> Nothing

histogram' :: [Int] -> [[Char]] -> [[Char]]
histogram' [] ans = ans
histogram' (h : xs) ans =
  let val = atMay ans h
   in case val of
        Nothing -> histogram' xs ans
        Just n -> histogram' xs $ take h ans ++ [n ++ ['*']] ++ drop (h + 1) ans

histogram :: [Int] -> [[Char]]
histogram list =
  let initFreq = [[] | _ <- [0 .. 9]]
   in histogram' list initFreq

data JoinedString = JoinedString String [String] Bool deriving (Show)

-- line -> next Iteration Line
reduceHistorgram :: [String] -> [String] -> Bool -> JoinedString
reduceHistorgram [] thisIteration unsaturated = JoinedString [] thisIteration unsaturated
reduceHistorgram (h : xs) thisIteration unsaturated =
  let front = take 1 h
      val = if front == "" then " " else "*"
      dropped = drop 1 h
      vall = if val == " " then "" else dropped
      updatedIteration = thisIteration ++ [vall]
      JoinedString nextVal updatedIteration' unsaturated' = reduceHistorgram xs updatedIteration $ if unsaturated then unsaturated else val == "*"
      str = val ++ nextVal
   in JoinedString str updatedIteration' unsaturated'

reduceHistorgram' :: JoinedString -> [String]
reduceHistorgram' (JoinedString ans nextIteration True) = ans : reduceHistorgram' (reduceHistorgram nextIteration [] False)
reduceHistorgram' (JoinedString ans _ _) = [ans]

suffix = ['=' | x <- [0 .. 9]] ++ "\n" ++ show [0 .. 9]

notEmpty :: String -> Bool
notEmpty x = length x > 0

driverHistogram ar =
  let ar' = reduceHistorgram' (JoinedString [] (histogram ar) True)
      nar = filter notEmpty ar'
      rev = reverse nar
      ar'' = rev ++ ["==========", "0123456789"]
   in join ar''

join :: [String] -> String
join [] = ""
join (h : xs) = h ++ "\n" ++ join xs