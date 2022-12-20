%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 FINAL PROJECT
% Program Description 
% This is the execution function. It will call M4_Algorithm user-defined
% function to get all values of yL, yH, tS and tau. Then it will calculate
% mean values and standard deviation for model FOS-1 to FOS-5.
%
% Assignment Information
%   Assignment:       	M5, execution 
%   Author:             Tomoki Koike, koike@purdue.edu, 
%                       Yi Zhou   zhou823@purdue.edu
%                       Eu JIn Lee  lee2219@purdue.edu
%                       Ian Pitman  ipitman@purdue.edu 
%   Team ID:            002-08      
%  	Contributor: 		no contributor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

filecool = "M3_Data_CoolingTimeHistories.csv";
fileheat = "M3_Data_HeatingTimeHistories.csv";

filecooldataOriginal = csvread(filecool);  %input the data
% the size of the cool data
[rowSizeCoolData, colSizeCoolData] = size(filecooldataOriginal);
timeCol = filecooldataOriginal(:,1);   % the first column is time
filecooldata = filecooldataOriginal(:,2:colSizeCoolData);
fileheatdata = csvread(fileheat, 0,1);

file = [filecooldata fileheatdata];  %combine two files into one file
[fileRowSize, fileColSize] = size(file); % the size of the file array

FOS1tau = zeros(1, 20);
FOS2tau = zeros(1, 20);
FOS3tau = zeros(1, 20);
FOS4tau = zeros(1, 20);
FOS5tau = zeros(1, 20);

for m = [0:10:40]
    FOS_tau = zeros(1,20);
    ct = 20;
    for i = [1:1:20]
        if 1<=i && i<=10
            tempCol = file(:,i+m);
            [yL, yH, tS, tau, SSEmod, string3] = ...
                Project_M4Algorithm_002_08(timeCol, tempCol);
            if string3 == "cooling"
                z = exp(-(tau-tS)/tau);
            elseif string3 == "heating"
                z = 1-exp(-(tau-tS)/tau);
            end
            if 0.50<=z && z<=0.75
                FOS_tau(i) = tau;
            else
                ct = ct - 1;
            end
        elseif 11<=i && i<=20
            tempCol = file(:,40+i+m);
            [yL, yH, tS, tau, SSEmod, string] = ...
                Project_M4Algorithm_002_08(timeCol, tempCol);
            if string3 == "cooling"
                z = exp(-(tau-tS)/tau);
            elseif string3 == "heating"
                z = 1-exp(-(tau-tS)/tau);
            end
            if 0.50<=z && z<=0.75
                FOS_tau(i) = tau;
            else
                ct = ct - 1;
            end
        end
    end
    FOS_all_tau = [FOS1tau FOS2tau FOS3tau FOS4tau FOS5tau];
    switch m
        case 0
            FOS1tau = FOS_tau;
            ct1 = ct;
            FOS1mean = sum(FOS1tau)/ct1;
            FOS1std = std(FOS1tau);
        case 10
            FOS2tau = FOS_tau;
            ct2 = ct;
            FOS2mean = sum(FOS2tau)/ct2;
            FOS2std = std(FOS2tau);
        case 20
            FOS3tau = FOS_tau;
            ct3 = ct;
            FOS3mean = sum(FOS3tau)/ct3;
            FOS3std = std(FOS3tau);
        case 30
            FOS4tau = FOS_tau;
            ct4 = ct;
            FOS4mean = sum(FOS4tau)/ct4;
            FOS4std = std(FOS4tau);
        case 40
            FOS5tau = FOS_tau;
            ct5 = ct;
            FOS5mean = sum(FOS5tau)/ct5;
            FOS5std = std(FOS5tau);
    end
end

toc
        