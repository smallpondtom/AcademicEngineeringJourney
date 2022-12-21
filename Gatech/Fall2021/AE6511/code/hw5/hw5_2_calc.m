clear 
clc

syms x1(t) x2(t) L A
u = -(L+A*exp(t));
eq = [diff(x2,t) == -x2 + u, diff(x1,t) == x2];
cond = [x1(0)==0, x2(0)==0];
[X1,X2] = dsolve(eq,cond)

% impose terminal condition
X1 = subs(X1, t, 3);
X2 = subs(X2, t, 3);
eq1 = X1 == 1;
eq2 = X2 == 2;

vars = [L,A];
[L, A] = solve(eq1, eq2, vars, 'Real', true);
a = vpa([L, A], 4)

