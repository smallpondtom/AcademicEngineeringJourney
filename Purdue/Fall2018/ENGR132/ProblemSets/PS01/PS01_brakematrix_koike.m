%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% Performance of matrix and vector manipulations of data concerning the
% stopping time of a mechanical brake.
%
% Assigment Information
%   Assignment:     PS 01, Problem 3
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
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION

%The matrix representation of the 4*3 data sets describing the tested
%stopping time under 3 different conditions.
brakeData = [0.59 0.62 0.6 0.6; 0.97 0.91 0.98 0.95; 1.25 1.15 1.1 1.12];

%% ____________________
%% MATRIX MANIPULATIONS

% Comment each of these matrix manipulation commands with a concise 
% explanation of what the command performs. If the command produces an
% error, explain the error and then comment the whole line

A = brakeData(2,3)          %this outputs the value on the 2nd row and 3rd column (s)
%B = brakeData(5,4)         the row value cannot exceed 3 

C = brakeData(1,:)          %this outputs all the values on the first row as one row vector (s)
D = brakeData(2,:)          %this outputs all the values on the second row as one row vector (s)
E = brakeData(:,3)          %this outputs all the values on the third column as one column vector (s)

F = brakeData(1:2)          %this outputs the row vector of the values on the first to second row but by default only the first column (s)
G = brakeData(2:3)          %this outputs the row vector of the values on the second to third row but by default only the first column (s)
H = brakeData(1:2,2:3)      %this outputs the matrix of the values on the first to second row and second to third column (s)

J = [D C]                   %this outputs the values in the row vectors D & C as one row vector (s)                                 
K = [D;C]                   %this outputs the values in the row vectors D & C as a matrix where D is on the first row and under that is the row of C (s)
L = [D C]                   %this has the same output as J

M = sort(D)                 %this outputs the row vector D in the order from smaller to bigger values (s)

brakeData(2,3) = 0.96       %this outputs a matrix that has the value on the 2nd row and 3rd column changed from 0.98 to 0.96 from the original matrix

%% ____________________
%% CALCULATIONS

%Assign all stopping times in test 2 to one variable 
test2 = brakeData(:,2);              %all the values in test2 (s)

%Assign the stopping time of Condition 3 in Test 4 to one variable by using
%array indexing (s)
conIIItestIV = brakeData(3,4);

%Using array indexing replace the first condition of Test 4 with a corrected value of 0.61 (s)
brakeData(1,4) = 0.61;

%Create a new vector column of Test 5 (s)
test5 = [0.58; 0.93; 1.2];

%horizontally concatenate the matrix brakeData and vector of Test 5 (s).
newBrakeData = horzcat(brakeData, test5);

%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% I have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have I provided
% access to my code to another. The script I am submitting
% is my own original work.
