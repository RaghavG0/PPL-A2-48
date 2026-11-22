% Tests for P2. Run from the repository folder that contains code/ and tests/:
%   swipl -q tests/test_q2.pl -g run_tests -t halt
:- use_module(library(plunit)).

:- prolog_load_context(directory, Dir),
   atomic_list_concat([Dir, '/../code/*_q2.pl'], Pattern),
   expand_file_name(Pattern, [File|_]),
   consult(File).

:- begin_tests(p2).

% Examples from the assignment.
test(all_4253, [true(Es == ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                            "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"])]) :-
    all_equations([4,2,5,3], Es).
test(gen_4253_is_one_of_all) :-
    generate_equation([4,2,5,3], E),
    string(E),
    all_equations([4,2,5,3], Es),
    memberchk(E, Es).
test(gen_234_fails, [fail]) :- generate_equation([2,3,4], _).
test(all_234_empty, [true(Es == [])]) :- all_equations([2,3,4], Es).
test(all_248, [true(Es == ["2*4=8"])]) :- all_equations([2,4,8], Es).

% Edge cases: lengths 0 and 1 fail / give [].
test(gen_empty_fails, [fail]) :- generate_equation([], _).
test(gen_single_fails, [fail]) :- generate_equation([7], _).
test(all_empty, [true(Es == [])]) :- all_equations([], Es).
test(count_single, [true(N == 0)]) :- count_equations([7], N).

% Two numbers: only the trivial equation.
test(two_equal, [true(Es == ["5=5"])]) :- all_equations([5,5], Es).
test(two_unequal, [true(Es == [])]) :- all_equations([5,6], Es).

% Division by zero is never used; 6*0=0 is the only equation here.
test(no_div_by_zero, [true(Es == ["6*0=0"])]) :- all_equations([6,0,0], Es).

% Inexact division is rejected: 7/2 is not allowed.
test(inexact_division, [true(Es == [])]) :- all_equations([7,2,3], Es).

% Every inner division must be exact, not only the last one.
test(inner_division_checked) :-
    all_equations([3,2,2,3], Es),
    \+ memberchk("3/2*2=3", Es),
    memberchk("3=2/2*3", Es).

% Negative intermediate values are allowed.
test(negative_intermediate) :-
    all_equations([2,5,1,4], Es),
    memberchk("2-5=1-4", Es).

% Parenthesisation rule: left-assoc trees vs right-nested trees differ.
test(paren_rule) :-
    all_equations([6,1,2,3], Es),
    memberchk("6=1+2+3", Es),
    memberchk("6=1+(2+3)", Es),
    memberchk("6=1*2*3", Es),
    memberchk("6=1*(2*3)", Es).

% Results are sorted and duplicate-free.
test(sorted_unique) :-
    all_equations([1,2,3,4,5], Es),
    sort(Es, Es).

% count_equations agrees with all_equations.
test(count_matches, [true(N == 7)]) :- count_equations([4,2,5,3], N).

% Every equation string is a string, has no spaces, and exactly one '='.
test(string_format) :-
    all_equations([1,2,3,4], Es),
    Es \== [],
    forall(member(E, Es),
           ( string(E),
             \+ sub_string(E, _, _, _, " "),
             aggregate_all(count, sub_string(E, _, 1, _, "="), 1) )).

:- end_tests(p2).
