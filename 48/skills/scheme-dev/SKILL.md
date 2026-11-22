---
name: scheme-dev
description: Conventions, allowed built-ins, run/test commands, a self-review checklist and known AI failure modes for writing Racket 8.x (#lang racket/base) code in CS F301 Assignment 2 (S1 tree traversals, S2 nested insert). Use for any Scheme function, test or review in this repository.
---

# scheme-dev

## Language and environment
- Racket 8.x. Every solution file starts with `#lang racket/base`.
- Files: `code/<id>_q3.rkt` (S1), `code/<id>_q4.rkt` (S2).
- The file contains only definitions: no top-level calls and no printing on load.
  The grader appends its own calls to the end of the file.

## Allowed built-ins (nothing else)
`define lambda let let* letrec` named `let`, `if cond else and or not begin quote`,
`cons car cdr list` and c[ad]{2,4}r compositions (`cadr caddr cddr cadddr ...`),
`null? pair? eq? assq assoc`, `+ - * < > <= >= = max`, `display newline`, and `read` (S2 only).

Forbidden: `set!` and relatives, vectors, hash tables, strings, `do`/`for` loops,
`length append reverse map filter member memq list-ref list-tail`, `apply`, `foldl`, `when`, `unless`.
Write your own helper instead (`my-length`, `my-map`, `my-reverse`).

## How the grader runs code
```
racket <id>_q3.rkt      # with the grader's calls appended
racket <id>_q4.rkt      # print-insert-result reads x, lst, n from stdin
```
## How we test
```
racket tests/test_q3.rkt
racket tests/test_q4.rkt
```
(The test files may use rackunit; only the solution files are restricted.)

## Coding conventions
- One unit of work per prompt: one function, one test file or one review.
- Above each function, a comment giving its recursive reading, e.g.
  `;; (inorder-acc t acc) = inorder list of t, followed by acc.`
- Names: `kebab-case`, predicates end in `?`, helpers start with `my-` when replacing a built-in.
- All state is passed through arguments. Prefer tail recursion with an accumulator where natural.
- Tree accessors (`node-value`, `node-left`, `node-right`) instead of bare `car/cadr/caddr`.
- Build lists right-to-left with an accumulator rather than using append.

## Self-review checklist (apply before answering)
1. Is every identifier used in the solution in the allowed list above, or defined in this file?
2. Does `racket file.rkt` alone print nothing?
3. Does every print function end with exactly one `newline`, using `display`?
4. Empty input: does `'()` work (empty tree, empty list, n = 0)?
5. Is recursion safe for 10,000 elements (tail-recursive helpers) and depth-100 nesting?
6. S2: is the length taken from the ORIGINAL list, before inserting x?
7. Is the recursive-reading comment true for the code as written?
8. Do all tests in `tests/` still pass?

## Known AI failure modes in Scheme/Racket
- Quietly using forbidden built-ins (`length`, `append`, `map`, `reverse`, `when`, `else` outside `cond`).
- Using `#lang racket` instead of `#lang racket/base`, or adding `(provide ...)`/`(require ...)`.
- Leaving example calls or `(display ...)` at top level, so the file prints on load.
- `print`/`write` instead of `display` (prints a leading quote or quotes symbols).
- Treating `'()` as an atom instead of an empty list in S2 (it must get x inserted when 0 < n).
- Measuring the length after insertion, or only at the top level.
- Non-tail recursion over 10,000-element lists in helpers.
- Mixing up preorder/postorder, or visiting right before left.
