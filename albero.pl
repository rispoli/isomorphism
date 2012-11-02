:- [applyPermTreeToType].

% albero(and(arrow(a,b,c,d),arrow(g,h,i,j),arrow(k,l,m)),and(arrow(l,k,m),arrow(h,g,i,j),arrow(b,a,c,d)),T).

albero(A, B, zero) :-
	equals(A, B),
	!.

albero(A, B, T) :-
	alpha(A, B, Sigma, Tau),
	Sigma =.. [and | [FirstBetas | Betas]],
	Tau =.. [and | [FirstGammas | Gammas]],
	getArgsAndArity(FirstBetas, arrow, FirstBetasArgs, M),
	getArgsAndArity(FirstGammas, arrow, FirstGammasArgs, _),
	N is M - 1,
	getPi(1, N, Pi),
	permutation(Pi, PermPi),
	tryPermOnFirstRow(PermPi, FirstBetasArgs, FirstGammasArgs, T),
	applyTreeToOtherRows(T, Betas, Gammas).

getPi(N, N, [[N, []]]) :- !.

getPi(I, N, [[I, []] | Pi]) :-
	J is I + 1,
	getPi(J, N, Pi).

tryPermOnFirstRow([], _, _, []).

tryPermOnFirstRow([PermPiHead | PermPiTail], Betas, [Gammak | GammasTail], [[Pik, Tk] | T]) :-
	nth1(1, PermPiHead, Pik),
	nth1(Pik, Betas, BetaPik),
	albero(BetaPik, Gammak, Tk),
	tryPermOnFirstRow(PermPiTail, Betas, GammasTail, T).

applyTreeToOtherRows(_, [], []).

applyTreeToOtherRows(T, [BetasHead | BetasTail], [GammasHead | GammasTail]) :-
	applyPermTreeToType(T, BetasHead, BetasTyped),
	equals(BetasTyped, GammasHead),
	applyTreeToOtherRows(T, BetasTail, GammasTail).
