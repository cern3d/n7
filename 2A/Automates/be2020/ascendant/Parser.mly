%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token UL_MACHINE
%token UL_ACCOUV UL_ACCFER
%token UL_EVENT
%token UL_REGION
%token UL_STATE 
%token UL_STARTS 
%token UL_ENDS
%token UL_ON
%token UL_TO
%token UL_FROM
%token UL_PT

/* Defini le type des donnees associees a l'unite lexicale */

%token <string> UL_IDENT

/* Unite lexicale particuliere qui represente la fin du fichier */

%token UL_FIN

/* Type renvoye pour le nom terminal document */
%type <unit> machine

/* Le non terminal document est l'axiome */
%start machine

%% /* Regles de productions */

machine : UL_MACHINE UL_IDENT UL_ACCOUV int_machine  UL_ACCFER UL_FIN { (print_endline "machine : MACHINE IDENT { ... } FIN ") }

int_machine : /*Lambda*/{ (print_endline "int_machine : lambda") } 
            | UL_EVENT UL_IDENT int_machine { (print_endline "int_machine : UL_IDENT UL_EVENT") }  
            | transition int_machine { (print_endline "int_machine : transition") }  
            | region int_machine { (print_endline "int_machine : region") }  

transition : UL_FROM nomqualifie UL_TO nomqualifie UL_ON UL_IDENT { (print_endline "transition : UL_FROM nomqualifie UL_TO nomqualifie UL_ON UL_IDENT ") }  

nomqualifie : UL_IDENT { (print_endline "nomqualifie : UL_IDENT")}
            | UL_IDENT UL_PT nomqualifie { (print_endline "nomqualifie : UL_IDENT UL_PT nomqualifie")}

region : UL_REGION UL_IDENT UL_ACCOUV etat_boucle UL_ACCFER { (print_endline "region : UL_REGION UL_IDENT UL_ACCOUV etat_boucle UL_ACCFER ") }  

etat_boucle : etat { (print_endline "etat_boucle : etat ") }  
            | etat etat_boucle { (print_endline "etat_boucle : etat etat_boucle ") }  

etat : UL_STATE UL_IDENT startsoupas endsoupas int_etat { (print_endline "etat : UL_STATE UL_IDENT startsoupas endsoupas int_etat ") }  

startsoupas : { (print_endline "startsoupas : ") }  
            | UL_STARTS { (print_endline "startsoupas : UL_STARTS ") }  


endsoupas : { (print_endline "endsoupas : ") }  
            | UL_ENDS { (print_endline "endsoupas : UL_ENDS ") }  

int_etat : { (print_endline "int_etat : ") }   
        | UL_ACCOUV region_boucle UL_ACCFER { (print_endline "int_etat : UL_ACCOUV region_boucle UL_ACCFER ") }  

region_boucle : region { (print_endline "region_boucle : region ") }  
            | region region_boucle { (print_endline "region_boucle : region region_boucle ") }  
%%
