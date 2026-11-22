# CS F301 Principles of Programming Languages: Assignment 2

Group: 48

| Member | ID | Owns |
|---|---|---|
| Raghav Gulati | 2023B1A70996H | P1 (`code/48_q1.pl`), `tests/test_q1.pl`, `P1_REPORT.md`, `prompts/P1.md` |
| Prateek Bagri | 2023B1A70716H | `skills/prolog-dev`, P2 (`code/48_q2.pl`), `tests/test_q2.pl`, `prompts/P2.md` |
| Aarika | 2024A7PS0023H | `skills/scheme-dev`, S1 (`code/48_q3.rkt`), `tests/test_q3.rkt`, `prompts/S1.md` |
| Sejal Mittal | 2024A7PS0161H | S2 (`code/48_q4.rkt`), `tests/test_q4.rkt`, `prompts/S2.md` |

## Layout
```
48/
  code/      48_q1.pl 48_q2.pl 48_q3.rkt 48_q4.rkt
  tests/     test_q1.pl test_q2.pl test_q3.rkt test_q4.rkt
  skills/    prolog-dev/SKILL.md scheme-dev/SKILL.md
  prompts/   P1.md P2.md S1.md S2.md
  P1_REPORT.md
```

## Running (from inside `48/`)
Solutions, the way the grader runs them:
```
swipl -q -f code/48_q1.pl -g main -t halt
swipl -q -f code/48_q2.pl -g "all_equations([4,2,5,3],E), print(E), nl" -t halt
racket code/48_q3.rkt
racket code/48_q4.rkt
```
Tests:
```
swipl -q -g run_tests -t halt tests/test_q1.pl
swipl -q -g run_tests -t halt tests/test_q2.pl
racket tests/test_q3.rkt
racket tests/test_q4.rkt
```
Environment: SWI-Prolog 9.x, Racket 8.x.
