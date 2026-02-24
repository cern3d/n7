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

imports :
    IMPORT { (print_endline "imports : IMPORT") }
  | /* empty */ { () }

fichier :
    programme FIN
  { (print_endline "fichier : programme FIN"); (print_string "Nombre de fonctions : "); (print_newline ()) }

(* A program can be a sequence of functions or top-level blocks *)
programme :
    /* Lambda, mot vide */ { (print_endline "programme : /* Lambda, mot vide */") }
  | fonction programme      { (print_endline "programme : fonction programme") }
  | bloc programme         { (print_endline "programme : bloc programme") }

typeStruct :
    typeBase declTab { (print_endline "typeStruct : typeBase declTab") }

typeBase :
      INT    { (print_endline "typeBase : INT") }
    | FLOAT  { (print_endline "typeBase : FLOAT") }
    | BOOL   { (print_endline "typeBase : BOOL") }
    | VOID   { (print_endline "typeBase : VOID") }
    | CHAR   { (print_endline "typeBase : CHAR") }
    | STRING { (print_endline "typeBase : STRING") }
    | TYPEIDENT { (print_endline "typeBase : TYPEIDENT") }

declTab :
    /* Lambda, mot vide */ { (print_endline "declTab : /* Lambda, mot vide */") }
  | CROOUV CROFER        { (print_endline "declTab : CROOUV CROFER") }

fonction :
    entete bloc  { (print_endline "fonction : entete bloc") }

entete :
    typeStruct IDENT PAROUV parsFormels PARFER { (print_endline "entete : typeStruct IDENT PAROUV parsFormels PARFER") }
  | VOID IDENT PAROUV parsFormels PARFER       { (print_endline "entete : VOID IDENT PAROUV parsFormels PARFER") }

parsFormels :
    /* Lambda, mot vide */ { (print_endline "parsFormels : /* Lambda, mot vide */") }
  | typeStruct IDENT suiteParsFormels { (print_endline "parsFormels : typeStruct IDENT suiteParsFormels") }

suiteParsFormels :
    /* Lambda, mot vide */ { (print_endline "suiteParsFormels : /* Lambda, mot vide */") }
  | VIRG typeStruct IDENT suiteParsFormels { (print_endline "suiteParsFormels : VIRG typeStruct IDENT suiteParsFormels") }

bloc :
    ACCOUV variables instructions ACCFER
    {
      (print_endline "bloc : ACCOUV variables instructions ACCFER");
      (print_string "Nombre de variables = ");
      (print_int $2);
      (print_newline ())
    }

variables :
    /* Lambda, mot vide */ { (print_endline "variables : /* Lambda, mot vide */"); 0 }
  | variable variables  { (print_endline "variables : variable variables"); ($2 + 1) }

variable :
    typeStruct IDENT PTVIRG { (print_endline "variable : typeStruct IDENT PTVIRG") }

(* suffixes for function call or array indexing: foo(), a[b], ( ) after expression *)
suffixes :
    /* Lambda, mot vide */ { (print_endline "suffixes : /* Lambda, mot vide */") }
  | suffixe suffixes      { (print_endline "suffixes : suffixe suffixes") }

suffixe :
    PAROUV PARFER { (print_endline "suffixe : PAROUV PARFER") }         (* foo() *)
  | PAROUV expressions PARFER { (print_endline "suffixe : PAROUV expressions PARFER") }  (* foo(e1, e2) *)
  | CROOUV expression CROFER  { (print_endline "suffixe : CROOUV expression CROFER") }  (* a[e] *)

(* casts and unary *)
unaire :
    PAROUV typeBase PARFER { (print_endline "unaire : ( type )") }  (* cast e.g. (int) x *)
  | OPPLUS { (print_endline "unaire : +") }
  | OPMOINS { (print_endline "unaire : -") }
  | OPNON { (print_endline "unaire : !") }

