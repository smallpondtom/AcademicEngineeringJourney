% AAE 666 HW7 Exercise 4
% Tomoki Koike
close all; clear all; clc;
%%
% Control matrices 
beta = 1.2;
A = [0 1; -2 -1];
B = [0; 1];
C = [1, beta];
D = 0;

% Nyquist Plot 
sys = ss(A,B,C,D);
fig = figure("Renderer","painters","Position",[60 60 900 700]); 
nyquist(sys);  
saveas(fig, "ex4_nyquist.png")

% Observability and Controllability 
Qc = ctrb(A,B);
rankQc = rref(Qc);
Qo = obsv(A,C);
rankQo = rref(Qo);
%%
echo off;
% Quadratic stability LMI of the problem 

% Setup LMI
setlmis([]);
% P matrix
p = lmivar(1, [2, 1]);  % P
a = lmivar(1, [1, 1]);  % alpha

if D == 0
    % Equation 1
    lmi1 = newlmi;
    lmiterm([-lmi1, 1, 1, 0], a);  % aI
    lmiterm([-lmi1, 1, 2, 1], B', p);  % B'P
    lmiterm([-lmi1, 1, 2, 0], -C);  % -C
    lmiterm([-lmi1, 2, 2, 0], a);  % aI
    
    % Equation 2
    lmi2 = newlmi;
    lmiterm([lmi2, 1, 1, p], 1, A, 's');  % PA + A'P
    
    % Equation 3
    lmi3 = newlmi;
    lmiterm([-lmi3, 1, 1, p], 1, 1);  % 0 < P
    
    lmi4 = newlmi;
    lmiterm([lmi4, 1, 1, a], 1, 1);
else
    % Equation 1
    lmi1 = newlmi;
    lmiterm([lmi1, 1, 1, p], 1, A, 's');  % PA + A'P
    lmiterm([lmi1, 1, 1, a], 2, p);       % 2aP
    lmiterm([lmi1, 1, 2, p], 1, B);       % PB
    lmiterm([lmi1, 1, 2, 0], -C');        % -C'
    
    lmiterm([lmi1, 2, 2, 0],-D);          % -D
    lmiterm([lmi1, 2, 2, 0],-D');         % -D'
    
    % Equation 2
    lmi2 = newlmi;
    lmiterm([-lmi2, 1, 1, p], 1, 1);  % 0 < P
    
    % Equation 3
    lmi3 = newlmi;
    lmiterm([-lmi3, 1, 1, a], 1, 1);  % 0 < a
end

% Configure for solver
lmis = getlmis;
%%

% Results
[tfeas, xfeas] = feasp(lmis);
P = dec2mat(lmis, xfeas, p);
v1 = defcx(lmis, 2, a);
c = mat2dec(lmis, v1);
options = [1e-5 0 0 0 0];
[alpha, xopt] = mincx(lmis, c, options);
    
assert(tfeas < 0, "This results is infeasible.");
%%
% Save file as .m
matlab.internal.liveeditor.openAndConvert('aae666_hw7_ex4.mlx', ...
    convertStringsToChars('aae666_hw7_ex4.m'));