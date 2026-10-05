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
  (match (peekAtFirstToken stream) with
    | token when (token = expected) ->
      (Success (advanceInStream stream))
    | _ -> Failure)
;;


(* acceptIdent : inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien un identifiant *)
(* et avance dans l'analyse si c'est le cas *)
let acceptIdent stream =
  (match (peekAtFirstToken stream) with
    | (UL_IDENT _) -> (Success (advanceInStream stream))
    | (UL_IDENTPORT _) -> (Success (advanceInStream stream))
    | _ -> Failure)
;;

(* acceptNumber : inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien un nombre *)
(* et avance dans l'analyse si c'est le cas *)
let acceptNumber stream =
  match (peekAtFirstToken stream) with
    | (UL_ENTIER _) -> (Success (advanceInStream stream))
    | _ -> Failure
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
let rec parseR stream =
  (print_string "R -> ...");
  (match (peekAtFirstToken stream) with
    | UL_MODEL -> 
    inject stream >>=
    accept UL_MODEL >>=
    acceptIdent >>=
    accept UL_ACCOUV >>=
    parseSE >>=
    accept UL_ACCFER

    | _ -> Failure)

and parseSE stream=
  (print_string "SE -> ...");
  (match (peekAtFirstToken stream) with
  |UL_ACCFER -> 
    inject stream
  |(UL_BLOCK|UL_SYSTEM|UL_FLOW) ->
  inject stream >>=
  parseE >>=
  parseSE
  |_ ->Failure)


and parseE stream=
  (print_string "E -> ...");
  (match (peekAtFirstToken stream) with
  | UL_BLOCK ->
  inject stream >>=
  (accept UL_BLOCK) >>=
  acceptIdent >>=
  parseP >>=
  accept UL_PTVIRG
  |UL_SYSTEM ->
  inject stream >>=
  accept UL_SYSTEM >>=
  acceptIdent >>=
  parseP >>=
  accept UL_ACCOUV >>=
  parseSE >>=
  accept UL_ACCFER
  | UL_FLOW ->
  inject stream >>=
  (accept UL_FLOW) >>=
  acceptIdent >>=
  accept UL_FROM >>=
  parseNQ >>=
  accept UL_TO >>=
  parseLN

  |_ ->Failure)


and parseNQ stream=
  (print_string "NQ -> ...");
  (match (peekAtFirstToken stream) with
  | (UL_IDENTPORT _) ->
  inject stream >>=
  (acceptIdent)
  |(UL_IDENT _) ->
  inject stream >>=
  acceptIdent >>=
  accept UL_OPPT >>=
  acceptIdent
  |_ ->Failure)


and parseLN stream=
  (print_string "LN -> ...");
  (match (peekAtFirstToken stream) with
  | UL_PTVIRG ->
  inject stream >>=
  accept UL_PTVIRG
  |(UL_IDENT _ | UL_IDENTPORT _) ->
  inject stream >>=
  parseNQ >>=
  parseSN
  |_ ->Failure)


and parseSN stream=
  (print_string "SN -> ...");
  (match (peekAtFirstToken stream) with
  | UL_PTVIRG ->
  inject stream
  | UL_VIRG ->
  inject stream >>=
  accept UL_VIRG >>=
  parseNQ >>=
  parseSN
  |_ ->Failure)


and parseP stream=
  (print_string "P  -> ...");
  (match (peekAtFirstToken stream) with
  | UL_PAROUV ->
  inject stream >>=
  accept UL_PAROUV >>=
  parseLP >>=
  accept UL_PARFER
  |_ ->Failure)


and parseLP stream=
  (print_string "LP -> ...");
  (match (peekAtFirstToken stream) with
  | (UL_IDENTPORT _) ->
  inject stream >>=
  parseDP >>=
  parseSP
  |_ ->Failure)


and parseSP stream=
  (print_string "SP -> ...");
  (match (peekAtFirstToken stream) with
  | UL_PARFER ->
  inject stream

  | UL_VIRG ->
  inject stream >>=
  accept UL_VIRG >>=
  parseDP >>=
  parseSP

  |_ ->Failure)


and parseDP stream=
  (print_string "DP -> ...");
  (match (peekAtFirstToken stream) with
  | (UL_IDENTPORT _) ->
  inject stream >>=
  acceptIdent >>=
  accept UL_DEPNT >>=
  parseM >>=
  parseT >>=
  parseOT
  |_ ->Failure)


and parseM stream=
  (print_string "M  -> ...");
  (match (peekAtFirstToken stream) with
  | UL_IN ->
  inject stream >>=
  accept UL_IN

  | UL_OUT ->
  inject stream >>=
  accept UL_OUT

  |_ ->Failure)


and parseT stream=
  (print_string "T  -> ...");
  (match (peekAtFirstToken stream) with
  | UL_INT ->
  inject stream >>=
  accept UL_INT

  | UL_FLOAT ->
  inject stream >>=
  accept UL_FLOAT

  | UL_BOOL ->
  inject stream >>=
  accept UL_BOOL
  |_ ->Failure)


and parseOT stream=
  (print_string "OT -> ...");
  (match (peekAtFirstToken stream) with
  | (UL_VIRG|UL_PARFER) ->
  inject stream

  | UL_CROOUV ->
  inject stream >>=
  accept UL_CROOUV >>=
  acceptNumber >>=
  parseSV >>=
  accept UL_CROFER
  |_ ->Failure)

and parseSV stream=
  (print_string "SV -> ...");
  (match (peekAtFirstToken stream) with
  | UL_CROFER ->
  inject stream

  | UL_VIRG ->
  inject stream >>=
  accept UL_VIRG >>=
  acceptNumber >>=
  parseSV
  |_ ->Failure)

;;
