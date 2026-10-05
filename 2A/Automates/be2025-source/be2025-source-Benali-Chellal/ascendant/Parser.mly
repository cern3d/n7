%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

  %token UL_ACCOUV 
  %token UL_ACCFER 		
  %token UL_PAROUV 	
  %token UL_DER
  %token UL_PT 
  %token UL_BAR 
  %token UL_PARFER 	
  %token UL_CROOUV 	
  %token UL_CROFER 	

/* Defini le type des donnees associees a l'unite lexicale */

%token <string> UL_TERMINAUX
%token <string> UL_NNTERMINAUX

/* Unite lexicale particuliere qui represente la fin du fichier */

%token UL_DOLLAR

/* Type renvoye pour le nom terminal document */
%type <unit> grammaire

/* Le non terminal document est l'axiome */
%start grammaire

%% /* Regles de productions */

grammaire : UL_NNTERMINAUX UL_DER production UL_PT UL_DOLLAR {  (print_endline "grammaire : UL_NNTERMINAUX UL_DER production UL_PT UL_DOLLAR ") }
        | UL_NNTERMINAUX UL_DER production UL_PT grammaire { (print_endline "grammaire : UL_NNTERMINAUX UL_DER production UL_PT grammaire") }


production : int_production boucle { (print_endline "production : int_production boucle ") }

boucle     : { (print_endline "boucle : LAMBDA") }
            |  baroupas production {  (print_endline "boucle : baroupas production ") }

int_production : UL_TERMINAUX { (print_endline "int_production : UL_TERMINAUX") }
                | UL_NNTERMINAUX {  (print_endline "int_production : UL_NNTERMINAUX") }
                | UL_ACCOUV production UL_ACCFER {  (print_endline "int_production : UL_ACCOUV production UL_ACCFER") }
                | UL_PAROUV production UL_PARFER {  (print_endline "int_production : UL_PAROUV production UL_PARFER") }
                | UL_CROOUV production UL_CROFER {  (print_endline "int_production : UL_CROOUV production UL_CROFER") }

baroupas : { (print_endline "baroupas : LAMBDA") } 
        | UL_BAR {  (print_endline "baroupas : UL_BAR") }
%%
