data Policy = Policy { char :: Char, min :: Int, max :: Int } deriving (Show)

checkPassword :: String -> Policy -> Bool
checkPassword pw (Policy c min max) = cs >= min && cs <= max
                                    where cs = length $ filter (== c) pw

parseLine :: String -> (String, Policy)
parseLine s = (pass, Policy (head char) (read min :: Int) (read max :: Int))
            where (char, pass) = break (== ':') $ filter (/= ' ') rest
                  (min, _:max) = break (== '-') minMax
                  (minMax, rest) = break (== ' ') s

main :: IO ()
main = do
    content <- readFile "input"
    let entries = map parseLine (lines content)
    let checked = map (uncurry checkPassword) entries
    putStrLn $ show (length $ filter (== True) checked) ++ " passwords valid"
