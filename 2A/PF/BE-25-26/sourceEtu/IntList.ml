open GrandNombre

module IntListBigNum : sig

  include IGrandNombre with type t = bool * int list

  val comparer_listes : int list -> int list -> int

  val plus_listes : int list -> int list -> int list

  val moins_listes : int list -> int list -> int list

  val mult_coeff : int list -> int -> int list

end = struct
  (* Type pour le grand nombre *)
  type t = bool * int list

  (* normalise : int list -> int list
     Normalise une liste de chiffres, c'est à dire retire autant de 0
     que possible du début du nombre.
     Paramètres :
         n : int list, nombre à normaliser (list de chiffre)
     Retour : n' tel que n et n' représentent le même nombre, mais n' ne
     commence pas par 0
  *)
  let normalise n =
    List.fold_right (fun t nq -> if t = 0 && nq = [] then [] else t::nq) n []

  let%test "normalise-1" = (normalise [1;2;3;0;0;0;0;0] = [1;2;3])
  let%test "normalise-2" = (normalise [1;0;1;0;1;0;1;0] = [1;0;1;0;1;0;1])
  let%test "normalise-3" = (normalise [2] = [2])
  let%test "normalise-4" = (normalise [] = [])
  let%test "normalise-5" = (normalise [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0] = [])

  let rec inter_fromint n =
    if n = 0 then [] else
    if n < 100 then [n] else (n mod 100)::(inter_fromint (n/100))

  let from_int n =
    if n < 0 then (true, List.rev (inter_fromint (-n))) else (false, List.rev (inter_fromint n))

(* Tests : TO DO *)
let%test "from_int-0" = (from_int 0 = (false, []))
let%test "from_int-1" = (from_int 100 = (false,[1;0]))
let%test "from_int-2" = (from_int 99 = (false,[99]))
let%test "from_int-2" = (from_int (-99) = (true,[99]))


let rec from_digitsi b l =
    match List.rev l with
    |[]-> 0
    |t::q->if b then -1*t + 10*from_digitsi b (List.rev q) else 1*t + 10*from_digitsi b (List.rev q)

let rec int_decompose n =
    if n=0 then [] else (
      (n mod 100)::int_decompose (n/100))

  let from_digits b l =
    match l with
    |[]-> (b, [])
    |t::q-> if b then (true, ( int_decompose (from_digitsi false l))) else (false , ( int_decompose (from_digitsi b l)))


let%test "from_digits-0" = (from_digits false [0;0] = (false, []))
let%test "from_digits-1" = (from_digits false [1;2;3;4;5;6;7] = (false, [67;45;23;1]))
let%test "from_digits-2" = (from_digits true [0;0;0;4;2] = (true, [42]))
let%test "from_digits-3" = (from_digits false [1;0;0;0;0] = (false, [0;0;1]))
let%test "from_digits-4" = (from_digits true [] = (true, []))
let%test "from_digits-5" = (from_digits true [9] = (true, [9]))


  let afficher_list =
    let rec afficher_aux fmt = function
      | [] -> ()
      | d :: q -> Format.fprintf fmt "%a%.2d" afficher_aux q d
    in
    fun fmt l ->
      match l with
      | [] -> Format.pp_print_char fmt '0'
      | _ -> afficher_aux fmt l

  let afficher (s,n) =
    Format.printf "%t%a"
      (fun fmt -> if s then Format.pp_print_char fmt '-' else ())
      afficher_list n


  (* comparer_listes : int list -> int list -> int
     Compare deux listes pour savoir laquelle représente le nombre le plus grand.
     Paramètres :
         n1,n2 : int list, nombres à comparer (liste de chiffres)
     Retour : > 0 si n1 > n2, < 0 si n2 > n1, = 0 sinon
  *)
  let rec comparer_listes l1 l2 =
    if (List.length l1) != (List.length l2) then (if List.length l1 > List.length l2 then 1 else -1 ) else
      match l1,l2 with
      |[],[] -> 0
      |t::q,i::j-> if t=i then comparer_listes q j else (if t>i then 1 else -1)

let%test "comparer_listes-0" = (comparer_listes [] [] = 0)
let%test "comparer_listes-1" = (comparer_listes [12] [] > 0)
let%test "comparer_listes-2" = (comparer_listes [] [12] < 0)
let%test "comparer_listes-3" = (comparer_listes [78;56;34;12] [78;56;34;12] = 0)
let%test "comparer_listes-4" = (comparer_listes [78;56;34;12] [79;56;34;12] < 0)
let%test "comparer_listes-5" = (comparer_listes [56;34;12] [11;11;11;11] < 0)

  let comparer (_,l1) (_,l2) =
    comparer_listes l1 l2

  (* Le module IntListTest, défini en fin de fonction, permet de tester les fonctions sur les grands nombres *)
  (* Tests complémentaires pour les cas limites *)

let%test "comparer-0-1" = (comparer (false,[]) (false,[]) = 0)
let%test "comparer-0-2" = (comparer (false,[]) (true,[]) = 0)


  (* plus_listes : int list -> int list -> int list
     Réalise la somme de deux listes de "chiffres"
     Paramètres :
         n1,n2 : int list, nombres à additionner, sous forme de liste de "chiffres"
     Retour : somme de n1 et n2 (sous forme de liste de "chiffres")
     Le résultat est normalisé
  *)
    let inter_plus_list l =
      match l with
      |[]->[1]
      |t::q->(t+1)::q

  let rec plus_listes l1 l2 =
    match l1 , l2 with
    |[],[]->[]
    |[],l->l
    |l,[]->l
    |t::q,i::j -> let r = (t+i) mod 100 in let p = (t+i) / 100 in if p>0 then (r)::(plus_listes (inter_plus_list q) j) else (t+i)::(plus_listes q j)


