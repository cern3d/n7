(* Pour les tests *)
(* [eq_perm l l'] retourne true ssi [l] et [l']
   sont égales à à permutation près (pour (=)).
   [l'] ne doit pas contenir de doublon. *)
let eq_perm l l' =
  List.length l = List.length l' && List.for_all (fun x -> List.mem x l) l'


module type StructureDonnees =
sig

  (* Type permettant de stocker le dictionnaire *)
  type dico

  (* Dictionnaire vide *)
  val empty : dico

  (* Ajoute un mot et son encodage au dictionnaire *)
  (* premier parametre : l'encodage du mot *)
  (* deuxième paramètre : le mot *)
  (* troisième paramètre : le dictionnaire *)
  val ajouter : int list -> string -> dico -> dico

  (* Cherche tous les mots associés à un encodage dans un dictionnaire *)
  (* premier parametre : l'encodage du mot *)
  (* second paramètre : le dictionnaire *)
  val chercher : int list -> dico -> string list


  (* Calcule le nombre maximum de mots ayant le même encodage dans un
     dictionnaire *)
  (* paramètre : le dictionnaire *)
  val max_mots_code_identique : dico -> int

  (* Liste tous les mots d'un dictionnaire dont un prefixe de l'encodage est donné en paramètre *)
  (* premier paramètre : le prefixe de l'encodage *)
  (* second paramètre : le dictionnaire *)
  val prefixe : int list -> dico -> string list

end

module ListAssoc : StructureDonnees =
struct

  type dico =(int list * string list) list

  let empty = []

  let rec recherche nombres suite =
    if suite = [] && not (nombres = []) then false
    else
    match nombres with
    |[]-> true
    |t::q -> let i::j = suite in if t=i then recherche q j else false

  let rec chercher nombres dict = 
    match dict with
    |[]->[]
    |t::q -> let (nombres_trouve,mots) = t in if nombres = nombres_trouve then mots else chercher nombres q

    (* match dict with
    | [] -> "Aucun mot trouve"
    | t::q -> let (nombrees,mot) = t in if test_chercher nombre nombrees then mot else chercher nombres q

  let test_chercher nombres suite =
    if suite = [] && not (nombres = []) then false
    else
    match nombres with
    |[]-> true
    |t::q -> let i::j = suite in if t=i then test_chercher q j else false
 *)

  let int_ajout nombres mot element =
    let (nombrees,mots)=element in
    if nombrees = nombres then (nombrees,mot::mots) else element

  let rec ajouter nombres mot dict=
    match dict with
    |[]-> [(nombres,[mot])]
    |t::q-> let (suite,_) = t in if suite = nombres then List.map (int_ajout nombres mot) dict else t :: (ajouter nombres mot q)

  let rec nombre_mots tete = let (nombres,mots) = tete in
  match mots with
  |[]-> 0
  |t::q -> 1 + nombre_mots (nombres,q)

  let max2 x y = if x>y then x else y;;
 
  let rec max_list l = match l with 
    [] -> 0 
    |x::reste -> max2 x (max_list reste) ;;

  let max_mots_code_identique dict = 
    max_list (List.map nombre_mots dict)

  let rec prefixe nombres dict= 
  match dict with
  | [] -> []
  | t::q -> let (nombrees,mot) = t in if recherche nombres nombrees then mot @ (prefixe nombres q) else prefixe nombres q

  let%test _ = eq_perm (ajouter [2;2] "kkkk" [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) [([2;2],["kkkk";"bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]
  let%test _ = eq_perm (ajouter [2;3] "xk" [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) [([2;3],["xk"]);([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]

  let%test _ = eq_perm (chercher [2;2] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) ["bb";"aa";"cc"]
  let%test _ = eq_perm (chercher [3;3] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) []
  let%test _ = eq_perm (chercher [2;7;3;3] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) ["bref"]
  let%test _ = eq_perm (chercher [2;6;6] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) ["bon"]
  let%test _ = eq_perm (chercher [2;6;6] []) []


  let%test _ =max_mots_code_identique [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])] = 3
  let%test _ =max_mots_code_identique [([2;7;3;3],["bref"]);([2;2],["bb";"aa";"cc"]); ([2;6;6],["bon"])] = 3
  let%test _ =max_mots_code_identique [] = 0
  let%test _ =max_mots_code_identique [([2;7;3;3],["bref"]);([2;2],["bb"]); ([2;6;6],["bon"])] = 1

  let%test _ = eq_perm (prefixe [] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) ["bb";"aa";"cc";"bref";"bon"]
  let%test _ = eq_perm (prefixe [] [([2;7;3;3],["bref"]);([2;2],["bb";"aa";"cc"]); ([2;6;6],["bon"])]) ["bref";"bb";"aa";"cc";"bon"]
  let%test _ = eq_perm (prefixe [] []) []
  let%test _ = eq_perm (prefixe [] [([2;7;3;3],["bref"]);([2;2],["bb"]); ([2;6;6],["bon"])]) ["bref";"bb";"bon"]
  let%test _ = eq_perm (prefixe [2] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) ["bb";"aa";"cc";"bref";"bon"]
  let%test _ = eq_perm (prefixe [2;2] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;6;6],["bon"])]) ["bb";"aa";"cc"]
  let%test _ = eq_perm (prefixe [2;2] [([2;2],["bb";"aa";"cc"]); ([2;7;3;3],["bref"]);([2;2;2],["bac";"bab"]);([2;6;6],["bon"])]) ["bb";"aa";"cc";"bac";"bab"]



end


module Arbre =
struct
  type dico = Noeud of string list * branch list
  and branch = int * dico

  let empty = Noeud ([], [])

  (* Recherche d’un sous-arbre correspondant à un chiffre c dans une liste de branches *)
  let rec recherche c lb =
    match lb with
    | [] -> None
    | (tc, ta) :: qlb ->
        if c = tc then Some ta
        else recherche c qlb

  (* Met à jour ou ajoute une branche c -> nouvelle_b dans lb *)
let rec maj c nouvelle_b lb =
  match lb with
  | [] -> [ (c, nouvelle_b) ]
  | (tc, ta) :: qlb ->
      if c < tc then (c, nouvelle_b) :: lb
      else if c = tc then (c, nouvelle_b) :: qlb
      else (tc, ta) :: maj c nouvelle_b qlb

  (* Recherche d’un mot correspondant à une suite de chiffres *)
  let rec chercher nombres (Noeud (mots, branches)) =
    match nombres with
    | [] -> mots
    | t :: q -> (
        match recherche t branches with
        | None -> []
        | Some a -> chercher q a )

  (* Ajoute un mot associé à une suite de chiffres *)
  let rec ajouter nombres mot (Noeud (mots, lb)) =
    match nombres with
    | [] -> Noeud (mot :: mots, lb)
    | c :: qlc ->
        let arbre_c =
          match recherche c lb with
          | None -> empty
          | Some a -> a
        in
        let nouveau_sous_arbre = ajouter qlc mot arbre_c in
        Noeud (mots, maj c nouveau_sous_arbre lb)

  (* Compte le nombre de mots stockés dans une liste *)
  let rec nombre_mots mots =
    match mots with
    | [] -> 0
    | _ :: q -> 1 + nombre_mots q

  let b_to_n (_, noeud) = noeud

  let rec create_list dict =
    match dict with
    | Noeud (mots, []) -> [ nombre_mots mots ]
    | Noeud (mots, lb) ->
        [ nombre_mots mots ]
        @ List.flatten (List.map create_list (List.map b_to_n lb))

  let max2 x y = if x > y then x else y

  let rec max_list l =
    match l with
    | [] -> 0
    | x :: reste -> max2 x (max_list reste)

  let max_mots_code_identique dict = max_list (create_list dict)

  (* Exemple d’une fonction prefixe — à compléter selon le besoin *)
  let rec prefixe p d =
    match p, d with
    | [], Noeud (mots, lb) -> mots @ List.flatten (List.map (fun (_, sous_arbre) -> prefixe [] sous_arbre) lb)
    | touche::q, Noeud (_, lb) -> (match List.assoc_opt touche lb with
                                | Some sous_arbre -> prefixe q sous_arbre
                                | None -> [])



      let a1 = Noeud
      ([],
       [(2,
         Noeud
           ([],
            [(6,
              Noeud
                ([],
                 [(6,
                   Noeud
                     ([],
                      [(5,
                        Noeud
                          ([],
                           [(6,
                             Noeud
                               ([], [(8, Noeud ([], [(7, Noeud (["bonjour"], []))]))]))]))]))]))]))])
  let%test _ = a1 = ajouter [2;6;6;5;6;8;7] "bonjour" empty

  let a2 = Noeud
      ([],
       [(6,
         Noeud
           ([],
            [(2,
              Noeud
                ([],
                 [(2, Noeud ([], [(6, Noeud ([], [(5, Noeud (["ocaml"], []))]))]))]))]))])

  let%test _ = a2 = ajouter [6;2;2;6;5] "ocaml" empty

  let a3 =   Noeud
      ([],
       [(2, Noeud (["a"], []));
        (6,
         Noeud
           ([],
            [(2,
              Noeud
                ([],
                 [(2, Noeud ([], [(6, Noeud ([], [(5, Noeud (["ocaml"], []))]))]))]))]))])

  let%test _ = a3 = ajouter [2] "a" a2

  let a4 = Noeud ([], [(2, Noeud ([], [(8, Noeud (["au"], []))]))])

  let%test _ = a4 = ajouter [2;8] "au" empty

  let a5 = Noeud
      ([], [(2, Noeud ([], [(6, Noeud (["an"], [])); (8, Noeud (["au"], []))]))])

  let%test _ = a5 = ajouter [2;6] "an" a4

  let a6 = Noeud
      ([],
       [(2,
         Noeud
           ([],
            [(6, Noeud (["an"], [(3, Noeud (["ane"], []))]));
             (8, Noeud (["au"], []))]))])

  let%test _ = a6 = ajouter [2;6;3] "ane" a5

  let a7 = Noeud
      ([],
       [(2,
         Noeud
           ([],
            [(6, Noeud (["an"], [(3, Noeud (["ame";"ane"], []))]));
             (8, Noeud (["au"], []))]))])


  let%test _ = a7 = ajouter [2;6;3] "ame" a6

  let a8 = Noeud
      ([],
       [(2,
         Noeud
           ([],
            [(6, Noeud (["an"], [(3, Noeud (["bof";"ame";"ane"], []))]));
             (8, Noeud (["au"], []))]))])


  let%test _ = a8 = ajouter [2;6;3] "bof" a7

  let a9_1 = Noeud
      ([],
       [(2,
         Noeud
           ([],
            [(6, Noeud (["an"], [(3, Noeud (["bof";"ame";"ane"], []))]));
             (8, Noeud (["bu";"au"], []))]))])
  let a9_2 = Noeud
      ([],
       [(2,
         Noeud
           ([],
            [(8, Noeud (["bu"; "au"], []));
             (6, Noeud (["an"], [(3, Noeud (["bof"; "ame"; "ane"], []))]))]))])


  let%test _ = (a9_1 = ajouter [2;8] "bu" a8 || a9_2 = ajouter [2;8] "bu" a8)

  let%test _ = eq_perm (chercher [2;8] a9_1) ["bu"; "au"]
  let%test _ = eq_perm (chercher [2;6] a9_1) ["an"]
  let%test _ = eq_perm (chercher [2;6;3] a9_1) ["bof"; "ame"; "ane"]
  let%test _ = eq_perm (chercher [1;4;5] a9_1) []
  let%test _ = eq_perm (chercher [2;8] a9_2) ["bu"; "au"]
  let%test _ = eq_perm (chercher [2;6] a9_2) ["an"]
  let%test _ = eq_perm (chercher [2;6;3] a9_2) ["bof"; "ame"; "ane"]
  let%test _ = eq_perm (chercher [1;4;5] a9_2) []

  let%test _ = max_mots_code_identique a9_1 = 3
  let%test _ = max_mots_code_identique a9_2 = 3
  let%test _ = max_mots_code_identique a8 = 3
  let%test _ = max_mots_code_identique a7 = 2
  let%test _ = max_mots_code_identique a6 = 1
  let%test _ = max_mots_code_identique a5 = 1
  let%test _ = max_mots_code_identique a4 = 1
  let%test _ = max_mots_code_identique a3 = 1
  let%test _ = max_mots_code_identique a2 = 1
  let%test _ = max_mots_code_identique a1 = 1


end




