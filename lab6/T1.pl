factorial(N, Acc, Result) :-
    number(N),
    integer(N),
    (N < 0 ->
        Result = 'Error: Input must be a non-negative integer.'
    ;
        factorial_helper(N, Acc, Result)
    ).

factorial(N, _, 'Error: Input must be a non-negative integer.') :-
    \+ number(N);
    \+ integer(N).


factorial_helper(0, Acc, Acc).
factorial_helper(N, Acc, Result) :-
    N > 0,
    NewAcc is Acc * N,
    N1 is N - 1,
    factorial_helper(N1, NewAcc, Result).