
module Types where

type Mag = Double

type NMag = Int

type Name = String

type Unit = Name

data Qty = Qty Mag Unit deriving (Show)

data Need =
    NeedIngred Name Qty Ingred
  | NeedCont   NMag Cont
  | NeedTool   NMag Tool deriving (Show)

data Ingred = Ingred Name deriving (Show)

data Cont = Cont Name deriving (Show)

data Tool = Tool Name deriving (Show)

data Error = ENotEnough deriving (Show)

data SpecialArgType =
    TArgText
  | TArgMag
  | TArgNMag
  deriving (Show)

data CombArgType =
    TArgIngred Bool
  | TArgCont
  | TArgTool
  deriving (Show)

data DefArg a = DefArg Name a deriving (Show)

data Def =
    DefUnit Unit Qty
  | DefComb [DefArg CombArgType]
  | DefSpecial [DefArg SpecialArgType]
  | DefIngred Name [Ingred]
  | DefCont Name [Cont]
  | DefTool Name [Tool]
  deriving (Show)

data SpecialArg =
    ArgText   String
  | ArgMag    Mag
  | ArgNMag   NMag
  deriving (Show)

data IngredRef = IRef (Either Mag Qty) Name deriving (Show)

data Action =
    Comb Cont [Tool] [IngredRef]
  | Special Int [SpecialArg]
  deriving (Show)

data Recipe = Recipe Name [Def] [Need] [Action] deriving (Show)

