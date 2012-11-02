:- [shared].

prefixToInfix(PrefixTerm, InfixTerm) :-
	PrefixTerm =.. [Functor | Args],
	getSymbol(Functor, FSymbol),
	prefixToInfixI(Args, InfixArgs),
	getInfixTerm(FSymbol, InfixArgs, InfixTerm),
	!.

prefixToInfix(Terminal, Terminal) :-
	atom(Terminal).

prefixToInfixI([], []).

prefixToInfixI([Head | Tail], [InfixHead | InfixTail]) :-
	prefixToInfix(Head, InfixHead),
	prefixToInfixI(Tail, InfixTail).

getSymbol(lam, 'lam') :- !.

getSymbol(app, '') :- !.

getSymbol(X, X).

getInfixTerm('lam', [InfixLeftArg , InfixRightArg], InfixTerm) :-
	current_prolog_flag(arch, Arch),
	getLambdaSymbol(Arch, Lambda),
	stringConcat(['(', Lambda, ' ', InfixLeftArg, '. ', InfixRightArg, ')'], '', InfixTerm).

getInfixTerm('', InfixArgs, InfixTerm) :-
	join(InfixArgs, ' ', StringArgs),
	stringConcat(['(', StringArgs, ')'], '', InfixTerm).

getLambdaSymbol(Arch, 'λ') :-
	sub_atom(Arch, _, _, _, linux),
	!.

getLambdaSymbol(_, 'lam').
