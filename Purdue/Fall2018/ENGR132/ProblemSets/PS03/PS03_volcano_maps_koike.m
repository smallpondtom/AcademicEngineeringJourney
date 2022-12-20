%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program maps the locations of volcanoes depending on the 
% visibiity which differs by the instrument used to collect data.
% Subsequently, an analysis is conducted by examining the plotted
% figure.
%
% Assigment Information
%   Assignment:     PS 03, Problem 3
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

% Importing the data file of volcanoes
volcanoData = csvread('Data_volcano_list.csv', 1, 3);

% Setting variables for the columns in the data table 

latit = volcanoData(:,1);    % The columns for the latitude of the 
                             % volcanoes (DD: decimal degrees)
long = volcanoData(:,2);     % The columns for the longitude of the 
                             % volcanoes (DD)
elevtn = volcanoData(:,3);   % The columns for the elevation of the 
                             % volcanoes (m: meters)
                             
% The total row indices
allRow = numel(latit);     % The total number of rows
allRowIndex = (1:1:allRow)'; % The column vector of all row indices

                             
%% ____________________
%% CALCULATIONS

% Using relational and logical operators to create vectors of latitude 
% and longitude values for all volcanoes that are

% a. Visible in the ACP-1 images
ACPlatit_v = latit(-39.5<=latit & latit<=39.5); 
            % The values of latitude of the volcanoes that are within
            % the limits of ACP-1 (DD).
ACPlatit_row = find(-39.5<=latit & latit<=39.5);
            % The row indices of the latitudes that satisfy the limit
            % of ACP-1 (DD).
ACPlong_v = long(ACPlatit_row);
            % The values of longitude of the volcanoes that are within
            % the limit of ACP-1 (DD).
    
            
% b. Visible in the VII images
VIIlatit_v = latit(elevtn>2500 & latit<=0); 
            % The values of latitude of the volcanoes that are within
            % the limits of VII (DD).
VIIlatit_row = find(elevtn>2500 & latit<=0);
            % The row indices of the latitudes that satisfy the limit
            % of VII (DD).
VIIlong_v = long(VIIlatit_row);
            % The values of longitude of the volcanoes that are within
            % the limit of VII (DD).

            
% c. Visible in the MASC images
MASClong_v = long((100<=long & long<145) | (-140<long & long<=-120)); 
            % The values of longitudes for the volcanoes that are 
            % within the limits of MASC (DD).
MASClong_row = find((100<=long & long<145) | (-140<long & long<=-120));
            % The row indices of the longitudes that satisfy the limit
            % of MASC (DD).
MASClatit_v = latit(MASClong_row);
            % The values of latitudes for the volcanoes that are 
            % within the limit of MASC (DD).

            
% d. Visible in the PoLAR Viewer images
PoLVlatit_v = latit(50<=latit); 
            % The values of latitude of the volcanoes that are within
            % the limits of PoLAR Viewer (DD).
PoLVlatit_row = find(50<=latit);
            % The row indices of the latitudes that satisfy the limit
            % of PoLAR Viewer (DD).
PoLVlong_v = long(PoLVlatit_row);
            % The values of longitude of the volcanoes that are within
            % the limit of PoLAR Viewer (DD).        

            
% e. visible in any instrument images
ACPlatitNull_row = setdiff(allRowIndex,ACPlatit_row);
            % Finds the row indices that are in ACPlatit_row but not
            % in allRowIndex.
VIIlatitNull_row = setdiff(allRowIndex,VIIlatit_row);
            % Finds the row indices that are in VIIlatit_row but not
            % in allRowIndex.
MASClongNull_row = setdiff(allRowIndex,MASClong_row);
            % Finds the row indices that are in MADClong_row but not 
            % in allRowIndex.
PoLVlatitNull_row = setdiff(allRowIndex,PoLVlatit_row);
            % Finds the row indices that are in PoLVlatit_row but 
            % not in allRowIndex.
noneVisible_row = intersect(intersect(intersect(ACPlatitNull_row...
    ,VIIlatitNull_row),MASClongNull_row),PoLVlatitNull_row);
            % Finds the row indices of the volcanoes that are not 
            % visible with any of the instruments.
