#lang racket/base
;; S2: Conditionally Insert into a Nested List

;; ---------- Helpers (built-ins length/map/reverse are not allowed) ----
;; (my-reverse-onto lst acc) = reverse of lst followed by acc. Tail recursive.
(define (my-reverse-onto lst acc)
  (if (null? lst)
      acc
      (my-reverse-onto (cdr lst) (cons (car lst) acc))))

(define (my-reverse lst) (my-reverse-onto lst '()))

;; (my-length lst) = number of top-level elements. Tail recursive.
(define (my-length lst)
  (let loop ((l lst) (n 0))
    (if (null? l)
        n
        (loop (cdr l) (+ n 1)))))

;; (my-map f lst) = list of (f e) for each e, in order. Tail recursive:
;; builds the result reversed, then reverses once (safe for 10,000 items).
(define (my-map f lst)
  (let loop ((l lst) (acc '()))
    (if (null? l)
        (my-reverse acc)
        (loop (cdr l) (cons (f (car l)) acc)))))

;; A list element is itself a list when it is '() or a pair.
(define (list-element? e)
  (or (null? e) (pair? e)))

;; ---------- S2.c: higher-order inserter -------------------------------
;; (make-inserter x len-ok?) returns a function on lists that inserts x at
;; the front of every list (at every level) whose ORIGINAL length satisfies
;; len-ok?. Sublists are processed first, then the length test is applied
;; to the original list, so earlier insertions never affect it.
(define (make-inserter x len-ok?)
  (letrec ((insert
            (lambda (lst)
              (let ((processed (my-map (lambda (e)
                                         (if (list-element? e) (insert e) e))
                                       lst)))
                (if (len-ok? (my-length lst))
                    (cons x processed)
                    processed)))))
    insert))

;; ---------- S2.b (final form, via make-inserter) ---------------------
;; Insert x before every list whose length is less than n.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

;; ---------- S2.a: read x, lst, n and print the result ----------------
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))
