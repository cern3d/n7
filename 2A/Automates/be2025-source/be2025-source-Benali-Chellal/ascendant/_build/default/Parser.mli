
(* The type of tokens. *)

type token = 
  | UL_TERMINAUX of (string)
  | UL_PT
  | UL_PAROUV
  | UL_PARFER
  | UL_NNTERMINAUX of (string)
  | UL_DOLLAR
  | UL_DER
  | UL_CROOUV
  | UL_CROFER
  | UL_BAR
  | UL_ACCOUV
  | UL_ACCFER

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val grammaire: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (unit)
