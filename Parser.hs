
module Parser where

import Data.Char
import Text.ParserCombinators.Parsec

import Types

recipe = do
  spaces
  title <- many1 $ noneOf ['\n', ':']
  string ":"
  defs <- many def
  --needs <- many1 need
  --actions <- many1 action
  needs <- return []
  actions <- return []
  spaces
  eof
  return $ Recipe title defs needs actions

tok xs = spaces >> string xs

assocTok xs = spaces >> (choice $ map (\(k, v) -> tok k >> return v) xs)

nameCharNonDigit = choice [letter, oneOf ['_', '-']]

name = do
  spaces
  x <- nameCharNonDigit
  xs <- many $ choice [nameCharNonDigit, digit]
  return (x : xs)

def = tok "def" >> choice [defUnit, defAction, defInher]

defUnit = do
  tok "unit"
  n <- name
  q <- qty
  return $ DefUnit n q

qty = do
  m <- mag
  n <- name
  return $ Qty m n

mag = do
  spaces
  numer <- num
  denom <- optionMaybe (string "/" >> num)
  return $ maybe id (flip (/)) denom numer
  where
    num = do
      pre <- many1 digit
      post <- optionMaybe (string "." >> many1 digit)
      return $ read (pre ++ maybe "" id post)

defSpecialArg =
  assocTok [("<text>", TArgText), ("<mag>",  TArgMag), ("<nmag>", TArgNMag)]

defCombArg =
  assocTok [("<cont>", TArgCont), ("<tool>", TArgTool),
            ("<ingred>", TArgIngred True), ("<*ingred>", TArgIngred False)]

defAction =
  assocTok [("comb",    f DefComb    defCombArg),
            ("special", f DefSpecial defSpecialArg)] >>= id
  where
    f con p = do
      args <- many1 (do
        n <- name
        t <- p
        return $ DefArg n t)
      return $ con args

optionList p = do
  x <- optionMaybe p
  return (case x of
    Nothing -> []
    Just x' -> x')

defInher = do
  assocTok [("ingred", f DefIngred Ingred),
            ("cont",   f DefCont   Cont),
            ("tool",   f DefTool   Tool)] >>= id
  where
    f ch par = do
      n <- name
      pars <- optionList (do
        tok "is"
        sepBy1 name (tok ","))
      return $ ch n $ map par pars

runRecipe = runParser recipe () "stdin"

