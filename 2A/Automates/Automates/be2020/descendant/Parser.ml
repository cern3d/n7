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
    | (UL_IDENT _) -> (Success (advanceInStream stream))
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


(* parseMachine : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
let rec parseMachine stream =
  (print_string "M -> ...");
  (match (peekAtFirstToken stream) with
    |UL_MACHINE -> 
    inject stream >>=
    accept UL_MACHINE >>=
    acceptIdent >>=
    accept UL_ACCOUV >>=
    parseSC >>=
    accept UL_ACCFER
    | _ -> Failure)


and parseSC stream =
  (print_string "SC -> ...");
  (match (peekAtFirstToken stream) with
    |UL_ACCFER ->
    inject stream
    |(UL_EVENT|UL_FROM|UL_REGION)->
    inject stream >>=
    parseC >>=
    parseSC
    | _ -> Failure)

 and parseC stream =
  (print_string "C -> ...");
  (match (peekAtFirstToken stream) with
    |UL_EVENT ->
    inject stream >>=
    accept UL_EVENT >>=
    acceptIdent
    |UL_FROM ->
    inject stream >>=
    accept UL_FROM >>=
    parseNQ >>=
    accept UL_TO >>=
    parseNQ >>=
    accept UL_ON >>=
    acceptIdent
    |UL_REGION ->
    inject stream >>=
    parseR
    | _ -> Failure)

and parseNQ stream =
  (print_string "NQ -> ...");
  (match (peekAtFirstToken stream) with
    | UL_IDENT _ -> 
    inject stream >>=
    acceptIdent >>=
    parseSQ
    | _ -> Failure)

and parseSQ stream =
  (print_string "SQ -> ...");
  (match (peekAtFirstToken stream) with
    | (UL_TO | UL_ON) ->
    inject stream
    | UL_PT ->
    inject stream >>=
    accept UL_PT >>=
    acceptIdent >>=
    parseSQ
    | _ -> Failure)

and parseR stream =
  (print_string "R -> ...");
  (match (peekAtFirstToken stream) with
    |UL_REGION ->
    inject stream >>=
    accept UL_REGION >>=
    acceptIdent >>=
    accept UL_ACCOUV >>=
    parseE >>=
    parseSE >>=
    accept UL_ACCFER
    | _ -> Failure)

and parseSE stream =
  (print_string "SE -> ...");
  (match (peekAtFirstToken stream) with
    |UL_ACCFER ->
    inject stream
    |UL_STATE ->
    inject stream >>=
    parseE >>=
    parseSE
    | _ -> Failure)

and parseE stream =
  (print_string "E -> ...");
  (match (peekAtFirstToken stream) with
    |UL_STATE ->
    inject stream >>=
    accept UL_STATE >>=
    acceptIdent >>=
    parseES >>=
    parseEE >>=
    parseEC
    | _ -> Failure)

and parseES stream =
  (print_string "Es -> ...");
  (match (peekAtFirstToken stream) with
    |UL_STARTS ->
    inject stream>>=
    accept UL_STARTS
    |(UL_ENDS|UL_ACCOUV|UL_STATE|UL_ACCFER)->
    inject stream
    | _ -> Failure)

and parseEE stream =
  (print_string "EE -> ...");
  (match (peekAtFirstToken stream) with
    |(UL_ACCOUV|UL_STATE|UL_ACCFER)->
    inject stream
    |UL_ENDS->
    inject stream >>=
    accept UL_ENDS
    | _ -> Failure)

and parseEC stream =
  (print_string "EC -> ...");
  (match (peekAtFirstToken stream) with
    |(UL_STATE|UL_ACCFER)->
    inject stream
    |UL_ACCOUV->
    inject stream >>=
    accept UL_ACCOUV >>=
    parseR >>=
    parseSR >>=
    accept UL_ACCFER
    | _ -> Failure)

and parseSR stream =
  (print_string "SR -> ...");
  (match (peekAtFirstToken stream) with
    |UL_ACCFER->
    inject stream
    |UL_REGION->
    inject stream >>=
    parseR >>=
    parseSR
    | _ -> Failure)

(*
and parseMachine stream =
  (print_string "Machine -> ...");
  (match (peekAtFirstToken stream) with
    | _ -> Failure)

and parseMachine stream =
  (print_string "Machine -> ...");
  (match (peekAtFirstToken stream) with
    | _ -> Failure)
;; *)
