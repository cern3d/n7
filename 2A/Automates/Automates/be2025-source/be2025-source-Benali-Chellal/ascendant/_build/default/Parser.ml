
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | UL_TERMINAUX of (
# 23 "Parser.mly"
       (string)
# 15 "Parser.ml"
  )
    | UL_PT
    | UL_PAROUV
    | UL_PARFER
    | UL_NNTERMINAUX of (
# 24 "Parser.mly"
       (string)
# 23 "Parser.ml"
  )
    | UL_DOLLAR
    | UL_DER
    | UL_CROOUV
    | UL_CROFER
    | UL_BAR
    | UL_ACCOUV
    | UL_ACCFER
  
end

include MenhirBasics

# 1 "Parser.mly"
  

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)


# 45 "Parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState00 : ('s, _menhir_box_grammaire) _menhir_state
    (** State 00.
        Stack shape : .
        Start symbol: grammaire. *)

  | MenhirState02 : (('s, _menhir_box_grammaire) _menhir_cell1_UL_NNTERMINAUX, _menhir_box_grammaire) _menhir_state
    (** State 02.
        Stack shape : UL_NNTERMINAUX.
        Start symbol: grammaire. *)

  | MenhirState04 : (('s, _menhir_box_grammaire) _menhir_cell1_UL_PAROUV, _menhir_box_grammaire) _menhir_state
    (** State 04.
        Stack shape : UL_PAROUV.
        Start symbol: grammaire. *)

  | MenhirState06 : (('s, _menhir_box_grammaire) _menhir_cell1_UL_CROOUV, _menhir_box_grammaire) _menhir_state
    (** State 06.
        Stack shape : UL_CROOUV.
        Start symbol: grammaire. *)

  | MenhirState07 : (('s, _menhir_box_grammaire) _menhir_cell1_UL_ACCOUV, _menhir_box_grammaire) _menhir_state
    (** State 07.
        Stack shape : UL_ACCOUV.
        Start symbol: grammaire. *)

  | MenhirState13 : (('s, _menhir_box_grammaire) _menhir_cell1_int_production _menhir_cell0_baroupas, _menhir_box_grammaire) _menhir_state
    (** State 13.
        Stack shape : int_production baroupas.
        Start symbol: grammaire. *)

  | MenhirState20 : ((('s, _menhir_box_grammaire) _menhir_cell1_UL_NNTERMINAUX, _menhir_box_grammaire) _menhir_cell1_production, _menhir_box_grammaire) _menhir_state
    (** State 20.
        Stack shape : UL_NNTERMINAUX production.
        Start symbol: grammaire. *)


and 's _menhir_cell0_baroupas = 
  | MenhirCell0_baroupas of 's * (unit)

and ('s, 'r) _menhir_cell1_int_production = 
  | MenhirCell1_int_production of 's * ('s, 'r) _menhir_state * (unit)

and ('s, 'r) _menhir_cell1_production = 
  | MenhirCell1_production of 's * ('s, 'r) _menhir_state * (unit)

and ('s, 'r) _menhir_cell1_UL_ACCOUV = 
  | MenhirCell1_UL_ACCOUV of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_UL_CROOUV = 
  | MenhirCell1_UL_CROOUV of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_UL_NNTERMINAUX = 
  | MenhirCell1_UL_NNTERMINAUX of 's * ('s, 'r) _menhir_state * (
# 24 "Parser.mly"
       (string)
# 103 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_UL_PAROUV = 
  | MenhirCell1_UL_PAROUV of 's * ('s, 'r) _menhir_state

and _menhir_box_grammaire = 
  | MenhirBox_grammaire of (unit) [@@unboxed]

let _menhir_action_01 =
  fun () ->
    (
# 53 "Parser.mly"
           ( (print_endline "baroupas : LAMBDA") )
# 117 "Parser.ml"
     : (unit))

let _menhir_action_02 =
  fun () ->
    (
# 54 "Parser.mly"
                 (  (print_endline "baroupas : UL_BAR") )
# 125 "Parser.ml"
     : (unit))

let _menhir_action_03 =
  fun () ->
    (
# 44 "Parser.mly"
             ( (print_endline "boucle : LAMBDA") )
# 133 "Parser.ml"
     : (unit))

let _menhir_action_04 =
  fun () ->
    (
# 45 "Parser.mly"
                                   (  (print_endline "boucle : baroupas production ") )
# 141 "Parser.ml"
     : (unit))

let _menhir_action_05 =
  fun () ->
    (
# 38 "Parser.mly"
                                                             (  (print_endline "grammaire : UL_NNTERMINAUX UL_DER production UL_PT UL_DOLLAR ") )
# 149 "Parser.ml"
     : (unit))

let _menhir_action_06 =
  fun () ->
    (
# 39 "Parser.mly"
                                                           ( (print_endline "grammaire : UL_NNTERMINAUX UL_DER production UL_PT grammaire") )
# 157 "Parser.ml"
     : (unit))

let _menhir_action_07 =
  fun () ->
    (
# 47 "Parser.mly"
                              ( (print_endline "int_production : UL_TERMINAUX") )
# 165 "Parser.ml"
     : (unit))

let _menhir_action_08 =
  fun () ->
    (
# 48 "Parser.mly"
                                 (  (print_endline "int_production : UL_NNTERMINAUX") )
# 173 "Parser.ml"
     : (unit))

let _menhir_action_09 =
  fun () ->
    (
# 49 "Parser.mly"
                                                 (  (print_endline "int_production : UL_ACCOUV production UL_ACCFER") )
# 181 "Parser.ml"
     : (unit))

let _menhir_action_10 =
  fun () ->
    (
# 50 "Parser.mly"
                                                 (  (print_endline "int_production : UL_PAROUV production UL_PARFER") )
# 189 "Parser.ml"
     : (unit))

let _menhir_action_11 =
  fun () ->
    (
# 51 "Parser.mly"
                                                 (  (print_endline "int_production : UL_CROOUV production UL_CROFER") )
# 197 "Parser.ml"
     : (unit))

let _menhir_action_12 =
  fun () ->
    (
# 42 "Parser.mly"
                                   ( (print_endline "production : int_production boucle ") )
# 205 "Parser.ml"
     : (unit))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | UL_ACCFER ->
        "UL_ACCFER"
    | UL_ACCOUV ->
        "UL_ACCOUV"
    | UL_BAR ->
        "UL_BAR"
    | UL_CROFER ->
        "UL_CROFER"
    | UL_CROOUV ->
        "UL_CROOUV"
    | UL_DER ->
        "UL_DER"
    | UL_DOLLAR ->
        "UL_DOLLAR"
    | UL_NNTERMINAUX _ ->
        "UL_NNTERMINAUX"
    | UL_PARFER ->
        "UL_PARFER"
    | UL_PAROUV ->
        "UL_PAROUV"
    | UL_PT ->
        "UL_PT"
    | UL_TERMINAUX _ ->
        "UL_TERMINAUX"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_23 : type  ttv_stack. ttv_stack -> _ -> _menhir_box_grammaire =
    fun _menhir_stack _v ->
      MenhirBox_grammaire _v
  
  let rec _menhir_goto_grammaire : type  ttv_stack. ttv_stack -> _ -> (ttv_stack, _menhir_box_grammaire) _menhir_state -> _menhir_box_grammaire =
    fun _menhir_stack _v _menhir_s ->
      match _menhir_s with
      | MenhirState00 ->
          _menhir_run_23 _menhir_stack _v
      | MenhirState20 ->
          _menhir_run_22 _menhir_stack
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_22 : type  ttv_stack. ((ttv_stack, _menhir_box_grammaire) _menhir_cell1_UL_NNTERMINAUX, _menhir_box_grammaire) _menhir_cell1_production -> _menhir_box_grammaire =
    fun _menhir_stack ->
      let MenhirCell1_production (_menhir_stack, _, _) = _menhir_stack in
      let MenhirCell1_UL_NNTERMINAUX (_menhir_stack, _menhir_s, _) = _menhir_stack in
      let _v = _menhir_action_06 () in
      _menhir_goto_grammaire _menhir_stack _v _menhir_s
  
  let rec _menhir_run_01 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_grammaire) _menhir_state -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_UL_NNTERMINAUX (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UL_DER ->
          let _menhir_s = MenhirState02 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UL_TERMINAUX _ ->
              _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | UL_PAROUV ->
              _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | UL_NNTERMINAUX _ ->
              _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | UL_CROOUV ->
              _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | UL_ACCOUV ->
              _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_03 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_grammaire) _menhir_state -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_07 () in
      _menhir_goto_int_production _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_int_production : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_grammaire) _menhir_state -> _ -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_int_production (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | UL_BAR ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_02 () in
          _menhir_goto_baroupas _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | UL_ACCOUV | UL_CROOUV | UL_NNTERMINAUX _ | UL_PAROUV | UL_TERMINAUX _ ->
          let _v = _menhir_action_01 () in
          _menhir_goto_baroupas _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | UL_ACCFER | UL_CROFER | UL_PARFER | UL_PT ->
          let _ = _menhir_action_03 () in
          _menhir_goto_boucle _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_baroupas : type  ttv_stack. (ttv_stack, _menhir_box_grammaire) _menhir_cell1_int_production -> _ -> _ -> _ -> _ -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let _menhir_stack = MenhirCell0_baroupas (_menhir_stack, _v) in
      match (_tok : MenhirBasics.token) with
      | UL_TERMINAUX _ ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState13
      | UL_PAROUV ->
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState13
      | UL_NNTERMINAUX _ ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState13
      | UL_CROOUV ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState13
      | UL_ACCOUV ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState13
      | _ ->
          _eRR ()
  
  and _menhir_run_04 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_grammaire) _menhir_state -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_UL_PAROUV (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState04 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UL_TERMINAUX _ ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | UL_PAROUV ->
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | UL_NNTERMINAUX _ ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | UL_CROOUV ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | UL_ACCOUV ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_05 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_grammaire) _menhir_state -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_08 () in
      _menhir_goto_int_production _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_06 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_grammaire) _menhir_state -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_UL_CROOUV (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState06 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UL_TERMINAUX _ ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | UL_PAROUV ->
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | UL_NNTERMINAUX _ ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | UL_CROOUV ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | UL_ACCOUV ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_07 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_grammaire) _menhir_state -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_UL_ACCOUV (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState07 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UL_TERMINAUX _ ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | UL_PAROUV ->
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | UL_NNTERMINAUX _ ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | UL_CROOUV ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | UL_ACCOUV ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_boucle : type  ttv_stack. (ttv_stack, _menhir_box_grammaire) _menhir_cell1_int_production -> _ -> _ -> _ -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      let MenhirCell1_int_production (_menhir_stack, _menhir_s, _) = _menhir_stack in
      let _v = _menhir_action_12 () in
      _menhir_goto_production _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_production : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_grammaire) _menhir_state -> _ -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState02 ->
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState04 ->
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | MenhirState06 ->
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | MenhirState13 ->
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | MenhirState07 ->
          _menhir_run_08 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_19 : type  ttv_stack. ((ttv_stack, _menhir_box_grammaire) _menhir_cell1_UL_NNTERMINAUX as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_grammaire) _menhir_state -> _ -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | UL_PT ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UL_NNTERMINAUX _v_0 ->
              let _menhir_stack = MenhirCell1_production (_menhir_stack, _menhir_s, _v) in
              _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState20
          | UL_DOLLAR ->
              let MenhirCell1_UL_NNTERMINAUX (_menhir_stack, _menhir_s, _) = _menhir_stack in
              let _v = _menhir_action_05 () in
              _menhir_goto_grammaire _menhir_stack _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_17 : type  ttv_stack. (ttv_stack, _menhir_box_grammaire) _menhir_cell1_UL_PAROUV -> _ -> _ -> _ -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      match (_tok : MenhirBasics.token) with
      | UL_PARFER ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_UL_PAROUV (_menhir_stack, _menhir_s) = _menhir_stack in
          let _v = _menhir_action_10 () in
          _menhir_goto_int_production _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_15 : type  ttv_stack. (ttv_stack, _menhir_box_grammaire) _menhir_cell1_UL_CROOUV -> _ -> _ -> _ -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      match (_tok : MenhirBasics.token) with
      | UL_CROFER ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_UL_CROOUV (_menhir_stack, _menhir_s) = _menhir_stack in
          let _v = _menhir_action_11 () in
          _menhir_goto_int_production _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_14 : type  ttv_stack. (ttv_stack, _menhir_box_grammaire) _menhir_cell1_int_production _menhir_cell0_baroupas -> _ -> _ -> _ -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      let MenhirCell0_baroupas (_menhir_stack, _) = _menhir_stack in
      let _ = _menhir_action_04 () in
      _menhir_goto_boucle _menhir_stack _menhir_lexbuf _menhir_lexer _tok
  
  and _menhir_run_08 : type  ttv_stack. (ttv_stack, _menhir_box_grammaire) _menhir_cell1_UL_ACCOUV -> _ -> _ -> _ -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      match (_tok : MenhirBasics.token) with
      | UL_ACCFER ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_UL_ACCOUV (_menhir_stack, _menhir_s) = _menhir_stack in
          let _v = _menhir_action_09 () in
          _menhir_goto_int_production _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  let _menhir_run_00 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_grammaire =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState00 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UL_NNTERMINAUX _v ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
end

let grammaire =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_grammaire v = _menhir_run_00 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v

# 55 "Parser.mly"
  

# 493 "Parser.ml"
