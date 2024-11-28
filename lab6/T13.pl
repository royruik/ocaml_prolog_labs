second_max(List, 'Error: List must contain at least two distinct elements.') :-
    length(List, Len),
    Len < 2.

second_max(List, 'Error: List must contain at least two distinct elements.') :-
    list_to_set(List, Set),
    length(Set, 1).

second_max(List, SecondMax) :-
    list_to_set(List, Set),
    length(Set, Len),
    Len >= 2,
    find_second_max(List, SecondMax).

find_second_max(List, SecondMax) :-
    sort(List, Sorted),
    reverse(Sorted, [_|T]),
    T = [SecondMax|_].