#lang racket/base
;; S1: Binary Tree Traversals
;; A tree is '() or (value left right).

;; ---------- Tree accessors -------------------------------------------
(define (node-value t) (car t))
(define (node-left t) (cadr t))
(define (node-right t) (caddr t))

;; ---------- S1.a: inorder --------------------------------------------
;; (inorder-acc t acc) = inorder list of t, followed by acc.
;; Building right-to-left with an accumulator avoids append.
(define (inorder-acc t acc)
  (if (null? t)
      acc
      (inorder-acc (node-left t)
                   (cons (node-value t)
                         (inorder-acc (node-right t) acc)))))

(define (inorder t) (inorder-acc t '()))

(define (print-inorder tree)
  (display (inorder tree))
  (newline))
