% P2: Form a Valid Arithmetic Equation

:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(aggregate)).

% ---------- Operators -------------------------------------------------
% op_prec(Op, Prec): precedence of each binary operator.
% A single number gets precedence 3, so it is never parenthesised.
op_prec('+', 1).
op_prec('-', 1).
op_prec('*', 2).
op_prec('/', 2).

% apply_op(Op, A, B, V): V is A Op B. Division succeeds only when the
% divisor is non-zero and the division is exact.
apply_op('+', A, B, V) :- V is A + B.
apply_op('-', A, B, V) :- V is A - B.
apply_op('*', A, B, V) :- V is A * B.
apply_op('/', A, B, V) :- B =\= 0, A mod B =:= 0, V is A // B.

% ---------- Canonical printing ----------------------------------------
% wrap_left(ChildPrec, ParentPrec, S, S1): a left operand is wrapped only
% when its top operator binds strictly looser than the parent.
wrap_left(CP, PP, S, S1) :-
    (   CP < PP -> format(string(S1), "(~w)", [S]) ; S1 = S ).

% wrap_right(ChildPrec, ParentPrec, S, S1): a right operand is wrapped when
% its top operator binds the same or looser (operators are left-assoc).
wrap_right(CP, PP, S, S1) :-
    (   CP =< PP -> format(string(S1), "(~w)", [S]) ; S1 = S ).

% ---------- Expressions -----------------------------------------------
% split(Nums, Left, Right): Nums = Left ++ Right, both non-empty.
split(Nums, [X|Ls], [Y|Rs]) :-
    append([X|Ls], [Y|Rs], Nums).

% expr(Nums, Value, String, Prec): some expression tree over Nums (all
% numbers, in order) has integer Value, canonical String and top-level
% precedence Prec. Values are computed from the tree, never by parsing.
expr([N], N, S, 3) :-
    number_string(N, S).
expr(Nums, V, S, P) :-
    split(Nums, Ls, Rs),
    findall(VL-SL-PL, expr(Ls, VL, SL, PL), LeftEs),
    findall(VR-SR-PR, expr(Rs, VR, SR, PR), RightEs),
    member(VL-SL-PL, LeftEs),
    member(VR-SR-PR, RightEs),
    op_prec(Op, P),
    apply_op(Op, VL, VR, V),
    wrap_left(PL, P, SL, SL1),
    wrap_right(PR, P, SR, SR1),
    format(string(S), "~w~w~w", [SL1, Op, SR1]).

% equation(List, Eq): Eq is "L=R" for some split of List where both
% sides have the same value.
equation(List, Eq) :-
    split(List, Ls, Rs),
    findall(V-S, expr(Ls, V, S, _), LeftEs),
    findall(V-S, expr(Rs, V, S, _), RightEs),
    member(VL-SL, LeftEs),
    member(VR-SR, RightEs),
    VL =:= VR,
    format(string(Eq), "~w=~w", [SL, SR]).

% ---------- P2.a ------------------------------------------------------
% generate_equation(List, Eq): one valid equation; fails if none exists
% (including lists of length 0 or 1, where split/3 has no answer).
generate_equation(List, Eq) :-
    once(equation(List, Eq)).
