function [windrow_height,windrow_weight] = PS06_salt_windrow_ipitman_zhou823(windrow_width,windrow_length);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% Finding the windrow height and weight when we are given the values for
% the windrow width and lenth.
%
% Function Call
% [windrow_height,windrow_weight] = PS06_salt_windrow_ipitman_zhou823(windrow_width,windrow_length)
%
% Input Arguments
% 1. Windrow width (scalar)
% 2. Windrow length (scalar)
%
% Output Arguments
% 1. Windrow height (scalar)
% 2. Windrow weight (scalar)
%
% Assignment Information
%   Assignment:			PS 06, Problem 1
%   Team ID:			002-08
%   Paired Partner:		Ian Pitman, ipitman@purdue.edu
%   Paired Partner:		Yi Zhou, zhou823@purdue.edu
%   Contributor:		Name, login@purdue [repeat for each]
%   Our contributor(s) helped us:	
%     [ ] understand the assignment expectations without
%         telling us how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping us plan our solution.
%     [ ] think through the meaning of a specific error or
%         bug present in our code without looking at our code.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ____________________
%% INITIALIZATION

% Angle of Repose
angle_repose = 32 * (pi/180);   % angle of repose (radians)

% Density of Salt
salt_density = 80;    % density of salt (pounds per cubic feet)
%% ____________________
%% CALCULATIONS

% Convert salt density to (metric ton)/m^3 using the conversion constants:
% 1 kg = 2.2 lb, 1 mt = 1000 kg, 1 m = 3.3 ft 
salt_density_mt = salt_density * (1/2.2) * (1/1000) * (3.3^3);    % density of salt (metric ton/m^3)

% Calculate the height, volume, and weight of salt in a single windrow pile
windrow_height = (windrow_width * tan(angle_repose)) / 2;   % height of single windrow pile (meters)
windrow_volume = (windrow_width * windrow_height * windrow_length) / 2;    % volume of single windrow pile (m^3)
windrow_weight = (salt_density_mt * windrow_volume) * 9.8;    % weight of a single windrow pile (metric tons)
%% ____________________
%% FORMATTED TEXT & FIGURE DISPLAYS

fprintf('The height of one windrow pile is %0.2f meters \n', windrow_height )
fprintf('The weight of one windrow pile is %0.1f metric tons \n', windrow_weight )
%% ____________________
%% COMMAND WINDOW OUTPUT

% [windrow_height,windrow_weight] = PS06_salt_windrow_ipitman_zhou823(windrow_width,windrow_length)
%  The height of one windrow pile is 5.73 meters 
% The weight of one windrow pile is 30314.4 metric tons 
% windrow_height =
% 
%     5.7332
% 
% 
% windrow_weight =
% 
%    3.0314e+04
%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% We have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have we provided
% access to our code to another. The function we are submitting
% is our own original work.
