%pendstuff.m
%
%Input-output analysis of a simple pendulum
%
%Find ue so that ye = pi/6 
%
[xe ue ye xdote] = trim('pend4',[],[],[pi/6],[],[],[1])
%
%Linearize
[A B C D] = linmod('pend4',xe,ue)
%
lambda = eig(A)
%
%Obtain transfer function for linearization
[num den]=ss2tf(A,B,C,D)
%
%Obtain poles of transfer function
poles=roots(den)
%
%Obtain zeros of transfer function
zeros=roots(num)