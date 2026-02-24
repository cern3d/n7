(* Exercice 1*)

(* max : int list -> int  *)
(* Paramètre : liste dont on cherche le maximum *)
(* Précondition : la liste n'est pas vide *)
(* Résultat :  l'élément le plus grand de la liste *)
let int_max x y = if x>y then x else y
let rec max l =
  List.fold_left int_max 0 l

(* TO DO : copier / coller les tests depuis conwayTests.txt *)
(************ tests de max ************)
let%test _ = max [ 1 ] = 1
let%test _ = max [ 1; 2 ] = 2
let%test _ = max [ 2; 1 ] = 2
let%test _ = max [ 1; 2; 3; 4; 3; 2; 1 ] = 4

(* max_max : int list list -> int  *)
(* Paramètre : la liste de listes dont on cherche le maximum *)
(* Précondition : il y a au moins un élement dans une des listes *)
(* Résultat :  l'élément le plus grand de la liste *)
let max_max l =
  max (List.flatten l)

(* TO DO : copier / coller les tests depuis conwayTests.txt *)
(************ tests de max_max ************)
let%test _ = max_max [ [ 1 ] ] = 1
let%test _ = max_max [ [ 1 ]; [ 2 ] ] = 2
let%test _ = max_max [ [ 2 ]; [ 2 ]; [ 1; 1; 2; 1; 2 ] ] = 2
let%test _ = max_max [ [ 2 ]; [ 1 ] ] = 2
let%test _ = max_max [ [ 1; 1; 2; 1 ]; [ 1; 2; 2 ] ] = 2


(* Exercice 2*)

(* suivant : int list -> int list *)
(* Calcule le terme suivant dans une suite de Conway *)
(* Paramètre : le terme dont on cherche le suivant *)
(* Précondition : paramètre différent de la liste vide *)
(* Retour : le terme suivant *)
let rec int_suivant l counter nombre =
  match l with
  |[]->[counter;nombre]
  |t::q->if t=nombre then int_suivant q (counter+1) nombre else [counter;nombre]@(int_suivant q 1 t)

let suivant l =
  match l with
  |[]->[]
  |t::q-> int_suivant q 1 t

(* TO DO : copier / coller les tests depuis conwayTests.txt *)
(************ tests de suivant ************)
let%test _ = suivant [ 1 ] = [ 1; 1 ]
let%test _ = suivant [ 2 ] = [ 1; 2 ]
let%test _ = suivant [ 3 ] = [ 1; 3 ]
let%test _ = suivant [ 1; 1 ] = [ 2; 1 ]
let%test _ = suivant [ 1; 2 ] = [ 1; 1; 1; 2 ]
let%test _ = suivant [ 1; 1; 1; 1; 3; 3; 4 ] = [ 4; 1; 2; 3; 1; 4 ]
let%test _ = suivant [ 1; 1; 1; 3; 3; 4 ] = [ 3; 1; 2; 3; 1; 4 ]
let%test _ = suivant [ 1; 3; 3; 4 ] = [ 1; 1; 2; 3; 1; 4 ]
let%test _ = suivant [3;3] = [2;3]

(* suite : int -> int list -> int list list *)
(* Calcule la suite de Conway *)
(* Paramètre taille : le nombre de termes de la suite que l'on veut calculer *)
(* Paramètre depart : le terme de départ de la suite de Conway *)
(* Résultat : la suite de Conway *)
let rec suite n l =
  if n = 1 then [l] else
  l::(suite (n-1) (suivant l))

(* TO DO : copier / coller les tests depuis conwayTests.txt *)
(************ tests de suite ************)
let%test _ = suite 1 [ 1 ] = [ [ 1 ] ]
let%test _ = suite 2 [ 1 ] = [ [ 1 ]; [ 1; 1 ] ]
let%test _ = suite 3 [ 1 ] = [ [ 1 ]; [ 1; 1 ]; [ 2; 1 ] ]
let%test _ = suite 4 [ 1 ] = [ [ 1 ]; [ 1; 1 ]; [ 2; 1 ]; [ 1; 2; 1; 1 ] ]

let%test _ =
  suite 5 [ 1 ]
  = [ [ 1 ]; [ 1; 1 ]; [ 2; 1 ]; [ 1; 2; 1; 1 ]; [ 1; 1; 1; 2; 2; 1 ] ]

let%test _ =
  suite 10 [ 1 ]
  = [
      [ 1 ];
      [ 1; 1 ];
      [ 2; 1 ];
      [ 1; 2; 1; 1 ];
      [ 1; 1; 1; 2; 2; 1 ];
      [ 3; 1; 2; 2; 1; 1 ];
      [ 1; 3; 1; 1; 2; 2; 2; 1 ];
      [ 1; 1; 1; 3; 2; 1; 3; 2; 1; 1 ];
      [ 3; 1; 1; 3; 1; 2; 1; 1; 1; 3; 1; 2; 2; 1 ];
      [ 1; 3; 2; 1; 1; 3; 1; 1; 1; 2; 3; 1; 1; 3; 1; 1; 2; 2; 1; 1 ];
    ]

let%test _ =
  suite 10 [ 3; 3 ]
  = [
      [ 3; 3 ];
      [ 2; 3 ];
      [ 1; 2; 1; 3 ];
      [ 1; 1; 1; 2; 1; 1; 1; 3 ];
      [ 3; 1; 1; 2; 3; 1; 1; 3 ];
      [ 1; 3; 2; 1; 1; 2; 1; 3; 2; 1; 1; 3 ];
      [ 1; 1; 1; 3; 1; 2; 2; 1; 1; 2; 1; 1; 1; 3; 1; 2; 2; 1; 1; 3 ];
      [ 3; 1; 1; 3; 1; 1; 2; 2; 2; 1; 1; 2; 3; 1; 1; 3; 1; 1; 2; 2; 2; 1; 1; 3 ];
      [ 1; 3; 2; 1; 1; 3; 2; 1; 3; 2; 2; 1; 1; 2; 1; 3; 2; 1; 1; 3; 2; 1; 3; 2; 2; 1; 1; 3; ];
      [ 1; 1; 1; 3; 1; 2; 2; 1; 1; 3; 1; 2; 1; 1; 1; 3; 2; 2; 2; 1; 1; 2; 1; 1; 1; 3; 1; 2; 2; 1; 1; 3; 1; 2; 1; 1; 1; 3; 2; 2; 2; 1; 1; 3; ];
    ]

(* Tests de la conjecture *)
(* "Aucun terme de la suite, démarant à 1, ne comporte un chiffre supérieur à 3" *)
(* TO DO *)
(* Remarque : TO DO *)