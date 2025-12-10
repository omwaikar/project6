
parse(X) :- lines(X, []).

% Grammer Rules
lines(In, Out) :- 
    line(In, T), 
    T = [';' | Rest], 
    lines(Rest, Out).
lines(In, Out) :- 
    line(In, Out).

line(In, Out) :- 
    num(In, T), 
    T = [',' | Rest], 
    line(Rest, Out).
line(In, Out) :- 
    num(In, Out).

% Recursive rule to parse numbers
num(In, Out) :- 
    digit(In, T), 
    num(T, Out).
num(In, Out) :- 
    digit(In, Out).

digit([H|T], T) :- 
    member(H, ['0','1','2','3','4','5','6','7','8','9']).