function [SSEmodClean1, SSEmodNoisy1, SSEmodClean2, SSEmodNoisy2] = Project_M2AlgExec_002_08(fileClean, fileNoisy)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 FINAL PROJECT
%
% Function Call
% [SSEmodClean1, SSEmodNoisy1, SSEmodClean2, SSEmodNoisy2] = Project_M2AlgExec_002_08(fileClean, fileNoisy)
%
% Input Arguments
% 1. fileClean: file name for clean data
% 2. fileNoisy: file name for noisy dsta
%
% Output Arguments
% 1. SSEmodeClean1: ‘modified’ SSE for algorithm1 of clean data 
% 2. SSEmodeNoisy1: ‘modified’ SSE for algorithm1 of noisy data
% 1. SSEmodeClean2: ‘modified’ SSE for algorithm2 of clean data 
% 2. SSEmodeNoisy2: ‘modified’ SSE for algorithm2 of noisy data
%
% Assignment Information
%   Assignment:       	M2 execution 
%   Author:             Tomoki Koike, koike@purdue.edu
%   Team ID:            002-08      
%  	Contributor: 		no contributor
%   My contributor(s) helped me:	
%     [ ] understand the assignment expectations without
%         telling me how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping me plan my solution.
%     [ ] think through the meaning of a specific error or
%         bug present in my code without looking at my code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Importing the data
M2dataClean = csvread(fileClean);
timeColClean = M2dataClean(:,1);    % put first column into column vector
                           % containing the time values
tempColClean = M2dataClean(:,2);    % put second column into column vector 
                           % containing the temperature values 

M2dataNoisy = csvread(fileNoisy);
timeColNoisy = M2dataNoisy(:,1);    % put first column into column vector
                           % containing the time values
tempColNoisy = M2dataNoisy(:,2);    % put second column into column vector 
                           % containing the temperature values 

%% Call the algorithm functions 
[yLClean1, yHClean1, tSClean1, tauClean1, stringClean1] = Project_M2Algorithm1_002_08(fileClean);
[yLNoisy1, yHNoisy1, tSNoisy1, tauNoisy1, stringNoisy1] = Project_M2Algorithm1_002_08(fileNoisy);

[yLClean2, yHClean2, tSClean2, tauClean2, stringClean2] = Project_M2Algorithm2_002_08(fileClean);
[yLNoisy2, yHNoisy2, tSNoisy2, tauNoisy2, stringNoisy2] = Project_M2Algorithm2_002_08(fileNoisy);

                           
%% Compute the SSEmod
% This step is particular to M2
% Now that we have all values yL, yH, tS, and tau, we can plug this 
%this into the y(t) equation. And then plug in the time column values 
%to get all the calculated y-values based on our code. And using these
%y-values and the y-values from the original data we can calculate the
%SSEmod.

% For algorithm 1

syms y(t)
if stringClean1 == "cooling" & stringNoisy1 == "cooling"   % cooling 
    yExpClean1 = yLClean1 + (yHClean1 - yLClean1)*...
        (exp(-(t - tSClean1)/tauClean1));
    yExpNoisy1 = yLNoisy1 + (yHNoisy1 - yLNoisy1)*...
        (exp(-(t - tSNoisy1)/tauNoisy1));
    yClean1(t) = piecewise(t<=tSClean1, yHClean1, tSClean1<t, yExpClean1);
    yNoisy1(t) = piecewise(t<=tSNoisy1, yHNoisy1, tSNoisy1<t, yExpNoisy1);
    yValsClean1 = subs(yClean1(t), t, timeColClean);
    yValsNoisy1 = subs(yNoisy1(t), t, timeColNoisy);
    SSEClean1 = sum((tempColClean - yValsClean1).^2);
    SSEmodClean1 = SSEClean1 / length(tempColClean);
    SSENoisy1 = sum((tempColNoisy - yValsNoisy1).^2);
    SSEmodNoisy1 = SSENoisy1 / length(tempColNoisy);
    
    % plotting 
    figure 
    subplot(2,1,1);
    plot(timeColClean, tempColClean, "-b");
    title( {"Clean data of the ThermoCouple", "for Cooling Process of Algorithm 1"});
    xlabel("time (s)");
    ylabel("temperature (C)");
    grid on
    hold on 
    plot(timeColClean, yValsClean1, "-r");
    hold off
    legend("original data", "equation (2)");
    subplot(2,1,2);
    plot(timeColNoisy, tempColNoisy, "-b");
    title( {"Noisy data of the ThermoCouple", "for Cooling Process of Algorithm 1"});
    xlabel("time (s)");
    ylabel("temperature (C)");
    grid on
    hold on 
    plot(timeColNoisy, yValsNoisy1, "-r");
    hold off
    legend("original data", "Alg1 equation (2)","location","northeast");

    
