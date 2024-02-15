%Sebastian_Mata_30547594

revertir_lista([], []).%revierte la lista
revertir_lista([X|L], S) :- revertir_lista(L, R), append(R, [X], S).

transponer(_,0,[]):-!.%transpone la matriz
transponer(X,N,M):-
    maplist(nth1(N),X,A),%extrae un elemento en una determinada posicion en todas las filas de la matriz
    revertir_lista(A,S),
    N1 is N-1,
    transponer(X,N1,W),
    append(W,[S],M).
%

rotar([],[]).%inicia el procedimiento de rotar
rotar(L,M):- length(L,N), transponer(L,N,M).


comparar(_,[],_):-!.%compara una variable con todos los elementos de una lista
comparar(N,[M|L],X):- X \== M, comparar(N,L,X).
comparar(0,[X|L],X):- comparar(1,L,X).%el elemento se puede repetir una sola vez, ya que se compara consigo mismo

unique(M):-maplist(comparar(0,M),M).


contar(_, [], 0).%cuenta las veces que aparece un elemento en una lista
contar(X, [X|L], N):- contar(X, L, N1), N is N1 + 1.
contar(X, [Y|L], N):- X \= Y, contar(X, L, N).

balanced(L):- length(L,N), N1 is N/2, contar(0,L,N1).%se asegura que los 0 solo aparezcan la cantidad de veces permitida en cada lista


dos_y_ya(L) :- %verifica que ni 0 ni 1 se repitan mas de 2 veces seguidas
    \+((append(_, [0,0,0|_], L) ; append(_, [1,1,1|_], L))).
%


replace(Var,Z):-var(Var), !, between(0,1,Z).% reemplaza por 0 o 1 cada vez que encuentre una variable
replace(X,X).

rr(L,M):- maplist(replace,L,M).%aplica replace a cada fila de la matriz

%predicado principal, busca una matriz que satisfaga todas las condiciones, con los numeros dados por entrada
cross(2,L,R):-rotar(L,S),rotar(S,R).% la matriz se rota una vez para atender las columnas, luego 3 veces mas para entregarla
cross(N,L,R):-
    maplist(rr,L,M),%reemplaza todas las variables por 0 o 1, siempre que se cumpla que:
    maplist(dos_y_ya,M),%no se repite ningun elemento mas de 2 veces seguidas
    maplist(balanced,M),%tiene igual cantidad de 0s y 1s
    unique(M),%y cada fila es unica,
    rotar(M,S),%rotar para considerar las columnas
    N1 is N+1,
    cross(N1,S,R).
%

tres_son_multitud([]):-!.%inicia el programa y valida la entrada
tres_son_multitud(L):- length(L,N), N>10, write("No se admiten matrices mayores de 10x10").
tres_son_multitud(L):- cross(0,L,R), write(R).