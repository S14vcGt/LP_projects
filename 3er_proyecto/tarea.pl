%Sebastian_Mata_30547594

%1

len([],0):-!.
len([_|Y],S):-len(Y,T), !, S is T + 1.

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
rotar(L,M):- len(L,N), transponer(L,N,M).


%2
palindromos([],[]).
palindromos(M,'Vertical y horizontal'):-revertir_lista(M,M), maplist(revertir_lista,M,M).
palindromos(M,'Vertical'):-revertir_lista(M,M).
palindromos(X,'Horizontal'):-maplist(revertir_lista,X,X).