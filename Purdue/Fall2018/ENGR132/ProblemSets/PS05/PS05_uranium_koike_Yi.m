%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program aims to test an amidoxime-based fabric for uranium
% adsorption by submerging several samples of fiber in to tanks filled 
% with uranimum spiked solutions. We are going to model a regression 
% line with the given data.
%
% Assigment Information
%   Assignment:			PS 05, Problem 1
%   Author:				Tomoki Koike koike@purdue.edu
%   Team ID:			002-08
%   Paired Partner:		Yi Zhou, zhou823@purdue.edu
%   Contributor:		none
%   Our contributor(s) helped us:	
%     [ ] understand the assignment expectations without
%         telling us how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping us plan our solution.
%     [ ] think through the meaning of a specific error or
%         bug present in our code without looking at our code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% ____________________
%% INITIALIZATION

% loading data
uraniumData = csvread("Data_uranium_adsorption.csv", 1,0);

% setting the columns varaiables
time = uraniumData(:,1);     % the time column of the data set
uranTake = uraniumData(:,2); % the uranium uptake of the data set


%% ____________________
%% SUBPLOT FIGURE

% plotting the 2*2 plot of linear, semilogx, semilogy, and loglog
% for given data
figure
subplot(2,2,1)
plot(time, uranTake,"xb");
xlabel("time (hours)");
ylabel({'Uranium Uptake'; '(micrograms U/grams absorbent)'});
title("linear");
set(gca,'fontsize',8);
grid on
grid minor

subplot(2,2,2)
semilogx(time, uranTake,"xb");
xlabel("time (hours)");
ylabel({'Uranium Uptake'; '(micrograms U/grams absorbent)'});
title("semilog x");
set(gca,'fontsize',8);
grid on
grid minor

subplot(2,2,3)
semilogy(time, uranTake,"xb");
xlabel("time (hours)");
ylabel({'Uranium Uptake'; '(micrograms U/grams absorbent)'});
title("semilog y");
set(gca,'fontsize',8);
grid on
grid minor


subplot(2,2,4)
loglog(time, uranTake,"xb");
xlabel("time (hours)");
ylabel({'Uranium Uptake'; '(micrograms U/grams absorbent)'});
title("log log");
set(gca,'fontsize',8);
grid on
grid minor

%% ____________________
%% LINEARIZATION

logTime = log10(time);         % transforming the x values to log
logUranTake = log10(uranTake); % transforming the y values to log

% manipulating the linear regression
pfit = polyfit(logTime, logUranTake,1);  % slope and y-intercept
slope = pfit(1,1);                       % slope value
yInter = pfit(1,2);                      % y-intercept value
pval = polyval(pfit,logTime);            % the y-values corresponding 
                                         % to the regression line

fprintf("The linear regression line for the data set is y = %.3fx + %.3f .",slope, yInter);
                % prining the linear model on the command window

% plotting the transformed data points with the predicted linear model
figure
plot(logTime,logUranTake, "xr",'DisplayName','logarthmic data points')
title({'The the Linearized data and the trend line' ;'for the logarthmically transformed data set'})
xlabel('time (hours)')
ylabel({'Uranium Uptake'; '(micrograms U/grams absorbent)'});
grid on 
grid minor 
set(gca,'FontSize',8)
hold on
plot(logTime,pval,"-b",'DisplayName','trend line')
hold off 
legend('location','northwest')

%% ____________________
%% UPTAKE MODEL

% Because the linear regression model is 
% log(y) = a*log(x) + b    //a and b are calculated by polyfit
% by manipulating this formula we can get 
% y = 10^b*x^a

genFormX = time;        
        % the x-values for the general form 
genFormY = 10.^(yInter).*(genFormX).^(slope);
        % the y-values for the general form
fprintf("The general form of the best fit equation is y = 10^(%.3f)*x^(%.3f) .",yInter, slope);
        % printing the equation on the command window
        
% plotting the general form of the equation for the data
figure
plot(genFormX,genFormY,"-r")
title('General Form Equation for the Given Data Set')
xlabel('time (hours)')
ylabel({'Uranium Uptake'; '(micrograms U/grams absorbent)'})
grid on 
grid minor 
set(gca,'FontSize',8)


%% ____________________
%% PREDICTIONS

% prediction for 10, 100, and 250 hours
predictionHr = [10 ; 100 ; 250];
predictionVal = 10.^(yInter).*(predictionHr).^(slope);


%% ____________________
%% ANALYSIS

%% -- Q1
% The type of function that best represents the data is the power 
% function because the data points line up the most clearly as a 
% linear function with having both x and y values in logarithmic 
% scale.


%% -- Q2
% The uranium uptake for 10, 100, and 250 hours is 74.6197, 196.3796,
% and 288.6208 respectively. From the prediction values and the 
% visual figure of the general form of the equation provides the 
% fact that the rate of increase is decreasing as the x-values 
% increases. 
% Due to this decrease in the tangent as time approaches infinity,
% the uranium uptake will be difficult to calculate with values that
% correspond to time that are very large values.



%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% We have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have we provided
% access to our code to another. The script we are submitting
% is our own original work.