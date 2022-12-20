function [cable_length,cable_weight,total_cost] = PS06_cableUDF_002_08(bridge_height, distances_deck, num_strand) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% We are on a civil engineering team working on a pedestrian bridge.
% This program includes a function that computes the total length, 
% weight, and cost for the cables used for the bridge. 
%
% Function Call
% [cable_length,cable_weight,total_cost] = PS06_cableUDF_002_08(bridge_height, distances_deck, num_strand)
%
% Input Arguments
% 1. Heights from the bridge deck to the cable tower anchorage
% 2. Distances between the tower base and the cable deck anchorage
% 3. Number of strands in the cable
%
% Output Arguments
% 1. Total Cable Length
% 2. Total Cable Weighteast_bridge_distance = [30, 58, 84, 108, 130, 150]';  % meters
% 3. Total Estimated Cost
%
% Assignment Information
%   Assignment:       	PS 06, Problem 3
%   Team ID:			002-08
%   Team Member:		Ian Pitman, ipitman@purdue.edu
%   Team Member:		Eu Jin Lee, lee2219@purdue.edu
%   Team Member:		Tomoki Koike, koike@purdue.edu
%   Team Member:		Yi Zhou, zhou823@purdue.edu
%  	Contributor: 		Name, login@purdue [repeat for each]
%   My contributor(s) helped me:	
%     [ ] understand the assignment expectations without
%         telling me how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping me plan my solution.
%     [ ] think through the meaning of a specific error or
%         bug present in my code without looking at my code.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
% the calculation for the cable length using pythagoreans theorem
% east side (m)
east_cable_length = sqrt(east_bridge_heights .^2 + east_bridge_distance .^2);
% west side (m)
west_cable_length = sqrt(west_bridge_heights .^2 + west_bridge_distance .^2);
% total length the sum of east side and the west side (m) 
% (north side only)
total_cable_length = east_cable_length + west_cable_length;
% the total length of cables for the bridge (north and south side)
cable_length = 2 * total_cable_length;


% the total weight of the cables (kg) 
% on the east side
cable_weight_east = 2 * sum(strand_weight * east_cable_length .* cables_strand);
% on the west side
cable_weight_west = 2 * sum(strand_weigth * west_cable_length .* cables_strand);
% the total weigth
cable_weight = cable_weigth_east + cable_weight_west;

% the total cost for the bridge 
total_cost = costPerKg * cable_weight;


%% ____________________
%% COMMAND WINDOW OUTPUT



%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% We have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have we provided
% access to our code to another. The function we are submitting
% is our own original work.
