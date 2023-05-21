whoMax :: Integer -> Integer -> Integer -> Integer
whoMax a b c
  | a > b && a > c = a
  | b > c = b
  | otherwise = c


localMaxima' :: [Integer] -> [Integer] -> [Integer]
localMaxima' (a : b : c : list) ans =
  localMaxima' (b : c : list) $
    if whoMax a b c == b
      then b : ans
      else ans
localMaxima' _ ans = ans

localMaxima :: [Integer] -> [Integer]
localMaxima list = localMaxima' list []


