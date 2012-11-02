:- [equality].
:- [shared].

% alpha(and(arrow(a,b,c,d),arrow(g,h,i,j),arrow(k,l,m)),and(arrow(n,o,m),arrow(p,q,i,j),arrow(r,s,c,d)),X,Y).

alpha(Expression1, Expression2, Expression1Cutted, Expression2Matched) :-
	getArgsAndArity(Expression1, and, Args1, NArgs1),
	getArgsAndArity(Expression2, and, Args2, NArgs2),
	NArgs1 = NArgs2,
	min(Args1, Args2, N),
	maplist(cutToTheSameLength(N, arrow), Args1, Args1Cutted),
	maplist(cutToTheSameLength(N, arrow), Args2, Args2Cutted),
	matchAlpha(Args1Cutted, Args2Cutted, Args2Matched),
	Expression1Cutted =.. [and | Args1Cutted],
	Expression2Matched =.. [and | Args2Matched].

getAlpha(Expression, Alpha) :-
	Expression =.. [arrow | Args],
	last(Args, Alpha).

getAlpha(Expression, Expression) :-
	atom(Expression).

matchAlpha([], [], []).

matchAlpha([Head | Tail], List2, [List2MatchedHead | List2MatchedTail]) :-
	getAlpha(Head, Alpha),
	alphaCorrispondence(Alpha, List2, List2MatchedHead),
	delete(List2, List2MatchedHead, List2N),
	matchAlpha(Tail, List2N, List2MatchedTail).

alphaCorrispondence(Alpha, [Head | _], Head) :-
	getAlpha(Head, Alpha_),
	equals(Alpha, Alpha_).

alphaCorrispondence(Expression, [_ | Tail], MatchingExpression) :-
	alphaCorrispondence(Expression, Tail, MatchingExpression).
