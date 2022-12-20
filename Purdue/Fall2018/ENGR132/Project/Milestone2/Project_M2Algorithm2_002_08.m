function [yL, yH, tS, tau, string] = Project_M2Algorithm2_002_08(file)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 FINAL PROJECT
%
% Function Call
% [yL, yH, tS, tau] = Project_M2Algorithm2_002_08(file)
%
% Input Arguments
% 1. filename: a string of a file name that we want to import
%
% Output Arguments
% 1. yL: initial low temperature/asymptoting lowest temperature
% 2. yH: initial high temperature/asymptoting highest temperature
% 3. tS: the threshold t-value of the change in temperature
% 4. tau: represents the time it takes for the dependent 
%    variable to achieve a value of yTau = yL + 0.632(yH ? yL).
% Assignment Information
%   Assignment:       	M2, Algorithm1 2
%   Author:             Yi Zhou, zhou823@purdue.edu
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



%---------------------------------------------------------------------------
%import data
%file = 'M2_Data_Calibration_HeatingNoisy.csv';   a sample to call it

M2data = csvread(file);
time = M2data(:,1);    %put first column into column vector named time
temperature = M2data(:,2);  %put second column into column vector named temperature

%--------------------------------------------------------------------------
%Calculating yL and yH
% For the bottom 5% to 10% of the data %
% calculat the point that the temperature begin to change drastically

numy = numel(temperature);   %get the size of temperature vector
avgY = zeros(1,6);   %create a vector with zero
stdY = zeros(1,6);   %create a vector with zero
m = 1; % initialize counter 
for n = [0.1:-0.01:0.05]     
    newtemp = temperature(1:round(numy * n));    % the temperature values in
                                                 %the range of n% of the data
    avgY(m) = mean(newtemp);                     % average of the temperatures in newTemp
    stdY(m) = std(newtemp) / sqrt(length(newtemp));%  the standard error of the temperatures in newTemp
                                                 
    m = m+1;  %increment 1
end

% get the indices that the standard errors of the newTemp
%are less than 0.1 Then find the average temperature values in the avgY 
%vector that corresponds to the indices found in the previous step.
foundstdY = find(stdY < 0.1);
optimalavgY = avgY(foundstdY);

y1 = mean(optimalavgY);   %y1 is the point that the temperature begin to change drastically
    
% For the top 10% to 5% of the data 

% This is identical to the bottom 5% to 10% except that the range of 
%the data we must probe is between 90% to 100%

numy = numel(temperature);
avgY = zeros(1,6);
stdY = zeros(1,6);
m = 1;
for n = [0.9:0.01:0.95]
    newtemp = temperature(round(numy*n) : numy);
    
    avgY(m) = mean(newtemp);
    stdY(m) = std(newtemp) / sqrt(length(newtemp));
    m = m+1;
end


foundstdY = find(stdY < 0.1);
optimalavgY = avgY(foundstdY);

y2 = mean(optimalavgY);   %y2 is the point that the temperature begin to be constant

% going to find whether the data is heating or cooling
if y1 > y2   %cooling
    yH = y1;
    yL = y2;
else         %heating
    yH = y2;
    yL = y1;
end

yH;
yL;


%-------------------------------------------------------------------------
%Finding the tS value

%calculate ts by finding the time of yH(cooling) or yL(heating)
if y1 > y2   %for cooling
    position = find(round(temperature) == round(yH), 1,'last');
    tS = time(position);
    string = "cooling";
else      %for heating
    position = find(round(temperature) == round(yL), 1,'last');
    tS = time(position);
    string = "heating";
end
    
tS;
%-------------------------------------------------------------------------
%Compute Tau
%calculate tau by finding ytau first based on equation, than find the time
%corresponding to ytau called tf, tau equal to tf - ts
ytau = yL + 0.632 * (yH - yL);
position2 = find(round(temperature) == round(ytau),1,'last');
tf = time(position2);

tau = tf - tS;

%-------------------------------------------------------------------------
% Compute the SSEmod
% plug yL, yH, tS, and tau into the y(t) equation. And then plug in the time column values 
%to get all the calculated y-values based on our code. And using these
%value to calculate the SSEmod.

syms y(t)
if y1 > y2    % cooling 
    yExp = yL + (yH - yL)*(exp(-(t - tS)/tau));
    y(t) = piecewise(t<=tS, yH, tS<t, yExp); 
    yVals = subs(y(t), t, time);
    SSE = sum((temperature - yVals).^2);
    SSEmod = SSE / length(temperature);
else
    yExp = yL + (yH - yL)*(1 - exp(-(t - tS)/tau));
    y(t) = piecewise(t<=tS, yL, tS<t, yExp); 
    yVals = subs(y(t), t, time);
    SSE = sum((temperature - yVals).^2);
    SSEmod = SSE / length(temperature);
end

%fprintf("\nThe SSEmod for algorithm 2 is -> %f\n\n", SSEmod);


%%
%% ACADEMIC INTEGRITY 

%PS07_academic_integrity_koike(["Tomoki Koike" "Yi Zhou" "Eu Jin Lee" "Ian Pitman"]);

