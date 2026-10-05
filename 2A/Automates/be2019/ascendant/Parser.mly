%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token UL_PAROUV UL_PARFER
%token UL_PT UL_VIRG
%token  UL_NEGATION 
%token  UL_FAIL
%token  UL_DED 
%token  UL_COUP 

/* Defini le type des donnees associees a l'unite lexicale */

%token <string> UL_SYMBOLE
%token <string> UL_VARIABLE

/* Unite lexicale particuliere qui represente la fin du fichier */

%token UL_FIN

/* Type renvoye pour le nom terminal document */
%type <unit> programme

/* Le non terminal document est l'axiome */
%start programme

%% /* Regles de productions */

programme : int_programme_boucle  UL_FIN { (print_endline "programme : regle suite_regle FIN ") }

int_programme : axiome { (print_endline "int_programme : axiome ") }
            | deduction { (print_endline "int_programme : int_programme_boucle ") }

int_programme_boucle : int_programme { (print_endline "int_programme_boucle : deduction ") }
                | int_programme int_programme_boucle { (print_endline "int_programme_boucle : deduction int_programme_boucle ") }

axiome : predicat UL_PT { (print_endline "axiome : predicat UL_PT ") }

deduction : predicat UL_DED int_deduction_boucle UL_PT { (print_endline "deduction : predicat UL_DED int_deduction_boucle UL_PT ") }

int_deduction_boucle : int_deduction { (print_endline "int_deduction_boucle : int_deduction ") }
                    | int_deduction UL_VIRG int_deduction_boucle { (print_endline "int_deduction_boucle : int_deduction UL_VIRG int_deduction_boucle ") }

int_deduction : negationoupas predicat { (print_endline "int_deduction : negationoupas predicat ") }
            | UL_FAIL { (print_endline "int_deduction : UL_FAIL ") }
            | UL_COUP { (print_endline "int_deduction : UL_COUP ") }

negationoupas : { (print_endline "negationoupas : Lambda ") }
            | UL_NEGATION { (print_endline "negationoupas : UL_NEGATION ") }
        
predicat : UL_SYMBOLE UL_PAROUV int_predicat_boucle UL_PARFER { (print_endline "predicat : UL_SYMBOLE UL_PAROUV int_predicat_boucle UL_PARFER ") }

int_predicat_boucle : int_predicat { (print_endline "int_predicat_boucle : int_predicat ") }
                    | int_predicat UL_VIRG int_predicat_boucle { (print_endline "int_predicat_boucle : int_predicat UL_VIRG int_predicat_boucle ") }

int_predicat : UL_VARIABLE { (print_endline "int_predicat : UL_VARIABLE ") }
            | terme { (print_endline "int_predicat : terme ") }

terme : UL_SYMBOLE { (print_endline "terme : UL_SYMBOLE ") }
    | UL_SYMBOLE UL_PAROUV int_predicat_boucle UL_PARFER { (print_endline "terme : UL_SYMBOLE UL_PAROUV int_predicat_boucle UL_PARFER ") }

%%
