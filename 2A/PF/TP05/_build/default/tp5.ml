(* Evaluation des expressions simples *)


(* Module abstrayant les expressions *)
module type ExprSimple =
sig
  type t
  val const : int -> t
  val plus : t -> t -> t
  val mult : t-> t -> t
end

(* Module réalisant l'évaluation d'une expression *)
module EvalSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = c
  let plus e1 e2 = e1 + e2
  let mult e1 e2 = e1 * e2
end

module PrintSimple : ExprSimple with type t = string =
struct
  type t = string
  let const c = string_of_int c
  let plus e1 e2 = "("^e1 ^"+"^ e2^")"
  let mult e1 e2 = "("^e1 ^"*"^ e2^")"
end

module CompteSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = 1
  let plus e1 e2 = e1 + e2
  let mult e1 e2 = e1 + e2
end


(* Solution 1 pour tester *)
(* A l'aide de foncteur *)

(* Définition des expressions *)
module ExemplesSimples (E:ExprSimple) =
struct
  (* 1+(2*3) *)
  let exemple1  = E.(plus (const 1) (mult (const 2) (const 3)) )
  (* (5+2)*(2*3) *)
  let exemple2 =  E.(mult (plus (const 5) (const 2)) (mult (const 2) (const 3)) )
end

(* Module d'évaluation des exemples *)
module EvalExemples =  ExemplesSimples (EvalSimple)

let%test _ = (EvalExemples.exemple1 = 7)
let%test _ = (EvalExemples.exemple2 = 42)


module EvalExemplesPrint =  ExemplesSimples (PrintSimple)

let%test _ = (EvalExemplesPrint.exemple1 = "(1+(2*3))")
let%test _ = (EvalExemplesPrint.exemple2 = "((5+2)*(2*3))")


module EvalExemplesCompte =  ExemplesSimples (CompteSimple)

let%test _ = (EvalExemplesCompte.exemple1 = 2)
let%test _ = (EvalExemplesCompte.exemple2 = 3)

