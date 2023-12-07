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
  (let*([vistos 1]
        [mayor (car fil-col)])
          (for ([i (in-range tam)])
                (when (> (list-ref fil-col i) mayor ); aqui retorna void cuando no se cumple
                     ((set! vistos (add1 vistos))
                      (set! mayor (list-ref fil-col i))))
          (if (not(= vistos (list-ref (list-ref vistas index) vertex))); vertex me indica la fila o columna en la que estamos ahora, e index la lista que contiene las vistas del punto cardinal que queremos verificar
                        #f
                        #t))))

(define (elegible grilla fil col tam vistas valor); me dice si el valor que se quiere asignar a la casilla no esta repetido
   (let* ([fila (vector->list (list-ref grilla fil))]
         [columna (map (lambda (x) (vector-ref (list-ref grilla x) col)) (range tam))]
         [in-fila? (member valor fila)]
         [in-col? (member valor columna)])
    (if (or in-fila? in-col?); si el valor esta en la fila o en la columna actual, false 
        #f
        #t)))

(define (vigilante grilla fil col tam vistas); me dice si los valores asignados despues de terminar una fila cumplen con las vistas
   (let* ([fila (vector->list (list-ref grilla fil))]
         [columna (map (lambda (x) (vector-ref (list-ref grilla x) col)) (range tam))])
    (let([oeste (verificador tam fila vistas fil 2)]
                 [norte (verificador tam columna vistas col 0)]
                 [este (verificador tam (reverse fila) vistas fil 3)]; revierto la fila o columna para evaluar en la otra direccion
                 [sur (verificador tam (reverse columna) vistas col 1)])
              (if (and (and oeste norte) (and este sur))
                  #t
                  #f)))); si todas las vistas corresponde, true sino false
              
(define (resolve grilla tam fil col vistas)
  (cond
    [(= fil tam) (display(for*/list ([i (in-range tam)]) ;si ya llega al final, se imprime la grilla
                          (vector->list (list-ref grilla i))))]
    [(= col (sub1 tam)) (resolve grilla tam (add1 fil) 0 vistas)]; si es la ultima columna, se pasa a la siguiente fila
    [else ( let*([posibles (vector-ref (list-ref grilla fil)col)]; la variable con la lista de los posibles valores
                 [result #f]; el resultado
                 [valor 0]);el valor a probar
             (for* ([ i (in-range (length posibles))])
               (if ( equal? result #f)
                   ((set! valor (list-ref posibles i))
                    (define aver (elegible grilla fil col tam vistas valor))
                    (when (equal? aver #t)
                      (vector-set! (list-ref grilla fil) col valor)
                      (if (= (- tam 1) col)
                        (unless (vigilante grilla fil col tam vistas)
                          (vector-set! (list-ref grilla fil) col posibles)
                          #f)
                        (set! result (resolve grilla tam fil (add1 col) vistas))))
                   ) result))
             (vector-set! (list-ref grilla fil) col posibles) #f)]))

(define (vistas lista)
  (let* ([grilla (asignar-valido (length (car lista )) lista)])
    (resolve grilla (length lista) 0 0 lista))); debo convertirlos en listas antes de la salida