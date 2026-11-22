#lang racket/base
;; Tests for S1. Run from the repository folder that contains code/ and tests/:
;;   racket tests/test_q3.rkt
;; Loads code/*_q3.rkt (any group ID prefix) and checks printed output.
(require rackunit racket/port racket/runtime-path racket/string)

(define-runtime-path code-dir "../code")
(define solution
  (let ([fs (filter (lambda (p) (string-suffix? (path->string p) "_q3.rkt"))
                    (directory-list code-dir))])
    (simplify-path (build-path code-dir (car fs)))))

;; Instantiate the solution module and look up its (unexported) definitions.
(define ns (make-base-namespace))
(parameterize ([current-namespace ns]) (dynamic-require solution #f))
(define mod-ns (parameterize ([current-namespace ns]) (module->namespace solution)))
(define (get name) (eval name mod-ns))

(define print-inorder (get 'print-inorder))
(define print-all-traversals (get 'print-all-traversals))
(define print-height-and-leaves (get 'print-height-and-leaves))

(define (out thunk) (with-output-to-string thunk))

;; Loading the file prints nothing.
(check-equal? (with-output-to-string
                (lambda ()
                  (parameterize ([current-namespace (make-base-namespace)])
                    (dynamic-require solution #f))))
              "")

(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))

;; Examples from the assignment.
(check-equal? (out (lambda () (print-inorder t1))) "(1 2 3 4 5 6 7)\n")
(check-equal? (out (lambda () (print-all-traversals t1)))
              "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n")
(check-equal? (out (lambda () (print-height-and-leaves t1))) "(3 4)\n")
(check-equal? (out (lambda () (print-all-traversals t2))) "(1 2 3)\n(1 2 3)\n(3 2 1)\n")
(check-equal? (out (lambda () (print-height-and-leaves t2))) "(3 1)\n")
(check-equal? (out (lambda () (print-all-traversals t3))) "(b a c)\n(a b c)\n(b c a)\n")
(check-equal? (out (lambda () (print-height-and-leaves t3))) "(2 2)\n")
(check-equal? (out (lambda () (print-inorder '()))) "()\n")
(check-equal? (out (lambda () (print-all-traversals '()))) "()\n()\n()\n")
(check-equal? (out (lambda () (print-height-and-leaves '()))) "(0 0)\n")

;; Extra edge cases.
;; Single node: height 1, one leaf.
(check-equal? (out (lambda () (print-all-traversals '(9 () ())))) "(9)\n(9)\n(9)\n")
(check-equal? (out (lambda () (print-height-and-leaves '(9 () ())))) "(1 1)\n")
;; Left-only chain.
(define t4 '(3 (2 (1 () ()) ()) ()))
(check-equal? (out (lambda () (print-all-traversals t4))) "(1 2 3)\n(3 2 1)\n(1 2 3)\n")
(check-equal? (out (lambda () (print-height-and-leaves t4))) "(3 1)\n")
;; Unbalanced tree with mixed symbols and numbers.
(define t5 '(m (x () (y () ())) (5 (z () ()) ())))
(check-equal? (out (lambda () (print-inorder t5))) "(x y m z 5)\n")
(check-equal? (out (lambda () (print-height-and-leaves t5))) "(3 2)\n")

;; A deep left chain (depth 2000) does not crash.
(define (chain k acc) (if (= k 0) acc (chain (- k 1) (list k acc '()))))
(check-equal? (out (lambda () (print-height-and-leaves (chain 2000 '()))))
              "(2000 1)\n")

(display "S1 tests finished\n")