let%test "plus_listes-base" = (plus_listes [] [] = []) (* 0 + 0 = 0 *)
let%test "plus_listes-zero-1" = (plus_listes [0] [1] = [1]) (* 0 + 1 = 1 *)
let%test "plus_listes-zero-2" = (plus_listes [34;12] [] = [34;12]) (* 1234+0 = 1234 *)
let%test "plus_listes-nominal-1" = (plus_listes [30;20;10] [1;5] = [31;25;10]) (* 102030 +501 = 102531 *)
let%test "plus_listes-nominal-2" = (plus_listes [4;5;6;7] [6;5;4;3] = [10;10;10;10]) (* 7060504 + 3040506 = 10101010 *)
let%test "plus_listes-carrier-1" = (plus_listes [99;10] [1] = [0;11]) (* 1099 + 1 = 1100 *)
let%test "plus_listes-carrier-2" = (plus_listes [10;5] [90;94] = [0;0;1]) (* 510 + 9490 = 10000*)


  (* moins_listes : int list -> int list -> int list
     Réalise la différence positive de deux listes de "chiffres"
     Paramètres :
         n1,n2 : int list, nombres à soustraire, sous forme de liste de "chiffres"
     Retour : différence entre n1 et n2 (sous forme de liste de "chiffres")
     Pré-conditions : n1 >= n2
     Le résultat est normalisé
  *)
  let rec moins_listes l1 l2 =
    match l1 , l2 with
    |[],[]->[]
    |[],l->l
    |l,[]->l
    |t::q,i::j -> if t=i then (moins_listes q j) else (if i>t then ((t+100)-i)::(moins_listes q (inter_plus_list j)) else (t-i)::(moins_listes q j))


let%test "moins_listes-base" = (moins_listes [] [] = [])
let%test "moins_listes-nominal-1" = (moins_listes [10;20;30] [1;1;1] = [9;19;29])
let%test "moins_listes-carrier-1" = (moins_listes [0;10] [1] = [99;9])
let%test "moins_listes-carrier-2" = (moins_listes [0;20;50] [1;20;1] = [99;99;48])
let%test "moins_listes-zero" = (moins_listes [1;2;3] [1;2;3] = [])


  (* Note plus a besoin de moins et moins a besoin de plus ; on les définit
     ensemble. *)
  let rec plus (b1,l1) (b2,l2) = 
    if b1 = false 
      then (if b2= false then (false,plus_listes l1 l2) else moins (b1,l1) (false,l2))
      else moins (b2,l2) (b1,l1)
      (* then (if b2 = false then (false, plus_listes l1 l2) else (if comparer_listes l1 l2 > 0 then (false , moins_listes l1 l2) else (true , moins_listes l2 l1)))
      else (if b2 = true then (true, plus_listes l1 l2) else (if comparer_listes l1 l2 > 0 then (true , moins_listes l1 l2) else (false , moins_listes l2 l1))) *)
  and moins (b1,l1) (b2,l2) =
   if b1 = false 
      then (if b2 = false then (if comparer_listes l1 l2>0 then (false,moins_listes l1 l2) else (true, moins_listes l2 l1)) else (true,plus_listes l1 l2))
      else (if b2 = false then (if comparer_listes l1 l2>0 then (true,moins_listes l1 l2) else (false, moins_listes l2 l1)) else (true,plus_listes l1 l2))
      (* then (if b2 = false then (false, moins_listes l1 l2) else (if comparer_listes l1 l2 > 0 then (false , moins_listes l1 l2) else (true , moins_listes l2 l1)))
      else (if b2 = true then (true, moins_listes l1 l2) else (if comparer_listes l1 l2 > 0 then (true , moins_listes l1 l2) else (false , moins_listes l2 l1))) *)
      

  (* mult_coeff : int list -> int -> int list
     Multiplie un grand nombre (une liste de chiffres) par un nombre entier "normal"
     Paramètres :
         n : int list, grand nombre (list de chiffres)
         m : int, entier qui sert de facteur
      Retour : n * m
      Post-conditions : nombre normalisé
  *)
  let rec mult_coeff l1 n =
    match l1 with
    |[]-> []
    |t::q -> let (b,res) = (from_int (t*n)) in  plus_listes res (mult_coeff q n)


let%test "mult_coeff-0" = mult_coeff [56;34;12] 0 = []
let%test "mult_coeff-1" = mult_coeff [34;12] 2  = [68;24]
let%test "mult_coeff-2" = mult_coeff [34;12] 10 = [40;23;1]
let%test "mult_coeff-3" = mult_coeff [34;12] 51 = [34;29;6]
let%test "mult_coeff-4" = mult_coeff [99;99] 99 = [01;99;98]

  let mult _ _ = (false,[])

  let puiss _ _ = (false,[])
end

(* Décommenter pour lancer les tests ! *)
(*module IntListTest = GrandNombreTest (IntListBigNum)*)
(*module IntListAlgo = GrandNombreAlgorithmes (IntListBigNum)*)



