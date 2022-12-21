function [x, iter] = cgsolve(H, b, tol, maxiter)
% CGSOLVE: Conjugate gradient algorithm for solving Hx = b.
% Author: Tomoki Koike 
% Organization: Georgia Institute of Technology, Aerospace Engineering
% Date: 10/26/2022
% 
% >>Inputs
%   H: NxN symmetric positive definite matrix.
%   b: vector of length N.
%   tol: tolerance for the halting condition.
%   maxiter: maximum number of iterations to perform.
% 
% <<Outputs
%   x: Solution of the gradient descent which is a vector of length N.
%   iter: Actual performed number of iterations.

%% Verify that the input matrix is a symmetric positive definte matrix
is_symm = issymmetric(H);
[~,D] = eig(H);  % eigendecomposition
is_pd = all(diag(D) > 0);
if ~is_symm || ~is_pd
  error("Input matrix H is not symmetric positive definite.");
end

% Verify that the dimension of H and b agree
% if b is a row vector first fix it to a column vector 
[m,n] = size(b);
if (m==1) && (n>1)
  b = b.';  % transpose
end
[M,~] = size(H);
if m ~= M
  error("Dimensions of the H matrix and b vector must agree.");
end
clear m n

%% Initial conditions
xk = randn(M,1);  % initial guess
rk = b - H * xk;
dk = rk;  % basis
iter = 0;
bnorm = norm(b);

%% Algorithm
while (norm(rk) / bnorm)>=tol
  q = H * dk;
  p = rk.' * rk;

  alphak = p / (dk.' * q);
  xk = xk + alphak * dk;  % update solution vector x at k+1 = k
  rkp1 = rk - alphak * q;  % compute the k+1 residual vector
  
  betak = (rkp1.' * rkp1) /  p;
  dk = rkp1 + betak * dk;  % update the basis vector d at k+1 = k

  rk = rkp1;  % update residual vector at k+1 = k
  
  if iter > maxiter
    break;
  end
  iter = iter + 1;  % count iteration
end

%% Solution
x = xk;

end