(* small helper nonterminal for printable binary operator forms (kept for debug messages if needed) *)
binaire :
    ASSIGN   { (print_endline "binaire : =") }
  | OPINF    { (print_endline "binaire : <") }
  | OPSUP    { (print_endline "binaire : >") }
  | OPINFEG  { (print_endline "binaire : <=") }
  | OPSUPEG  { (print_endline "binaire : >=") }
  | OPEG     { (print_endline "binaire : ==") }
  | OPNONEG  { (print_endline "binaire : !=") }
  | OPPLUS   { (print_endline "binaire : +") }
  | OPMOINS  { (print_endline "binaire : -") }
  | OPOU     { (print_endline "binaire : ||") }
  | OPMULT   { (print_endline "binaire : *") }
  | OPMOD    { (print_endline "binaire : %") }
  | OPDIV    { (print_endline "binaire : /") }
  | OPET     { (print_endline "binaire : &&") }
  | OPNON    { (print_endline "binaire : !") }
  | OPPT     { (print_endline "binaire : .") }

(* instructions: sequence of 0 or more instructions *)
instructions :
    /* Lambda, mot vide */ { (print_endline "instructions : /* Lambda, mot vide */") }
  | instruction instructions { (print_endline "instructions : instruction instructions") }

(* instruction forms *)
instruction :
    expression PTVIRG                { (print_endline "instruction : expression PTVIRG") }  (* expression-statement like foo(); or a = b; *)
  | SI PAROUV expression PARFER bloc   { (print_endline "instruction : SI PAROUV expression PARFER bloc") }
  | SI PAROUV expression PARFER bloc SINON bloc { (print_endline "instruction : SI ... SINON ...") }
  | TANTQUE PAROUV expression PARFER bloc { (print_endline "instruction : TANTQUE PAROUV expression PARFER bloc") }
  | RETOUR expression PTVIRG         { (print_endline "instruction : RETOUR expression PTVIRG") }

(* Expressions with precedence based on declared %left/%right above. *)
expression :
    ENTIER                      { (print_endline "expression : ENTIER") }
  | FLOTTANT                    { (print_endline "expression : FLOTTANT") }
  | CARACTERE                   { (print_endline "expression : CARACTERE") }
  | BOOLEEN                     { (print_endline "expression : BOOLEEN") }
  | CHAINE                      { (print_endline "expression : CHAINE") }
  | IDENT suffixes              { (print_endline "expression : IDENT suffixes") }
  | NOUVEAU IDENT PAROUV PARFER { (print_endline "expression : NOUVEAU IDENT()") }
  | NOUVEAU IDENT CROOUV expression CROFER { (print_endline "expression : NOUVEAU IDENT[expr]") }
  | PAROUV expression PARFER    { (print_endline "expression : ( expression )") }
  | unaire expression           { (print_endline "expression : unaire expression") }
  | expression OPPT IDENT       { (print_endline "expression : expression . IDENT") }  (* object.field *)
  | expression OPMULT expression { (print_endline "expression : e * e") }
  | expression OPDIV expression  { (print_endline "expression : e / e") }
  | expression OPMOD expression  { (print_endline "expression : e % e") }
  | expression OPPLUS expression { (print_endline "expression : e + e") }
  | expression OPMOINS expression { (print_endline "expression : e - e") }
  | expression OPINF expression  { (print_endline "expression : e < e") }
  | expression OPSUP expression  { (print_endline "expression : e > e") }
  | expression OPINFEG expression { (print_endline "expression : e <= e") }
  | expression OPSUPEG expression { (print_endline "expression : e >= e") }
  | expression OPEG expression   { (print_endline "expression : e == e") }
  | expression OPNONEG expression{ (print_endline "expression : e != e") }
  | expression OPET expression   { (print_endline "expression : e && e") }
  | expression OPOU expression   { (print_endline "expression : e || e") }
  | expression ASSIGN expression { (print_endline "expression : e = e") }  (* assignment has right assoc declared above *)

(* expressions list for calls: e1, e2, ... *)
expressions :
    expression { (print_endline "expressions : expression") }
  | expressions VIRG expression { (print_endline "expressions : expressions , expression") }

%%
