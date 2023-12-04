(define (asignar-valido tam vistas)
  (define grilla (make-vector tam (make-vector tam '())))
  (for ((i (range tam)))
    (for ((j (range tam)))
      (cond
        [(= i 0)
         (if (= (vector-ref (vector-ref vistas 0) i) 1)
             (vector-set! (vector-ref grilla i) j (list tam))
             (vector-set! (vector-ref grilla i) j (range (- tam (vector-ref (vector-ref vistas 0) i) 1))))]

        [(= j 0)
         (if (= (vector-ref (vector-ref vistas 2) i) 1)
             (vector-set! (vector-ref grilla i) j (list tam))
             (vector-set! (vector-ref grilla i) j (range (- tam (vector-ref (vector-ref vistas 2) i) 1))))]

        [(= i (- tam 1))
         (if (= (vector-ref (vector-ref vistas 1) i) 1)
             (vector-set! (vector-ref grilla i) j (list tam))
             (vector-set! (vector-ref grilla i) j (range (- tam (vector-ref (vector-ref vistas 1) i) 1))))]

        [(= j (- tam 1))
         (if (= (vector-ref (vector-ref vistas 3) i) 1)
             (vector-set! (vector-ref grilla i) j (list tam))
             (vector-set! (vector-ref grilla i) j (range (- tam (vector-ref (vector-ref vistas 3) i) 1))))]

        [(and (not (= i 0)) (not (= i (- tam 1))) (not (= j 0)) (not (= j (- tam 1))))
         (vector-set! (vector-ref grilla i) j (range tam))])))

  grilla)

(define (comprobar-fila grilla fil col vistas n)
  (define vistos 1)
  (define mayor (vector-ref (vector-ref grilla fil) 0))
  (for ((i (range n)))
    (when (> (vector-ref (vector-ref grilla fil) i) mayor)
      (set! vistos (+ vistos 1))
      (set! mayor (vector-ref (vector-ref grilla fil) i))))
  (if (not (= vistos (vector-ref (vector-ref vistas 2) fil)))
      #f
      (begin
        (set! vistos 1)
        (for ((i (range (- n 1) -1 -1)))
          (when (> (vector-ref (vector-ref grilla fil) i) mayor)
            (set! vistos (+ vistos 1))
            (set! mayor (vector-ref (vector-ref grilla fil) i))))
        (if (not (= vistos (vector-ref (vector-ref vistas 3) fil)))
            #f
            #t))))

(define (comprobar-columna grilla fil col vistas n)
  (define vistos 1)
  (define mayor (vector-ref (vector-ref grilla 0) col))
  (for ((i (range n)))
    (when (> (vector-ref (vector-ref grilla i) col) mayor)
      (set! vistos (+ vistos 1))
      (set! mayor (vector-ref (vector-ref grilla fil) i))))
  (if (not (= vistos (vector-ref (vector-ref vistas 0) col)))
      #f
      (begin
        (set! vistos 1)
        (for ((i (range (- n 1) -1 -1)))
          (when (> (vector-ref (vector-ref grilla i) col) mayor)
            (set! vistos (+ vistos 1))
            (set! mayor (vector-ref (vector-ref grilla i) col))))
        (if (not (= vistos (vector-ref (vector-ref vistas 1) col)))
            #f
            #t))))

(define (elegible grilla fil col valor n)
  (define result #t)
  (for ((i (range n)))
    (when (or (= valor (vector-ref (vector-ref grilla fil) i)) (= valor (vector-ref (vector-ref grilla i) col)))
      (set! result #f)))
  result)

(define (resolve2 grilla tam fil col vistas)
  (cond
    [(= fil tam) grilla]
    [(= col tam) (resolve grilla tam (+ fil 1) 0 vistas)]
    [else
     (define posibles (vector-ref (vector-ref grilla fil) col))
     (define i 0)
     (define result #f)
     (while (not result)
       (when (< i (length posibles))
         (define valor (list-ref posibles i))
         (when (elegible grilla fil col valor tam)
           (vector-set! (vector-ref grilla fil) col valor)
           (when (= fil (- tam 1))
             (if (and (comprobar-fila grilla fil col vistas tam) (comprobar-columna grilla fil col vistas tam))
                 (set! result (resolve grilla tam fil (+ col 1) vistas))
                 (set! result #f))))
         (set! i (+ i 1))))
     (if result
         #t
         #f)]))