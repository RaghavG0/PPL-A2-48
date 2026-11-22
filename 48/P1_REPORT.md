# P1 Report: Department Assignment Puzzle, Reloaded

## P1.b: number of solutions for clues 1 to 8

```
?- count_solutions([1,2,3,4,5,6,7,8], N).
N = 3.
```

For comparison, `count_solutions([], N)` gives N = 13824 (= 24 × 24 × 24 candidates,
because each attribute is a permutation of four values).

The three solutions are:

| # | Alex | Ben | Carla | Dana |
|---|------|-----|-------|------|
| 1 | design, java, AI | development, javascript, web | research, c++, data | testing, python, embedded |
| 2 | design, java, embedded | development, javascript, web | testing, python, AI | research, c++, data |
| 3 | testing, python, embedded | development, javascript, web | design, java, AI | research, c++, data |

### What this tells us about the puzzle

- **The puzzle is under-determined.** Clues 1 to 8 do not have a unique answer, so as written it is not a well-posed logic puzzle: a solver can only say "one of three".
- Some facts are fixed by the clues: Ben is always development, javascript, web. The research person always uses c++ and prefers data. The testing person always uses python, and the design person always uses java.
- Solutions 1 and 3 contain exactly the same four (department, language, project) triples. Only the names attached to two of them differ: Alex and Carla swap rows. Because a ninth clue may refer to friends **only through attribute values, never by name**, no such clue can keep one of solutions 1 and 3 and reject the other. The only solution that a name-free clue can single out is **solution 2**.

## P1.c: the repair

```prolog
% CLUE 9: The friend who works in the testing department prefers the AI project.
clue(9, S) :-
    member(p(_, testing, _, 'AI'), S).
```

- Solution 2: the testing friend (Carla) prefers AI → clue 9 is **true**.
- Solution 1: the testing friend (Dana) prefers embedded → **false**.
- Solution 3: the testing friend (Alex) prefers embedded → **false**.

```
?- count_solutions([1,2,3,4,5,6,7,8,9], N).
N = 1.
```

The unique solution is
`[p('Alex',design,java,embedded), p('Ben',development,javascript,web), p('Carla',testing,python,'AI'), p('Dana',research,'c++',data)]`.

Note: `main/0` (P1.a) is required to print *a* solution of clues 1 to 8 and uses only those clues,
so it prints the first one found (solution 1). That is valid for P1.a.
