%consult('C:/Users/Sebas/OneDrive/Escritorio/LP_projects/3er_proyecto/3_son_multitud.pl').
%Sebastian_Mata_30547594

matriz([[0,_,_,_,_,_], [_,_,1,0,_,_], [_,_,1,1,_,_], [_,_,_,0,1,_], [_,1,_,1,1,_], [_,_,_,_,_,_]]).

marta([[0,1,0,1,0,1], [1,0,1,0,1,0], [0,0,1,1,0,1], [1,1,0,0,1,0], [0,1,0,1,1,0], [1,0,1,0,0,1]]).

revertir_lista([], []).
revertir_lista([X|L], S) :- revertir_lista(L, R), append(R, [X], S).

transponer(_,0,[]):-!.
transponer(X,N,M):-
    maplist(nth1(N),X,A),
    revertir_lista(A,S),
    N1 is N-1,
    transponer(X,N1,W),
    append(W,[S],M).
%

rotar([],[]).
rotar(L,M):- length(L,N), transponer(L,N,M).


comparar(_,[],_):-!.
comparar(N,[M|L],X):- X \== M, comparar(N,L,X).
comparar(0,[M|L],X):- X == M , comparar(1,L,X).

unique(M):-maplist(comparar(0,M),M).


contar(_, [], 0).
contar(X, [X|L], N):- contar(X, L, N1), N is N1 + 1.
contar(X, [Y|L], N):- X \= Y, contar(X, L, N).

balanced(L):- length(L,N), N1 is N/2, contar(0,L,N1).


no_rep(N, X, L) :- 
    append(_, [X,X,X|M], L), 
    length([X,X,X|M], N).
%
dos_y_ya(L):- \+((member(X,L), no_rep(N,X,L), N > 2)).


replace(Var,Z):-var(Var), !, between(0,1,Z).
replace(X,X).

rr(L,M):- maplist(replace,L,M).

cross(2,L,R):-rotar(L,S),rotar(S,R).
cross(N,L,R):-
    maplist(rr,L,M),
    unique(M),
    maplist(balanced,M),
    maplist(dos_y_ya,M),
    rotar(M,S),
    N1 is N+1,
    cross(N1,S,R).
%

tres_son_multitud([],[]):-!.
tres_son_multitud(L,R):- cross(0,L,R).