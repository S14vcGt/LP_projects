#lang racket

(define (divisible? n x)
  ( zero? (remainder n x)))

(define(divisores x)
  (for/list ([y (in-range 1 (+ 1 x))]
             #:when (divisible? x y))
      y))
    

(define(primo x)
  (equal? (divisores x) (list 1 x)))

(define (largo x)
  (length x))

(define (primero x)
  (if (null? x)
      ( error "no se permiten listas vacias")
      ( list-ref x 0)))

(let*([vistos 1]
                        [mayor (car fila)])
                    (for ([i (in-range tam)])
                      (if (> (list-ref fila i) mayor )
                          ((set! vistos (add1 vistos)) (set! mayor (list-ref fila i))) #t))
                    (if (not(= vistos (list-ref (list-ref vistas 2) fil)))
                        #f
                        #t))

(define (este-sur tam fil-col vistas vertex index)
  (let*([vistos 1]
        [mayor (car fil-col)])
          (for ([i (in-inclusive-range (sub1 tam) 0 -1)])
                (if (> (list-ref fil-col i) mayor )
                     ((set! vistos (add1 vistos)) (set! mayor (list-ref fil-col i)))#t))
          (if (not(= vistos (list-ref (list-ref vistas index) vertex)))
                        #f
                        #t)))
  