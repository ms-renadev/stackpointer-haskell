                        --like [a] list of i-input nako then it will return 1 number
myProduct :: Num a => [a] -> a
--func name  --type class constraint
myProduct []     = 1
-- rep empty na list, returns 1 means empty siya

myProduct (x:xs) = x * myProduct xs

main :: IO ()
main = do
    let result = myProduct [2, 3, 4]
    print result