function [] = PS07_academic_integrity_koike(nameArray)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program aims to print out an academic integrity statement which
% which corresponds to the number of names of students that will be 
% inputed into the function as an array of strings.
%
% Function Call
% PS07_academic_integrity_koike(nameArray)
%
% Input Arguments
% 1. nameArray: a string array of student names
%
% Output Arguments
% there is no output 
%
% Assignment Information
%   Assignment:       	PS 07, Problem 2
%   Author:             Tomoki Koike, koike@purdue.edu
%   Team ID:            002-08      
%  	Contributor: 		Name, login@purdue [repeat for each]
%   My contributor(s) helped me:	
%     [ ] understand the assignment expectations without
%         telling me how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping me plan my solution.
%     [ ] think through the meaning of a specific error or
%         bug present in my code without looking at my code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ____________________
%% INITIALIZATION

% the number of names in the nameArray
numNames = length(nameArray);

% this is the academic integrity statement displayed for only an 

% individual 
oneStd = sprintf("I am submitting code that is my own original work. I have not used\nsource code, either modified or unmodified, obtained from any\nunauthorized source. Neither have I provided access to my code to any\npeer or unauthorized source. Signed,\n<%s>\n",nameArray);
% two students 
twoStd = sprintf("We are submitting code that is our own original work. We have not used\nsource code, either modified or unmodified, obtained from any\nunauthorized source. Neither have we provided access to our code to\nany peer or unauthorized source. Signed,\n<%s>\n<%s>\n",nameArray);
% three students
threeStd = sprintf("We are submitting code that is our own original work. We have not used\nsource code, either modified or unmodified, obtained from any\nunauthorized source. Neither have we provided access to our code to\nany peer or unauthorized source. Signed,\n<%s>\n<%s>\n<%s>\n",nameArray);
% four students
fourStd = sprintf("We are submitting code that is our own original work. We have not used\nsource code, either modified or unmodified, obtained from any\nunauthorized source. Neither have we provided access to our code to\nany peer or unauthorized source. Signed,\n<%s>\n<%s>\n<%s>\n<%s>\n",nameArray);
% five students
fiveStd = sprintf("We are submitting code that is our own original work. We have not used\nsource code, either modified or unmodified, obtained from any\nunauthorized source. Neither have we provided access to our code to\nany peer or unauthorized source. Signed,\n<%s>\n<%s>\n<%s>\n<%s>\n<%s>\n",nameArray);

%% ____________________
%% SELECTION STRUCTURE

% Start -> input (calling function) 
    if isstring(nameArray) == 0
        disp('Error! The input is not a string.');
    elseif numNames == 1
        fprintf(oneStd);
    elseif numNames == 2
        fprintf(twoStd);
    elseif numNames == 3
        fprintf(threeStd);
    elseif numNames == 4
        fprintf(fourStd);
    elseif numNames == 5
        fprintf(fiveStd);
    else
        disp('Error! The number of inputs is inappropriate.');
    end
% terminates
% example of display
%% ____________________
%% COMMAND WINDOW OUTPUTS

% nameArray = [1 2 3];
%PS07_academic_integrity_koike(nameArray)
%Error! The input is not a string.

% nameArray = ["Tomoki"];
%PS07_academic_integrity_koike(nameArray)
%I am submitting code that is my own original work. I have not used
%source code, either modified or unmodified, obtained from any
%unauthorized source. Neither have I provided access to my code to any
%peer or unauthorized source. Signed,
%<Tomoki>

% nameArray = ["Tomoki Koike" "Ian Pitman"];
%PS07_academic_integrity_koike(nameArray)
%We are submitting code that is our own original work. We have not used
%source code, either modified or unmodified, obtained from any
%unauthorized source. Neither have we provided access to our code to
%any peer or unauthorized source. Signed,
%<Tomoki Koike>
%<Ian Pitman>

% nameArray = ["Tomoki Koike" "Ian Pitman" "Yi"];
%PS07_academic_integrity_koike(nameArray)
%We are submitting code that is our own original work. We have not used
%source code, either modified or unmodified, obtained from any
%unauthorized source. Neither have we provided access to our code to
%any peer or unauthorized source. Signed,
%<Tomoki Koike>
%<Ian Pitman>
%<Yi>

% nameArray = ["Tomoki Koike" "Ian Pitman" "Yi" "EJ"];
%PS07_academic_integrity_koike(nameArray)
%We are submitting code that is our own original work. We have not used
%source code, either modified or unmodified, obtained from any
%unauthorized source. Neither have we provided access to our code to
%any peer or unauthorized source. Signed,
%<Tomoki Koike>
%<Ian Pitman>
%<Yi>
%<EJ>

% nameArray = ["Tomoki Koike" "Ian Pitman" "Yi" "EJ" "Danny"];
%PS07_academic_integrity_koike(nameArray)
%We are submitting code that is our own original work. We have not used    
%source code, either modified or unmodified, obtained from any
%unauthorized source. Neither have we provided access to our code to
%any peer or unauthorized source. Signed,
%<Tomoki Koike>
%<Ian Pitman>
%<Yi>
%<EJ>
%<Danny>

% nameArray = ["Tomoki Koike" "Ian Pitman" "Yi" "EJ" "Danny" "May"];
%PS07_academic_integrity_koike(nameArray)
%Error! The number of inputs is inappropriate.

%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% We have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have we provided
% access to our code to another. The function we are submitting
% is our own original work.