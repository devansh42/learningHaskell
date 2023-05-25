data Stream a = Cons a (Stream a)

streamToList :: Stream a -> [a]
streamToList (Cons x xs) = x : streamToList xs 


instance Show a => Show (Stream a) where
    show :: Show a => Stream a -> String
    show xs = show $ take 20 $ streamToList xs 


streamRepeat :: a -> Stream a
streamRepeat x = Cons x $ streamRepeat x


streamMap :: (a->b) -> Stream a -> Stream b
streamMap fn (Cons x xs) = Cons (fn x) $ streamMap fn xs

streamFromSeed :: (a->a) -> a -> Stream a
streamFromSeed fn x = Cons x $ streamFromSeed fn $ fn x


nats :: Stream Integer
nats = streamFromSeed (+ 1) 0  

