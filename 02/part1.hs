module Part1(Policy(Policy), checkPasswords) where

data Policy = Policy { char :: Char, min :: Int, max :: Int } deriving (Show)

checkPassword :: String -> Policy -> Bool
checkPassword pw (Policy c min max) = cs >= min && cs <= max
                                    where cs = length $ filter (== c) pw

parseLine :: String -> (String, Policy)
parseLine s = (pass, Policy (head char) (read min :: Int) (read max :: Int))
            where (char, _:pass) = break (== ':') $ filter (/= ' ') rest
                  (min, _:max) = break (== '-') minMax
                  (minMax, rest) = break (== ' ') s

checkPasswords :: (String -> Policy -> Bool) -> IO ()
checkPasswords check = do
    content <- readFile "input"
    let entries = map parseLine (lines content)
    let checked = map (uncurry check) entries
    putStrLn $ show (length $ filter (== True) checked) ++ " passwords valid"

main :: IO ()
main = checkPasswords checkPassword
