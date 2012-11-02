:- [albero].
:- [infixToPrefix].
:- [prefixToInfix].
:- [reductionRules].

% isoterm((b22->b21->a2)->b3->b1->a,b1->(b21->b22->a2)->b3->a,T).

isoterm(SigmaInfix, TauInfix, IsoTerm) :-
	infixToPrefix(SigmaInfix, SigmaPrefix),
	normalize(SigmaPrefix, Sigma),
	infixToPrefix(TauInfix, TauPrefix),
	normalize(TauPrefix, Tau),
	albero(Tau, Sigma, T),
	reset_gensym,
	topTerm(T, PrefixIsoTerm),
	prefixToInfix(PrefixIsoTerm, IsoTerm).

topTerm(T, lam(z, IsoTerm)) :-
	term(T, z, IsoTerm).

term(zero, X, X) :- !.

term(T, Z, IsoTerm) :-
	length(T, PiCardinality),
	getNewVariables(1, PiCardinality, NewVariables),
	getTerms(T, NewVariables, Terms),
	generateIsoTerm(Z, NewVariables, Terms, IsoTerm),
	!.

getTerms([], _, []).

getTerms([[PiN, TN] | TailT], NewVariables, [TNXPiN | TTail]) :-
	nth1(PiN, NewVariables, XPiN),
	term(TN, XPiN, TNXPiN),
	getTerms(TailT, NewVariables, TTail).

getNewVariables(PiCardinality, PiCardinality, [X]) :-
	gensym(x, X),
	!.

getNewVariables(N, PiCardinality, [X | OtherNewVariables]) :-
	gensym(x, X),
	M is N + 1,
	getNewVariables(M, PiCardinality, OtherNewVariables).

generateIsoTerm(Z, [], Terms, IsoTerm) :-
	generateIsoTermTerms(Terms, IsoTermList),
	IsoTerm =.. [app | [Z | IsoTermList]].

generateIsoTerm(Z, [XHead | XTail], Terms, lam(XHead, IsoTerm)) :-
	generateIsoTerm(Z, XTail, Terms, IsoTerm).

generateIsoTermTerms([], []).

generateIsoTermTerms([TermsHead | TermsTail], [TermsHead | IsoTerm]) :-
	generateIsoTermTerms(TermsTail, IsoTerm).
