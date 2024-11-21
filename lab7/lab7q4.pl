:- dynamic book/4, borrowed/4.



add_book(Title, Author, Year, Genre) :-
    \+ book(Title, Author, Year, Genre), 
    assertz(book(Title, Author, Year, Genre)).


remove_book(Title, Author, Year, Genre) :-
    retract(book(Title, Author, Year, Genre)).


is_available(Title, Author, Year, Genre) :-
    book(Title, Author, Year, Genre),
    \+ borrowed(Title, Author, Year, Genre).


borrow_book(Title, Author, Year, Genre) :-
    is_available(Title, Author, Year, Genre),
    assertz(borrowed(Title, Author, Year, Genre)).

return_book(Title, Author, Year, Genre) :-
    borrowed(Title, Author, Year, Genre),
    retract(borrowed(Title, Author, Year, Genre)).

find_by_author(Author, Books) :-
    findall(Title, book(Title, Author, _, _), Books).

find_by_genre(Genre, Books) :-
    findall(Title, book(Title, _, _, Genre), Books).

find_by_year(Year, Books) :-
    findall(Title, book(Title, _, Year, _), Books).

recommend_by_genre(Genre, Recommendations) :-
    findall(Title, book(Title, _, _, Genre), Recommendations).

recommend_by_author(Author, Recommendations) :-
    findall(Title, book(Title, Author, _, _), Recommendations).


