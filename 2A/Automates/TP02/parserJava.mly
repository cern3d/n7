%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token <string> IMPORT
%token <string> IDENT TYPEIDENT
%token INT FLOAT BOOL CHAR VOID STRING
%token ACCOUV ACCFER PAROUV PARFER CROOUV CROFER
%token PTVIRG VIRG
%token SI SINON TANTQUE RETOUR
/* Defini le type des donnees associees a l'unite lexicale */
%token <int> ENTIER
%token <float> FLOTTANT
%token <bool> BOOLEEN
%token <char> CARACTERE
%token <string> CHAINE
%token VIDE
%token NOUVEAU
%token ASSIGN
%token OPINF OPSUP OPINFEG OPSUPEG OPEG OPNONEG
%token OPPLUS OPMOINS OPOU
%token OPMULT OPMOD OPDIV OPET
%token OPNON
%token OPPT
/* Unite lexicale particuliere qui represente la fin du fichier */
%token FIN

/* Declarations des regles d'associative et de priorite pour les operateurs */
/* La priorite est croissante de haut en bas */
/* Associatif a droite */
%right ASSIGN /* Priorite la plus faible */
/* Non associatif */
%nonassoc OPINF OPSUP OPINFEG OPSUPEG OPEG OPNONEG
/* Associatif a gauche */
%left OPPLUS OPMOINS OPOU
%left OPMULT OPMOD OPDIV OPET
%right OPNON
%left OPPT PAROUV CROOUV /* Priorite la plus forte */

/* Type renvoye pour le nom terminal fichier */
%type <unit> fichier
%type <int> variables

/* Le non terminal fichier est l'axiome */
%start fichier

%% /* Regles de productions */

imports : IMPORT { (print_endline "imports : IMPORT"); }

fichier : programme FIN { (print_endline "fichier : programme FIN");(print_string "Nombre de fonctions : ");(print_newline()) }

programme : /* Lambda, mot vide */ { (print_endline "programme : /* Lambda, mot vide */") }
          | fonction programme { (print_endline "programme : fonction programme") }          | fonction programme { (print_endline "programme : fonction programme") }


typeStruct : typeBase declTab { (print_endline "typeStruct : typeBase declTab") }

typeBase : INT { (print_endline "typeBase : INT") }
         | FLOAT { (print_endline "typeBase : FLOAT") }
         | BOOL { (print_endline "typeBase : BOOL") }
         | VOID { (print_endline "typeBase : VOID") }
         | CHAR { (print_endline "typeBase : CHAR") }
         | STRING { (print_endline "typeBase : STRING") }
         | TYPEIDENT { (print_endline "typeBase : TYPEIDENT") }

declTab : /* Lambda, mot vide */ { (print_endline "declTab : /* Lambda, mot vide */") }
        | CROOUV CROFER { (print_endline "declTab : CROOUV CROFER") }

fonction : entete bloc  { (print_endline "fonction : entete bloc") }

entete : typeStruct IDENT PAROUV parsFormels PARFER { (print_endline "entete : typeStruct IDENT PAROUV parsFormels PARFER") }
       | VOID IDENT PAROUV parsFormels PARFER { (print_endline "entete : VOID IDENT PAROUV parsFormels PARFER") }

parsFormels : /* Lambda, mot vide */ { (print_endline "parsFormels : /* Lambda, mot vide */") }
            | typeStruct IDENT suiteParsFormels { (print_endline "parsFormels : typeStruct IDENT suiteParsFormels") }

suiteParsFormels : /* Lambda, mot vide */ { (print_endline "suiteParsFormels : /* Lambda, mot vide */") }
                 | VIRG typeStruct IDENT suiteParsFormels { (print_endline "suiteParsFormels : VIRG typeStruct IDENT suiteParsFormels") }

bloc : ACCOUV /* $1 */ variables /* $2 */ instructions /* $3 */ ACCFER /* $4 */
     {
	(print_endline "bloc : ACCOUV variables instructions ACCFER");
	(print_string "Nombre de variables = ");
	(print_int $2);
	(print_newline ())
	}

variables : /* Lambda, mot vide */
		{
		(print_endline "variables : /* Lambda, mot vide */");0
		}
          | variable /* $1 */ variables /* $2 */
		{
		(print_endline "variables : variable variables");
		($2 + 1)
		}

