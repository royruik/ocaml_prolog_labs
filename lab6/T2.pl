taller_than([], _, _, 'No match found.') :- !.  

taller_than(List, MinHeight, age_in_range(MinAge, MaxAge), Result) :-
    find_person(List, MinHeight, MinAge, MaxAge, Result), !.  

taller_than(_, _, _, 'No match found.').  


find_person([H|_], MinHeight, MinAge, MaxAge, H) :-
    H = person(_, Height, Age),
    Height > MinHeight,  
    Age >= MinAge,     
    Age < MaxAge.      

find_person([_|T], MinHeight, MinAge, MaxAge, Result) :-
    find_person(T, MinHeight, MinAge, MaxAge, Result).

