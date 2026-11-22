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

% ---------- Search space ---------------------------------------------
% candidate(S): S is any assignment where each attribute is a
% permutation of its four values (24^3 = 13824 candidates).
candidate([p('Alex',  D1, L1, P1),
           p('Ben',   D2, L2, P2),
           p('Carla', D3, L3, P3),
           p('Dana',  D4, L4, P4)]) :-
    permutation([research, development, design, testing], [D1, D2, D3, D4]),
    permutation([python, java, 'c++', javascript],       [L1, L2, L3, L4]),
    permutation(['AI', web, embedded, data],             [P1, P2, P3, P4]).

% satisfies(Active, S): every clue number in Active holds in S.
satisfies(Active, S) :-
    forall(member(N, Active), clue(N, S)).

% solve(Active, S): S is a candidate satisfying exactly the clues in Active.
solve(Active, S) :-
    candidate(S),
    satisfies(Active, S).

% ---------- P1.a ------------------------------------------------------
main :-
    once(solve([1,2,3,4,5,6,7,8], S)),
    forall(member(p(Name, D, L, P), S),
           format("~w = [~w, ~w, ~w]~n", [Name, D, L, P])).

% ---------- P1.b ------------------------------------------------------
% count_solutions(Active, N): N solutions satisfy the clues in Active.
count_solutions(Active, N) :-
    aggregate_all(count, solve(Active, _), N).

% ---------- P1.c ------------------------------------------------------
% CLUE 9: The friend who works in the testing department prefers the AI project.
clue(9, S) :-
    member(p(_, testing, _, 'AI'), S).
