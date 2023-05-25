fib :: Integer -> Integer
fib 0 = 0
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)

fibsl :: [Integer]
fibsl = [fib n | n <- [0 ..]]

fib' :: [Integer] -> Integer -> Integer -> [Integer]
fib' n p pp = n ++ fib' [p + pp] (p + pp) p

fibs2 :: [Integer]
fibs2 = fib' [0, 1] 1 0