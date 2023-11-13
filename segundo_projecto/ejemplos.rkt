#lang racket

(define (divisible? n x)
  ( zero? (remainder n x)))

(define(divisores x)
  (for ([y (in-range 1 x)])
    (when (divisible? x y)
      (display(append(list y))))))

(define(primo x)
  (= (divisores x) (list 1 x)))

(define (largo x)
  (length x))

(define (primero x)
  (list-ref x 0))