variable : typeStruct IDENT PTVIRG { (print_endline "variable : typeStruct IDENT PTVIRG") }

suffixes : /* Lambda, mot vide */{ (print_endline "parsFormels : /* Lambda, mot vide */") }
		 |suffixe { (print_endline "parsFormels : suffixe") }

suffixe : PAROUV PARFER { (print_endline "parsFormels : suffixe") }
		| PAROUV expressions PARFER { (print_endline "parsFormels : PAROUV expressions PARFER") }
		| CROOUV expression CROFER { (print_endline "parsFormels : CROOUV expression CROFER") }

unaire : PAROUV typeBase PARFER { (print_endline "unaire : ( type )") }
        | OPPLUS { (print_endline "unaire : +") }
        | OPMOINS { (print_endline "unaire : -") }
        | OPNON { (print_endline "unaire : !") }

binaire : ASSIGN { (print_endline "binaire : =") }
        | OPINF { (print_endline "binaire : <") }
        | OPSUP { (print_endline "binaire : >") }
        | OPINFEG { (print_endline "binaire : <=") }
        | OPSUPEG { (print_endline "binaire : >=")}
        | OPEG { (print_endline "binaire : ==") }
        | OPNONEG { (print_endline "binaire : !=") }
        | OPPLUS { (print_endline "binaire : +") }
        | OPMOINS { (print_endline "binaire : -") }
        | OPOU { (print_endline "binaire : ||") }
        | OPMULT { (print_endline "binaire : *") }
        | OPMOD { (print_endline "binaire : %") }
        | OPDIV { (print_endline "binaire : /") }
        | OPET { (print_endline "binaire : &&") }
        | OPNON { (print_endline "binaire : !") }
        | OPPT { (print_endline "binaire : .") }


binaires : /* Lambda, mot vide */{ (print_endline "binaires : /* Lambda, mot vide */") }
			| binaire { (print_endline "binaires : binaire") }

/* A FAIRE : Completer pour decrire une liste d'instructions eventuellement vide */
instructions : /* Lambda, mot vide */{ (print_endline "instruction : /* Lambda, mot vide */") }
			| instruction { (print_endline "instructions : instruction") }

/* A FAIRE : Completer pour ajouter les autres formes d'instructions */
               instruction : expression PTVIRG { (print_endline "instruction : expression PTVIRG") }
                             | SI PAROUV expression PARFER bloc { (print_endline "instruction : SI PAROUV expression PARFER bloc") }
                             | SI PAROUV expression PARFER bloc SINON bloc { (print_endline "instruction : SI PAROUV expression PARFER bloc SINON bloc") }
                             | TANTQUE PAROUV expression PARFER bloc { (print_endline "instruction : TANTQUE PAROUV expression PARFER bloc") }
                             | RETOUR expression PTVIRG  { (print_endline "instruction : RETURN expression PTVIRG") }

/* A FAIRE : Completer pour ajouter les autres formes d'expressions */
expression : 
	   | VIDE {(print_endline "variables : VIDE")}
       | ENTIER { (print_endline "expression : ENTIER") }
	   | FLOTTANT { (print_endline "expression : FLOTTANT") }
	   | CARACTERE { (print_endline "expression : CARACTERE") }
	   | BOOLEEN { (print_endline "expression : BOOLEEN") }
	   | NOUVEAU IDENT PAROUV PARFER { (print_endline "expression : NOUVEAU IDENT PAROUV PARFER") }
	   | NOUVEAU IDENT CROOUV expression CROFER { (print_endline "expression : NOUVEAU IDENT CROOUV expression CROFER") }
	   | IDENT suffixes { (print_endline "expression : IDENT suffixes") }
	   | PAROUV expression PARFER suffixes { (print_endline "expression : PAROUV expression PARFER suffixes") }
       | unaire expression { (print_endline "expression : unaire") }
       | binaire expression { (print_endline "expression : binaire") }

expressions : /* Lambda, mot vide */{ (print_endline "expressions : /* Lambda, mot vide */") }
			| expressions expression VIRG { (print_endline "expressions : expressions expression VIRG") }

%%
