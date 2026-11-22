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
