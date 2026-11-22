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
