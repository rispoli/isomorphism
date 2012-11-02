:- [prettyPrinter].
:- [reductionRules].
:- [infixToPrefix].

simplify(InfixExpression, Filename) :-
	infixToPrefix(InfixExpression, Expression),
	stringConcat([Filename, 'Before.dot'], '', Before),
	drawTree(Expression, Before),
	format('Generating tree ~`.t [OK]~64|~n'),
	normalize(Expression, ReducedExpression),
	format('Reducing (if necessary) ~`.t [OK]~64|~n'),
	stringConcat([Filename, 'After.dot'], '', After),
	drawTree(ReducedExpression, After),
	format('Generating new tree ~`.t [OK]~64|~n').
