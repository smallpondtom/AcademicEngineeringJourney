%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
%   Calculating the physcial factors - time, distance, velocity, force, and power - of an 
%   interior crane system using vector operations. As well as, calculating the investion of
%   to create a long-term crane repair fund involving the interest rates. 
%
% Assigment Information
%   Assignment:     PS 01, Problem 2
%   Author:         Tomoki Koike, koike@purdue.edu
%   Team ID:        individual
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

%vector setups based on the provided crane information
liftMass = [500; 600; 700; 800; 1000];           %the lifted mass by the crane (kg)
liftDist = [1.2; 4.2; 3.0; 1.5; 2.5];            %the lifted distance by the crane (m)
liftTime = [1.2; 2.4; 2.0; 1.5; 3.0];            %the lifting time by the crane (s)
retTime = [2.4; 4.8; 4.0; 3.5; 9.0];             %the returning time of the crane (s)

%scalar values for calcualtion
opHrs = 12;                               %the operation hours of the crane for one day (hr)
grav = 9.81;                              %the acceleration due to gravity (m/s^2)

%vectors for the crane repair fund
%Principle
%1
vectorPrinciple1 = 1000: 100: 2000;          %vector of initial amount of money from $1000 to $2000 with $100 increment
%2
vectorPrinciple2 = linspace(1000,2000,11);   %vector of initial amount of money from $1000 to $2000 with $100 increment

%Interest Rate
%1
vectorInterest1 = 0.1: -0.0075: 0.025;       %vector of interest rate starting from 0.1 and decreasing to 0.025 with an icnrement of 0.0075
%2 
vectorInterest2 = linspace(0.1,0.025,11);    %vector of interest rate starting from 0.1 and decreasing to 0.025 with an icnrement of 0.0075

%investment time 
%1
vectorInTime1 = 1:2:21;                      %vector of investment time starting from one year and increasing to 21 years with an increment of 2 years
vectorInTime2 = linspace(1,21,11);           %vector of investment time starting from one year and increasing to 21 years with an increment of 2 years


%% ____________________
%% CALCULATIONS

%%%% vector dimensions will be expressed as dimR(_)
%Calculate the lifting velocity of an object 
liftVel = liftDist ./ liftTime;             %dimR(5) and unit (m/s)

%Calculate the force on an object due to gravity 
force = liftMass * grav;                    %dimR(5) and unit (N)

%Calculate the power necessary to lift an object 
power = liftVel .* force;                   %dimR(5) and unit (W)

%Calculate the number of lifts possible in a day
%operation time in seconds necessary to calculate
opSec = opHrs * 3600;                        %conversion from hours to seconds (s)
liftPerDay = opSec ./ (liftTime + retTime); %demR(5) and no unit

%number1) Calculate "the total value of the investment fund for each year in the
%investment time vector" when the principle is $1000 and the interest rate
%is 0.025 ($)
investCal1 = vectorPrinciple1(1) * (1 + vectorInterest1(11)) .^ vectorInTime1;

%number2) Calculate "the total value of the investment for each potential
%interest rate" when the principle is $1500 and investmemt time is 5 years.
%($)
investCal2 = vectorPrinciple1(6) * (1 + vectorInterest1) .^ vectorInTime1(3);

%number3) Calculate "the total value of the investment for each initial
%principal amount" when the interest rate is 0.07 and the investment time
%is 17 years. ($)
investCal3 = vectorPrinciple1 * (1 + vectorInterest1(5)) ^ vectorInTime1(9);


%% ____________________
%% FORMATTED TEXT & FIGURE DISPLAYS

%Print on the command window the values of lift velocity, force, power,
%number of lifts possible a day, and the three values calculated for the 
%repair fund.

%crane lifts
fprintf('The lift velocity of the interior crane system is %d m/s \n', liftVel);
fprintf('The force done by gravity on the object of the interior crane system is %d N \n', force);
fprintf('The power of one lift t by the interior crane system is %d W \n', power);
fprintf('The number of lifts possible by the interior crane system per day is %d \n', liftPerDay);

%repair fund
fprintf('When the principle is $1000 and the interest rate is 0.025 the total value of the investment fund for each year in the investment time vector is %d dollars \n', investCal1);
fprintf('When the principle is $1500 and investmemt time is 5 years the total value of the investment for each potential interest rate is %d dollars \n', investCal2);
fprintf('When the interest rate is 0.07 and the investment timeis 17 years the total value of the investment for each initial principal amount is %d dollars \n', investCal3);


%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% I have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have I provided
% access to my code to another. The script I am submitting
% is my own original work.
