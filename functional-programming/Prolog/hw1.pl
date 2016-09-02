% Gerald Brown
% gemabrow@ucsc.edu
father(al, bud).
father(al, kelly).
father(al, greg).
mother(peggy, kelly).
mother(peggy, bud).
mother(martha, peggy).
transition(q0,q1,a).
transition(q1,q2,b).
transition(q0,q3,a).
transition(q3,q3,a).
accepting(q2).
accepting(q3).
% Question 9.
grandma(X,Y):-
  mother(X,Z),
  mother(Z,Y).
% Question 10.
descendants(X,Y) :-
  mother(X,Y);
  father(X,Y);
  grandma(X,Y).
% Question 11.
siblings(X,Y) :-
  samemother(X,Y);
  father(B,X),
  father(B,Y),
  X\=Y,
  not(samemother(X,Y)).
% helper function for question 11 ensuring
% duplicates, i.e. full-blooded siblings,
% are not repeated
samemother(X,Y) :-
  mother(A,X),
  mother(A,Y),
  X\=Y.
% Question 12.
accepts(State, InputList) :-
  % if an empty InputList, check for accepting state
  InputList = [],
  accepting(State);
  % otherwise separate into head and remaining input,
  % check for a nextState which satisfies transition
  % rules and recursive check for accepting state.
  InputList = [H|T],
  transition(State,NextState,H),
  accepts(NextState,T).
