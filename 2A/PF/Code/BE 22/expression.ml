(* Exercice 3 *)
module type Expression = sig
  (* Type pour représenter les expressions *)
  type exp


(* eval : exp -> int  *)
(* Paramètre : l'arbre dont on veut l'evaluation *)
(* Résultat :  la valeur de l'expression de l'arbre *)
  val eval : exp -> int
end

(* Exercice 4 *)

(* TO DO avec l'aide du fichier  expressionArbreBinaire.txt *)
  (* Type pour représenter les expressions binaires *)
module ExpressionArbreBinaire : Expression = struct

  type op = Moins | Plus | Mult | Div
  type exp = Binaire of exp * op * exp | Entier of int

  (* eval *)
  let rec eval e =
    match e with
    |Entier(i) -> i
    |Binaire(e1,o,e2)-> match o with
                        Moins->(eval e1) - (eval e2) | Plus->(eval e1)+(eval e2)  | Mult->(eval e1) *(eval e2)  | Div->(eval e1) /(eval e2) 
  
  let a1 = Binaire(Entier(1),Moins,Entier(2))

  let a2 = Entier(0)

  let a3 = Binaire(Binaire(Binaire(Entier(5),Plus,Entier(2)),Moins,Entier(2)),Mult,Entier(4))

  let%test _ = eval a3 = 20
  let%test _ = eval a2 = 0
  let%test _ = eval a1 = -1

end
(* Exercice 5 *)

(* TO DO avec l'aide du fichier  expressionArbreNaire.txt *)
module ExpressionArbreNaire : Expression = struct
  (* Linéarisation des opérateurs binaire associatif gauche et droit *)
  type op = Moins | Plus | Mult | Div
  type exp = Naire of op * exp list | Valeur of int

  
(* bienformee : exp -> bool *)
(* Vérifie qu'un arbre n-aire représente bien une expression n-aire *)
(* c'est-à-dire que les opérateurs d'addition et multiplication ont au moins deux opérandes *)
(* et que les opérateurs de division et soustraction ont exactement deux opérandes.*)
(* Paramètre : l'arbre n-aire dont ont veut vérifier si il correspond à une expression *)

let rec int_bienformee lb =
  match lb with
  |[]->true
  |t::q->t && int_bienformee q

let rec bienformee e =
  match e with
  |Valeur(_)->true
  |Naire(o,le)-> match o with
                |Plus -> if List.length le < 2 then false else true && int_bienformee (List.map bienformee le)
                |Moins -> if List.length le != 2 then false else true && int_bienformee (List.map bienformee le)
                |Mult ->if List.length le < 2 then false else true && int_bienformee (List.map bienformee le)
                |Div -> if List.length le != 2 then false else true && int_bienformee (List.map bienformee le)

let en1 = Naire (Plus, [ Valeur 3; Valeur 4; Valeur 12 ])
let en2 = Naire (Moins, [ en1; Valeur 5 ])
let en3 = Naire (Mult, [ en1; en2; en1 ])
let en4 = Naire (Div, [ en3; Valeur 2 ])
let en1err = Naire (Plus, [ Valeur 3 ])
let en2err = Naire (Moins, [ en1; Valeur 5; Valeur 4 ])
let en3err = Naire (Mult, [ en1 ])
let en4err = Naire (Div, [ en3; Valeur 2; Valeur 3 ])

let%test _ = bienformee en1
let%test _ = bienformee en2
let%test _ = bienformee en3
let%test _ = bienformee en4
let%test _ = not (bienformee en1err)
let%test _ = not (bienformee en2err)
let%test _ = not (bienformee en3err)
let%test _ = not (bienformee en4err)

(* eval : exp-> int *)
(* Calcule la valeur d'une expression n-aire *)
(* Paramètre : l'expression dont on veut calculer la valeur *)
(* Précondition : l'expression est bien formée *)
(* Résultat : la valeur de l'expression *)


let rec eval_bienformee e = 
    match e with
    |Valeur(i) -> i
    |Naire(o,le)-> match o with
                      | Moins->let [e1;e2]=le in (eval_bienformee e1) - (eval_bienformee e2)
                      | Plus-> List.fold_left (fun a b -> a+b) 0 (List.map eval_bienformee le)
                      | Mult-> List.fold_left (fun a b -> a*b) 1 (List.map eval_bienformee le)
                      | Div->let [e1;e2]=le in (eval_bienformee e1) /(eval_bienformee e2) 


let%test _ = eval_bienformee en1 = 19
let%test _ = eval_bienformee en2 = 14
let%test _ = eval_bienformee en3 = 5054
let%test _ = eval_bienformee en4 = 2527

(* Définition de l'exception Malformee *)
(* TO DO *)
exception Malformee

(* eval : exp-> int *)
(* Calcule la valeur d'une expression n-aire *)
(* Paramètre : l'expression dont on veut calculer la valeur *)
(* Résultat : la valeur de l'expression *)
(* Exception  Malformee si le paramètre est mal formé *)
let eval e =
  if not (bienformee e) then raise Malformee else eval_bienformee e

let%test _ = eval en1 = 19
let%test _ = eval en2 = 14
let%test _ = eval en3 = 5054
let%test _ = eval en4 = 2527

let%test _ =
  try
    let _ = eval en1err in
    false
  with Malformee -> true

let%test _ =
  try
    let _ = eval en2err in
    false
  with Malformee -> true

let%test _ =
  try
    let _ = eval en3err in
    false
  with Malformee -> true

let%test _ =
  try
    let _ = eval en4err in
    false
  with Malformee -> true


end