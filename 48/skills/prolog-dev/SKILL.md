---
name: prolog-dev
description: Conventions, run/test commands, a self-review checklist and known AI failure modes for writing SWI-Prolog 9.x code in CS F301 Assignment 2 (P1 puzzle, P2 equations). Use for any Prolog predicate, test or review in this repository.
---

# prolog-dev

## Language and environment
- SWI-Prolog 9.x. Files: `code/<id>_q1.pl`, `code/<id>_q2.pl`.
- Allowed libraries only: `lists`, `apply`, `yall`, `aggregate`.
- Forbidden: `assert`/`retract` (any variant), global variables (`b_setval`, `nb_setval`),
  `halt/0` inside the file, any `initialization` directive, building a string and
  parsing it back into a term (P2).
- The file contains only definitions and directives such as `use_module` or `discontiguous`.
  Nothing is printed on load.

## How the grader runs code
```
swipl -q -f <id>_q1.pl -g main -t halt
swipl -q -f <id>_q2.pl -g "all_equations([4,2,5,3],E), print(E), nl" -t halt
```
## How we test
```
swipl -q -g run_tests -t halt tests/test_q1.pl
swipl -q -g run_tests -t halt tests/test_q2.pl
```
Options (`-g`, `-t`) go BEFORE the file name. After the file name they become script arguments
and the toplevel starts.

## Coding conventions
- One unit of work per prompt: one predicate, one test file or one review.
- Every predicate gets a comment with its declarative reading:
  `% foo(X, Y): Y is ... of X.`
- Names: `snake_case` predicates, `CamelCase` variables, `_` for unused variables (no singleton warnings).
- Quoted atoms exactly as the spec gives them: `'Alex'`, `'c++'`, `'AI'`.
- P1 clues: one clause `clue(N, S)` per clue, which succeeds exactly when clue N holds in a fully
  ground solution `S`. Use `\==` for "is not" (S is ground, so this is safe).
- Counting uses `aggregate_all(count, ...)` or `findall/3` + `length/2`. Use `forall/2` for
  "all active clues hold", so one solution is never counted twice.
- P2: carry the value, the canonical string and the top-level precedence together while building
  an expression. Never evaluate by parsing the string.

## Self-review checklist (apply before answering)
1. Does the file load with zero warnings (`swipl -q -f file -t halt` prints nothing)?
2. No forbidden builtin or library? No `halt`, no `initialization`?
3. Does every predicate terminate on every input from the spec, including `[]` and one-element lists?
4. Does failure mean "no answer" rather than an exception (division by zero, unbound arithmetic)?
5. Is output exactly the required format (spacing, commas, newlines, strings vs atoms)?
6. Are counts free of duplicate solutions (choice points left by `member/2` or `;`)?
7. Is the declarative-reading comment true for the code as written?
8. Do all tests in `tests/` still pass?

## Known AI failure modes in Prolog
- Writing `\=` (does not unify) where `\==` or `=\=` is meant, or the reverse.
- Using `is` with unbound right-hand sides → instantiation errors.
- Leaving choice points so `count` double-counts (e.g. `;` inside a clue, or `member` that can match twice).
- Hard-coding the puzzle answer in `main`.
- Integer division: using `/` (may give a float) instead of `//`, and forgetting the
  `B =\= 0` and `A mod B =:= 0` checks.
- Returning atoms or code lists where an SWI string is required (P2 wants `"4*2=5+3"`).
- Inventing library predicates that do not exist, or using libraries outside the allowed list.
- Getting the parenthesis rule wrong for the right operand (same precedence ⇒ parentheses).
- Splitting clauses of one predicate without `:- discontiguous`, which makes SWI print a warning on load.
