:- [shared].

% drawTree(and(arrow(v, v), arrow(t, and(arrow(q, h), arrow(f, and(n, w))))), 'tree.dot').

drawTree(NAdicExpression, FileName) :-
	cutToTheSameLength(2, _, NAdicExpression, Expression),
	tell(FileName),
	format('graph {~n\tnode [ shape = "plaintext", fontname = "Standard Symbols L", fontsize = 12 ];~n'),
	greekExpression(Expression, GreekExpression),
	format('\tlabel = "~w";~n\tfontname = "Standard Symbols L";~n\tfontsize = 20;~n', GreekExpression),
	retractall(nID(_)),
	assert(nID(0)),
	Expression =.. [F|Args],
	name(F, AsciiLabel),
	greekLabel(AsciiLabel, GreekLabel),
	format('\t~d [ label = "&#~d;" ];~n', [0, GreekLabel]),
	makeTree(Args, 0),
	format('}'),
	told.

makeTree([], _).

makeTree([und(Head)|Tail], ParentID) :-
	makeTree(Head, ParentID),
	makeTree(Tail, ParentID),
	!.

makeTree([Head|Tail], ParentID) :-
	makeTree(Head, ParentID),
	makeTree(Tail, ParentID),
	!.

makeTree(Terminal, ParentID) :-
	atom(Terminal),
	writeNode(ParentID, Terminal, _),
	!.

makeTree(Expression, ParentID) :-
	Expression =.. [F|Args],
	writeNode(ParentID, F, ID),
	makeTree(Args, ID).

newID(N) :-
	retract(nID(N0)),
	N is N0 + 1,
	assert(nID(N)).

writeNode(ParentID, Label, ID) :-
	newID(ID),
	name(Label, AsciiLabel),
	greekLabel(AsciiLabel, GreekLabel),
	format('\t~d [ label = "&#~d;", labelfontsize = 10 ];~n', [ID, GreekLabel]),
	format('\t~d -- ~d [ style = "setlinewidth(0.5)" ];~n', [ParentID, ID]).

greekLabel([97, 114, 114, 111, 119], 8594) :- !.	% arrow = [97, 114, 114, 111, 119] --> rightArrow = 8594

greekLabel([97, 110, 100], 8743) :- !.				% and = [97, 110, 100] --> and = 8743

greekLabel([118], 981) :- !.						% v = 118 --> phi = 981


greekLabel(Label, GreekLabel) :-
	GreekLabel is Label + 848.						% alpha = 945, a = 97 --> alpha - a = 848

greekExpression([], []).

greekExpression(und(Expression), GreekExpression) :-
	greekExpression(Expression, GreekExpression),
	!.

greekExpression(Terminal, GreekTerminal) :-
	atom(Terminal),
	name(Terminal, AsciiTerminal),
	greekLabel(AsciiTerminal, GreekTerminal),
	!.

greekExpression(Expression, GreekExpression) :-
	Expression =.. [F, LeftArgs, RightArgs],
	name(F, AsciiF),
	greekLabel(AsciiF, GreekF),
	greekExpression(LeftArgs, GreekLeftArgs),
	greekExpression(RightArgs, GreekRightArgs),
	specialChar(GreekLeftArgs, GreekLeftArgsReady),
	specialChar(GreekRightArgs, GreekRightArgsReady),
	format(atom(GreekFReady), '&#~d;', GreekF),
	stringConcat(['(', GreekLeftArgsReady, GreekFReady, GreekRightArgsReady, ')'], '', GreekExpression).

specialChar(Expression, SpecialExpression) :-
	number(Expression),
	format(atom(SpecialExpression), '&#~d;', Expression),
	!.

specialChar(Expression, SpecialExpression) :-
	format(atom(SpecialExpression), '~w', Expression).
