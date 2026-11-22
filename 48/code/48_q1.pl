% P1: Department Assignment Puzzle, Reloaded
% Solution = [p('Alex',D,L,P), p('Ben',..), p('Carla',..), p('Dana',..)]

:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(aggregate)).

% clue/2 is extended later by clue 9 (P1.c), so its clauses are split.
:- discontiguous clue/2.

% ---------- Clues ----------------------------------------------------
% Each clue(N, S) is read declaratively: "clue N holds in the fully
% filled-in solution S". Every value is used exactly once, so
% "the friend who ..." is found with member/2 and then checked.

% 1. The friend who prefers AI does not work in research and is not Dana.
clue(1, S) :-
    member(p(Name, Dept, _, 'AI'), S),
    Dept \== research,
    Name \== 'Dana'.

% 2. Alex does not work in development and does not prefer C++.
clue(2, S) :-
    member(p('Alex', Dept, Lang, _), S),
    Dept \== development,
    Lang \== 'c++'.

% 3. The friend in testing likes Python.
clue(3, S) :-
    member(p(_, testing, python, _), S).

% 4. Ben prefers web projects and does not work in testing.
clue(4, S) :-
    member(p('Ben', Dept, _, web), S),
    Dept \== testing.

% 5. The friend whose favorite language is Java works in design.
clue(5, S) :-
    member(p(_, design, java, _), S).

% 6. Carla's project is not embedded and her department is not development.
clue(6, S) :-
    member(p('Carla', Dept, _, Proj), S),
    Proj \== embedded,
    Dept \== development.

% 7. Dana's language is not Java, and she works in research or testing.
clue(7, S) :-
    member(p('Dana', Dept, Lang, _), S),
    Lang \== java,
    memberchk(Dept, [research, testing]).

% 8. The friend who prefers data works in research and does not use JavaScript.
clue(8, S) :-
    member(p(_, research, Lang, data), S),
    Lang \== javascript.
