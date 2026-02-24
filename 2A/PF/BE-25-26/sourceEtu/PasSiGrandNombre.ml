open GrandNombre

module PasSiGrandNombre : IGrandNombre =
struct
  type t = int
  let from_int n = n
  let rec from_digits b l =
    match List.rev l with
    |[]-> 0
    |t::q->if b then -1*t + 10*from_digits b (List.rev q) else 1*t + 10*from_digits b (List.rev q)
  let afficher x = print_int x
  let comparer a b = compare a b
  let plus = (+)
  let moins = (-)
  let mult a b = a * b
  let rec puiss base exponent =
    if exponent = 0 then 1 else
    if exponent = 1 then base else base * (puiss base (exponent-1))
end

(* Décommenter pour lancer les tests ! *)
module PasSiGrandNombreTest = GrandNombreTest (PasSiGrandNombre)
(* module PasSiGrandNombreAlgo = GrandNombreAlgorithmes (PasSiGrandNombre) *)

