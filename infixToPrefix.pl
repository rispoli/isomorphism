:- [shared].

infixToPrefix(PrefixTerm, InfixTerm) :-
	infixToPrefix('', '', PrefixTerm, InfixTerm).

infixToPrefix(ParentFunctor, Direction, PrefixTerm, InfixTerm) :-
	PrefixTerm =.. [Functor | [LeftArgs , RightArgs]],
	mapPrefixFunctorToInfix(Functor, InfixFunctor),
	infixToPrefix(InfixFunctor, left, LeftArgs, LeftInfixArgs),
	infixToPrefix(InfixFunctor, right, RightArgs, RightInfixArgs),
	getInfixTermGivenFunctor(Direction, ParentFunctor, InfixFunctor, LeftInfixArgs, RightInfixArgs, InfixTerm),
	!.

infixToPrefix(_, left, Terminal, Terminal) :-
	atom(Terminal),
	!.

infixToPrefix(_, _, Terminal, [Terminal]) :-
	atom(Terminal).

getInfixTermGivenFunctor(left, Functor, Functor, LeftArgs, RightArgs, InfixTerm) :-
	InfixTerm =.. [Functor | [LeftArgs | RightArgs]],
	!.

getInfixTermGivenFunctor(_, Functor, Functor, LeftArgs, RightArgs, [LeftArgs | RightArgs]) :- !.

getInfixTermGivenFunctor(right, _, Functor, LeftArgs, RightArgs, [InfixTerm]) :-
	InfixTerm =.. [Functor | [LeftArgs | RightArgs]],
	!.

getInfixTermGivenFunctor(_, _, Functor, LeftArgs, RightArgs, InfixTerm) :-
	InfixTerm =.. [Functor | [LeftArgs | RightArgs]].

mapPrefixFunctorToInfix(->, arrow).

mapPrefixFunctorToInfix(&, and).
