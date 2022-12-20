function [yL, yH, tS, tau, string] = Project_M3Algorithm_002_08(timeCol, tempCol)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 FINAL PROJECT
%
% Function Call
% [yL, yH, tS, tau, string] = Project_M3Algorithm_002_08(file)
%
% Input Arguments
% 1. file: a string of a file name that we w
%
% Output Arguments
% 1. yL: initial low temperature/asymptoting lowest temperature
% 2. yH: initial high temperature/asymptoting highest temperature
% 3. tS: the threshold t-value of the change in temperature
% 4. tau: represents the time it takes for the dependent 
%    variable to achieve a value of yTau = yL + 0.632(yH ? yL).
% 5. string: cooling or heating
%
% Assignment Information
%   Assignment:       	M3
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


%%
%% STEP ONE - Calculating yL and yH

%%%%%%%%%% For the bottom 5% to 10% of the data %%%%%%%%%%

% Calculate the point that the temperature begins 
%to change exponentially

numY = numel(tempCol);   % size the temperature vector
avgY = zeros(1,6);        % preallocate a vector containing the average 
                          %temperature values for a certain range
stdErrorY = zeros(1,6);   % preallocate a vector containing the 
                          %standard error values of temperature 
                          %values of a certain range

% A loop to find temperature values in the range of n% of the provided
%data

m = 1; % initialize counter 

for n = 0.1:-0.01:0.05     
    newTemp = tempCol(1:round(numY * n)); % the temperature values in
                                           %the range of n% of the data
    avgY(m) = mean(newTemp);               % finding the average of the 
                                           %temperatures in newTemp
    stdErrorY(m) = std(newTemp) / sqrt(length(newTemp));
                                           % finding the standard error
                                           %of the temperatures in 
                                           %newTemp
    m = m+1;                               % increment the counter 
end

% Finding the indices in which the standard errors of the newTemp
%are less than 0.1 (0.1 is arbitrary; however, is the a value that 
%ensures the least necessary validity of the data to figure out the
%yL and yH). Then find the average temperature values in the avgY 
%vector that corresponds to the indices found in the previous step.
foundStdY = find(stdErrorY < 0.1);
optimalAvgY = avgY(foundStdY);

% Take the average of the optimal average value of standard error <0.1,
%which is equivalent to yL and yH.
y1 = mean(optimalAvgY);   

 
    
%%%%%%%%%% For the top 10% to 5% of the data %%%%%%%%%%

% This is identical to the bottom 5% to 10% except that the range of 
%the data we must probe is between 90% to 100%

numY = numel(tempCol);
avgY = zeros(1,6);
stdErrorY = zeros(1,6);

m = 1;

for n = 0.9:0.01:0.95
    newTemp = tempCol(round(numY*n) : numY);  
    avgY(m) = mean(newTemp);
    stdErrorY(m) = std(newTemp) / sqrt(length(newTemp));
    m = m+1;
end

foundStdY = find(stdErrorY < 0.1);
optimalAvgY = avgY(foundStdY);

y2 = mean(optimalAvgY);   

% The statement below shuffles the y1 and y2 values that we have 
%obtained to match it with the data in which the data represents 
%either the heating or the cooling process
if y1 > y2   % cooling 
    yH = y1;
    yL = y2;
    string = "cooling";
else         % heating
    yH = y2;
    yL = y1;
    string = "heating";
end


%%
%% STEP TWO - Finding the tS value

% For this step we use the yL and yH values that we have figured out
%in the previous step

% Finding the indices for the values in the data set that are equal 
%to yL. Then finding the highest index value. 
yLowRange = find(tempCol >= (yL - 0.5) & tempCol <= (yL + 0.5)); 
if y1 > y2   % cooling
    yLowLimit = min(yLowRange);
else         % heating 
    yLowLimit = max(yLowRange);
end

% Do the same for the upper limit. And by retrieving the upper and 
%lower bounds of these we are able to find a decent range of the 
%temperature values to use in the following procedures
yHighRange = find(tempCol >= (yH - 0.5) & tempCol <= (yH + 0.5));
if y1 > y2   % cooling 
    yHighLimit = max(yHighRange);
else
    yHighLimit = min(yHighRange);
end

% the range of temperature values to scrutinize
if y1 > y2   % cooling
    tempRange = tempCol(yHighLimit : yLowLimit);
else         % heating
    tempRange = tempCol(yLowLimit : yHighLimit);
end

slope = zeros(1, yHighLimit - yLowLimit + 1); % preallocating a vector
                                              %which will contain the 
                                              %slope values
if y1 > y2   % cooling 
    for n = 1:(yLowLimit - yHighLimit)
        % finding the time values that correspond with the 
        %temperature range
        timeValues = timeCol(yHighLimit : yLowLimit);
        % calculating the slopes 
        slope(n) = (tempRange(n+1) - tempRange(n)) / ...
            (timeValues(n+1) - timeValues(n));
    end
