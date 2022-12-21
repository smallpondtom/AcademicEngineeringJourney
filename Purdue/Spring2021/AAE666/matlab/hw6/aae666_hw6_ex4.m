% AAE 666 HW6 Exercise 4
% Tomoki Koike
close all; clear all; clc;
%%
echo off;
%k = 1;
k = 17.9;
while true
    % Quadratic stability LMI of the problem 
    A0 = [   0  0  1  0; 
             0  0  0  1;
          -2*k  k -2  1;
             k -k  1 -1];
    DelA1 = [0 0 0 0;
             0 0 0 0;
             1 0 0 0;
             0 0 0 0];
    DelA2 = [0 0 0 0;
             0 0 0 0;
             0 0 0 0;
             0 1 0 0];
    A1 = A0 - DelA1 - DelA2;
    A2 = A0 - DelA1 + DelA2;
    A3 = A0 + DelA1 - DelA2;
    A4 = A0 + DelA1 + DelA2;
    
    % Setup LMI
    setlmis([]);
    % P matrix
    p=lmivar(1, [4,1]);
    % Equation 1
    lmi1=newlmi;
    lmiterm([lmi1,1,1,p],1,A1,'s');
    % Equation 2
    lmi2=newlmi;
    lmiterm([lmi2,1,1,p],1,A2,'s');
    % Equation 3
    lmi2=newlmi;
    lmiterm([lmi2,1,1,p],1,A3,'s');
    % Equation 4
    lmi2=newlmi;
    lmiterm([lmi2,1,1,p],1,A4,'s');
    % Equation 5
    Plmi= newlmi;
    lmiterm([-Plmi,1,1,p],1,1);
    lmiterm([Plmi,1,1,0],1);
    % Configure for solver
    lmis = getlmis;
    % Results
    [tfeas, xfeas] = feasp(lmis);
    P = dec2mat(lmis,xfeas,p);
    
    v1 = P*A1 + A1'*P;
    v2 = P*A2 + A2'*P;
    v3 = P*A3 + A3'*P;
    v4 = P*A4 + A4'*P;
    % Check symmetry 
    cp11 = issymmetric(v1);
    cp12 = issymmetric(v2);
    cp13 = issymmetric(v3);
    cp14 = issymmetric(v4);
    cp1 = cp11 & cp12 & cp13 & cp14;
    % Check negative eigenvalues  
    cp21 = all(eig(v1) < 0);
    cp22 = all(eig(v2) < 0);
    cp23 = all(eig(v3) < 0);
    cp24 = all(eig(v4) < 0);
    cp2 = cp21 & cp22 & cp23 & cp24;
    % Check tfeas to be negative
    cp3 = tfeas < 0;
    % Check if the conditions are negative definite 
    cp = cp1 & cp2 & cp3
    % Check if the conditions are negative definite 
    if cp
        break;
    end
    % Increment gamma value
    %k = k + 0.1;
    k = k + 0.0001;
end