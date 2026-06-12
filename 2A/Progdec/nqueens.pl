

/*Question 1 */ 

/*  Sur un échiquier N*N, on va forcément placer une reine par ligne
   (sinon deux reines s'attaquent).
   La ligne de la reine est donc déjà connue par sa position dans la liste,
   il suffit donc de stocker la colonne de la reine.
   Exemple : [3, 1, ...]
   - La reine 1 est en ligne 1, colonne 3
   - La reine 2 est en ligne 2, colonne 1
*/

/* Question 2 :*/
no_attack(R, [], _).          
no_attack(R, [H|T], DISTANCE) :-
    R =\= H,                             
    abs(R - H) =\= DISTANCE,     /*Deux reines sont en diagonales si l'ecart de ligne est egale à l'écart de colonne*/       
    DISTANCE1 is DISTANCE + 1,
    no_attack(R, T, DISTANCE1).

/* cas de tests: 
-no_attack(5, [3, 1, 6], 1).  Renvoie true
-no_attack(3, [3, 1, 6], 1). Renvoie no (même colonne)
- no_attack(5, [3, 1], 1). Renvoie no (même diagonale)

*/

/*Question 3*/

correct_config_eight([]).
correct_config_eight([H|T]) :-
    correct_config_eight(T),
    member(H, [1,2,3,4,5,6,7,8]),  
    no_attack(H, T, 1).

/* cas de tests:
- correct_config_eight([3]). Renvoie true (une reine seule n'attaque personne)
- correct_config_eight([1, 1]). Renvoie no (deux reines sur la même colonnne)
- correct_config_eight([1, 2]). Renvoie no (deux reines sur la même diagonale)
- correct_config_eight([4, 2, 7, 3, 6, 8, 5, 1]). Renvoie true
*/

/* correct_config_eight(X) ne permet pas de résoudre le problème
   car elle ne contraint pas la longueur de la liste.
   Prolog retourne X = [] comme première solution puis [1], [2] etc... 
   Il faut donc imposer que la liste soit de taille 8 pour avoir une bonne configuration
*/

/* Question 4 */
solution_eight(L) :-
    length(L,8),
    correct_config_eight(L).


/* Question 5 */

/*  En testant avec findall(L, solution_eight(L), Ls), length(Ls, N) on trouve 
   exactement 92 solutions ce qui confirme les résultats prouvés.
   D'après wikipedia (Problème des huit dames), "le problème a 92 solutions distinctes 
   ou seulement 12 en tenant compte des rotations et réflexions 
   (par l'intermédiaire du lemme de Burnside)."
   On a donc des solutions en double qu'il faut éliminer. 
   solution : parmi deux solutions symétriques, on garde toujours celle qui commence par le plus petit numéro.
   */

solution_eight_ordered(L) :-
    solution_eight(L),
    L = [FIRST | _],
    last(L, LAST),
    FIRST < LAST.

/* En testant avec findall(L, solution_eight_ordered(L), Ls), length(Ls, N)
   on trouve bien 46 solutions (92/2). 
   on a éliminé les symétries.*/




/* Question 6*/

correct_config_n([], _).
correct_config_n([H|T], N) :-
    correct_config_n(T, N),
    between(1, N, H),       
    no_attack(H, T, 1).

solution_n(L, N) :-
    length(L, N),
    correct_config_n(L, N).


/* Cas de tests:
- solution_n(L, 8).   Renvoie les 92 solutions
- solution_n(L, 4).   REnvoie 2 solutions 
*/