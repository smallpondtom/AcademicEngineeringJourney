%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           PROJECT 2
% NAME: TOMOKI KOIKE
% CLASS: MA266-074
% PROFESSOR: DR. MARIANO
% 
% DESCRIPTION: THIS PROGRAM PLOTS THE GRAPH OF A RLC CIRCUIT AND 
% WITH DIFFERENT POWER SUPPLY FREQUENCIES 
% MOTION OF THE SYSTEM. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

%% 
%% INITIALIZAITON 

L = 1;     %the inductance
C = 1/5;   %the capacitance 
R = 4;     %the resistance
% E = 10*cos(omega*t);  %the power supply


%%
%% QUESTION #1
% 1. Use ode45 (and plot routines) to plot the solution of (omega) with 
% Q(0) = 0 and Q'(0) = 0 over the interval 
% 0 <= t <= 80 for omega = 0, 0.5, 1, 2, 4, 8, 16.

figure('rend','painters','pos',[10 10 900 600])
for omega = [0.1 0.5 1 2 4 8 16]
    [t,q] = ode45(@(t,q) qp(t,q,L,R,C,omega), [0,80], [0;0]);
    % plotting
    hold on
    plot(t,q(:,1),'-o');
    title('RLC Circuit');
    xlabel('time (s)');
    ylabel('Charge Q (C)');
    grid on;
end
legend('oemga=0.1','omega=0.5','omega=1','omega=2','omega=4','omega=8','omega=16','location','southwest');
hold off

%% 
%% QUESTIONS 
% 2. Let A(omega) = maximum of |Q(t)| over the interval 30 <= t <= 80 
% (this approximates the amplitude of the steady-stat solution). 
% Experiment with various values of ? and discuss what appears to 
% happen to A(omega) as omega -> infinity and as omega -> 0. Also,
% interpret your findings in terms of an equivalent spring-mass system.

%index
n=1;
omega = 0:1:100;
%setting up the vector for the omega and the amplitude 
amp_maxVector = zeros(1,numel(omega));
omegaVector = zeros(1,numel(omega));

for omega = 0:1:100
    %solving the diff eqn
    [t,q] = ode45(@(t,q) qp(t,q,L,R,C,omega), [30,80], [0;0]);
    %figuring out the maximum |Q(t)|
    max_q1_q2 = max(q);
    maxq = max_q1_q2(1,1);
    min_q1_q2 = min(q);
    minq = min_q1_q2(1,1);
    abs_minq = abs(minq);
    ampPossibleMax = [maxq, abs_minq];
    amp_max = max(ampPossibleMax);
    %inserting it into the vector
    omegaVector(n) = omega;
    amp_maxVector(n) = amp_max;
    fprintf("n=%d, omega=%f, amp=%f\n",n,omega,amp_max);
    n = n + 1;
end

plot(omegaVector, amp_maxVector, '-ob');
title("The Relation Between the Amplitude and Omega");
xlabel('omega');
ylabel('Amplitude or the Maximum Charge (C)');

% Analysis
% When the omega goes to infinity for the A(omega) function the result 
% asymptotes to 0. And when the omega goes to zero, the result of the 
% function becomes 2.

%%
%% ACADEMIC INTEGRITY 
PS07_academic_integrity_koike("Tomoki Koike");
