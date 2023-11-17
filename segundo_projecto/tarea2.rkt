#lang racket

(define (quitar-dup x)
  (list->string(remove-duplicates (string->list(symbol->string x)))))

;(define (romanos x)