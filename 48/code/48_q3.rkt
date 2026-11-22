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

;; ---------- S1.b: preorder and postorder ------------------------------
;; (preorder-acc t acc) = node, then left subtree, then right subtree, then acc.
(define (preorder-acc t acc)
  (if (null? t)
      acc
      (cons (node-value t)
            (preorder-acc (node-left t)
                          (preorder-acc (node-right t) acc)))))

;; (postorder-acc t acc) = left subtree, then right subtree, then node, then acc.
(define (postorder-acc t acc)
  (if (null? t)
      acc
      (postorder-acc (node-left t)
                     (postorder-acc (node-right t)
                                    (cons (node-value t) acc)))))

(define (preorder t) (preorder-acc t '()))
(define (postorder t) (postorder-acc t '()))

(define (print-all-traversals tree)
  (display (inorder tree))
  (newline)
  (display (preorder tree))
  (newline)
  (display (postorder tree))
  (newline))
