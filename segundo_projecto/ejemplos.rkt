#lang racket

(define (divisible? n x)
  ( zero? (remainder n x)))

(define(divisores x)
  (for/list ([y (in-range 1 x)]
             #: when (divisible? x y))))
    
 

(define(primo x)
  (= (divisores x) (list 1 x)))

(define (largo x)
  (length x))

(define (primero x)
  (if (null? x)
      ( error "no se permiten listas vacias")
      ( list-ref x 0)))
