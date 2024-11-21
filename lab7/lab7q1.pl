right_angle_triangle_console :-
    write('Enter the height of the right-angled triangle: '),
    read(Height),
    print_triangle(1, Height).

print_triangle(Current, Height) :-
    Current =< Height,
    print_row(Current),
    nl,
    Next is Current + 1,
    print_triangle(Next, Height).
print_triangle(Current, Height) :-
    Current > Height.

print_row(N) :-
    N > 0,
    write('#'),
    N1 is N - 1,
    print_row(N1).
print_row(0).
