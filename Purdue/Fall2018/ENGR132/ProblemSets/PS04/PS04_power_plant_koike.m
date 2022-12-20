%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program manipulates the data of ambient temperatures and the 
% corresponding power output of a power plant. Using this data a
% regression line will be plotted along with a scatter graph with 
% proper commands.
% Assigment Information
%   Assignment:     PS 04, Problem 2
%   Author:         Tomoki Koike, koike@purdue.edu
%   Team ID:        002-08
%  	Contributor:    no contributor 
%   My contributor(s) helped me:	
%     [ ] understand the assignment expectations without
%         telling me how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping me plan my solution.
%     [ ] think through the meaning of a specific error or
%         bug present in my code without looking at my code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION

% Importing the data 
plantData = csvread("Data_power_measurements.csv", 1,0); 

% Setting each column as a column vector
temp = plantData(:,1);      %The column vector for the temperatures
output = plantData(:,2);    %The column vectors for the power outputs 


%% ____________________
%% CALCULATIONS

% Calcualting the predicted values of regression line
PolyF = polyfit(temp,output,1);  
                % This calculates the least square polynominal of 
                % the given data set
PolyF_a = PolyF(1,1);
                % The slope of the regression model
PolyF_b = PolyF(1,2);
                % The y-intercept of the regression model
PolyV = polyval(PolyF,temp);
                % This returns the values of the polynominals 
                % evaluated at s-value, temp
outputAvg = mean(output);
                % Calculates the average value of the power outputs
SSE = sum((output - PolyV) .^2);
                % Caluculating the sum of squares due to error for 
                % the data
SST = sum((output - mean(output)) .^2);
                % Calculating the sum of squares for the data set
rSquare = 1 - SSE/SST;
                % This calculates the coefficient of determination


%% ____________________
%% FORMATTED TEXT & FIGURE DISPLAYS

%Printing the model equation;
fprintf("The model equation of the regression line is y = %.4fx + %.4f .\n", PolyF_a, PolyF_b);q 

% Printing the results of the SSE, SST, and r^2 on the command window
fprintf("The SSE of the regression line of the data is %.4f\n", SSE);
fprintf("The SST of the regression line of the data is %.4f\n", SST);
fprintf("The r^2 of the regression line of the data is %.4f", rSquare);


% Plotting the scatter graph and the regression line 
plot(temp,output,".r")
xlabel("Ambient Temperature (deg C)")
ylabel("Net Hourly Electrical Output (MW)")
title("The Power Output of a Power Plant by Ambient Temperature")
hold on
plot(temp,PolyV,"-b")
legend('data points','regression model',"location","northeast")
hold off

%% ____________________
%% ANALYSIS

%% -- Q1
% The least square models of the excel and the matlab are almost 
% identical; however are 0.001% different which is trivial.
% Ultimately, the coefficient of determination are both 0.903.

%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% I have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have I provided
% access to my code to another. The script I am submitting
% is my own original work.