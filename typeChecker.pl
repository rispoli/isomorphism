:- op(200, xfy, '-->').

type(A, X, T) :-
	member((X, T), A).

type(A, app(M, N), T) :-
	type(A, M, T1 --> T),
	type(A, N, T1).

type(A, lam(X, M), T1 --> T2) :-
	type([(X, T1) | A], M, T2).
