%consult('C:/Users/Sebas/OneDrive/Escritorio/LP_projects/3er_proyecto/3_son_multitud.pl').
%Sebastian_Mata_30547594

matriz([[0,_,_,_,_,_], [_,_,1,0,_,_], [_,_,1,1,_,_], [_,_,_,0,1,_], 
[_,1,_,1,1,_], [_,_,_,_,_,_]]).

es_anonima(Var):-
var(Var),
\+ \+ Var = _,!.

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

revertir_lista([], []).
revertir_lista([X|Resto], Revertida) :-
    revertir_lista(Resto, RestoRevertido),
    append(RestoRevertido, [X], Revertida).
%

da_n_ultim(L,N,S):-
revertir_lista(L,T),
da_n_pri(T,N,R),
revertir_lista(R,S).

recorrer(_,0,[]):-!.
recorrer([X|L],N,R):-
    

3_son_multitud([],[]):-!.
3_son_multitud(L,R):-
len(L,N),
recorrer(L,N,R).
