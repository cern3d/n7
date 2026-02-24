open Base

module Conversion (B:Base)=
struct
  (* decompose : réalise une décomposition dans la base d’un entier supposé naturel*)
  (* int -> int list *)
  (* pré-condition : entier est positif *)
  (* résultat : la décomposition dans la base *)
  let rec int_decompose n =
    if n=0 then [] else (
      (n mod B.base)::int_decompose (n/B.base))

  let rec decompose n =
    List.rev (int_decompose n)

  (* recompose : réalise la recomposition d'un entien naturel depuis sa représentation dans la base *)
  (* int list -> int *)
  (* L'entier représenté par la liste de booléens *)
  let is_even n = 
    n mod 2 = 0

  (* https://en.wikipedia.org/wiki/Exponentiation_by_squaring *)
  let pow base exponent =
    if exponent < 0 then invalid_arg "exponent can not be negative" else
    let rec aux accumulator base = function
      | 0 -> accumulator
      | 1 -> base * accumulator
      | e when is_even e -> aux accumulator (base * base) (e / 2)
      | e -> aux (base * accumulator) (base * base) ((e - 1) / 2) in
    aux 1 base exponent
  
  let rec liste_mul l1 l2 =
    match l1,l2 with
    |[],[] -> []
    |t::q,i::j -> (t*i)::(liste_mul q j)

  let rec sum l=
    match l with
    []->0
    |h::t-> h + (sum t);;

  let rec recompose l =
    sum (liste_mul (List.init (List.length l) (fun a -> pow (B.base) a )) (List.rev l) )
    
end

 
module TestConversion2 = struct
  module Conversion2 = Conversion (Base2)
  open Conversion2

  let%test_unit _ =
    print_string "=== Tests du module Conversion en Base 2 ===\n"

  (* decompose *)
  let%test _ = decompose 0 = []
  let%test _ = decompose 1 = [ 1 ]
  let%test _ = decompose 2 = [ 1; 0 ]
  let%test _ = decompose 3 = [ 1; 1 ]
  let%test _ = decompose 4 = [ 1; 0; 0 ]
  let%test _ = decompose 5 = [ 1; 0; 1 ]
  let%test _ = decompose 6 = [ 1; 1; 0 ]
  let%test _ = decompose 7 = [ 1; 1; 1 ]
  let%test _ = decompose 14 = [ 1; 1; 1; 0 ]
  (* recompose *)
  let%test _ = recompose [] = 0
  let%test _ = recompose [ 1 ] = 1
  let%test _ = recompose [ 1; 0 ] = 2
  let%test _ = recompose [ 1; 1 ] = 3
  let%test _ = recompose [ 1; 0; 0 ] = 4
  let%test _ = recompose [ 1; 0; 1 ] = 5
  let%test _ = recompose [ 1; 1; 0 ] = 6
  let%test _ = recompose [ 1; 1; 1 ] = 7
  let%test _ = recompose [ 1; 1; 1; 0 ] = 14
end

module TestConversion5 = struct
  module Conversion5 = Conversion (Base5)
  open Conversion5

  let%test_unit _ =
    print_string "=== Tests du module Conversion en Base 5 ===\n"
  
  (* decompose *)
  let%test _ = decompose 0 = []
  let%test _ = decompose 1 = [ 1 ]
  let%test _ = decompose 2 = [ 2 ]
  let%test _ = decompose 3 = [ 3 ]
  let%test _ = decompose 4 = [ 4 ]
  let%test _ = decompose 5 = [ 1; 0 ]
  let%test _ = decompose 6 = [ 1; 1 ]
  let%test _ = decompose 7 = [ 1; 2 ]
  let%test _ = decompose 14 = [ 2; 4 ]
  let%test _ = decompose 36 = [ 1; 2; 1 ]
  (* recompose *)
  let%test _ = recompose [] = 0
  let%test _ = recompose [ 1 ] = 1
  let%test _ = recompose [ 2 ] = 2
  let%test _ = recompose [ 3 ] = 3
  let%test _ = recompose [ 4 ] = 4
  let%test _ = recompose [ 1; 0 ] = 5
  let%test _ = recompose [ 1; 1 ] = 6
  let%test _ = recompose [ 1; 2 ] = 7
  let%test _ = recompose [ 2; 4 ] = 14
  let%test _ = recompose [ 1; 2; 1 ] = 36
end