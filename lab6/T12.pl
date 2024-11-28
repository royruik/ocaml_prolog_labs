filter_list(List, Conditions, Result) :-
    filter_helper(List, Conditions, [], Result).

filter_helper([], _, Acc, Result) :-
    reverse(Acc, Result).

filter_helper([H|T], Conditions, Acc, Result) :-
    (check_all_conditions(H, Conditions) ->
        filter_helper(T, Conditions, [H|Acc], Result)
    ;
        filter_helper(T, Conditions, Acc, Result)
    ).


check_all_conditions(_, []).
check_all_conditions(Element, [H|T]) :-
    call(H, Element),
    check_all_conditions(Element, T).


greater_than(Range, Element) :-
    number(Element),
    Element > Range.

multiple_of(Divisor, Element) :-
    number(Element),
    Divisor > 0,
    0 is Element mod Divisor.