#lang racket/base
;; Tests for S2. Run from the repository folder that contains code/ and tests/:
;;   racket tests/test_q4.rkt
;; Loads code/*_q4.rkt (any group ID prefix) and checks results and output.
(require rackunit racket/port racket/runtime-path racket/string)

(define-runtime-path code-dir "../code")
(define solution
  (let ([fs (filter (lambda (p) (string-suffix? (path->string p) "_q4.rkt"))
                    (directory-list code-dir))])
    (simplify-path (build-path code-dir (car fs)))))

(define ns (make-base-namespace))
(parameterize ([current-namespace ns]) (dynamic-require solution #f))
(define mod-ns (parameterize ([current-namespace ns]) (module->namespace solution)))
(define (get name) (eval name mod-ns))

(define print-insert-result (get 'print-insert-result))
(define insert-if-short (get 'insert-if-short))
(define make-inserter (get 'make-inserter))
(define my-length (get 'my-length))
(define my-map (get 'my-map))

;; Run print-insert-result with the given standard input.
(define (run input)
  (with-output-to-string
    (lambda () (with-input-from-string input print-insert-result))))

;; Loading the file prints nothing.
(check-equal? (with-output-to-string
                (lambda ()
                  (parameterize ([current-namespace (make-base-namespace)])
                    (dynamic-require solution #f))))
              "")

;; Examples from the assignment (stdin -> stdout).
(check-equal? (run "42 ((1 2) (3 4 5) (6) ()) 3") "((42 1 2) (3 4 5) (42 6) (42))\n")
(check-equal? (run "0 (((1) 2) (3) ((4 5 6) ())) 3") "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))\n")
(check-equal? (run "7 () 3") "(7)\n")
(check-equal? (run "7 () 0") "()\n")

;; S2.b helpers.
(check-equal? (my-length '()) 0)
(check-equal? (my-length '(a (b c) ())) 3)
(check-equal? (my-map (lambda (v) (* v v)) '(1 2 3)) '(1 4 9))
(check-equal? (my-map (lambda (v) v) '()) '())

;; Length is measured on the original list (before insertion):
;; (1 2) has length 2 < 3, so it gets x even though it then has length 3.
(check-equal? (insert-if-short 'x '((1 2)) 3) '(x (x 1 2)))
;; n = 0: nothing is ever inserted.
(check-equal? (insert-if-short 'x '((1) (() ())) 0) '((1) (() ())))
;; Top-level list is treated like any other list.
(check-equal? (insert-if-short 'x '(1 2 3) 4) '(x 1 2 3))
(check-equal? (insert-if-short 'x '(1 2 3) 3) '(1 2 3))
;; Nested empty lists. The top level has length 2, which is not < 2.
(check-equal? (insert-if-short 'q '(() (())) 2) '((q) (q (q))))
(check-equal? (insert-if-short 'q '(() (())) 3) '(q (q) (q (q))))

;; S2.c: make-inserter with a different predicate.
(check-equal? ((make-inserter 'e (lambda (len) (= len 2))) '((1 2) (3) (4 5)))
              '((e 1 2) (3) (e 4 5)))
(check-equal? ((make-inserter 'z (lambda (len) #t)) '(())) '(z (z)))

;; Hidden-test scale: 10,000 elements and nesting depth 100.
(define (iota k) (let loop ([i k] [acc '()]) (if (= i 0) acc (loop (- i 1) (cons i acc)))))
(define big (iota 10000))
(define big-result (insert-if-short 'z big 20000))
(check-equal? (car big-result) 'z)
(check-equal? (my-length big-result) 10001)
(check-equal? (cadr big-result) 1)

(define (nest d) (if (= d 0) '() (list 1 (nest (- d 1)))))
;; depth-of follows the last element down while it is a non-empty list.
(define (last-elem l) (if (null? (cdr l)) (car l) (last-elem (cdr l))))
(define (depth-of l)
  (if (pair? (last-elem l)) (+ 1 (depth-of (last-elem l))) 1))
(define deep-result (insert-if-short 'z (nest 100) 3))
(check-equal? (car deep-result) 'z)
;; 100 levels of (z 1 ...) plus the innermost () which became (z).
(check-equal? (depth-of deep-result) 101)

(display "S2 tests finished\n")
