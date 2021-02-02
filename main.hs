import Data.List.Split
import Data.List

data Def = Def String Bool deriving (Show)

specialChars = ["T","F","|","&","^","~"]

main = do
    defs <- getLine
    expr <- getLine
    putStrLn $ show $ eval defs expr

eval :: String -> String -> Bool
eval _ ""      = error "Cannot evaluate empty expression"
eval defs expr = evalTokens $ substituteDefs (words expr) (parseDefs defs)

parseDefs :: String -> [Def]
parseDefs s = parseDefTokens $ words s

parseDefTokens :: [String] -> [Def]
parseDefTokens (name:"=":val:rest) 
    | name `elem` specialChars = error $ name ++ ": invalid name in definitions"
    | val == "T"               = (Def name True):(parseDefTokens rest)
    | val == "F"               = (Def name False):(parseDefTokens rest)
    | otherwise                = error $ val ++ ": invalid syntax in definitions"
parseDefTokens [] = []
parseDefTokens (_:_:_:_) = error "Expected '='"

substituteDefs :: [String] -> [Def] -> [String]
substituteDefs [] defs = []
substituteDefs (x:xs) defs 
    | x `elem` specialChars = x:(substituteDefs xs defs)
    | otherwise             = (getDefStrValue x):(substituteDefs xs defs)
    where 
        getDefStrValue :: String -> String
        strFromDef     :: Def -> String
        getDefStrValue name = 
            case name `elemIndex` (map (\(Def n _) -> n) defs) of
                Just idx -> strFromDef $ defs !! idx
                Nothing  -> error $ name ++ ": invalid syntax"
        strFromDef (Def _ val) 
            | val == True  = "T"
            | val == False = "F"

evalToken :: [Bool] -> String -> [Bool]
evalToken cum "T"      = True:cum
evalToken cum "F"      = False:cum
evalToken (x:y:ys) "|" = (x || y):ys
evalToken _ "|"        = error "Invalid syntax"
evalToken (x:y:ys) "&" = (x && y):ys
evalToken _ "&"        = error "Invalid syntax"
evalToken (x:y:ys) "^" = (x == y):ys
evalToken _ "^"        = error "Invalid syntax"
evalToken (x:xs) "~"   = (not x):xs
evalToken _ "~"        = error "Invalid syntax"
evalToken _ _          = error "Invalid syntax" 

evalTokens :: [String] -> Bool
evalTokens tokens = case (foldl (evalToken) [] tokens) of
    []    -> error "Error: empty value stack when terminating"
    [val] -> val
    _     -> error "Invalid expression: left with too many values on value stack" 
