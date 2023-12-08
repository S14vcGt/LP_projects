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