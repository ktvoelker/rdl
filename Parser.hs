
module Parser where

import Data.Char
import Text.ParserCombinators.Parsec

import Types

recipe = do
  spaces
  title <- many1 $ noneOf ['\n', ':']
  string ":"
  many def
  many1 need
  many1 action
  return title

tok xs = spaces >> string xs

assocTok xs = spaces >> choice $ map (\(k, v) -> string k >> return v) xs

nameCharNonDigit = choice [letter, oneOf ['_', '-']]

name = do
  spaces
  x <- nameCharNonDigit
  xs <- choice [nameCharNonDigit, digit]
  return (x : xs)

def = tok "def" >> choice [defUnit, defAction, defInher]

defUnit = do
  tok "unit"
  n <- name
  q <- qty
  return $ DefUnit n q

defAction = tok "action" >> many1 defArg >>= (return . DefAction)

optionList p = do
  x <- optionMaybe p
  return (case x of
    Nothing -> []
    Just x' -> x')

defInher = do
  (ch, par) <- assocTok [("ingred", (DefIngred, Ingred)),
                         ("cont",   (DefCont,   Cont)),
                         ("tool",   (DefTool,   Tool))]
  n <- name
  pars <- optionList do
    tok "is"
    sepBy1 name (tok ",")
  return $ ch n $ map par pars

runRecipe = runParser recipe () "stdin"

