% AAE 666 HW7 Exercise 2
% Tomoki Koike
close all; clear all; clc;
%%
echo off;
%k = 1
k = 17.9;
while true
    % Quadratic stability LMI of the problem 
    A = [   0  0  1  0; 
            0  0  0  1;
         -2*k  k -2  1;
            k -k  1 -1];
    
    B1 = [0; 0; 1; 0];
    B2 = [0; 0; 0; 1];
    C1 = [1 0 0 0];
    C2 = [0 1 0 0];
    
    % Setup LMI
    setlmis([]);
    % P matrix
    p=lmivar(1, [4,1]);
    % Equation 1
    lmi1=newlmi;
    lmiterm([lmi1,1,1,p],1,A,'s');  % PA + A'P
    lmiterm([lmi1,1,1,0],C1'*C1);  % C1'C1
    lmiterm([lmi1,1,1,0],C2'*C2);  % C2'C2
    lmiterm([lmi1,1,2,p],1,B1);  % PB1
    lmiterm([lmi1,1,3,p],1,B2);  % PB1
    lmiterm([lmi1,2,2,0],-1);  % -I
    lmiterm([lmi1,3,3,0],-1);  % -I
    % Equation 2
    lmi2=newlmi;
    lmiterm([-lmi2,1,1,p],1,1);  % 0 < P
    % Configure for solver
    lmis = getlmis;
    % Results
    [tfeas, xfeas] = feasp(lmis);
    P = dec2mat(lmis,xfeas,p);
    
    if tfeas < 0
        break;
    end
    % Increment gamma value
    %k = k + 0.1;
    k = k + 0.0001;
end 

% Save file as .m
matlab.internal.liveeditor.openAndConvert('aae666_hw7_ex2.mlx', ...
    convertStringsToChars(fullfile(pwd, 'aae666_hw7_ex2.m')));