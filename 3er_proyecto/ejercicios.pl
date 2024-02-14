%consult('C:/Users/Sebas/OneDrive/Escritorio/LP_projects/3er_proyecto/ejercicios.pl').

mas_grande(elefante,caballo).
mas_grande(caballo,perro).
mas_grande(perro,raton).
mas_grande(raton,pulga).
mas_grande(pulga,bacteria).
mas_grande(bacteria,virus).

muchomasgrande(A,C):-
    mas_grande(A,C).
muchomasgrande(A,C):-
    mas_grande(A,B),
    muchomasgrande(B,C).

sim([],[],_).
sim([X|C1],C2,[X|C3]):-
    not(member(X,C2)),
    sim(C1,C2,C3).
sim(C1,[X|C2],[X|C3]):-
    not(member(X,C1)),
    sim(C1,C2,C3).
sim([X|C1],[X|C2],C3):-
    member(X,C1),
    member(X,C2),
    sim(C1,C2,C3).

dif([],_,[]).
dif([X|L],L2,L3):-
    member(X,L2),
    dif(L,L2,L3).
dif([X|L],L2,[X|L3]):-
    not(member(X,L2)),
    dif(L,L2,L3).

es_anonima(Var):-
var(Var),
\+ \+ Var = _,!.
 
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
rotar(L,M):- length(L,N), transponer(L,N,M).

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