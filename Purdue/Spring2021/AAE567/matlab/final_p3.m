% AAE 567 Final Exam Spring 2021 Problem 3
% Tomoki Koike

% Housekeeping commands
clear all; close all; clc;
%%
% Problem 3
Rg = [];
sz = 4;
for i = 1:sz
    for j = 1:sz
        if (i==1) && (j==1)
            Rg(i,j) = 1;
        elseif (i==1) || (j==1)
            Rg(i,j) = 0;
        elseif i==j
            Rg(i,j) = 2;
        else
            Rg(i,j) = 1;
        end
    end
end
Rxg = ones(1,sz); 
Rxg(1) = 0;
inv(Rg)
coefs = Rxg * inv(Rg)