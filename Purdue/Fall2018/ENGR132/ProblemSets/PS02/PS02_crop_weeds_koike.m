%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program manipulates data to utilize the data of weed prevalence     
% within the present vegetation which was gathered by dividing the 
%field into square field pixels.
%
% Assigment Information
%   Assignment:     PS 02, Problem #3
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

fielddata = load('Data_weed_percent_fieldA152nF.txt'); 
%the laoding of the text file   


%% ____________________
%% CALCULATIONS

%A. How many field pixels are in the data set?
pixSetSum = numel(fielddata);   %Finds the total number of field
                                %pixels in the data set

                                
%B. Which column has the highest average weed percent, and what is its average weed percent?
avgCol = mean(fielddata);  %Creates a row vector of the mean of each
                           %column in the data set
avgCol(:);                 %Converts the row vector created in the
                           %previous step into a column vector
[maxVal,maxIndex] = max(avgCol(:));  
                           %Indicates the maximum value and the
                           %row index of the maximum value in the 
                           %column vector
[maxIndex_row, maxIndex_col] = ind2sub(size(avgCol),maxIndex);  
                           %Extracts the maximum value found in the
                           %previous step from the original row vector     
                           %of the averages and outputs the row and 
                           %column indices

                           
%C. Weed percentages of less than 15% at this point in the growing 
%cycle mean the crop plants are dominant. How many field pixels are 
%in this category, and what is the average weed percentage in the 
%crop-dominant pixels?
%How many?
cropDom = fielddata(fielddata<0.15);  
                             %The values in the data set that are 
                             %crop dominant pixels
cropDomNum = numel(cropDom); %The total numbers of the crop 
                             %dominant pixels
%The average?
cropDomAvg = mean(cropDom);  %The average value of the crop 
                             %dominant pixel values 

                             
%D. Weed percentages in the range of 75-95%, inclusive of both, 
%require urgent weed treatment. How many field pixels are in this 
%category?
urgWeedTreat = fielddata(0.75<=fielddata & fielddata<=0.95);     
            %The values that are categorized as to require 
            %urgent weed treatment
urgWeedTreatNum = numel(urgWeedTreat);  
            %The number of values that included in the values
            %manipulated from the previous step

            
%E. Any pixel with a weed percentage greater than 95% require a 
%person to visually inspect the pixel. What pixel locations, using 
%row and column indices, require visual inspection?
[over95_row,over95_col] = find(fielddata>0.95);                  
% This indicates the row and column indices 
%of the pixel that requires inspection


%% ____________________
%% FORMATTED TEXT DISPLAYS

%A
fprintf("The total numbere of field pixels in the data set is %d.\n", pixSetSum);
%B
fprintf("The column with the highest weed precentage is %d, and its average weed precent is %.3f.\n", maxIndex_col, maxVal);
%C
fprintf("The number of pixels in the crop plant dominant category is %d, and its average weed precentage is %.3f.\n", cropDomNum, cropDomAvg);
%D
fprintf("The number of field pixels with the weed precentage range of 75-95% inclusive is %d.\n", urgWeedTreatNum);
%E
fprintf("The location of the field pixel with over a 95% weed precentage is row index %d and column index %d.\n", over95_row, over95_col);  



%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% I have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have I provided
% access to my code to another. The code I am submitting
% is my own original work.