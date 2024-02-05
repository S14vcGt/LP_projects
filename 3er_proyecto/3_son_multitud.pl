%consult('C:/Users/Sebas/OneDrive/Escritorio/LP_projects/3er_proyecto/3_son_multitud.pl').
%Sebastian_Mata_30547594

matriz([[0,_,_,_,_,_], [_,_,1,0,_,_], [_,_,1,1,_,_], [_,_,_,0,1,_], 
[_,1,_,1,1,_], [_,_,_,_,_,_]]).

es_anonima(Var):-
var(Var),
\+ \+ Var = _,!.
 

len([],0):-!.
len([_|Y],S):-len(Y,T),!, S is T + 1.

lista([]):-!.
lista([_|Y]):-lista(Y).

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

da_n_pri(_,0,[]):-!.
da_n_pri([],_,[]):-!.
da_n_pri([X|_],1,[1]):- es_anonima(X).
da_n_pri([X|_],1,[X]):-!.
da_n_pri([X|M],N,S):-
N1 is N -1,
es_anonima(X),
da_n_pri(M,N1,T),
append(T,[1],S).
da_n_pri([X|M],N,S):-
N1 is N -1,
da_n_pri(M,N1,T),
append(T,[X],S).

da_n_ultim(L,N,S):-
revertir_lista(L,T),
da_n_pri(T,N,R),
revertir_lista(R,S).

comparar(_,[],_):-!.
comparar(N,[M|L],X):- X \== M, comparar(N,L,X).
comparar(0,[M|L],X):- X == M , comparar(1,L,X).
unique(M):-maplist(comparar(0,M),M).


replace(Z,Var):-var(Var), !, Z in 0..1.
replace(X,X).
rr(L,M):-maplist(replace,L,M).

cross(2,L,R):-rotar(L,S),rotar(S,R).
cross(N,L,R):-
rr(L,M),
unique(M),
balanced(M),
dos_y_ya(M),
rotar(M,S),
N1 is N+1,
cross(N1,S,R).


tres_son_multitud([],[]):-!.
tres_son_multitud(L,R):-
maplist(cross(0,L),L,R).