any_index = setdiff(allRowIndex,noneVisible_row);
            % Finds the row indices that is visible in any one of the
            % instrument images. 
anyLatit = latit(any_index);
            % Finds the value of the latitudes that are visible in 
            % any of the instrument images.
anyLong = long(any_index);
            % Finds the value of the longitudes that are visible in 
            % any of the instrument images.
         
            
% f. Not visible in any instrument images
noneVisible_latit = latit(noneVisible_row);
            % The latitudes of the volcanoes that are not visible
            % in any of the instruments.
noneVisible_long = long(noneVisible_row);
            % The longitudes of the volcanoes that are not visible 
            % in any of the instruments. 

%% ____________________
%% FORMATTED FIGURES 

% Plotting all the volcanoes in the data.
figure
plot(long,latit,'xr')
hold on
title('Locations of All Volcanoes')
xlabel('longitude (DD)')
ylabel('latitude (DD)')
xlim([-180,180])
ylim([-90,90])
grid on 
grid minor 
hold off

% Plotting the locations of the volcanoes that are visible for each
% instrument.
% ACP-1
figure
subplot(2,2,1)
hold on
plot(ACPlong_v,ACPlatit_v,'xm')
title('Volcanoes Visible in ACP-1')
xlabel('longitude (DD)')
ylabel('latitude (DD)')
xlim([-180,180])
ylim([-90,90])
grid on 
grid minor

% VII
subplot(2,2,3)
plot(VIIlong_v,VIIlatit_v,'xg')
title('Volcanoes Visible in VII')
xlabel('longitude (DD)')
ylabel('latitude (DD)')
xlim([-180,180])
ylim([-90,90])
grid on 
grid minor

% MASC
subplot(2,2,2)
plot(MASClong_v,MASClatit_v,'xb')
title('Volcanoes Visible in MASC')
xlabel('longitude (DD)')
ylabel('latitude (DD)')
xlim([-180,180])
ylim([-90,90])
grid on 
grid minor

% PoLAR Viewer
subplot(2,2,4)
plot(PoLVlong_v,PoLVlatit_v,'xk')
title('Volcanoes Visible in PoLAR Viewer')
xlabel('longitude (DD)')
ylabel('latitude (DD)')
xlim([-180,180])
ylim([-90,90])
grid on 
grid minor
hold off


% A figure showing the locations of the volcanoes that are visible 
% in any instrument as well as the volcanoes that are not visible in
% any of the instruments.
figure
plot(noneVisible_long,noneVisible_latit,'or')
title('Volcanoes Visible/Not Visible in Any Instrument')
xlabel('longitude (DD)')
ylabel('latitude (DD)')
xlim([-180,180])
ylim([-90,90])
grid on 
grid minor
hold on 
plot(anyLong,anyLatit,'xb');
legend('Volcanoes not visible in any instrument image',...
    'Volcanoes visible in any instrument image', 'location','southoutside')
hold off

% Optional 
% Combining the world map with the location of the volcanoes that are 
% visisble in all instrument image and not visible in all instrument 
% images.
figure
plot(noneVisible_long,noneVisible_latit,'or')
hold on 
landareas = shaperead('landareas.shp');
mapshow(landareas);
title('Volcanoes Visible/not visible in any Instrument')
xlabel('longitude (DD)')
ylabel('latitude (DD)')
xlim([-180,180])
ylim([-90,90])
grid on 
grid minor
plot(anyLong,anyLatit,'xb');
legend('Volcanoes not visible in any instrument image',...
    'Volcanoes visible in any instrument image', 'location','southoutside')
hold off


%% ____________________
%% ANALYSIS 

%% -- Q1
% The instruments provided for the analysis is not sufficient 
% considering the fact that there are volcanoes that are not 
% visible in any of the instruments and also that there is no 
% volcano that is commonly visible in all of the instruments.
% Overall, there are volcanoes that are not visible due to the 
% limited domain of the latitude. By observing the figure of the 
% volcanoes that are not visible in any of the instruments it is 
% evident that volcanoes that have latitudes from -60 to -50 and
% 40 to 50 are ruled out from the remote sensing process.


%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% I have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have I provided
% access to my code to another. The script I am submitting
% is my own original work.