else         % heating
    for n = 1:(yHighLimit - yLowLimit)
        % finding the time values that correspond with the 
        %temperature range
        timeValues = timeCol(yLowLimit : yHighLimit);
        % calculating the slopes 
        slope(n) = (tempRange(n+1) - tempRange(n)) / ...
            (timeValues(n+1) - timeValues(n));
    end
end

% In the next step, if the data is for a heating process, we must rule
%out the slopes with negative values, and if it is a cooling process 
%we will need to rule out the slopes with positive values 

if y1 > y2    % cooling 
    validSlopes = slope(slope < 0);
else          % heating 
    validSlopes = slope(slope > 0);
end

% Then, obtaining the valid slopes we are going to take the average of
% those sloeps to find an approximate linear equation 

% y = m*x + b1
avgSlope = mean(validSlopes);  % m

% y-intercept b1 will be
intercept1 = tempCol(yLowLimit) - avgSlope*timeCol(yLowLimit);
% First equation is y = avgSlope*x + intercept1

% y = m*x + b2
intercept2 = tempCol(yHighLimit) - avgSlope*timeCol(yHighLimit);

% Finally we calculate the tS for either the cooling or heating 
% process

if y1 > y2   % cooling 
    tS = (yH - intercept2) / avgSlope;
else         % heating 
    tS = (yL - intercept1) / avgSlope;
end

%%
%% STEP THREE - Compute Tau

% This step is fairly simple in that we have figured all the other
%three variables that we need. First, what we do is plug the yL and 
%yH into the equation yTau = yL + 0.632(yH - yL), and solve for yTau.

yTau = yL + 0.632*(yH - yL);

% Then to find the corresponding time value to yTau we figure out the
%indices in the temperature vector where the values are within the 
%error of n degrees from yTau. And find the time values that correspond
%to those indices.
% First we will find the error n. Then plugging that as errorN 
%into a operation of finding the corresponding y-values.

if y1 > y2     % cooling
    ct = 0; % counter initialization
    probDensLow = -1; % initialization 
    probDensHigh = -1; % initialization
    while ((probDensLow < 0.0102) & (probDensHigh < 0.0102)) 
        pd = fitdist(tempCol, 'Normal');
        y = [(yTau - ct), yTau, (yTau + ct)];
        probDens = pdf(pd, y);
        probDensLow = probDens(1,1);
        probDensHigh = probDens(1,3);
        ct = ct + 1;
    end
    tauCorrespondIndex = find((yTau - ct)<=tempCol &...
        tempCol <= (yTau + ct));
else           % heating
    ct = 0; % counter initialization
    probDensLow = -1; % initialization 
    probDensHigh = -1; % initialization
    while ((probDensLow < 0.0102) & (probDensHigh < 0.0102)) 
        pd = fitdist(tempCol, 'Normal');
        y = [(yTau - ct), yTau, (yTau + ct)];
        probDens = pdf(pd, y);
        probDensLow = probDens(1,1);
        probDensHigh = probDens(1,3);
        ct = ct + 1;
    end
    tauCorrespondIndex = find((yTau - ct)<=tempCol &...
        tempCol <= (yTau + ct));
end

% find the time values for these indices 
tTauValues = timeCol(tauCorrespondIndex);

% solve the equation for tau and t
syms t tau
eqn = yTau == yL + (yH - yL)*(1 - exp(-(t - tS)/tau));
solTau = solve(eqn, tau);

% plug in the t values as tTauValues
% and approximate the answer
syms t
allTau = subs(solTau, t, max(tTauValues));
tau = mean(allTau);
tau = vpa(tau,6);

%%
%% STEP FOUR - Compute the SSEmod

% This step is particular to M2
% Now that we have all values yL, yH, tS, and tau, we can plub this 
%this into the y(t) equation. And then plug in the time column values 
%to get all the calculated y-values based on our code. And using these
%y-values and the y-values from the original data we can calculate the
%SSEmod.

syms y(t)
if y1 > y2    % cooling 
    yExp = yL + (yH - yL)*(exp(-(t - tS)/tau));
    y(t) = piecewise(t<=tS, yH, tS<t, yExp); 
    yVals = subs(y(t), t, timeCol);
    SSE = sum((tempCol - yVals).^2);
    SSEmod = SSE / length(tempCol);
else          % heating 
    yExp = yL + (yH - yL)*(1 - exp(-(t - tS)/tau));
    y(t) = piecewise(t<=tS, yL, tS<t, yExp); 
    yVals = subs(y(t), t, timeCol);
    SSE = sum((tempCol - yVals).^2);
    SSEmod = SSE / length(tempCol);
end

%fprintf("\nThe SSEmod for algorithm 1 is -> %f\n\n", SSEmod);

%%
%% ACADEMIC INTEGRITY 

PS07_academic_integrity_koike(["Tomoki Koike" "Yi Zhou" "Eu Jin Lee" "Ian Pitman"]);


