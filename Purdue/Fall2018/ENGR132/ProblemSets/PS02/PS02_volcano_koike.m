%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% The purpose of this program is to analyze data - volcano type, name,     
% country, latitude, longitude, and elevation above sea level -
% which involves volcanos from all around the world and is gathered by
% remote sensing. The analysis is conducted based on the limitations 
% of the tools used for the data collection. 
%
% Assigment Information
%   Assignment:     PS 02, Problem 2
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

%Importing the data file of volcanoes
volcanoData = csvread('Data_volcano_list.csv', 1, 3);

%Setting variables for the columns in the data table 
latit = volcanoData(:,1);    %The columns for the latitude of the 
                             %volcanoes (DD: decimal degrees)
long = volcanoData(:,2);     %The columns for the longitude of the 
                             %volcanoes (DD)
elevtn = volcanoData(:,3);   %The columns for the elevation of the 
                             %volcanoes (m: meters)

%Settings of rows that are stratovolcanoes
latitStrato = volcanoData(121:395,1);
longStrato = volcanoData(121:395,2);
elevtnStrato = volcanoData(121:395,3);


%% ____________________
%% CALCULATIONS

%A. How many volcanoes are visible in the PoLAR Viewer images and 
%what is their average elevation?
%How many?
polView_volc = find(latit >= 50);  %Finding the row indices with 
                                   %volcanoes that have latitudes 
                                   %larger than 50 (DD)
polView_number = numel(polView_volc);  
                                   %The number of volcanoes that were       
                                   %listed up by the previous command 
%Average Elevation?
polView_elevtn = elevtn(polView_volc,:);  
                                   %The elevation of the volcanoes 
                                   %with latitudes larger than 50 DD
polView_AvgElevtn = mean(polView_elevtn); 
                                   %The average elevation of the 
                                   %volcanos with latitudes larger
                                   %than 50 DD


%B. How many stratovolcanoes are visible in the VII images and what
%is the minimum and maximum elevation found in the stratovolcanoes 
%visible to VII?
%How many?
VII_strato = find((latitStrato <= 0)&(elevtnStrato > 2500));    
%The row indices of stratovolcanoes that have elevation higher 
%than 2500 and latitude equal to or less than 0
VII_stratoNumber = numel(VII_strato); %The number of stratovolcanoes
                                      %listed by the previous 
                                      %command
%The minimum and maximum elevation?
VII_stratoElevtn = elevtnStrato(VII_strato); 
                                      %The elevations of the 
                                      %stratovolcanoes with 
                                      %elevation higher than 2500 
                                      %and latitude equal to or less
                                      %than 0 (m)
VII_stratoElevtnMin = min(VII_stratoElevtn); 
                                      %The minimum elevation within 
                                      %the elevations listed in the 
                                      %previous command (m)
VII_stratoElevtnMax = max(VII_stratoElevtn); 
                                      %The maximum elevation within 
                                      %the elevations listed in the 
                                      %previous command (m)


%C. How many stratovolcanoes and how many non-stratovolcanoes are 
%visible in the ACP-1 images?
%How many stratovolcanoes?
ACP_strato = find(-39.5<=latitStrato & latitStrato<=39.5);     
%The row indices of the stratovolcanoes with latitudes bigger than and      
%equal -39.5 and lower than and equal to 39.5 (DD)
ACP_stratoNumber = numel(ACP_strato); %The number of stratovolcanoes
                                      %listed in the previous command
%How many non-stratovolcanoes?
ACP_volc = find(-39.5<=latit & latit<=39.5);
%The number of any type of volcano that have a latitude higher than
%and equal to -39.5 and lower than and equal to 39.5 (DD)
ACP_volcNumber = numel(ACP_volc); %The number of volcanoes listed in 
                                  %the previous command
ACP_nonstratoNumber = ACP_volcNumber - ACP_stratoNumber;        
                              %The number of non-stratovolcanoes that
                              %have a latitude higher than and equal 
                              %to -39.5 and lower than and equal to 
                              %39.5


%D. How many stratovolcanoes are visible in the MASC images and 
%what is their average elevation?
%How many?
MASC_strato = find((100<=longStrato & longStrato<145)|(-140<longStrato & longStrato<=-120));   
%The stratovolcanoes that are visible with MASC (DD)
MASC_stratoNumber = numel(MASC_strato);                                                        
%The number of stratovolcanoes that are listed in the previous command
%Average elevation?
MASC_stratoElevtn = elevtnStrato(MASC_strato,:); 
                             %The elevations of the stratovolcanoes
                             %listed in the previous command(m)
MASC_stratoAvgElevtn = mean(MASC_stratoElevtn);  
                             %The average elevation of the elevations
                             %listed in the previous command (m)


% ____________________
%% FORMATTED TEXT DISPLAYS

%A
fprintf("The number of volcanoes visible in the Polar Viewer is %d and the average elevation of those volcanoes is %.2f m.\n", polView_number, polView_AvgElevtn);
%B
fprintf("The number of stratovolcanoe visible in the VII is %d and the minimum and maximum elevations among those stratovolcanoes are %d m and %d m.\n", VII_stratoNumber, VII_stratoElevtnMin, VII_stratoElevtnMax);
%C
fprintf("The number of statovolcanoes and non-stratovolcanoes visible in the ACP-1 are %d and %d.\n",  ACP_stratoNumber, ACP_nonstratoNumber);
%D
fprintf("The number of stratovolcanoes visible in the MASC is %d and the average elevation of those stratovolcanoes is %.2f m.\n", MASC_stratoNumber, MASC_stratoAvgElevtn);


%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% I have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have I provided
% access to my code to another. The code I am submitting
% is my own original work.