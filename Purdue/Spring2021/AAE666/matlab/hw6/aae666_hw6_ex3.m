% AAE 666 HW6 Exercise 3
% Tomoki Koike
close all; clear all; clc;
%%
echo off;
gamma=1;
A0 = [0 1; -2 -1];
DelA = [0 0; 1 0];
alpha = 0.1
while true
    % Quadratic stability LMI of the problem 
    A1 = A0 - gamma*DelA;
    A2 = A0 + gamma*DelA;
    
    % Setup LMI
    setlmis([]);
    % Equation 1
    p=lmivar(1, [2,1]);
    lmi1=newlmi;
    lmiterm([lmi1,1,1,p],1,A1,'s');
    lmiterm([lmi1,1,1,p],2*alpha,eye(2));
    % Equation 2
    lmi2=newlmi;
    lmiterm([lmi2,1,1,p],1,A2,'s');
    lmiterm([lmi2,1,1,p],2*alpha,eye(2));
    % Equation 3
    Plmi= newlmi;
    lmiterm([-Plmi,1,1,p],1,1);
    lmiterm([Plmi,1,1,0],1);
    % Configure for solver
    lmis = getlmis;
    % Results
    [tfeas, xfeas] = feasp(lmis);
    P = dec2mat(lmis,xfeas,p);
    
    v1 = P*A1 + A1'*P + 2*alpha*P;
    v2 = P*A2 + A2'*P + 2*alpha*P;
    % Check symmetry 
    cp11 = issymmetric(v1);
    cp12 = issymmetric(v2);
    cp1 = cp11 & cp12;
    % Check negative eigenvalues  
    cp21 = all(eig(v1) <= 0);
    cp22 = all(eig(v2) <= 0);
    cp2 = cp21 & cp22;
    % Check if the conditions are negative semi-definite 
    if ~(cp1 && cp2)
        alpha = alpha - 0.0001;
        break;
    end
    % Increment gamma value
    alpha = alpha + 0.0001;
end 


setlmis([]);
% Equation 1
p=lmivar(1, [2,1]);
lmi1=newlmi;
lmiterm([lmi1,1,1,p],1,A1,'s');
lmiterm([lmi1,1,1,p],2*alpha,eye(2));
% Equation 2
lmi2=newlmi;
lmiterm([lmi2,1,1,p],1,A2,'s');
lmiterm([lmi2,1,1,p],2*alpha,eye(2));
% Equation 3
Plmi= newlmi;
lmiterm([-Plmi,1,1,p],1,1);
lmiterm([Plmi,1,1,0],1);
% Configure for solver
lmis = getlmis;
% Results
[tfeas, xfeas] = feasp(lmis);
P = dec2mat(lmis,xfeas,p);