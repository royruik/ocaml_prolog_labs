isosceles_triangle_pattern_file(Height, Filename) :-
    open(Filename, write, Stream),
    write_triangle(1, Height, Stream),
    close(Stream),
    format('Isosceles triangle pattern written to file: ~w~n', [Filename]).

write_triangle(Current, Height, Stream) :-
    Current =< Height,
    Spaces is Height - Current,
    Stars is 2 * Current - 1,
    print_spaces(Spaces, Stream),
    print_stars(Stars, Stream),
    nl(Stream),
    Next is Current + 1,
    write_triangle(Next, Height, Stream).
write_triangle(Current, Height, _) :-
    Current > Height.

print_spaces(0, _).
print_spaces(N, Stream) :-
    N > 0,
    write(Stream, ' '),
    N1 is N - 1,
    print_spaces(N1, Stream).

print_stars(0, _).
print_stars(N, Stream) :-
    N > 0,
    write(Stream, '*'),
    N1 is N - 1,
    print_stars(N1, Stream).
