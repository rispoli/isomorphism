:- [underline].

normalize([Terminal], Terminal) :-
	atom(Terminal),
	!.

normalize(Expression, NormalizedExpression) :-
	bequadro(Expression, UnderlinedExpression),
	reduce(UnderlinedExpression, ReducedExpression),
	ununderline(ReducedExpression, UnunderlinedExpression),
	nextStep(Expression, ReducedExpression, UnunderlinedExpression, NormalizedExpression).

reduce(Terminal, Terminal) :-
	atom(Terminal),
	!.

reduce(Expression, ReducedExpression) :-
	applyReductionRules(Expression, ReducedExpression).

applyReductionRules(Expression, ReducedExpression) :-
	Expression =.. [arrow | ArrowArgs],
	nextto(A, B, ArrowArgs),
	B =.. [and | AndArgs],
	getIntersectionArgs(A, AndArgs, IntersectionArgs),
	Intersection =.. [and | IntersectionArgs],
	putIntersectionInRightPlace(ArrowArgs, A, B, Intersection, ReducedArgs),
	reunite(arrow, ReducedArgs, ReducedExpression),
	!.

applyReductionRules(Expression, ReducedExpression) :-
	Expression =.. [and | AndArgs],
	findB(AndArgs, Bi, AndArgsBi, R),
	delete(AndArgs, Bi, AndArgsMinusBi),
	findB(AndArgsMinusBi, _, AndArgsBj, R),
	list_to_set(AndArgsBi, SetAndArgsBi),
	list_to_set(AndArgsBj, SetAndArgsBj),
	subset(SetAndArgsBj, SetAndArgsBi),
	reunite(and, AndArgsMinusBi, ReducedExpression),
	!.

applyReductionRules(Expression, Expression).

getIntersectionArgs(_, [], []).

getIntersectionArgs(A, [Head | Tail], [ArrowedHead | ArrowedTail]) :-
	ArrowedHead =.. [arrow | [A , Head]],
	getIntersectionArgs(A, Tail, ArrowedTail).

putIntersectionInRightPlace([Head | [HeadTail | TailTail]], Head, HeadTail, Intersection, [Intersection | TailTail]).

putIntersectionInRightPlace([Head | Tail], A, B, Intersection, [Head | ReducedArgs]) :-
	putIntersectionInRightPlace(Tail, A, B, Intersection, ReducedArgs).

reunite(Functor, Args, Expression) :-
	length(Args, N),
	N > 1,
	Expression =.. [Functor | Args],
	!.

reunite(_, [Expression], Expression).

findB([Head | _], Head, AndArgs, R) :-
	Head =.. [arrow | [And | R]],
	(
		And =.. [and | AndArgs];
		AndArgs = [And]
	).

findB([_ | Tail], Bi, AndArgs, R) :-
	findB(Tail, Bi, AndArgs, R).

ununderline(und(Expression), Expression) :- !.

ununderline(Terminal, Terminal) :-
	atom(Terminal),
	!.

ununderline(UnderlinedExpression, UnunderlinedExpression) :-
	UnderlinedExpression =.. [Functor | Args],
	ununderlineList(Args, UnunderlinedArgs),
	UnunderlinedExpression =.. [Functor | UnunderlinedArgs].

ununderlineList([], []).

ununderlineList([Head | Tail], [UHead | UTail]) :-
	ununderline(Head, UHead),
	ununderlineList(Tail, UTail).

nextStep(TempReducedExpression, PossiblyUnderlinedExpression, TempReducedExpression, ReducedExpression) :- % DO NOT rebuild atom tree because no reduction rule was applied
	PossiblyUnderlinedExpression =.. [Functor | Args],
	reduceList(Args, ReducedArgs),
	innerNextStep(Functor, Args, ReducedArgs, ReducedExpression),
	!.

nextStep(_, _, UnunderlinedExpression, ReducedExpression) :-
	normalize(UnunderlinedExpression, ReducedExpression).

reduceList([], []).

reduceList([und(Head) | Tail], [und(Head) | ReducedTail]) :-
	reduceList(Tail, ReducedTail).

reduceList([Head|Tail], [ReducedHead|ReducedTail]) :-
	reduce(Head, ReducedHead),
	reduceList(Tail, ReducedTail).

innerNextStep(Functor, Args, Args, ReducedExpression) :-
	reuniteAndSortIfNecessary(Functor, Args, ReducedExpression),
	!.

innerNextStep(Functor, _, Args, ReducedExpression) :-
	reuniteAndSortIfNecessary(Functor, Args, TempReducedExpression),
	ununderline(TempReducedExpression, UnunderlinedExpression),
	normalize(UnunderlinedExpression, ReducedExpression).

reuniteAndSortIfNecessary(Functor, Args, Expression) :-
	level(Functor, Args, LevelledReducedArgs),
	innerReuniteAndSortIfNecessary(Functor, LevelledReducedArgs, Expression).

level(_, [], []).

level(and, [Head | Tail], LevelledArgs) :-
	Head =.. [and | Args],
	level(and, Tail, LevelledTail),
	append(Args, LevelledTail, LevelledArgs).

level(F, [Head | Tail], [Head | LevelledTail]) :-
	level(F, Tail, LevelledTail).

innerReuniteAndSortIfNecessary(and, Args, Expression) :-
	list_to_set(Args, NonDuplicatedArgs),
	Expression =.. [and | NonDuplicatedArgs].

innerReuniteAndSortIfNecessary(arrow, Args, Expression) :-
	Expression =.. [arrow | Args].
