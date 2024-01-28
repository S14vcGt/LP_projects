%consult('C:/Users/Sebas/OneDrive/Escritorio/LP_projects/3er_proyecto/3_son_multitud.pl').
%Sebastian_Mata_30547594

es_anonima(Var):-
var(Var),
\+ \+ Var = _,
!.

concatenar([],L,L):-!.
concatenar([X|M],L,[X|Z]):-concatenar(M,L,Z).

len([],0):-!.
len([X|Y],S):-len(Y,T),!, S is T + 1.

lista([]):-!.
lista([X|Y]):-lista(Y).

da_n_pri(L,0,[]):-!.
da_n_pri([],N,[]):-!.
da_n_pri([X|M],1,[1]):- es_anonima(X).
da_n_pri([X|M],1,[X]):-!.
da_n_pri([X|M],N,S):-
N1 is N -1,
es_anonima(X),
da_n_pri(M,N1,T),
concatenar([1],T,S).
da_n_pri([X|M],N,S):-
N1 is N -1,
da_n_pri(M,N1,T),
concatenar([X],T,S).

invertir_tot([],[]):-!.
invertir_tot([X|M],S):-
lista(X),
invertir_tot(X,P),
invertir_tot(M,T),
concatenar(T,[P],S).
invertir_tot([X|M],S):-invertir_tot(M,T),concatenar(T,[X],S),!.


desde_x([Y|M],X,S):-X=\=Y,desde_x(M,X,S),!.
desde_x([X,Y|M],X,[Y|M]):-X=\=Y,!.
desde_x([Y|M],X,S):-desde_x(M,X,S),!.



