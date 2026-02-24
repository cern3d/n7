open Parser

(* Fonction d'affichage des unités lexicales et des données qu'elles contiennent *)
let printToken t =
  (print_endline
   (match t with
  |UL_ACCOUV -> "{"	
  |UL_ACCFER ->	"}"		
  | UL_BAR -> "|"
  |UL_PAROUV -> "("	
  |UL_DER -> "::="		
  |UL_PT -> "."					
  |UL_PARFER -> ")"	
  |UL_CROOUV -> "["	
  |UL_CROFER -> "]"	
  |UL_TERMINAUX texte-> texte 
  |UL_NNTERMINAUX texte-> texte 
      (* A COMPLETER *)
      | UL_DOLLAR -> "EOF"
));;

(* Analyse lexicale, syntaxique et sémantique du fichier passé en paramètre de la ligne de commande *)

let main () =
if (Array.length Sys.argv > 1)
then
  ((let lexbuf = (Lexing.from_channel (open_in Sys.argv.(1))) in
  try
    (let token = ref (Lexer.lexer lexbuf) in
    while ((!token) != UL_DOLLAR) do
      (printToken (!token));
      (token := (Lexer.lexer lexbuf))
    done)
  with
  | Lexer.LexicalError ->
    (print_endline "KO"));
  (let lexbuf = (Lexing.from_channel (open_in Sys.argv.(1))) in
  try
    (Parser.grammaire Lexer.lexer lexbuf);(print_endline "OK")
  with
  | Lexer.LexicalError ->
    print_endline "KO"
  | Parser.Error ->
     (print_endline "KO"))
  )
else
  (print_endline "MainEBNF fichier");;

main();;
