{-# OPTIONS_GHC -Wall #-}

module LogAnalysis where

import Log

-- @parseMessage will parse the given string message to a log message
parseMessage :: String -> LogMessage
parseMessage entry =
  let splits = words entry
      getTs'' x = read $ x !! 1 :: Int
      getTs' x = read $ x !! 2 :: Int
      getSev = getTs''
      getMsg = unwords . drop 2
      getMsg' = unwords . drop 3
      nonErr level = LogMessage level (getTs'' splits) (getMsg splits)
   in case head splits of
        "I" -> nonErr Info
        "W" -> nonErr Warning
        "E" -> LogMessage (Error (getSev splits)) (getTs' splits) (getMsg' splits)
        _ -> Unknown entry

-- @parse will parse the entire log file
parse :: String -> [LogMessage]
parse rows = [parseMessage row | row <- lines rows]

getTs :: LogMessage -> Int
getTs (LogMessage (Error _) ts _) = ts
getTs (LogMessage _ ts _) = ts
getTs (Unknown _) = 0

insert :: LogMessage -> MessageTree -> MessageTree
insert logMsg tree =
  case tree of
    Leaf -> Node Leaf logMsg Leaf
    Node left msg right ->
      case msg of
        Unknown _ -> tree
        _ ->
          if getTs logMsg < getTs msg
            then Node (insert logMsg left) msg right
            else Node left msg (insert logMsg right)

build :: [LogMessage] -> MessageTree
build = foldr insert Leaf 

inorder :: MessageTree -> [LogMessage]
inorder Leaf = []
inorder (Node left msg right) = inorder left ++ [msg] ++ inorder right

whatWentWrong :: [LogMessage] -> [String]
whatWentWrong msgs = [msg | (LogMessage (Error sev) _ msg) <- inorder . build $ msgs, sev >= 50]
