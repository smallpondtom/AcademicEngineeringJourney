function [yL,yH,tS,tau] = Project_M4_loopalgorithm_002_08(filecool, fileheat)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 FINAL PROJECT
%
% Program Description 
% This user-defined funciton can run 100 times and get all values of yL,
% yH, tau and tS as vectors.
%
% Function Call
% [yL,yH,tS,tau] = Project_M4_loopalgorithm_002_08(filecool, fileheat)
%
% Input Arguments
% 1. filecool: the name of cooling data file that we want to input as a
%    string
% 2. fileheat: the name of heating data file that we want to input as a 
%    string
%
% Output Arguments
% 1. yL: initial low temperature/asymptoting lowest temperature
% 2. yH: initial high temperature/asymptoting highest temperature
% 3. tS: the threshold t-value of the change in temperature
% 4. tau: represents the time it takes for the dependent 
%    variable to achieve a value of yTau = yL + 0.632(yH ? yL).
%
% Assignment Information
%   Assignment:       	M4
%   Author:             Tomoki Koike, koike@purdue.edu, 
%                       Yi Zhou   zhou823@purdue.edu
%                       Eu JIn Lee  lee2219@purdue.edu
%                       Ian Pitman  ipitman@purdue.edu 
%   Team ID:            002-08      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

timerVal = tic;
filecooldataOriginal = csvread(filecool);  %input the data
% the size of the cool data
[rowSizeCoolData, colSizeCoolData] = size(filecooldataOriginal);
timeCol = filecooldataOriginal(:,1);   % the first column is time
filecooldata = filecooldataOriginal(:,2:colSizeCoolData);
fileheatdata = csvread(fileheat, 0,1);

file = [filecooldata fileheatdata];  %combine two files into one file
[fileRowSize, fileColSize] = size(file); % the size of the file array
m = 1;  %index

for col = [1:fileColSize]    %for loop to call algorithm udf 100 time
   tempCol = file(:,col);  %tempCol is changing every loop
   %call M4Algorithm to get the values of yL, yH, tau and tS. They will
   %store in column vectors
   [yL(m), yH(m), tS(m), tau(m), SSEmod(m), string(m)] =...
       Project_M4Algorithm_002_08(timeCol, tempCol);      
   m = m + 1; %index plus 1
end
    


