open List

type token = 
    | UL_ACCOUV
    | UL_ACCFER
    | UL_MODEL
    | UL_IDENT of string
  | UL_BLOCK
  | UL_SYSTEM
  | UL_FLOW
  | UL_TO
  | UL_FROM
  | UL_INT 
  | UL_FLOAT 
  | UL_BOOL 
  | UL_IN 
  | UL_OUT 
  | UL_VIRG 
  | UL_DEPNT 
  | UL_PTVIRG 
  | UL_OPPT 
  | UL_PAROUV 
  | UL_PARFER 
  | UL_CROOUV 
  | UL_CROFER 
  |UL_IDENTPORT of string 
  |UL_ENTIER of int 
    | UL_FIN
    | UL_ERREUR;;

type inputStream = token list;;

(* string_of_token : token -> string *)
(* Converti un token en une chaîne de caractère*)
let string_of_token token =
     match token with
       | UL_ACCOUV -> "{"
       | UL_ACCFER -> "}"
       | UL_MODEL -> "model"
       | UL_IDENT n -> n
       | UL_FIN -> "EOF"
      | UL_BLOCK -> "block"           
      | UL_SYSTEM -> "sytem"           
      | UL_FLOW -> "flow"           
      | UL_TO -> "to"           
      | UL_FROM -> "from"           
      | UL_INT  -> "int"						
      | UL_FLOAT  -> "float"						
      | UL_BOOL  -> "boolean"						
      | UL_IN  -> "in"            
      | UL_OUT  -> "out"            
      | UL_VIRG  -> ","							
      | UL_DEPNT  -> ":"							
      | UL_PTVIRG  -> ";"							
      | UL_OPPT  -> "." 						
      | UL_PAROUV  -> "("					       		
      | UL_PARFER  -> ")"							
      | UL_CROOUV  -> "["							
      | UL_CROFER  -> "]"							
      |UL_IDENTPORT texte -> texte
      |UL_ENTIER texte -> (string_of_int texte)
       | UL_ERREUR -> "Erreur Lexicale";;

(* string_of_stream : inputStream -> string *)
(* Converti un inputStream (liste de token) en une chaîne de caractère *)
let string_of_stream stream =
  List.fold_right (fun t tq -> (string_of_token t) ^ " " ^ tq ) stream "";;


(* peekAtFirstToken : inputStream -> token *)
(* Renvoie le premier élément d'un inputStream *)
(* Erreur : si l'inputStream est vide *)
let peekAtFirstToken stream = 
  match stream with
  (* Normalement, ne doit jamais se produire sauf si la grammaire essaie de lire *)
  (* après la fin de l'inputStream. *)
  | [] -> failwith "Impossible d'acceder au premier element d'un inputStream vide"
   |t::_ -> t;;

(* advanceInStream : inputStream -> inputStream *)
(* Consomme le premier élément d'un inputStream *)
(* Erreur : si l'inputStream est vide *)
let advanceInStream stream =
  match stream with
  (* Normalement, ne doit jamais se produire sauf si la grammaire essaie de lire *)
  (* après la fin de l'inputStream. *)
  | [] -> failwith "Impossible de consommer le premier element d'un inputStream vide"
  | _::q -> q;;
