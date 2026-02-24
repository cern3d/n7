(*  Exercice à rendre **)


(*  
   pgcd : int int -> int
   calcule du pgcd
   Parametre (a,b) : int * int, les nombres dont on veut le pgcd
   Resultat : int, pgcd de a et b
   Précondition : a et b strictement positives
*)

let rec pgcd a b = 
  if a - b = 0
  then a
  else if a - b > 0
      then pgcd (a-b) b
else pgcd a (b-a)



let%test _ = pgcd 11 5 = 1
let%test _ = pgcd 11 11 = 11
let%test _ = pgcd 11 22 = 11
let%test _ = pgcd 20 16 = 4