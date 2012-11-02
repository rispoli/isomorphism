:- op(1200, xfx, <=).
:- op(1100, xfy, ->).
:- op(1000, xfy, &).

join(List, Separator, Output) :-
	innerJoin(List, Separator, '', Output).

innerJoin([Last], _, TempString, Output) :-
	string_concat(TempString, Last, Output).

innerJoin([Head | Tail], Separator, TempString, Output) :-
	stringConcat([Head, Separator], TempString, TempString1),
	innerJoin(Tail, Separator, TempString1, Output).

stringConcat([], Output, Output).

stringConcat([Head|Tail], TempString, Output) :-
	string_concat(TempString, Head, TempString1),
	stringConcat(Tail, TempString1, Output).

getArgsAndArity(Expression, Functor, Args, Arity) :-
	Expression =.. [Functor | Args],
	length(Args, Arity),
	!.

getArgsAndArity(Terminal, _, Terminal, 1) :-
	atom(Terminal),
	!.

getArgsAndArity(Expression, and, [Expression], 1).

minNum(X, Y, X) :- X =< Y, !.
minNum(_, Y, Y).

min([Head1 | Tail1], [Head2 | Tail2], Min) :-
	getArgsAndArity(Head1, arrow, _, NArgs1),
	getArgsAndArity(Head2, arrow, _, NArgs2),
	minNum(NArgs1, NArgs2, HeadMin),
	(
		(
			min(Tail1, Tail2, TailMin),
			minNum(HeadMin, TailMin, Min),
			!
		);
		Min is HeadMin
	).

createAlpha(_, List, 0, List) :- !.

createAlpha(Functor, [A, B | Tail], N, List) :-
	NewHead =.. [Functor | [B , A]],
	append([NewHead], Tail, NewList),
	M is N - 1,
	createAlpha(Functor, NewList, M, List).

cutToTheSameLength(Length, Functor, Expression, Expression) :-
	getArgsAndArity(Expression, Functor, _, NArgs),
	NArgs = Length,
	!.

cutToTheSameLength(Length, Functor, Expression, CuttedExpression) :-
	getArgsAndArity(Expression, Functor, Args, NArgs),
	N is NArgs - Length,
	reverse(Args, ReversedArgs),
	createAlpha(Functor, ReversedArgs, N, ReversedCuttedArgs),
	reverse(ReversedCuttedArgs, CuttedArgs),
	CuttedExpression =.. [Functor | CuttedArgs].
