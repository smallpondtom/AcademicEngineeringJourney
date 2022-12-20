%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
%   This program manipulates the data that is targeted to figure out 
%   the global mean sea level which is a indicator of the sea level 
%   rise. Specifically, the program compares the regression lines of 
%   the data points of two different measurement methods: tide gauge 
%   and satellite-based altimeters.
% Assigment Information
%   Assignment:     PS 04, Problem 3
%   Author:         Tomoki Koike, koike@purdue.edu
%   Team ID:        008-02
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

% Importing the two datas
tideGaugeData = csvread('Data_CSIRO_gmsl_mo_2013.csv', 1,0);   
                               % tide gauge 
altmData = load('Data_NASA_altimeter_gmsl_meas.txt');
                               % altimeter

% Setting the relevant columns in the data as column vectors
TG_year = tideGaugeData(:,1);  % The year columns of the time 
                               % gauge data
TG_gmsl = tideGaugeData(:,2);  % The GMSL columns of the time 
                               % gauge data
altm_year = altmData(:,2);     % The year columns of the satellite
                               % -based altimeter data
altm_gmsl = altmData(:,5);     % The GMSL columns of the satellite
                               % -based altimeter data

% Manipulating the column vectors to find the data corresponding the 
% 1993 to 2013 time span
% tide gauge
TG93_13_year = TG_year(1993<=TG_year & TG_year<=2013);
TG93_13_index = find(1993<=TG_year & TG_year<=2013);
TG93_13_gmsl = TG_gmsl(TG93_13_index);
% satellite-based altimeter
altm93_13_year = altm_year(1993<=altm_year & altm_year<=2013);
altm93_13_index = find(1993<=altm_year & altm_year<=2013);
altm93_13_gmsl = altm_gmsl(altm93_13_index);

%% ____________________
%% CALCULATIONS

% Computing the best fit regression line for each of the data set, and
% calculating the SSE, SST, and coefficient of determination
% tide gauge 
TG_pFit = polyfit(TG93_13_year,TG93_13_gmsl,1);
TG_pVal = polyval(TG_pFit,TG93_13_year);
TG_pVal_a = TG_pFit(1,1);
TG_pVal_b = TG_pFit(1,2);
TG_gmsl_mean = mean(TG93_13_gmsl);
TG_SSE = sum((TG93_13_gmsl - TG_pVal).^2);
TG_SST = sum((TG93_13_gmsl - TG_gmsl_mean).^2);
TG_rSquare = 1 - TG_SSE / TG_SST;
% Satellite-based altimeter 
altm_pFit = polyfit(altm93_13_year,altm93_13_gmsl,1);
altm_pVal = polyval(altm_pFit,altm93_13_year);
altm_pVal_a = altm_pFit(1,1);
altm_pVal_b = altm_pFit(1,2);
altm_gmsl_mean = mean(altm93_13_gmsl);
altm_SSE = sum((altm93_13_gmsl - altm_pVal).^2);
altm_SST = sum((altm93_13_gmsl - altm_gmsl_mean).^2);
altm_rSquare = 1 - altm_SSE / altm_SST;


%% ____________________
%% FIGURE DISPLAY

% The plotting of the graph for the tide gauge data 
figure
subplot(2,1,2)
scatter(TG93_13_year,TG93_13_gmsl,".b")
title("The Global Mean Sea Level By the method of Tide Gauge")
xlabel("year")
ylabel("Global Mean Sea Level (mm)")
grid on
grid minor 
hold on 
plot(TG93_13_year,TG_pVal,"-r")
legend('data points','regression line','location','northwest')
hold off 
% Plotting the scattered data points and the regression model
% for the satellite-based altimeter
subplot(2,1,1)
scatter(altm93_13_year,altm93_13_gmsl,".b")
title("The Global Mean Sea Level By the method of satellite-based alimeter")
xlabel("year")
ylabel("Global Mean Sea Level (mm)")
grid on
grid minor 
hold on 
plot(altm93_13_year,altm_pVal,"-r")
legend('data points','regression line','location','northwest')
hold off 

%% ____________________
%% TEXT DISPLAY

% Displaying the results on the command window
fprintf("The regression model for the satellite-based altimeter measurement is y = %.4fx + %.4f .\n", altm_pVal_a, altm_pVal_b);
fprintf("The regression model for the tide gauge measurement is y = %.4fx + %.4f .\n", TG_pVal_a, TG_pVal_b);
fprintf("The SSE for the satellite-based altimeter measurement is %.4f .\n", altm_SSE);
fprintf("The SSE for the tide gauge measurement is %.4f .\n", TG_SSE);
fprintf("The SST for the satellite-based altimeter measurement is %.4f .\n", altm_SST);
fprintf("The SST for the tide gauge measurement is %.4f .\n", TG_SST);
fprintf("The coefficient of determinant of the satellite-based altimeter measurement is %.4f .\n", altm_rSquare);
fprintf("The coefficient of determinant of the tide gauge measurement is %.4f .\n", TG_rSquare);




%% ____________________
%% ANALYSIS

%% Q1
% Given the coefficient of determination from the data of each 
% measurements it is clear that both measurements have relatively 
% a highly accurate regression model. When comparing the two the 
% coefficient of determination of the satellite-based altimeter 
% is statistically accurate because its value is closer to 1.

%% Q2
% The variation of data is much more evident in the data set of the 
% tide gauge measurement becuase the coefficient of determination is 
% lower. This is because R^2 (coefficient of determination) is 
% specifically the ratio of data that are certain, and if that ratio
% is low the amount of variation is higher due to more deviation from
% the regresson model.

%% Q3
% From the slope of each regression model the tide gauge has a higher
% slope meaning that the tide gauge has a higher rate of global mean 
% sea level rise.

%% Q4
% By plugging in 2019 as the x-value for both regression models of 
% of the satellite-based altimeter and the tide gauge the estimation
% of the GMSL is possible. For the former the result is 39.8019 and 
% the for the latter the result is 91.4480. This shows the predicted 
% GMSL for the tide gauge is indicating three times  than that of the
% satellite-based altimeter.

%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% I have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have I provided
% access to my code to another. The script I am submitting
% is my own original work.

