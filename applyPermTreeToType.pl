:- [findAlpha].

applyPermTreeToType(zero, T, T) :- !.

applyPermTreeToType(PermTree, Expression, TypedExpression) :-
	getArgsAndArity(Expression, Functor, Args, Arity),
	getTypedArgs(Functor, PermTree, Args, Arity, TypedArgs),
	reuniteTerm(Functor, TypedArgs, TypedExpression),
	!.

applyPermTreeToType(_, _, undefined).

getTypedArgs(and, PermTree, Args, _, TypedArgs) :-
	applyPermTreeToInt(PermTree, Args, TypedArgs).

getTypedArgs(arrow, PermTree, Args, Arity, TypedArgs) :-
	length(PermTree, PiCardinality),
	NumberOfBetas is Arity - 1,
	PiCardinality = NumberOfBetas,
	applyTnToBetaPin(PermTree, Args, TypedArgs).

applyPermTreeToInt(_, [], []).

applyPermTreeToInt(T, [Head | Tail], TypedIntersection) :-
	applyPermTreeToType(T, Head, TypedIntersectionHead),
	checkIfUndefined(applyPermTreeToInt, T, Tail, TypedIntersectionHead, TypedIntersection).

applyTnToBetaPin([], Betas, [Alpha]) :-
	last(Betas, Alpha).

applyTnToBetaPin([[N , T] | TailPermTree], Betas, TypedBeta) :-
	nth1(N, Betas, PiBeta),
	applyPermTreeToType(T, PiBeta, TypedPiBeta),
	checkIfUndefined(applyTnToBetaPin, TailPermTree, Betas, TypedPiBeta, TypedBeta).

checkIfUndefined(_, _, _, undefined, undefined) :- !.

checkIfUndefined(Functor, T, Args, Head, [Head | Tail]) :-
	MetaPredicate =.. [Functor | [T, Args, Tail]],
	MetaPredicate.

reuniteTerm(_, TypedArgs, undefined) :-
	flatten(TypedArgs, TypedArgsFlattened),
	member(undefined, TypedArgsFlattened),
	!.

reuniteTerm(Functor, TypedArgs, TypedTerm) :-
	TypedTerm =.. [Functor | TypedArgs].
