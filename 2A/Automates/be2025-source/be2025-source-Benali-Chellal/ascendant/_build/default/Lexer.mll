{

(* Partie recopiée dans le fichier CaML généré. *)
(* Ouverture de modules exploités dans les actions *)
(* Déclarations de types, de constantes, de fonctions, d'exceptions exploités dans les actions *)

  open Parser 
  exception LexicalError

}

(* Déclaration d'expressions régulières exploitées par la suite *)
let chiffre = ['0' - '9']
let minuscule = ['a' - 'z']
let majuscule = ['A' - 'Z']
let alphabet = minuscule | majuscule
let alphanum = alphabet | chiffre | '_'
let commentaire =
  (* Commentaire fin de ligne *)
  "#" [^'\n']*

rule lexer = parse
  | ['\n' '\t' ' ']+					{ (lexer lexbuf) }
  | commentaire						{ (lexer lexbuf) }
  | "{"							{ UL_ACCOUV }
  | "}"							{ UL_ACCFER }
  | "("					       		{ UL_PAROUV }
  | "::="							{ UL_DER }
  | "."							{ UL_PT }
  | "|"							{ UL_BAR}
  | ")"							{ UL_PARFER }
  | "["							{ UL_CROOUV }
  | "]"							{ UL_CROFER }
  | "<" minuscule alphabet* ">" as texte { UL_NNTERMINAUX texte}
  | majuscule alphabet* as texte { UL_TERMINAUX texte}
(* A COMPLETER *)
  | eof							{ UL_DOLLAR }
  | _ as texte				 		{ (print_string "Erreur lexicale : ");(print_char texte);(print_newline ()); raise LexicalError }

{

}
