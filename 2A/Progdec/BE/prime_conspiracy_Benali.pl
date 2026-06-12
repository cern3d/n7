/* This simple Prolog program computes the number of occurrences of
   transitions from the last digits of two consecutive prime
   integers. For instance, how many times are there two consecutive
   prime numbers with 9 and 3 as last digits respectively?

   PLEASE WRITE YOUR NAMES HERE:

   - NAME 1: Abdellah Benali
*/

/*
  range(A, B, L) is true if L is a list containing the range of
  integers between A and B (both included).
*/

range(A, B, []):-
  A=<B+1.
range(A, B, [A|L]):-
  K is B-A,
  length(L,K),
  A=<B,
  A1 is A+1,
  range(A1,B,L).
  

/*
  remove_multiple(N, L, R) is true if R is a list obtained from list
  L by removing all multiples of N in L.
*/
remove_multiple(_, [], _).
remove_multiple(N, [L|Ls], [L|R]):-
  L mod N =\= 0, 
  remove_multiple(N,Ls,R).

/*
  sieve(L, R) is true if R is the greatest sublist of L such that for
  every sublist [ H | T ] of L, there are no multiples of H in T.
*/
sieve([], _).
sieve([L|Ls], R):-
  remove_multiple(L,Ls,[L|R]).

/*
  count(D1, D2, L, R) is such that L is a list containing (N1, N2, N3)
  triplets of integers.
  It is true if R contains the same triplets as L, but the triplet
  (D1, D2, N) is such that N is incremented by 1 compared to the triplet
  in L.
*/
count(_, _, _, _).

/*
  make_stat(L1, L2) is true if L1 is a list of integers, L2 is a
  list of triplets (D1, D2, N) such that there are exactly N pairs
  (N1, N2) of consecutive numbers in L such that the last digit of
  N1 (resp. N2) is D1 (resp. D2).
*/
make_stat(_, _).

/*
  display_stat(Stats, Nb) displays the statistics contained in Stats
  on the console. Nb is the number of prime numbers used.
*/
display_stat(Stats) :-
    forall(
        member((D1, D2, N), Stats),
        format("~d -> ~d: ~d~n",
               [D1, D2, N])
    ).

/*
  prime_conspiracy(N) computes all transition statistics for prime
  numbers up to N and prints them on the console.
*/
prime_conspiracy(N) :-
    range(2, N, Nat_list),
    sieve(Nat_list, Prime_list),
    make_stat(Prime_list, Stat_list),
    !,
    sort(Stat_list, Sorted_stat_list),
    display_stat(Sorted_stat_list).
