#lang racket

(define (divisible? n x)
  ( zero? (remainder n x)))

(define(divisores x)
  (for/list ([y (in-range 1 (+ 1 x))]
             #:when (divisible? x y))
      y))
    

(define(primo? x)
  (equal? (divisores x) (list 1 x)))

(define (largo x)
  (length x))

(define (primero x)
  (if (null? x)
      ( error "no se permiten listas vacias")
      ( car x)))

(define (primo-hasta x)
  (for/list ([y (in-inclusive-range 1 x)]
             #:when (primo? y))
      y))

(define(pares-hasta x)
  (for/list ([y (in-range 1 (+ 1 x))]
             #:when (divisible? y 2))
      y))

(define (sumar z)
  (if (null? z)
      0
      (+ (car z) (sumar (cdr z)))))

(define (sumar-rango z)
  (let ([ y (for/list ([ x (in-inclusive-range 1 z)]) x)])
    (sumar y)))

(define (sumar-rango-primo z)
  (let ([ y (primo-hasta z)]);([ y (filter (lambda (n) (primo? n)) (for/list ([ x (in-inclusive-range 1 z)])x))])
    (sumar y)))

(define (sublist? x y)
  (andmap (lambda (n) (if (member n y) #t #f)) x)) 