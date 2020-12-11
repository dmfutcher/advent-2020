import Part1(Policy(Policy), checkPasswords)

checkPassword :: String -> Policy -> Bool
checkPassword pw (Policy c x y) = (length $ filter (== c) chars) == 1
                                where chars = [pw !! (x - 1), pw !! (y - 1)]

main :: IO ()
main = checkPasswords checkPassword
