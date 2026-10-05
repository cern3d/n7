%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token UL_MODEL
%token UL_ACCOUV UL_ACCFER
%token UL_BLOCK
%token UL_SYSTEM
%token UL_FLOW
%token UL_TO
%token UL_FROM
%token UL_INT 
%token UL_FLOAT 
%token UL_BOOL 
%token UL_IN 
%token UL_OUT 
%token UL_VIRG 
%token UL_DEPNT 
%token UL_PTVIRG 
%token UL_OPPT 
%token UL_PAROUV 
%token UL_PARFER 
%token UL_CROOUV 
%token UL_CROFER 

/* Defini le type des donnees associees a l'unite lexicale */

%token <string> UL_IDENT
%token <string> UL_ENTIER
%token <string> UL_IDENTPORT

/* Unite lexicale particuliere qui represente la fin du fichier */

%token UL_FIN

/* Type renvoye pour le nom terminal document */
%type <unit> modele

/* Le non terminal document est l'axiome */
%start modele

%% /* Regles de productions */

modele : UL_MODEL UL_IDENT UL_ACCOUV int_modele UL_ACCFER UL_FIN { (print_endline "modele : UL_MODEL IDENT { ... } UL_FIN ") }

int_modele :
    /* Lambda */ { print_endline "modele : Lambda vide" }
  | bloc int_modele { print_endline "modele : bloc" }
  | systeme int_modele { print_endline "modele : system" }
  | flot int_modele { print_endline "modele : flot" }



bloc : UL_BLOCK UL_IDENT parametres UL_PTVIRG { (print_endline "bloc : UL_BLOCK UL_IDENT parametres UL_PTVIR ") }


systeme : UL_SYSTEM UL_IDENT parametres UL_ACCOUV int_modele UL_ACCFER { (print_endline " systeme :  UL_SYSTEM UL_IDENT parametres UL_ACCOUV int_modele UL_ACCFER ") }


parametres : UL_PAROUV int_parametres UL_PARFER { (print_endline "parametres : UL_PAROUV int_parametres UL_PARFER ") }

int_parametres : port { (print_endline "int_parametres : port ") }
                | port UL_VIRG int_parametres  { (print_endline "int_parametres : port UL_VIRG int_parametres  ") }

port : UL_IDENTPORT UL_DEPNT UL_IN tipe { (print_endline "port : UL_IDENTPORT UL_DEPNT UL_IN tipe ") }
    | UL_IDENTPORT UL_DEPNT UL_OUT tipe { (print_endline "port : UL_IDENTPORT UL_DEPNT UL_OUT tipe ") }

tipe : UL_INT { (print_endline "tipe : UL_INT ") }
    | UL_FLOAT { (print_endline "tipe : UL_FLOAT ") }
    |UL_BOOL { (print_endline "tipe :UL_BOOL ") }
    |UL_INT UL_ACCOUV int_tipe UL_ACCFER { (print_endline "tipe :UL_INT UL_ACCOUV int_tipe UL_ACCFER ") }
    |UL_BOOL UL_ACCOUV int_tipe UL_ACCFER { (print_endline "tipe :UL_BOOL UL_ACCOUV int_tipe UL_ACCFER ") }
    | UL_FLOAT UL_ACCOUV int_tipe UL_ACCFER { (print_endline "tipe : UL_FLOAT UL_ACCOUV int_tipe UL_ACCFER ") }

int_tipe : UL_ENTIER { (print_endline "int_tipe : UL_ENTIER ") }
        |UL_ENTIER UL_VIRG int_tipe { (print_endline "int_tipe :UL_ENTIER UL_VIRG int_tipe ") }

flot : UL_FLOW UL_IDENTPORT UL_FROM identdotornot UL_IDENTPORT UL_TO int_flot UL_PTVIRG { (print_endline "flot : UL_FLOW UL_IDENTPORT UL_FROM identdotornot UL_IDENTPORT UL_TO int_flot UL_PTVIRG ") }

int_flot :  { (print_endline "int_flot :  ") }
        |int_int_flot { (print_endline "int_flot : int_int_flot ") }

int_int_flot : identdotornot UL_IDENTPORT { (print_endline "int_int_flot : identdotornot UL_IDENTPORT ") }
        | identdotornot UL_IDENTPORT UL_PTVIRG int_flot { (print_endline "int_int_flot : identdotornot UL_IDENTPORT UL_PTVIRG int_flot ") }

identdotornot :  { (print_endline "identdotornot :  ") }
            |UL_IDENT UL_OPPT { (print_endline "identdotornot : UL_IDENT UL_OPPT ") }


%%
