function [height_cone, weight_cone] = PS06_salt_cone_koike_lee2219(cone_width); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% Create seven (7) variables and set them equal to the values provided in 
% the problem setup: cone width, number of conical piles, angle of 
% repose, and density of salt. On calculating user defined functions 
% will be implemented to calculate the height and the weight of the 
% cone piles.
%
% Function Call
% [coneHeight, coneWeight] = PS06_salt_cone_koike_lee2219(cone_width);
%
% Input Arguments
%  1. diameter is the given diameter or width of the cone
%
% Output Arguments
%  1. coneHeight: is the calculated height of the cone
%  2. coneWidth: is the calculated weight of the cone
%
% Assignment Information
%   Assignment:			PS 06, Problem 1
%   Team ID:			002-08
%   Paired Partner:		Tomoki Koike , koike@purdue.edu
%   Paired Partner:		Eu Jin Lee, lee2219@purdue.edu
%   Contributor:		no contributor
%   Our contributor(s) helped us:	
%     [ ] understand the assignment expectations without
%         telling us how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping us plan our solution.
%     [ ] think through the meaning of a specific error or
%         bug present in our code without looking at our code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION

% Create seven variables 

angle_repose = 32;              %the angle of the natrually formed slope of salt pile, aka angle of repose (degrees)
density_salt = 80;              %the density of salt (lb/ft^3)


%% ____________________
%% CALCULATIONS

% Convert salt density to (metric ton)/m^3 using the conversion 
% constants: 1 kg = 2.2 lb, 1 mt = 1000 kg, 1 m = 3.3 ft 
% mt stands for metric tons
lb_to_kg = 2.2;                                                         
        %conversion of one kilogram per one pound (lb/kg)
kg_to_mt = 10^(-3);                                                     
        %conversion of one kilogram to metric tons (mt/kg)
cubic_ft = 3.3^3;                                                      
        %cubic foot per cubic meter (ft^3/m^3)
density_salt_metric = density_salt / lb_to_kg * kg_to_mt * cubic_ft;    
        %density of salt (mt/m^3)  

% height, volume, and weight of salt in a single conical pile 
%calculation of the height
tangent_angle = tand(angle_repose);                         
        %the tangent value of the angle of repose
height_cone = cone_width * tangent_angle / 2;               
        %height of one conical pile (m)

%calculation of the volume
volume_cone = pi * cone_width^2 * height_cone / 12;         
        %volume of one conical pile (m^3)

%calculation of the weight 
weight_cone = density_salt_metric * volume_cone;            
        %weight of one conical pile (mt)


%% ____________________
%% FORMATTED TEXT & FIGURE DISPLAYS

% Print the height and weight of one conical pile to the Command Window 
% using one print command. Use language appropriate for technical communication.

% Display the height with 2 decimal place to the command window.
fprintf("The height of one conical pile is %.2f meters. \n" , height_cone);

% Display the weight with 1 decimal place to the command window. 
fprintf("The weight of one conical pile is %.1f metric tons. \n" , weight_cone);


%% ____________________
%% COMMAND WINDOW OUTPUT
% [coneHeight, coneWeight] = PS06_salt_cone_koike_lee2219(cone_width);

%cone_width = 21.5
%
%cone_width =
%
%   21.5000
%
%[heigth_cone,weight_cone] = PS06_salt_cone_koike_lee2219(cone_width);
%The height of one conical pile is 6.72 meters. 
%The weight of one conical pile is 1062.3 metric tons. 
%
%heigth_cone =
%
%    6.7173
%
%
%weight_cone =
%
%   1.0623e+03
%
%
%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% We have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have we provided
% access to our code to another. The function we are submitting
% is our own original work.
