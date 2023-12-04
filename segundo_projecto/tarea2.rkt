#lang racket

;Sebastian Mata C.I: 30547594

;Problema 1
(define (quitar-dup x)
  (if (symbol? x)
      (list->string(remove-duplicates (string->list(symbol->string x)))) ; convierto la entrada en tipo string, luego a lista y elimino los duplicados para convertirlo de nuevo en string
      (if (string? x)
          (list->string(remove-duplicates (string->list x)))
          (error "entrada invalida"))));si ya es string, solo paso a lista y elimino los duplicados para convertirlo de nuevo en string

;Problema 2
(define(arabic char);devuelve el valor correspondiente a cada numero romano
  (match char [#\I 1][#\V 5][#\X 10][#\L 50][#\C 100][#\D 500][#\M 1000]))

(define (eater ch x i); recursivamente suma todos los caracteres iguales desde el punto donde se concluyo que son para restarse, hacia atras 
  (if (equal? ch (string-ref x i))
      (+ (arabic(string-ref x i )) (eater ch x (sub1 i)))
      0))

(define (roman x i); se mueve a travez del string de entrada recursivamente
  (if ( = i (string-length x)); si llegamos al final de la cadena
      0;devuelve 0
      (if ( = i 0); sino, si es la primera llamada
          (+ (arabic(string-ref x i )) (roman x (add1 i))); devolver la suma del valor del caracter actual mas el valor del caracter siguiente
          (if (< (arabic(string-ref x (sub1 i ))) (arabic(string-ref x i)));sino, si el caracter anterior es menor al actual
              (+ (- (arabic(string-ref x i ))  (* (eater (string-ref x (sub1 i)) x (sub1 i)) 2)) (roman x (add1 i)));entonces se devuelve la suma de la resta del valor actual menos el doble del total menor anterior mas el valor del siguiente caracter
              (+ (arabic(string-ref x i )) (roman x (add1 i)))))));sino, devolver la suma del valor del caracter actual mas el valor del caracter siguiente

(define (romano->arabico  x); toma la entrada y se asegura que sea valida
  (if (symbol? x)(roman (symbol->string x) 0)(if (string? x)(roman x 0)(error "entrada invalida"))))
          
;Problema 3
(define (comevocales x)
  (for/list ([p (in-list x)]);itero sobre la lista, poniendo el resultado dentro de otra lista
    (list->string(for/list([ch (in-string p)]; itero sobre la cadena y el resultado va a una lista
                           #:unless (or (equal? ch #\a) (equal? ch #\e) (equal? ch #\i) (equal? ch #\o) (equal? ch #\u)));si hay una vocal la ignoro
                   ch))));si no es vocal agrego el caracter en la lista que despues convierto en cadena