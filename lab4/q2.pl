sum_odd_numbers([], 0).

sum_odd_numbers([X|Xs], Sum) :-
    0 =:= X mod 2,
    sum_odd_numbers(Xs, Sum).

sum_odd_numbers([X|Xs], Sum) :-
    0 =\= X mod 2,
    sum_odd_numbers(Xs, RestSum),
    Sum is X + RestSum.
