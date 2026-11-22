% Tests for P1. Run from the repository folder that contains code/ and tests/:
%   swipl -q tests/test_q1.pl -g run_tests -t halt
:- use_module(library(plunit)).

% Load the solution file whatever the group ID prefix is.
:- prolog_load_context(directory, Dir),
   atomic_list_concat([Dir, '/../code/*_q1.pl'], Pattern),
   expand_file_name(Pattern, [File|_]),
   consult(File).

:- begin_tests(p1).

% Each of clues 1..8 holds in every solution counted for [1..8].
test(each_clue_holds_in_found_solution) :-
    once(solve([1,2,3,4,5,6,7,8], S)),
    forall(between(1, 8, N), clue(N, S)).

% P1.a: main prints four lines in the required format.
test(main_output_format) :-
    with_output_to(string(Out), main),
    split_string(Out, "\n", "", Lines0),
    exclude(==(""), Lines0, Lines),
    length(Lines, 4),
    Lines = [A, B, C, D],
    sub_string(A, 0, _, _, "Alex = ["),
    sub_string(B, 0, _, _, "Ben = ["),
    sub_string(C, 0, _, _, "Carla = ["),
    sub_string(D, 0, _, _, "Dana = [").

% P1.a: what main prints really satisfies clues 1..8 (not hard-coded).
test(main_prints_a_real_solution) :-
    with_output_to(string(Out), main),
    once(solve([1,2,3,4,5,6,7,8], S)),
    forall(member(p(Nm, Dp, Lg, Pj), S),
           ( format(string(L), "~w = [~w, ~w, ~w]", [Nm, Dp, Lg, Pj]),
             sub_string(Out, _, _, _, L) )).

% P1.b: counts.
test(count_no_clues, [true(N == 13824)]) :- count_solutions([], N).
test(count_clues_1_to_8, [true(N == 3)]) :- count_solutions([1,2,3,4,5,6,7,8], N).
test(count_single_clue_3, [true(N == 3456)]) :- count_solutions([3], N).

% P1.c: clue 9 makes the puzzle unique.
test(count_clues_1_to_9, [true(N == 1)]) :- count_solutions([1,2,3,4,5,6,7,8,9], N).

% P1.c: clue 9 is false in the two solutions it removes.
test(clue9_rejects_others, [true(K == 2)]) :-
    aggregate_all(count, (solve([1,2,3,4,5,6,7,8], S), \+ clue(9, S)), K).

% P1.c: clue 9 is written without naming any friend.
test(clue9_mentions_no_name) :-
    clause(clue(9, _), Body),
    term_to_atom(Body, A),
    forall(member(Nm, ['Alex', 'Ben', 'Carla', 'Dana']),
           \+ sub_atom(A, _, _, _, Nm)).

:- end_tests(p1).
