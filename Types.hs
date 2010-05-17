
module Types where

type Mag = Double

type NMag = Int

type Name = String

type Unit = Name

data Qty = Qty Unit Mag deriving (Show)

data DefUnit = DefUnit Unit Qty deriving (Show)

data Need =
    NeedIngred Qty  Ingred
  | NeedCont   NMag Cont
  | NeedTool   NMag Tool deriving (Show)

data Ingred = Ingred Name deriving (Show)

data Cont = Cont Name deriving (Show)

data Tool = Tool Name deriving (Show)

data Error = ENotEnough deriving (Show)

data ArgType =
    TArgText | TArgMag | TArgNMag | TArgQty | TArgIngred | TArgCont | TArgTool
  | TArgList ArgType
  deriving (Show)

data DefArg = DefArg Bool ArgType deriving (Show)

data DefAction = DefAction [([Name], DefArg)] deriving (Show)

data Arg =
    ArgText   String
  | ArgMag    Mag
  | ArgNMag   NMag
  | ArgQty    Qty
  | ArgIngred (Either Mag Qty) Ingred
  | ArgCont   Cont
  | ArgTool   Tool
  | ArgList   [Arg]
  deriving (Show)

data Action = Action DefAction [Arg] deriving (Show)

data Recipe = Recipe [DefUnit] [Need] [Action] deriving (Show)

