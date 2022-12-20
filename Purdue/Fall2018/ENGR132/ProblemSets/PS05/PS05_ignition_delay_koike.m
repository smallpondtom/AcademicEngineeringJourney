%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program delves into the ignition delay of a turbine engine which
% is the time interval between the fuel enter the compressor and the 
% fuel to actually combust. Mainly, the relation between the 
% temperature and the ignition delay is modelled graphically for two
% different types of fuels.
% Assigment Information
%   Assignment:     PS 05, Problem 2
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
dieselData = csvread("Data_diesel_ignition_delay.csv",1,0);
            % the data for the diesel #2 fuel
jetData = csvread("Data_jetA_ignition_delay.csv",1,0);
            % the data for the jet-A fuel
            
% setting variables for the columns in the data 
% the diesel data
dieselTemp = dieselData(:,1);   % the temperature factor 1000/T (K^-1) 
dieselDel = dieselData(:,2);    % the ignition delay (msec)
% the jet fuel data 
jetTemp = jetData(:,1);         % the temperature factor 1000/t (K^-1)
jetDel = jetData(:,2);          % the ignition delay (msec)


%% ____________________
%% SUBPLOT FIGURE(S)

% plotting the two data sets together in the form of linear, semilogX,
% semilogY, and loglog
figure
% the subplot for the linear graph
subplot(2,2,1)
plot(dieselTemp,dieselDel,"or")
title('linear')
xlabel('1000/T (K^{-1})')
ylabel('Ignition Delay (msec)')
grid on
grid minor
hold on
plot(jetTemp,jetDel,"xb")
hold off
legend('diesel data','jetA data','location','northwest')

% the subplot for the semilogx
subplot(2,2,2)
semilogx(dieselTemp,dieselDel,"or")
title('Semilog X')
xlabel('1000/T (K^{-1})')
ylabel('Ignition Delay (msec)')
grid on
grid minor
hold on
semilogx(jetTemp,jetDel,"xb")
hold off
legend('diesel data','jetA data','location','northwest')

% the subplot for the semilogy
subplot(2,2,3)
semilogy(dieselTemp,dieselDel,"or")
title('Semilog Y')
xlabel('1000/T (K^{-1})')
ylabel('Ignition Delay (msec)')
grid on
grid minor
hold on
semilogy(jetTemp,jetDel,"xb")
hold off
legend('diesel data','jetA data','location','northwest')

% the subplot for the loglog 
subplot(2,2,4)
loglog(dieselTemp,dieselDel,"or")
title('Loglog')
xlabel('1000/T (K^{-1})')
ylabel('Ignition Delay (msec)')
grid on
grid minor
hold on
loglog(jetTemp,jetDel,"xb")
hold off
legend('diesel data','jetA data','location','northwest')


%% ____________________
%% LINEARIZATION

% transforming the y-values to log(y)
% diesel
dieselLogDel = log10(dieselDel);
% jetA
jetLogDel = log10(jetDel);

% manipulating the linear regression
% diesel 
pfitDiesel = polyfit(dieselTemp,dieselLogDel,1);
            % finding the slope and the y-intercept for the 
            % regression line 
dieselSlope = pfitDiesel(1,1);
            % the slope value
dieselY_incpt = pfitDiesel(1,2);
            % the y-intercept value
pvalDiesel = polyval(pfitDiesel,dieselTemp);
            % the y-values corresponding to the x-values on the 
            % modeled regression line 
% jetA
pfitJet = polyfit(jetTemp,jetLogDel,1);
            % finding the slope and the y-intercept for the 
            % regression line 
jetSlope = pfitJet(1,1);
            % the slope value
jetY_incpt = pfitJet(1,2);
            % the y-intercept value
pvalJet = polyval(pfitJet,jetTemp);
            % the y-values corresponding to the x-values on the 
            % modeled regression line 
            
% printing the predicted regression model equation
fprintf("The linear regression line for the diesel data set is y = %.3fx + %.3f .\n", dieselSlope, dieselY_incpt);
fprintf("The linear regression line for the jetA data set is y = %.3fx + %.3f .\n", jetSlope, jetY_incpt);

% plotting the linearized data and the trend line for the two data sets 
figure
plot(dieselTemp,pvalDiesel,"-or")
title('The Linearized Model of the Diesel and JetA Data Set')
xlabel('1000/T (K^{-1})')
ylabel('Ignition Delay (msec)')
grid on
grid minor
hold on
plot(jetTemp,pvalJet,"-xb")
hold off
legend('diesel data','jetA data','location','northwest')




%% ____________________
%% MODEL

% Because the linear regression model is 
% log10(y) = a*x + b    //a and b are calculated by polyfit
% by manipulating this formula we can get 
% y = 10^(ax+b)

% printing and plotting the general equation (best fit curve) for 
% each data set
% diesel
dieselGenFormX = dieselTemp;        
        % the x-values for the general form 
dieselGenFormY = 10.^(dieselSlope*dieselGenFormX + dieselY_incpt);
        % the y-values for the general form
fprintf("\nThe general form of the best fit equation is y = 10^(%.3dx+%.3d) .",dieselSlope, dieselY_incpt);
        % printing the equation on the command window
% jet
jetGenFormX = jetTemp;        
        % the x-values for the general form 
jetGenFormY = 10.^(jetSlope*jetGenFormX + jetY_incpt);
        % the y-values for the general form
fprintf("\nThe general form of the best fit equation is y = 10^(%.3dx+%.3d) .\n",jetSlope, jetY_incpt);
        % printing the equation on the command window
        
% plotting 
% diesel
figure
plot(dieselGenFormX,dieselGenFormY,"-or")
title('The Best Fit Curve of the Diesel Data Set')
xlabel('1000/T (K^{-1})')
ylabel('Ignition Delay (msec)')
grid on
grid minor

% jetA
figure
plot(jetGenFormX,jetGenFormY,"-xb")
title('The Best Fir Curve of the JetA Data Set')
xlabel('1000/T (K^{-1})')
ylabel('Ignition Delay (msec)')
grid on
grid minor

%% ____________________
%% ANALYSIS

%% -- Q1
% The model of the semilog y is possibly the best data representing 
% model because the scattered data points line up linearly the best
% and also the x axis scaling does not have much difference by 
% transforming the x-values to log(x). Namely, the normal x axis spans
% x-values from approximately 1.12 to 1.84, whereas the log(x) x axis 
% spans x-values from approximately 0 to 1.82. This means that 
% transforming the x to log(x) is unecessary.


%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% I have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have I provided
% access to my code to another. The script I am submitting
% is my own original work.