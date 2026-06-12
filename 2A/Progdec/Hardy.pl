

dg(Vars):-
    Vars = [N,A,B,C,D],

    fd_domain(Vars,0,1000000),

    A**3 + B**3 #= N,
    C**3 + D**3 #= N,
    A #\= C,
    A #\= D,
    B #\= C,
    B #\= D,
    fd_labeling(Vars, [variable_method(smallest)]).
