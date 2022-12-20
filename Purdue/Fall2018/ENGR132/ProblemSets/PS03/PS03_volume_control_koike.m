%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program calculates the power-volume relation for using a model 
% function for head phones. Moreover, the program plots the 
% power-volume relation as a graph for furhter analysis.
%
% Assigment Information
%   Assignment:     PS 03, Problem 2
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

%Import data
volPowData = csvread('Data_volume_power.csv', 2,0);

%Set variable to each column
powCol = volPowData(:,1);   %The columns of the power values
ope4col = volPowData(:,2);  %The columns of the OPE4 volumes 
iep3col = volPowData(:,3);  %The columns of the IPE3 volumes 


%% ____________________
%% CALCULATIONS

% Calculation of the volume of the headphones using the modeled 
% equation.
% OEP4
vOEP4 = 67.1*log10(powCol)-1.3; %model calculation for OPE4
% IEP3
vIEP3 = 77.7*log10(powCol)-1.3; %model calculation for IPE3


%% ____________________
%% FORMATTED FIGURE

% Plotting the data of the original power-volume relation and 
% overlaying by the modeled power-volume relation.
figure
plot(powCol,ope4col,'-or')  % power and volume of OPE4 from data
grid on                     % turning on the grid
grid minor                  % adding minor gridlines
xlabel('Power (mW)')        % adding x-axis label
ylabel('Volume (dB)')       % adding y-axis label
hold on                     % holding the plot to add more 
plot(powCol,iep3col,'-xg')  % power and volume of IPE3 from data
plot(powCol,vOEP4,'-sr')    % power and volume of OPE4 from model
plot(powCol,vIEP3,'-^g')    % power and volume of IPE3 from model
legend('OPE4','IEP3','OPE4model','IEP3model','location','northwest')
                            % adding legends and determining its 
                            % location
title('Power-Volume Relation from Data & Model Equation')
                            % adding the title of the graph
hold off                    % turning off the hold command



%% ____________________
%% ANALYSIS

%% -- Q1
% By examining the graph, the model line for the OPE4 headphone 
% accords more to the curve plotted by the data. Thus, OPE4's 
% model best fits its data.

%% -- Q2
% By visualizing a tangenet line on both model lines, it is 
% fair to say that the model line of IEP3 would have a tangent line
% with a larger slope. Therefore, IEP3 has more sensitivity.


%% -- Q3
% At a volume of 60 dB the OPE4 headphone requires a power of 
% approximately 6.2 mW, whereas IEP3 requires 8.0 mW. This tells 
% that at 60 dB OPE4 is superior in terms of battery longetivity.
% However, at 30 dB OPE4 requires about 2.5 mW and IEP3 requires 
% 3.0 mW which is not that large difference. Nonetheless, from the 
% graph OPE4 headphone may last slightly longer than IEP3. 


%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% I have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have I provided
% access to my code to another. The script I am submitting
% is my own original work.