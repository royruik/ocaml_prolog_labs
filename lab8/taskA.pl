:- dynamic destination/4.  
:- dynamic expense/3.     


add_destination(Name, StartDate, EndDate, Budget) :-
    assert(destination(Name, StartDate, EndDate, Budget)).

remove_destination(Name) :-
    retract(destination(Name, _, _, _)),
    retractall(expense(Name, _, _)).


add_expense(Destination, Category, Amount) :-
    destination(Destination, _, _, _),  
    assert(expense(Destination, Category, Amount)).


total_expenses(Destination, Total) :-
    findall(Amount, expense(Destination, _, Amount), Expenses),
    sum_list(Expenses, Total).


validate_budget(Destination) :-
    destination(Destination, _, _, Budget),
    total_expenses(Destination, Total),
    Total =< Budget.


filter_destinations_by_date(Date, Destinations) :-
    findall(Name, 
            (destination(Name, Start, End, _),
             Date @>= Start,
             Date @=< End),
            Destinations).

filter_expenses_by_category(Category, Expenses) :-
    findall((Dest, Amount),
            expense(Dest, Category, Amount),
            Expenses).


command(add_dest(Name, Start, End, Budget)) -->
    ["add"], ["destination"], [Name], [Start], [End], [Budget].

command(remove_dest(Name)) -->
    ["remove"], ["destination"], [Name].

command(list_expenses(Dest)) -->
    ["list"], ["expenses"], [Dest].

command(check_budget(Dest)) -->
    ["check"], ["budget"], [Dest].

parse_command(Input, Command) :-
    split_string(Input, " ", "", Words),
    phrase(command(Command), Words).


save_journey(Filename) :-
    open(Filename, write, Stream),
    write_destinations(Stream),
    write_expenses(Stream),
    close(Stream).

write_destinations(Stream) :-
    forall(destination(Name, Start, End, Budget),
           (format(Stream, 'destination(~w,~w,~w,~w).~n', 
                  [Name, Start, End, Budget]))).

write_expenses(Stream) :-
    forall(expense(Dest, Cat, Amount),
           (format(Stream, 'expense(~w,~w,~w).~n',
                  [Dest, Cat, Amount]))).

load_journey(Filename) :-
    exists_file(Filename),
    clear_data,
    see(Filename),
    load_data,
    seen.

clear_data :-
    retractall(destination(_, _, _, _)),
    retractall(expense(_, _, _)).

load_data :-
    repeat,
    read(Term),
    (Term == end_of_file -> !;
        assert(Term),
        fail).
