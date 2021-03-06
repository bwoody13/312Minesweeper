{--
Basic data structures and functions for a game of minesweeper
--}
module MData where

data Game = Gamestate Size Bombs Board WinState
-- Size is the x and y dimensions of the board, number of bombs remaining
type Size = (Int, Int)
-- Bombs is the number of remaining bombs
type Bombs = Int
-- Board is a list of Rows
type Board = [Row]
-- Row is a list of Cells
type Row = [Cell]

data WinState = Win |
                Loss |
                Continue
                deriving (Show,Eq)

-- each Cell is a cell with the contents of the cell
data Cell = CellC Content State Location-- add a location?, new type of either just Int or (Int,Int)
              deriving (Show, Eq)
-- Content is what a cell contains
data Content = Bomb |
               Clue Int |
               Blank
               deriving (Show,Eq)

data State = Covered |
             Flagged |
             Uncovered
             deriving (Show,Eq)

-- Location identifies a particular Cell on the board
type Location = (Int, Int)

data Difficulty = VeryEasy |
                  Easy |
                  Medium |
                  Hard
                  deriving (Show,Eq)

-- Data Functions

getContent :: Board -> Location -> Content
getContent b (x,y) = (\(CellC c _ _) -> c) ((b !! y) !! x)

-- Given a row and a x location and Content, update the cell
setContent :: Board -> Location -> Content -> Board
setContent b loc content = map (setContentRow loc content) b
  where setContentRow :: Location -> Content -> Row -> Row
        setContentRow loc content row =
          map (\(CellC cc cs cl) -> if cl == loc
            then (CellC content cs cl)
            else (CellC cc cs cl)) row

getState :: Board -> Location -> State
getState b (x,y) = (\(CellC _ s _) -> s) ((b !! y) !! x)

-- Given a board, a location and Content, update the cell content
setState :: Board -> Location -> State -> Board
setState b loc state = map (setStateRow loc state) b
  where setStateRow :: Location -> State -> Row -> Row
        setStateRow loc state row =
          map (\(CellC cc cs cl) -> if cl == loc
            then (CellC cc state cl)
            else (CellC cc cs cl)) row

-- gets a board's size so we don't have to always give size as an argument
getSize :: Board -> Size
getSize b = (length (b !! 0), length b)

-- Takes in a location and returns a list of neighbors that are within bounds
findNeighbors :: Location -> Size -> [Location]
findNeighbors location size = filter (isvalid size) (makeNeighbors location)
    where
      isvalid :: Location -> Location -> Bool
      isvalid (xbound, ybound) (x, y) = ((x >= 0) && (x < xbound)) && ((y >= 0) && (y < ybound))
      makeNeighbors :: Location -> [Location]
      makeNeighbors (x, y) = (x-1,y-1):(x,y-1):(x+1,y-1) :
                             (x-1,y):(x+1,y) :
                             (x-1,y+1):(x,y+1):(x+1,y+1):[]
