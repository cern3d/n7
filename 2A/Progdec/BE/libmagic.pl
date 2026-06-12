headtail([L1|L1s], L1, L1s).

% trans(+M, -TM) succeeds if TM is the transpose of matrix M
transpose([[]|_], []):- !.
transpose(M, [C|Cs]):-
    maplist(headtail, M, C, RM),
    transpose(RM, Cs).

tail([_|L1s], L1s).

% diag1(+M, -D) succeeds if D is the diagonal matrix M ((1,1) -> (n,m))
diag1([], []).
diag1([[]], []):- !.
diag1([[M11|_]|Ls], [M11|R]):-
    maplist(tail, Ls, Ms),
    diag1(Ms, R).

% diag2(+M, -D) succeeds if D is the anti-diagonal of matrix M ((1,m) -> (n,1))
diag2(M, D):-
    maplist(reverse, M, RM),
    diag1(RM, D).

% ijth(+I, +J, +M, -MIJ) succeeds if MIJ is contained in cell (I,J) of matrix M
ijth(I, J, M, MIJ):-
    nth(I, M, LI),
    nth(J, LI, MIJ).

printint(X):-
    format("%2d ", [X]).

printrow(L):-
    maplist(printint, L),
    format("\n", []).

printmat(M):-
    maplist(printrow, M).

printperf(B, T0, S):-
    user_time(T),
    TSec is (T - T0) / 1000,
    format("\nsolution with sum %d found in %d bt (%gs)\n", [S, B, TSec]).

% printsol(+M, +B, +T0) prints integer matrix M, the number of backtracks B and
% the time (in s) since user_time(T0) was executed.
printsol(M, B, T0):-
    M = [L1|_],
    sum_list(L1, S),
    printperf(B, T0, S),
    printmat(M).

subsumv(_, _, J1, J2, 0):-
    J1 > J2, !.
subsumv(M, I, J1, J2, MIJ+R):-
    ijth(I, J1, M, MIJ),
    J11 is J1 + 1,
    subsumv(M, I, J11, J2, R).

% subsum(+M, +I1, +I2, +J1, +J2, -S) succeeds if S is the expression of the sum
% of the elements of the sub-matrix ranging vertically in [I1,I2] and
% horizontally in [J1,J2]
subsum(_, I1, I2, _, _, 0):-
    I1 > I2, !.
subsum(M, I1, I2, J1, J2, S + R):-
    subsumv(M, I1, J1, J2, S),
    I11 is I1 + 1,
    subsum(M, I11, I2, J1, J2, R).