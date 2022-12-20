%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% BLAH
%
% Assigment Information
%   Assignment:			PS 03, Problem 1
%   Author:				Tomoki Koike, koike@purdue.edu
%   Team ID:			002-08
%   Paired Partner:		Eu Jin Lee, lee2219@purdue.edu
%   Contributor:		no contributor 
%   Our contributor(s) helped us:	
%     [x] understand the assignment expectations without
%         telling us how they will approach it.
%     [x] understand different ways to think about a solution
%         without helping us plan our solution.
%     [x] think through the meaning of a specific error or
%         bug present in our code without looking at our code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% ____________________
%% INITIALIZATION

A = zeros(4,4);
vals = [1 3 2 4; 5 6 7 8; 9 10 11 12; 13 15 14 16];


%% ____________________
%% COPY & CONCATENATION

%% 6.
% a.
M = vals(2:3, 2:3);
% b.
C = vals(1, 2:3);
% c.
D = vals(4, 2:3);
% d. 
E = [vals(1,1),D,vals(1,4)];
% e.
F = [vals(4,1),C,vals(4,4)];


%% ____________________
%% REPLACE MATRIX ELEMENTS

%% 7.
% a.
A(1,1:4)=E;
A(2:3,2:3)=M;
A(4,1:4)=F;

% b.
A(2,1)=vals(3,4);
A(3,1)=vals(2,4);
A(2,4)=vals(3,1);
A(3,4)=vals(2,1);


%% ____________________
%% FINAL MATRIX

%% 8
% a.
X = sum(A);
% b.
G = [A;X];
% c.
Y = sum(G,2)
% d.
H = [G,Y];
% e.
H(5,5)= H(1,1)+H(2,2)+H(3,3)+H(4,4)+H(5,5);

%% ____________________
%% FORMATTED TEXT DISPLAY 

fprintf('After doing step 8.e, the value in the center of H is%d.\n', H(3,3))
fprintf('\n\nAfter doing step 8.e, the value in the upper left of H is %d, and the value in the upper right of H is %d.\n', H(1,1), H(1,5))
fprintf('\n\nAfter doing step 8.e, the value in the lower left of H is %d, and the value in the lower right of H is %d.\n', H(5,1), H(5,5))

%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% We have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have we provided
% access to our code to another. The script we are submitting
% is our own original work.
