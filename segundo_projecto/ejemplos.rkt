#lang racket

(define (divisible? n x)
  (= (remainder n x) 0))

(define(divisores x)
  (for ([y x])
    (when (divisible? x y)
      (append(list y)))))
  