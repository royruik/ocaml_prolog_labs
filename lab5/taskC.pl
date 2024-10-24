solve_puzzle(Houses, GreenIndex) :-
    Houses = [_, _, _, _],   

    permutation([red, blue, green, yellow], Houses),  

    next_to(red, blue, Houses),

    nth1(GreenIndex, Houses, green),

    \+ next_to(yellow, green, Houses),
    \+ next_to(green, yellow, Houses),

    GreenIndex \= 2.

next_to(X, Y, [X,Y|_]).
next_to(X, Y, [_|T]) :- next_to(X, Y, T).

