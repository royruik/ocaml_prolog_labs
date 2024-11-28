:- dynamic mine/2.
:- dynamic revealed/2.
:- dynamic flagged/2.


init_game :-
    retractall(mine(_, _)),
    retractall(revealed(_, _)),
    retractall(flagged(_, _)),
    place_mines(6).


place_mines(0) :- !.
place_mines(N) :-
    random_between(1, 6, X),
    random_between(1, 6, Y),
    (   mine(X, Y)
    ->  place_mines(N) 
    ;   assertz(mine(X, Y)),
        N1 is N - 1,
        place_mines(N1)
    ).


display_grid :-
    between(1, 6, X),
    between(1, 6, Y),
    (   flagged(X, Y)
    ->  write('F')
    ;   revealed(X, Y)
    ->  (   mine(X, Y)
        ->  write('*')
        ;   count_adjacent_mines(X, Y, Count),
            write(Count)
        )
    ;   write('#')
    ),
    (   Y = 6
    ->  nl
    ;   write(' ')
    ),
    fail.
display_grid.


count_adjacent_mines(X, Y, Count) :-
    findall(1, (adjacent(X, Y, X1, Y1), mine(X1, Y1)), Mines),
    length(Mines, Count).


adjacent(X, Y, X1, Y1) :-
    between(-1, 1, DX),
    between(-1, 1, DY),
    (DX \= 0 ; DY \= 0),
    X1 is X + DX,
    Y1 is Y + DY,
    between(1, 6, X1),
    between(1, 6, Y1).


reveal(X, Y) :-
    (   mine(X, Y)
    ->  write('Boom! You hit a mine! Game over.'), nl,
        assertz(revealed(X, Y))
    ;   assertz(revealed(X, Y)),
        write('Cell revealed.'), nl,
        display_grid
    ).


flag(X, Y) :-
    (   flagged(X, Y)
    ->  retract(flagged(X, Y)),
        write('Cell unflagged.'), nl,
        display_grid
    ;   assertz(flagged(X, Y)),
        write('Cell flagged.'), nl,
        check_win_condition,
        display_grid
    ).


check_win_condition :-
    findall((X, Y), mine(X, Y), Mines),
    findall((X, Y), flagged(X, Y), Flags),
    sort(Mines, SortedMines),
    sort(Flags, SortedFlags),
    (   SortedMines == SortedFlags
    ->  write('Congratulations! You flagged all the mines and won the game!'), nl
    ;   true
    ).


display_mines_for_debugging :-
    between(1, 6, X),
    between(1, 6, Y),
    (   mine(X, Y)
    ->  write('M')
    ;   write('.')
    ),
    (   Y = 6
    ->  nl
    ;   write(' ')
    ),
    fail.
display_mines_for_debugging.


start :-
    init_game,
    display_mines_for_debugging,
    write('Grid initialized with 6 mines.'), nl,
    display_grid.
