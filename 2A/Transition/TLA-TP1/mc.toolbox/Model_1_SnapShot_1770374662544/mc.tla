---------------- MODULE mc ----------------
\* Time-stamp: <09 oct 2024 11:53 Philippe Queinnec>

(* Le problème de l'homme, du loup, du mouton et du chou *)
(* Version ensembliste basique *)

EXTENDS Naturals, FiniteSets



CONSTANT
    NBC, NBM, I

VARIABLES
  MG, MD, CG, CD, R
  
SideR == {"D","G"}

TypeOK ==
  [](/\ R \in SideR
)

pasMiam == /\ \neg((CG > MG) /\ (CD > MG))


ToujoursOk == []pasMiam

Solution ==
  []\neg(MD = 0 /\ CD = 0)
----------------------------------------------------------------

Init ==
  /\ MG = 0
  /\ MD = NBM
  /\ CG = 0
  /\ CD = NBM
  /\ R = "D"



inv(r) == IF r = "G" THEN "D" ELSE "G"


bougeM(i) ==
  IF R = "D" THEN
  /\ R' = inv(R)
  /\ MD' = MD - i
  /\ MG' = MG + i
  /\ UNCHANGED <<CG,CD>>
  ELSE 
  /\ R' = inv(R)
  /\ MD' = MD + i
  /\ MG' = MG - i
  /\ UNCHANGED <<CG,CD>>
  
bougeC(i) ==
  IF R = "D" THEN
  /\ R' = inv(R)
  /\ CD' = CD - i
  /\ CG' = CG + i
  /\ UNCHANGED <<MG,MD>>
  ELSE 
  /\ R' = inv(R)
  /\ CD' = CD + i
  /\ CG' = CG - i
  /\ UNCHANGED <<MG,MD>>


Next ==(bougeM(1) /\ bougeC(1))

Spec == Init /\ [] [ Next ]_<<MG, MD, CG, CD, R>>


================================================================
