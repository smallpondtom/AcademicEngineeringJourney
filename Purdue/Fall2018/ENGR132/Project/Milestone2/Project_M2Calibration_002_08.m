function Project_M2Calibration_002_08(fileCleanheat, fileNoisyheat, fileCleancool, fileNoisycool)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 FINAL PROJECT
%
% Function Call
% [] = Project_M2Calibration_002_08(fileClean, fileNoisy)
%
% Input Arguments
% 1. fileCleanheat: file name for heating clean data
% 2. fileNoisyheat: file name for heating noisy data
% 3. fileCleancool: file name for cooling clean data
% 4. fileNoisycool: file name for cooling noisy data
%
% Output Arguments
% none
%
% Assignment Information
%   Assignment:       	M2 calibration
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
%sample of calling
%fileCleanheat = "M2_Data_Calibration_HeatingClean.csv"
%fileNoisyheat = "M2_Data_Calibration_HeatingNoisy.csv"
%fileNoisycool = "M2_Data_Calibration_CoolingNoisy.csv"
%fileCleancool = "M2_Data_Calibration_CoolingClean.csv"


% import file 
M2dataCleanheat = csvread(fileCleanheat);
timeColCleanheat = M2dataCleanheat(:,1);    % put first column into column vector
                           % containing the time values
tempColCleanheat = M2dataCleanheat(:,2);    % put second column into column vector 
                           % containing the temperature values 

M2dataCleancool = csvread(fileCleancool);
timeColCleancool = M2dataCleancool(:,1);    % put first column into column vector
                           % containing the time values
tempColCleancool = M2dataCleancool(:,2);    % put second column into column vector 
                           % containing the temperature values 

                                                      
M2dataNoisyheat = csvread(fileNoisyheat);
timeColNoisyheat = M2dataNoisyheat(:,1);    % put first column into column vector
                           % containing the time values
tempColNoisyheat = M2dataNoisyheat(:,2);    % put second column into column vector 
                           % containing the temperature values 
       
                           
M2dataNoisycool = csvread(fileNoisycool);
timeColNoisycool = M2dataNoisycool(:,1);    % put first column into column vector
                           % containing the time values
tempColNoisycool = M2dataNoisycool(:,2);    % put second column into column vector 
                           % containing the temperature values 
                           
%--------------------------------------------------------------------

%import calibration parameter values

yLcleanheat = 0;
yLnoisyheat = -0.64;
yHcleanheat = 100;
yHnoisyheat = 99.36;
tScleanheat = 1.5;
tSnoisyheat = 1.5;
taucleanheat = 0.31;
taunoisyheat = 1.65;

yLcleancool = 0.94;
yLnoisycool = -0.21;
yHcleancool = 100;
yHnoisycool = 98.81;
tScleancool = 1.5;
tSnoisycool = 1.5;
taucleancool = 1.82;
taunoisycool = 1.12;

%-------------------------------------------------------------------------
%figure 1, cooling data
syms y(t)
    yExpCleancool = yLcleancool + (yHcleancool - yLcleancool)*...
        (exp(-(t - tScleancool)/taucleancool));
    yExpNoisycool = yLnoisycool + (yHnoisycool - yLnoisycool)*...
        (exp(-(t - tSnoisycool)/taunoisycool));
    yCleancool(t) = piecewise(t<=tScleancool, yHcleancool, tScleancool<t, yExpCleancool);
    yNoisycool(t) = piecewise(t<=tSnoisycool, yHnoisycool, tSnoisycool<t, yExpNoisycool);
    yValsCleancool = subs(yCleancool(t), t, timeColCleancool);
    yValsNoisycool = subs(yNoisycool(t), t, timeColNoisycool);
    
     % plotting 
    figure 
    subplot(2,1,1);
    plot(timeColCleancool, tempColCleancool, "-b");
    title( {"Clean data for cooling process"});
    xlabel("time (s)");
    ylabel("temperature (C)");
    grid on
    hold on 
    plot(timeColCleancool, yValsCleancool, "-r");
    hold off
    legend("original data", "equation (2)");
    subplot(2,1,2);
    plot(timeColNoisycool, tempColNoisycool, "-b");
    title( {"Noisy data for cooling process"});
    xlabel("time (s)");
    ylabel("temperature (C)");
    grid on
    hold on 
    plot(timeColNoisycool, yValsNoisycool, "-r");
    hold off
    legend("original data", "calibration equation","location","northeast");
    
    %---------------------------------------------------------------------
   %figure2 heating data
   
   yExpCleanheat = yLcleanheat + (yHcleanheat - yLcleanheat)*...
        (1 - exp(-(t - tScleanheat)/taucleanheat));
    yExpNoisyheat = yLnoisyheat + (yHnoisyheat - yLnoisyheat)*...
        (1 - exp(-(t - tSnoisyheat)/taunoisyheat));
    yCleanheat(t) = piecewise(t<=tScleanheat, yLcleanheat, tScleanheat<t, yExpCleanheat);
    yNoisyheat(t) = piecewise(t<=tSnoisyheat, yLnoisyheat, tSnoisyheat<t, yExpNoisyheat);
    yValsCleanheat = subs(yCleanheat(t), t, timeColCleanheat);
    yValsNoisyheat = subs(yNoisyheat(t), t, timeColNoisyheat);
    
    
    % plotting 
    figure 
    subplot(2,1,1);
    plot(timeColCleanheat, tempColCleanheat, "-b");
    title({"Clean data for Heating Process"});
    xlabel("time (s)");
    ylabel("temperature (C)");
    grid on
    hold on 
    plot(timeColCleanheat, yValsCleanheat, "-r");
    hold off
    legend("original data", "equation (1)");
    subplot(2,1,2);
    plot(timeColNoisyheat, tempColNoisyheat, "-b");
    title({"Noisy data for Heating Process"});
    xlabel("time (s)");
    ylabel("temperature (C)");
    grid on
    hold on 
    plot(timeColNoisyheat, yValsNoisyheat, "-r");
    hold off
    legend("original data", "calibration equation","location","southeast");