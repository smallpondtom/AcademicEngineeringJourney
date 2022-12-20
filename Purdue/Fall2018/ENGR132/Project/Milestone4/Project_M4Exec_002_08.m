%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 FINAL PROJECT
% Program Description 
% This is the execution function. It will call M4_loopalgorithm user-defined
% function to get all values of yL, yH, tS and tau. Then it will calculate
% mean values and standard deviation for model FOS-1 to FOS-5. Then it will
% call M4Regression user-define function to get plots, the Linear
% Regression Model,
% values of SSE, SST and rsquare.
%
% Assignment Information
%   Assignment:       	M4, execution 
%   Author:             Tomoki Koike, koike@purdue.edu, 
%                       Yi Zhou   zhou823@purdue.edu
%                       Eu JIn Lee  lee2219@purdue.edu
%                       Ian Pitman  ipitman@purdue.edu 
%   Team ID:            002-08      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

%define the filenames
filecool = "M3_Data_CoolingTimeHistories.csv";
fileheat = "M3_Data_HeatingTimeHistories.csv";

%call user-defined funciton to get all valuse of yL, yH, tS and tau.They
%will return as columns vectors.
[yL,yH,tS,tau] = Project_M4_loopalgorithm_002_08(filecool, fileheat);  

%make group of data based on different prices
yLD1cool = yL(1:10);
yLD1heat = yL(51:60);
yLD2cool = yL(11:20);
yLD2heat = yL(61:70);
yLD3cool = yL(21:30);
yLD3heat = yL(71:80);
yLD4cool = yL(31:40);
yLD4heat = yL(81:90);
yLD5cool = yL(41:50);
yLD5heat = yL(91:100);

yHD1cool = yH(1:10);
yHD1heat = yH(51:60);
yHD2cool = yH(11:20);
yHD2heat = yH(61:70);
yHD3cool = yH(21:30);
yHD3heat = yH(71:80);
yHD4cool = yH(31:40);
yHD4heat = yH(81:90);
yHD5cool = yH(41:50);
yHD5heat = yH(91:100);

tSD1cool = tS(1:10);
tSD1heat = tS(51:60);
tSD2cool = tS(11:20);
tSD2heat = tS(61:70);
tSD3cool = tS(21:30);
tSD3heat = tS(71:80);
tSD4cool = tS(31:40);
tSD4heat = tS(81:90);
tSD5cool = tS(41:50);
tSD5heat = tS(91:100);

tauD1cool = tau(1:10);
tauD1heat = tau(51:60);
tauD2cool = tau(11:20);
tauD2heat = tau(61:70);
tauD3cool = tau(21:30);
tauD3heat = tau(71:80);
tauD4cool = tau(31:40);
tauD4heat = tau(81:90);
tauD5cool = tau(41:50);
tauD5heat = tau(91:100);

%calculate the mean values of tau for different mode numbers
FOS1mean = mean([tauD1heat tauD1cool]);
FOS2mean = mean([tauD2heat tauD2cool]);
FOS3mean = mean([tauD3heat tauD3cool]);
FOS4mean = mean([tauD4heat tauD4cool]);
FOS5mean = mean([tauD5heat tauD5cool]);

%calculate the standard deviaitons of tau for different mode numbers
FOS1std = std([tauD1heat tauD1cool]);
FOS2std = std([tauD2heat tauD2cool]);
FOS3std = std([tauD3heat tauD3cool]);
FOS4std = std([tauD4heat tauD4cool]);
FOS5std = std([tauD5heat tauD5cool]);

%call M4Regression user-defined function to get plots, the Linear Regression Model and sse, sst and rsquare.
Project_M4Regression_002_08(tau);   

%Category 2, code below is for academic integrity, we comment
%it out to increase effeciency
%PS07_academic_integrity_koike(["Tomoki Koike" "Yi Zhou" "Eu Jin Lee" "Ian
%Pitman"]);     
toc

