% ISYE7750 HW5 Problem 5
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% (a)
a1 = [1;1;-1;-1;-1];
a2 = [1;1;1;1;1];
a3 = [1;-1;1;-1;1];
A = [a1 a2 a3];

% Hand calculate the Gram-Schmidt
q1 = a1 / norm(a1);
w2 = a2 - dot(a2,q1)*q1;
q2 = w2 / norm(w2);
w3 = a3 - dot(a3,q1)*q1 - dot(a3,q2)*q2;
q3 = w3 / norm(w3);

% Using function
q = gramSchmidt(A);

%% (b)
[Q,R] = QRfactor(A);








%% Functions

function q = gramSchmidt(a)
% GRAMSCHIMDT: Computes orthonormal basis for Span(a1,a2,...,aN) using the 
%              Gram-Schmidt algorithm.
% Author: Tomoki Koike
% Organization: Georgia Institute of Technology, Aerospace Engineering
% 
% >>Input
%   a: vectors a spanning some Euclidean space.
% 
% <<Output
%   q: orthonormal vectors of a, spanning the same space.
[M,N] = size(a);
q = zeros(M,N);
q(:,1) = a(:,1) / norm(a(:,1));

for k = 2:N
  wk = a(:,k);
  for l = 1:k-1
    wk = wk - dot(a(:,k), q(:,l)) * q(:,l);
  end
  q(:,k) = wk / norm(wk);
end

end

function [Q, R] = QRfactor(A)
% QRFACTOR: Computes the QR factorization for nonsingular matrix A.
% Author: Tomoki Koike
% Organization: Georgia Institute of Technology, Aerospace Engineering
% 
% >>Input
%   A: Nonsingular matrix where column spans some Euclidean space.
% 
% <<Output
%   Q: matrix consisting of orthonormal basis vectors.
%   R: upper triangular matrix.
[M,N] = size(A);
Q = zeros(M,N); 
R = zeros(N,N);
Q(:,1) = A(:,1) / norm(A(:,1));
R(1,1) = dot(A(:,1), Q(:,1));

for k = 2:N
  wk = A(:,k);
  for l = 1:k-1
    tmp = dot(A(:,k), Q(:,l));
    wk = wk - tmp * Q(:,l);
    R(l,k) = tmp;
  end
  Q(:,k) = wk / norm(wk);
  R(k,k) = dot(A(:,k), Q(:,k));
end

end