
module Main where

import Parser

main :: IO ()
main = interact (show . runRecipe)

