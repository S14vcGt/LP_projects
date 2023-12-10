#lang racket
;Sebastian Mata - C.I: 30547594

(define (asignar-valido tam vistas); me entrega una matriz tam x tam con los numeros posibles en cada casilla segun las vistas
  (for*/list ([i(in-range tam)]); una lista de vectores
    (for*/vector ([j(in-range tam)])
      (cond; dependiendo de la vista que corresponda con la casilla actual, se le asignan los numeros probables con la formula (tam - vistas[i][j])+1
        [ (= i 0) (if (= (list-ref(car vistas) j) 1)
                      (list tam)
                      (for*/list ([k(in-range 1 (+ 2 (- tam (list-ref(car vistas) j))))])k))];le sumo 2 pq no me entere que existia un range inclusivo
        [(= j 0) (if (=(list-ref(list-ref vistas 2) i) 1)                                    ; hasta que ya tenia la funcion completa
                     (list tam)
                     (for*/list ([k(in-range 1 (+ 2 (- tam (list-ref(list-ref vistas 2)i))))])k))]
        [(= i (sub1 tam)) (if (= (list-ref(list-ref vistas 1)j)1)
                              (list tam)
                              (for*/list ([k(in-range 1 (+ 2 (- tam (list-ref(list-ref vistas 1)j))))])k))]
        [ (= j (sub1 tam)) (if (=(list-ref(list-ref vistas 3) i) 1)
                               (list tam)
                               (for*/list ([k(in-range 1 (+ 2 (- tam (list-ref(list-ref vistas 3)i))))])k))]
        [else (for*/list ([k(in-range 1 (add1 tam))])k)])))); si no estamos en ninguna da las pocisiones que asignan vistas, los posibles son range tam

(define (verificador tam fil-col vistas vertex index); verifica las vistas en los 4 puntos cardinales
  (let loop([vistos 0] [mayor 0] [rr fil-col])
    (cond
      [(null? rr) (= vistos (list-ref (list-ref vistas index) vertex))]; vertex me indica la fila o columna en la que estamos ahora,
      [(list? (car rr)) #t]; si encuantra una lista la columna no esta terminada
      [(> (car rr) mayor) (loop (add1 vistos) (car rr) (cdr rr) )]; e index la lista que contiene las vistas del punto cardinal que queremos verificar
      [else (loop vistos mayor (cdr rr))])))
  
(define (elegible? grilla fil col tam valor); me dice si el valor que se quiere asignar a la casilla no esta repetido
   (let* ([fila (vector->list (list-ref grilla fil))]
         [columna (map (lambda (x) (vector-ref (list-ref grilla x) col)) (range tam))]
         [in-fila? (member valor fila)]
         [in-col? (member valor columna)])
     (not (or in-fila? in-col?)))) 
        
(define (vigilante grilla fil col tam vistas); me dice si los valores asignados en una fila o columna cumplen con las correspondientes vistas
  (if (or (= fil (sub1 tam)) (= col (sub1 tam)))
      (let* ([fila (vector->list (list-ref grilla fil))]
            [columna (map (lambda (x) (vector-ref (list-ref grilla x) col)) (range tam))]
            [oeste (verificador tam fila vistas fil 2)]
            [norte (verificador tam columna vistas col 0)]
            [este (verificador tam (reverse fila) vistas fil 3)];revierto la fila para evaluarla
            [sur (verificador tam (reverse columna) vistas col 1)])
        (and (and oeste norte) (and este sur)))#t));si no estamos al final de una fila o columna, continua la ejecucion
              
(define (resolve grilla tam fil col vistas); resuelve el puzzle
  (cond
    [(= fil tam) grilla]
    [(= col tam) (resolve grilla tam (add1 fil) 0 vistas)]; si es la ultima columna, se pasa a la siguiente fila
    [else (let ([posibles (filter (lambda (n) (elegible? grilla fil col tam n)) (vector-ref (list-ref grilla fil)col))]; genera una lista nueva con solo los elegibles de la lista de los posibles par esa casilla
                [rollback (vector-ref (list-ref grilla fil)col)]); lista de posibles, usada para hacer el rollback sin perder los posibles
            (if (null? posibles)
                #f
                (let loop ([valores posibles])
                  (if (null? valores); si ya no hay mas valores validos, se retrocede.
                      ((lambda (n) (vector-set! (vector-ref (vector-copy (list->vector n)) fil) col rollback) #f) grilla); se hace aqui el rollback porque esta dentro del loop
                      (let ([grilla-copy ((lambda (n) (vector-set! (vector-ref (vector-copy (list->vector n)) fil) col (car valores)) n) grilla)]); sobreescribo la grilla con el valor 
                        (if(vigilante grilla-copy fil col tam vistas); si las vistas son satisfechas
                           (let ([result (resolve grilla-copy tam fil (add1 col) vistas)]);paso a la siguiente columna recursivamente
                             (if result; si tuvo exito la grilla esta completa y se devuelve
                                 result
                                 (loop(cdr valores)))); si no se cambia el valor y se intenta de nuevo
                           (loop(cdr valores))))))))])); si no se satisfacen las vistas, se trata con otro valor
                         
(define (vistas lista)
  (let* ([ tam (length (car lista ))];definido el tamano de la cuadricula
         [grilla (asignar-valido tam lista)]);creo la grilla
    (display (resolve grilla tam 0 0 lista))))