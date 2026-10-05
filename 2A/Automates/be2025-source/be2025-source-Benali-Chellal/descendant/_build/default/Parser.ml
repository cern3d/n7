open Tokens

(* Type du résultat d'une analyse syntaxique *)
type parseResult =
  | Success of inputStream
  | Failure
;;

(* accept : token -> inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien le token attendu *)
(* et avance dans l'analyse si c'est le cas *)
let accept expected stream =
  match (peekAtFirstToken stream) with
    | token when (token = expected) ->
      (Success (advanceInStream stream))
    | _ -> Failure
;;


(* acceptIdent : inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien un identifiant *)
(* et avance dans l'analyse si c'est le cas *)
let acceptIdent stream =
  (match (peekAtFirstToken stream) with
    | (UL_TERMINAUX _) -> (Success (advanceInStream stream))
    | (UL_NNTERMINAUX _) -> (Success (advanceInStream stream))
    | _ -> Failure)
;;

(* Définition de la monade  qui est composée de : *)
(* - le type de donnée monadique : parseResult  *)
(* - la fonction : inject qui construit ce type à partir d'une liste de terminaux *)
(* - la fonction : bind (opérateur >>=) qui combine les fonctions d'analyse. *)

(* inject inputStream -> parseResult *)
(* Construit le type de la monade à partir d'une liste de terminaux *)
let inject s = Success s;;

(* bind : 'a m -> ('a -> 'b m) -> 'b m *)
(* bind (opérateur >>=) qui combine les fonctions d'analyse. *)
(* ici on utilise une version spécialisée de bind :
   'b  ->  inputStream
   'a  ->  inputStream
    m  ->  parseResult
*)
(* >>= : parseResult -> (inputStream -> parseResult) -> parseResult *)
let (>>=) result f =
  match result with
    | Success next -> f next
    | Failure -> Failure
;;


(* parseG : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
let rec parseG stream =
  (print_string "G -> ");
  (match (peekAtFirstToken stream) with
    | (UL_NNTERMINAUX _) ->
    inject stream >>=
    parseR >>=
    parseG
    | UL_DOLLAR ->
    inject stream
    | _ -> Failure)

and parseR stream =
  (print_string "R -> ");
  (match (peekAtFirstToken stream) with
    | (UL_NNTERMINAUX _) ->
    inject stream >>=
    acceptIdent >>=
    accept UL_DER >>=
    parseP >>=
    accept UL_PT
    | _ -> Failure)

and parseP stream =
  (print_string "P -> ");
  (match (peekAtFirstToken stream) with
    | ((UL_PAROUV|UL_CROOUV|UL_ACCOUV|(UL_NNTERMINAUX _)|(UL_TERMINAUX _))|UL_BAR|UL_PT|UL_PARFER|UL_CROFER|UL_ACCFER) ->
    inject stream >>=
    parseL >>=
    parseS
    | _ -> Failure)

and parseS stream =
  (print_string "S -> ");
  (match (peekAtFirstToken stream) with
    | UL_BAR ->
    inject stream >>=
    accept UL_BAR >>=
    parseL >>=
    parseS
    | (UL_PT|UL_PARFER|UL_CROFER|UL_ACCFER) -> inject stream
    | _ -> Failure)

and parseL stream =
  (print_string "L -> ");
  (match (peekAtFirstToken stream) with
    | (UL_PAROUV|UL_CROOUV|UL_ACCOUV|(UL_NNTERMINAUX _)|(UL_TERMINAUX _)) ->
    inject stream >>=
    parseE >>=
    parseL
    | (UL_BAR|UL_PT|UL_PARFER|UL_CROFER|UL_ACCFER) ->
    inject stream
    | _ -> Failure)

and parseE stream =
  (print_string "E -> ");
  (match (peekAtFirstToken stream) with
    | UL_PAROUV ->
    inject stream >>=
    accept UL_PAROUV >>=
    parseP >>=
    accept UL_PARFER
    | UL_CROOUV ->
    inject stream >>=
    accept UL_CROOUV >>=
    parseP >>=
    accept UL_CROFER
    | UL_ACCOUV ->
    inject stream >>=
    accept UL_ACCOUV >>=
    parseP >>=
    accept UL_ACCFER
    | (UL_NNTERMINAUX _) ->
    inject stream >>=
    acceptIdent
    | (UL_TERMINAUX _) ->
    inject stream >>=
    acceptIdent
    
    | _ -> Failure)


;;
