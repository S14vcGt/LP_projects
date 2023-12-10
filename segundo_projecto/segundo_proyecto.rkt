#lang racket
;Sebastian Mata - C.I: 30547594

(define (asignar-valido tam vistas); me entrega una matriz tam x tam con los numeros posibles en cada casilla segun las vistas
  (for*/list ([i(in-range tam)]); una lista de vectores
    (for*/vector ([j(in-range tam)])
      (cond; dependiendo de la vista que corresponda con la casilla actual, se le asignan los numeros probables con la formula (tam - vistas[i][j])+1
        [ (= i 0) (if (= (list-ref(car vistas) j) 1)
                      (list tam)
                      (for*/list ([k(in-range 1 (+ 2 (- tam (list-ref(car vistas) j))))])k))]
        [(= j 0) (if (=(list-ref(list-ref vistas 2) i) 1)
                     (list tam)
                     (for*/list ([k(in-range 1 (+ 2 (- tam (list-ref(list-ref vistas 2)i))))])k))]
        [(= i (sub1 tam)) (if (= (list-ref(list-ref vistas 1)j)1)
                              (list tam)
                              (for*/list ([k(in-range 1 (+ 2 (- tam (list-ref(list-ref vistas 1)j))))])k))]
        [ (= j (sub1 tam)) (if (=(list-ref(list-ref vistas 3) i) 1)
                               (list tam)
                               (for*/list ([k(in-range 1 (+ 2 (- tam (list-ref(list-ref vistas 3)i))))])k))]
        [else (for*/list ([k(in-range 1 (add1 tam))])k)]))))

(define (verificador tam fil-col vistas vertex index); verifica las vistas en los 4 puntos cardinales
  (let loop([vistos 0] [mayor 0] [rr fil-col])
    (cond
      [(null? rr) (= vistos (list-ref (list-ref vistas index) vertex))]; vertex me indica la fila o columna en la que estamos ahora,
      [(list? (car rr)) #t]
      [(> (car rr) mayor) (loop (add1 vistos) (car rr) (cdr rr) )]; e index la lista que contiene las vistas del punto cardinal que queremos verificar
      [else (loop vistos mayor (cdr rr))])))
  
(define (elegible? grilla fil col tam valor); me dice si el valor que se quiere asignar a la casilla no esta repetido, it tells if the value is not repeated
   (let* ([fila (vector->list (list-ref grilla fil))]
         [columna (map (lambda (x) (vector-ref (list-ref grilla x) col)) (range tam))]
         [in-fila? (member valor fila)]
         [in-col? (member valor columna)])
     (not (or in-fila? in-col?)))); si el valor esta en la fila o en la columna actual, false 
        
(define (vigilante grilla fil col tam vistas); me dice si los valores asignados despues de terminar una fila cumplen con las vistas
  (if (or (= fil (sub1 tam)) (= col (sub1 tam)))
      (let* ([fila (vector->list (list-ref grilla fil))]
            [columna (map (lambda (x) (vector-ref (list-ref grilla x) col)) (range tam))]
            [oeste (verificador tam fila vistas fil 2)]
            [norte (verificador tam columna vistas col 0)]
            [este (verificador tam (reverse fila) vistas fil 3)]
            [sur (verificador tam (reverse columna) vistas col 1)])
        (and (and oeste norte) (and este sur)))#t))
              
(define (resolve grilla tam fil col vistas)
  (cond
    [(= fil tam) grilla]
    [(= col tam) (resolve grilla tam (add1 fil) 0 vistas)]; si es la ultima columna, se pasa a la siguiente fila
    [else (let ([posibles (filter (lambda (n) (elegible? grilla fil col tam n)) (vector-ref (list-ref grilla fil)col))]
                [rollback (vector-ref (list-ref grilla fil)col)]); lista de valores posibles
            (if (null? posibles)
                #f
                (let loop ([valores posibles])
                  (if (null? valores)
                      ((lambda (n) (vector-set! (vector-ref (vector-copy (list->vector n)) fil) col rollback) #f) grilla)
                      (let ([grilla-copy ((lambda (n) (vector-set! (vector-ref (vector-copy (list->vector n)) fil) col (car valores)) n) grilla)])
                        (if(vigilante grilla-copy fil col tam vistas)
                           (let ([result (resolve grilla-copy tam fil (add1 col) vistas)])
                             (if result
                                 result
                                 (loop(cdr valores))))
                           (loop(cdr valores))))))))]))
                         
(define (vistas lista)
  (let* ([ tam (length (car lista ))]
         [grilla (asignar-valido tam lista)])
    (display (resolve grilla tam 0 0 lista))))
; in (vistas'((2 1 3 3 4) (3 3 2 2 1) (2 1 3 2 4) (3 5 3 2 1)))
; supossed out ((4 5 1 3 2), (5 4 3 2 1), (1 2 5 4 3), (3 1 2 5 4) (2 3 4 1 5))