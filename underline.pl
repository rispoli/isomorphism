metaList(Predicate, LeftExpression, RightExpression, Expression) :-
	min([LeftExpression], [RightExpression], N),
	cutToTheSameLength(N, arrow, LeftExpression, LeftExpressionCutted),
	cutToTheSameLength(N, arrow, RightExpression, RightExpressionCutted),
	LeftExpressionCutted =.. [arrow | LeftArgs],
	RightExpressionCutted =.. [arrow | RightArgs],
	innerMetaList(Predicate, LeftArgs, RightArgs, Expression).

innerMetaList(_, [], [], []).

innerMetaList(Predicate, [LeftHead | LeftTail], [RightHead | RightTail], [Head | Tail]) :-
	MetaPredicate =.. [Predicate , LeftHead , RightHead, Head],
	MetaPredicate,
	innerMetaList(Predicate, LeftTail, RightTail, Tail).

meet(dot, _, dot) :- !.

meet(_, dot, dot) :- !.

meet(LeftArrow, RightArrow, MeetedArrow) :-
	metaList(meet, LeftArrow, RightArrow, MeetedArgs),
	MeetedArrow =.. [arrow | MeetedArgs].

atomTree(Terminal, dot) :-
	atom(Terminal),
	!.

atomTree(Expression, AtomTree) :-
	Expression =.. [Functor | Args],
	atomTreeList(Args, AtomTreeArgs),
	innerAtomTree(Functor, AtomTreeArgs, AtomTree).

innerAtomTree(arrow, AtomTreeArgs, AtomTree) :-
	AtomTree =.. [arrow | AtomTreeArgs].

innerAtomTree(and, AtomTreeArgs, AtomTree) :-
	meetList(AtomTreeArgs, AtomTree).

meetList([A , B | Tail], MeetedList) :-
	meet(A, B, M),
	meetListL(M, Tail, MeetedList).

meetListL(M, [], M).

meetListL(M, [Head | Tail], MeetedList) :-
	meet(M, Head, N),
	meetListL(N, Tail, MeetedList),
	!.

meetListL(M, [Last], MeetedLast) :-
	meet(M, Last, MeetedLast).

atomTreeList([], []).

atomTreeList([Head | Tail], [AtomTreeHead | AtomTreeTail]) :-
	atomTree(Head, AtomTreeHead),
	atomTreeList(Tail, AtomTreeTail).

bemolle(dot, Terminal, Terminal) :-
	atom(Terminal),
	!.

bemolle(AtomTree, Expression, BemolledExpression) :-
	Expression =.. [Functor | Args],
	innerBemolle(AtomTree, Functor, Args, BemolledExpression).

innerBemolle(dot, arrow, Args, UnderlinedExpression) :-
	Expression =.. [arrow | Args],
	UnderlinedExpression =.. [und , Expression].

innerBemolle(AtomTree, arrow, Args, BemolledExpression) :-
	Expression =.. [arrow | Args],
	metaList(bemolle, AtomTree, Expression, BemolledArgs),
	BemolledExpression =.. [arrow | BemolledArgs].

innerBemolle(AtomTree, and, Args, BemolledExpression) :-
	maplist(bemolle(AtomTree), Args, BemolledArgs),
	BemolledExpression =.. [and | BemolledArgs].

bequadro(Expression, UnderlinedExpression) :-
	atomTree(Expression, AtomTreeExpression),
	bemolle(AtomTreeExpression, Expression, UnderlinedExpression).
