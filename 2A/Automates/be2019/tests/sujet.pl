requin(jacques).


lapin(bugs).

vegetarien(lapin(X)).

omnivore(X) :-
   carnivore(X),
   vegetarien(X).
    
