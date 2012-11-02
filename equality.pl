% equals(arrow(and(e,c,z,e,z,e,e,e,c,z,e),b,and(a,b,c)),arrow(and(z,e,c),b,and(c,b,a))).

equals(Terminal, Terminal) :-
	atom(Terminal),
	!.

equals(Expression1, Expression2) :-
	Expression1 =.. [F1|Args1],
	Expression2 =.. [F2|Args2],
	equals(F1, Args1, F2, Args2).

equals(F, List1, F, List2) :-
	List1 == List2,
	!.

equals(and, List1, and, List2) :-
	sort(List1, List1Sorted),
	sort(List2, List2Sorted),
	List1Sorted == List2Sorted.

equals(F, List1, F, List2) :-
	deepEquals(List1, List2).

deepEquals([], []).

deepEquals([Head1|Tail1], [Head2|Tail2]) :-
	equals(Head1, Head2),
	deepEquals(Tail1, Tail2).
