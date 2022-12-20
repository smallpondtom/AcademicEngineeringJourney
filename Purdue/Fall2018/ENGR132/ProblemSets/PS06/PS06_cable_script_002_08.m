%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% We are a team of civil engineers and working on a pedestain bridge.
% This program is aimed to figure out the total length, weight, and 
% cost of the cables used for the bridge.
%
% Assigment Information
% Assignment:       	PS 06, Problem 3
%   Team ID:			002-08
%   Team Member:		Ian Pitman, ipitman@purdue.edu
%   Team Member:		Eu Jin Lee, lee2219@purdue.edu
%   Team Member:		Tomoki Koike, koike@purdue.edu
%   Team Member:		Yi Zhou, zhou823@purdue.edu
%  	Contributor:    Name, login@purdue [repeat for each]
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

% the north side of the bridge 
% the heights and the distances of the cables for the east side 
east_bridge_heights = [50, 54, 58, 62, 66, 70]';      % meters
east_bridge_distance = [30, 58, 84, 108, 130, 150]';  % meters

% the heights and distances of the cables for the east side
west_bridge_heights = [50, 54, 58, 62, 66, 70]';  % meters
west_bridge_distance = [18, 34, 48, 60, 70, 78]'; % meters

% the number of strands for each cable
cables_strands = [45, 45, 45, 45, 45, 36]';
 
strand_weight = 1.1; % the weight for one strand (kg) 
costPerKg = 25;      % the cost per kg ($)


%% ____________________
%% CALCULATIONS

% the callouts for the function which calculates the
% total length, weight, and cost of the cables.
[cable_length,cable_weight,total_cost] = PS06_cableUDF_002_08(east_bridge_heights, distances_deck, num_strand)


%% ____________________
%% FORMATTED TEXT & FIGURE DISPLAYS



%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% We have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have we provided
% access to our code to another. The script we are submitting
% is our own original work.



