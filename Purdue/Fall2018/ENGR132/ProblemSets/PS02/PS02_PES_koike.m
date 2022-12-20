%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program uses relational and logical operators to analyze a 
% compiled data of students' survey result showing their GPA and 
% interest in several engineering departments - Civil Engineering,
% Electrical and Computer Engineering, and Mechanical Engineering -
% which is ranked numerically.
%
% Assigment Information
%   Assignment:     PS 02, Problem 1
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
 
%Importing the data file of the student survey
surveyData = csvread('Data_PES_survey_record.csv', 1, 0);

%Setting variables for each department
ECE = surveyData(:,2);  %Electrical and Computer Engineering 
ME = surveyData(:,3);   %Mechanical Engineering
CE = surveyData(:,4);   %Civil Engineering

%Other data on the data
GPA = surveyData(:,5);      %the column of the GPA
idenNum = surveyData(:,1);  %the identification numbers on the data
                            %table

%% ____________________
%% CALCULATIONS

%A.
%The row indices of the students who failed to select any school.
failSelect = find(ECE+ME+CE==0);
%another way is failSelect = *****find(ECE==0&ME==0&CE==0)*****
%The number of students who failed to select any school.
numFail = numel(failSelect);


%B.
%The number of students that showed interest to only one school.
oneSelect = find(ECE+ME+CE==1); %the row indices of students that
                                %showed interest to only one 
                                %school
%another way is 
%***oneSelect =
% find((ECE==1&ME==0&CE==0)|(ECE==0&ME==1&CE==0)|(ECE==0&ME==0
% &CE==1))***
numOneSelect = numel(oneSelect);


%C.
%The minimum GPA of a student that has interest in ECE and CE but not      
%ME.
ece_and_ce = find(ECE+CE-ME==3);  %the row indices with students who
                                  %have only interest in ECE and CE
%another way of doing this *****ece_and_ce = find(ECE&CE&~ME)*****      
gpaEceCe = GPA(ece_and_ce,:); %the GPA values of the row indices in 
                              %the variable ece_and_ce
minGPA = min(gpaEceCe);       %the minimum GPA 


%D.
%The survey identification numbers of the students who indicated an 
%interest in all three schools.
allSchools = find(ECE&CE&ME);   %the row indices that show students 
                                %that have interest in all of the 
                                %three schools 
%another way is *****allSchools = find(ECE+CE+ME==6)*****
%allSchools = find(ECE+CE+ME=6) another way to find it
idenNumAllSchool = idenNum(allSchools, :); 
                                %the identification numbers of 
                                %the students that showed 
                                %interest in all of the schools

                                            
%E.
%The number of students that chose CE as their first and ME as 
%their third
ce1me3 = find((CE==1)&(ME==3));   %the row indices of the 
                                  %students that chose CE as 
                                  %their first and ME as their 
                                  %third
numCE1ME3 = numel(ce1me3);        %the number of students that
                                  %are included in ce1me3

                                  
%F.
%The average level of interest within the students that showed 
%interest to ECE.
eceIntrst = find(ECE);            %the row indices in the data 
                                  %that show students who have 
                                  %interest in ECE
eceIntrstVal = ECE(eceIntrst,:);  %the values in each indices 
                                  %of eceIntrst
avgLevel = mean(eceIntrstVal);    %the average value for the 
                                  %interest level of ECE

                                   
%G.
%The average GPA of the students whose GPA is higher than 3.5 and who       
%selected either ECE or ME as their first choice
ece_or_me1 = find((ECE==1|ME==1)&GPA>3.5000);  
                       %the row indices of students who have a GPA 
                       %higher than 3.5 and selected ECE or ME 
                       %as their first choice                                            
ece_or_me1Value = GPA(ece_or_me1,:);  %the GPA value of the row 
                                      %indices found in the 
                                      %previous step
avgOver3point5 = mean(ece_or_me1Value); %the average GPA for the GPA
                                        %values found in the 
                                        %previous step



%% ____________________
%% FORMATTED TEXT DISPLAYS

%B
fprintf("The number of studnets who failed to select any school is %d.\n", numFail);
%C
fprintf("The number of students that showed interest to only one school is %d.\n", numOneSelect);
%D
fprintf("The minimum GPA of a student that has interest in ECE and CE but not ME is %d.\n", minGPA);
%G
fprintf("The average level of interest within the students that showed interest to ECE is %d.\n",avgLevel);


%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% I have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have I provided
% access to my code to another. The code I am submitting
% is my own original work.