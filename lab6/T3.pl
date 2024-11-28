is_prime(2).
is_prime(N) :-
    N > 2,
    \+ has_factor(N, 2).

has_factor(N, F) :-
    F * F =< N,
    (N mod F =:= 0;
    F2 is F + 1,
    has_factor(N, F2)).


reverse_digits(N, R) :-
    number_chars(N, Chars),
    reverse(Chars, RevChars),
    number_chars(R, RevChars).


filter_and_transform(List, Result) :-
    filter_and_transform(List, [], 0, Result).


filter_and_transform(_, Acc, 5, Result) :- !, 
    reverse(Acc, Result).
filter_and_transform([], Acc, _, Result) :- 
    reverse(Acc, Result).

filter_and_transform([H|T], Acc, Count, Result) :-
    (is_prime(H) ->
        reverse_digits(H, Reversed),
        Count1 is Count + 1,
        filter_and_transform(T, [Reversed|Acc], Count1, Result)
    ;
        filter_and_transform(T, Acc, Count, Result)
    ).