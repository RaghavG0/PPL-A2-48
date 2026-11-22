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

;; ---------- S2.b: insert-if-short (direct version) -------------------
;; (insert-if-short x lst n): x is put at the front of every list (at every
;; level) whose ORIGINAL length is less than n. Sublists are processed first;
;; the length test uses lst itself, so insertions never affect it.
(define (insert-if-short x lst n)
  (let ((processed (my-map (lambda (e)
                             (if (list-element? e) (insert-if-short x e n) e))
                           lst)))
    (if (< (my-length lst) n)
        (cons x processed)
        processed)))

;; ---------- S2.a: read x, lst, n and print the result ----------------
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))