else                      % heating
    yExpClean1 = yLClean1 + (yHClean1 - yLClean1)*...
        (1 - exp(-(t - tSClean1)/tauClean1));
    yExpNoisy1 = yLNoisy1 + (yHNoisy1 - yLNoisy1)*...
        (1 - exp(-(t - tSNoisy1)/tauNoisy1));
    yClean1(t) = piecewise(t<=tSClean1, yLClean1, tSClean1<t, yExpClean1);
    yNoisy1(t) = piecewise(t<=tSNoisy1, yLNoisy1, tSNoisy1<t, yExpNoisy1);
    yValsClean1 = subs(yClean1(t), t, timeColClean);
    yValsNoisy1 = subs(yNoisy1(t), t, timeColNoisy);
    SSEClean1 = sum((tempColClean - yValsClean1).^2);
    SSEmodClean1 = SSEClean1 / length(tempColClean);
    SSENoisy1 = sum((tempColNoisy - yValsNoisy1).^2);
    SSEmodNoisy1 = SSENoisy1 / length(tempColNoisy);
    
    % plotting 
    figure 
    subplot(2,1,1);
    plot(timeColClean, tempColClean, "-b");
    title({"Clean data of the ThermoCouple", "for Heating Process of Algorithm 1"});
    xlabel("time (s)");
    ylabel("temperature (C)");
    grid on
    hold on 
    plot(timeColClean, yValsClean1, "-r");
    hold off
    legend("original data", "equation (1)");
    subplot(2,1,2);
    plot(timeColNoisy, tempColNoisy, "-b");
    title({"Noisy data of the ThermoCouple", "for Heating Process of Algorithm 1"});
    xlabel("time (s)");
    ylabel("temperature (C)");
    grid on
    hold on 
    plot(timeColNoisy, yValsNoisy1, "-r");
    hold off
    legend("original data", "Alg 1 equation (1)","location","southeast");
    
end
vpa(SSEmodClean1,8);
vpa(SSEmodNoisy1,8);

% For Algorithm 2

syms y(t)
if stringClean2 == "cooling" & stringNoisy2 == "cooling"   % cooling 
    yExpClean2 = yLClean2 + (yHClean2 - yLClean2)*...
        (exp(-(t - tSClean2)/tauClean2));
    yExpNoisy2 = yLNoisy2 + (yHNoisy2 - yLNoisy2)*...
        (exp(-(t - tSNoisy2)/tauNoisy2));
    yClean2(t) = piecewise(t<=tSClean2, yHClean2, tSClean2<t, yExpClean2);
    yNoisy2(t) = piecewise(t<=tSNoisy2, yHNoisy2, tSNoisy2<t, yExpNoisy2);
    yValsClean2 = subs(yClean2(t), t, timeColClean);
    yValsNoisy2 = subs(yNoisy2(t), t, timeColNoisy);
    SSEClean2 = sum((tempColClean - yValsClean2).^2);
    SSEmodClean2 = SSEClean2 / length(tempColClean);
    SSENoisy2 = sum((tempColNoisy - yValsNoisy2).^2);
    SSEmodNoisy2 = SSENoisy2 / length(tempColNoisy);
    
   % plotting 
    figure 
    subplot(2,1,1);
    plot(timeColClean, tempColClean, "-b");
    title( {"Clean data of the ThermoCouple", "for Cooling Process of Algorithm 2"});
    xlabel("time (s)");
    ylabel("temperature (C)");
    grid on
    hold on 
    plot(timeColClean, yValsClean2, "-r");
    hold off
    legend("original data", "equation (2)");
    subplot(2,1,2);
    plot(timeColNoisy, tempColNoisy, "-b");
    title( {"Noisy data of the ThermoCouple", "for Cooling Process of Algorithm 2"});
    xlabel("time (s)");
    ylabel("temperature (C)");
    grid on
    hold on 
    plot(timeColNoisy, yValsNoisy2, "-r");
    hold off
    legend("original data", "Alg2 equation (2)","location", "northeast");
    
else                      % heating
    yExpClean2 = yLClean2 + (yHClean2 - yLClean2)*...
        (1 - exp(-(t - tSClean2)/tauClean2));
    yExpNoisy2 = yLNoisy2 + (yHNoisy2 - yLNoisy2)*...
        (1 - exp(-(t - tSNoisy2)/tauNoisy2));
    yClean2(t) = piecewise(t<=tSClean2, yLClean2, tSClean2<t, yExpClean2);
    yNoisy2(t) = piecewise(t<=tSNoisy2, yLNoisy2, tSNoisy2<t, yExpNoisy2);
    yValsClean2 = subs(yClean2(t), t, timeColClean);
    yValsNoisy2 = subs(yNoisy2(t), t, timeColNoisy);
    SSEClean2 = sum((tempColClean - yValsClean2).^2);
    SSEmodClean2 = SSEClean2 / length(tempColClean);
    SSENoisy2 = sum((tempColNoisy - yValsNoisy2).^2);
    SSEmodNoisy2 = SSENoisy2 / length(tempColNoisy);
    
    % plotting 
    figure 
    subplot(2,1,1);
    plot(timeColClean, tempColClean, "-b");
    title({"Clean data of the ThermoCouple", "for Heating Process of Algorithm 2"});
    xlabel("time (s)");
    ylabel("temperature (C)");
    grid on
    hold on 
    plot(timeColClean, yValsClean2, "-r");
    hold off
    legend("original data", "Alg 2 equation (1)");
    subplot(2,1,2);
    plot(timeColNoisy, tempColNoisy, "-b");
    title({"Noisy data of the ThermoCouple", "for Heating Process of Algorithm 2"});
    xlabel("time (s)");
    ylabel("temperature (C)");
    grid on
    hold on 
    plot(timeColNoisy, yValsNoisy2, "-r");
    hold off
    legend("original data", "Alg 2 equation (1)","location","southeast");    
    
end
vpa(SSEmodClean2,8);
vpa(SSEmodNoisy2,8);


