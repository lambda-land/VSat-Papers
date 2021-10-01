module VSAT where

import Prelude hiding (and,or)


type Dim = String
type Var = String

data Op = And | Or
  deriving (Eq,Show)

data Exp
   = Sym
   | Unit
   | Ref Var
   | Not Exp
   | Bin Op Exp Exp
   | Chc Dim Exp Exp
  deriving Eq

instance Show Exp where
  show Sym     = "s"
  show Unit    = "o"
  show (Ref x) = x
  show (Chc d l r)   = concat [d, "<", show l, ",", show r, ">"]
  show (Bin Or l r)  = show l ++ " | " ++ show r
  show (Bin And l r) = help l ++ " & " ++ help r
    where
      help e@(Bin Or _ _) = "(" ++ show e ++ ")"
      help e              = show e

and  = Bin And
or   = Bin Or
a    = Ref "a"
b    = Ref "b"
c    = Ref "c"
chc  = Chc "D"
chc' = Chc "D'"


-- | Structure of accumulation.
acc :: Exp -> Exp
acc (Ref _)     = Sym
acc (Not e)     = case acc e of
    Sym -> Sym
    e'  -> Not e'
acc (Bin o l r) = case (acc l, acc r) of
    (Sym, Sym) -> Sym
    (l', r')   -> Bin o l' r'
acc e = e

-- | Structure of evaluation.
eval :: Exp -> Exp
eval Sym           = Unit
eval (Bin And l r) = case (eval l, eval r) of
    (Unit, r') -> r'
    (l', Unit) -> l'
    (l', r')   -> Bin And l' r'
eval e = let e' = acc e
         in if e == e' then e' else eval e'


data Ctx = InL Op Exp Ctx
         | InR Op Ctx -- there's a Sym in here!
         | InN Ctx    -- there's a Sym in here!
         | Top

type Cfg = [(Dim,Bool)]

-- | Structure of choice removal.
cr :: Cfg -> Ctx -> Exp -> (Exp,Int)

cr c Top Sym = (eval Sym,1)

cr c (InL o r z) Sym = cr c (InR o z) r
cr c (InR o z)   Sym = let s = acc (Bin o Sym Sym)
                       in cr c z s

cr c (InN z)     Sym = let s = acc (Not Sym)
                       in cr c z s

-- recursive cases
cr c z (Not e)       = cr c (InN z) e

cr c z (Bin And l r) = cr c (InL And r z) l
cr c z (Bin Or  l r) = cr c (InL Or  r z) l

cr c z (Chc d l r)   = case lookup d c of
    Just True  -> cr c z l
    Just False -> cr c z r
    Nothing    -> let (Unit,i) = cr ((d,True):c) z l
                      (Unit,j) = cr ((d,False):c) z r
                  in (Unit,i+j)

cr c z e = let e' = acc e
           in if e == e' then error "boom" else cr c z e'


-- Examples from accumulation section.
ex1 = or a (and a b)
ex2 = or ex1 (and (chc a (and a b)) ex1)


-- Example from evaluation section.
ex3 = and (or a b) (chc a c)

ex4 = and (chc' a c) (or a b)
