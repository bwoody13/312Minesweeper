-- functions for displaying Minesweeper in a text interface

module MDisplay where

import MData
import Data.List

{--
Displays, when printed, look like this

  00 Bombs   -- infoLine
  a b c d e  -- topline
a X X F 1 0
b X X 2 0 0
c X F 1 1 1
d X X X X X
e X X X X X

input "(x, y, c)"
   or "(x, y, r)"

X is a covered square
numbers are clues
F is a flag
--}

display :: Game -> IO ()
display g = putStrLn ((makeInfoLine     g) ++
                      (makeTopLine      g) ++
                      (makeDisplayBoard g))

makeInfoLine :: Game -> [Char]
makeInfoLine (Gamestate _ bombs _) = (show bombs) ++ " Bombs \n"

makeTopLine :: Game -> [Char]
makeTopLine (Gamestate (x, _) _ _) = ' ':' ':(intersperse ' ' (take x ['a'..])) ++ "\n"

makeDisplayBoard :: Game -> [Char]
makeDisplayBoard (Gamestate (x, y) bombs board) = flatBoard
  where
    charBoard    :: [[Char]]
    zippedBoard  :: [(Char, [Char])]
    splicedBoard :: [[Char]]
    spreadBoard  :: [[Char]]
    linedBoard   :: [[Char]]
    flatBoard    :: [Char]
    charBoard    = map (map cellToChar) board
    zippedBoard  = zip ['a'..] charBoard
    splicedBoard = foldr (\(label, row) acc -> (label:row):acc) zippedBoard [[]]
    spreadBoard  = map (intersperse ' ') splicedBoard
    linedBoard   = intersperse "\n" splicedBoard
    flatBoard    = concat linedBoard


cellToChar :: Cell -> Char
cellToChar (CellC _ Covered _)          = 'X'
cellToChar (CellC _ Flagged _)          = 'F'
cellToChar (CellC (Clue 0) Uncovered _) = '0'
cellToChar (CellC (Clue c) Uncovered _) = (show c) !! 0
