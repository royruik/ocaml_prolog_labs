parent(john, mary).
parent(john, tom).
parent(mary, ann).
parent(mary, fred).
parent(tom, liz).
male(john).
male(tom).
male(fred).
female(mary).
female(ann).
female(liz).

sibling(Sibling1, Sibling2) :- 
    parent(Parent, Sibling1), 
    parent(Parent, Sibling2), 
    Sibling1 \= Sibling2.

grandparent(Grandparent, Grandchild) :- 
    parent(Grandparent, Parent), parent(Parent, Grandchild).

ancestor(Ancestor, Descendant) :- 
    parent(Ancestor, Descendant).
    
ancestor(Ancestor, Descendant) :- 
    parent(Parent, Descendant),
    ancestor(Ancestor, Parent),
    !.
    

