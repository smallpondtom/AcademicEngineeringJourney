function [fluidVol] = PS07_tankVolume_koike(orientation, fluidHeight)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program is designed to calculate the volume of fluid inside 
% a horizontal and vertical cylindrical tank with hemispherical end 
% caps.
%
% Function Call
% PS07_tankVolume_koike(orientation, fluidHeight)
%
% Input Arguments
% 1. orientation: the orientation of the tank which are horizontal 
%    and vertical 
% 2. fluidHeight: the height of the fluid inside the tank   
%
% Output Arguments
% 1. fluidVol: the volume of the fluid
%
% Assignment Information
%   Assignment:       	PS 07, Problem 3
%   Author:             Tomoki Koike , koike@purdue.edu
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

% for the academic integrity statement 
nameArray = ["Tomoki Koike"];

% setting variables for constant values of the tank 
tankR = 3.35 / 2;   %the radius of the hemispherical part of tank (m)
tankCenterL = 21.1 - 3.35;       %the length of the cylindrical center
                                 %of the tank (m)

% the different ranges of the fluid height for when the 
% tank is in vertical orientation

%when the fluid height goes up to the top hemisphere
upToTopHemis = (orientation == "vertical")&((tankR + tankCenterL)<=fluidHeight)&(fluidHeight<=(2*tankR + tankCenterL));
%when the fluid height is in between the cylindrical section
upToCylinder = (orientation == "vertical")&(tankR<=fluidHeight)&(fluidHeight<=(tankR + tankCenterL));
%when the fluid height is only in the low hemisphere
upToLowHemis = (orientation == "vertical")&(0<=fluidHeight)&(fluidHeight<=tankR);

%the condition for the horizontal orientation 
horzOrient = (orientation == "horizontal")&(0<=fluidHeight & fluidHeight<=2*tankR);
%the condition for the vertcial orientation 
vertOrient = (orientation == "vertical")&(0<=fluidHeight & fluidHeight<=(2*tankR + tankCenterL));


%% ____________________
%% CALCULATIONS, STRUCTURE, & TEXT DISPLAYS

% the calculation for the fluid volume for each orientation and 
% conditions

% for the vertical upToLowHemis condition
vertLowHemisVol = (pi*(fluidHeight^2)*(3*tankR - fluidHeight))/3;
% for the vertical upToCylinder condition
vertCylinderVol = 2*pi*(tankR^3)/3 + pi*(tankR^2)*(fluidHeight - tankR);
% for the vertical upToTopHemis condition
vertTopHemisVol = pi*(tankR^2)*tankCenterL + pi*((fluidHeight - tankCenterL)^2)*(3*tankR - fluidHeight + tankCenterL)/3;
% for the horizontal orientation
horzVol = vertLowHemisVol + tankCenterL*((tankR^2)*acos((tankR - fluidHeight)/tankR) - (tankR - fluidHeight)*sqrt(2*tankR*fluidHeight - (fluidHeight^2)));

% the selection structure 

    if ~(horzOrient || vertOrient)
        fluidVol = -1;
        fprintf('\nError: Improper orientaion or fluid height inputted (orientation only accepts horizontal or vertical, case-sensitive)\n\n');
    elseif horzOrient
        fluidVol = horzVol;
        fprintf('\nThe volume of the fluid in the tank is %.4f m^3.\n\n',fluidVol);
    elseif upToTopHemis
        fluidVol = vertTopHemisVol;
        fprintf('\nThe volume of the fluid in the tank is %.4f m^3.\n\n',fluidVol);
    elseif upToCylinder
        fluidVol = vertCylinderVol;
        fprintf('\nThe volume of the fluid in the tank is %.4f m^3.\n\n',fluidVol);
    elseif upToLowHemis
        fluidVol = vertLowHemisVol;
        fprintf('\nThe volume of the fluid in the tank is %.4f m^3.\n\n',fluidVol);
    else
        fluidVol = -1;
        fprintf('\nError: Unexpected error occuring\n\n');
    end
      
%% ____________________
%% COMMAND WINDOW OUTPUTS

%orientation = "horizontal";
%PS07_tankVolume_koike(orientation, 2.5)

%The volume of the fluid in the tank is 141.7453 m^3.

%I am submitting code that is my own original work. I have not used
%source code, either modified or unmodified, obtained from any
%unauthorized source. Neither have I provided access to my code to any
%peer or unauthorized source. Signed,
%<Tomoki Koike>

%ans =

%  141.7453

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%orientation = "vertical";

%PS07_tankVolume_koike(orientation, 1.5)

%The volume of the fluid in the tank is 8.3056 m^3.

%I am submitting code that is my own original work. I have not used
%source code, either modified or unmodified, obtained from any
%unauthorized source. Neither have I provided access to my code to any
%peer or unauthorized source. Signed,
%<Tomoki Koike>

%ans =

%    8.3056

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%PS07_tankVolume_koike(orientation, 10.33)

%The volume of the fluid in the tank is 86.1287 m^3.

%I am submitting code that is my own original work. I have not used
%source code, either modified or unmodified, obtained from any
%unauthorized source. Neither have I provided access to my code to any
%peer or unauthorized source. Signed,
%<Tomoki Koike>

%ans =

%   86.1287

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%PS07_tankVolume_koike(orientation, 17.59)

%The volume of the fluid in the tank is 150.1193 m^3.

%I am submitting code that is my own original work. I have not used
%source code, either modified or unmodified, obtained from any
%unauthorized source. Neither have I provided access to my code to any
%peer or unauthorized source. Signed,
%<Tomoki Koike>

%ans =

%  150.1193

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%PS07_tankVolume_koike(orientation, 20)

%The volume of the fluid in the tank is 171.1623 m^3.

%I am submitting code that is my own original work. I have not used
%source code, either modified or unmodified, obtained from any
%unauthorized source. Neither have I provided access to my code to any
%peer or unauthorized source. Signed,
%<Tomoki Koike>

%ans =

%  171.1623

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%orientation = "h";
%PS07_tankVolume_koike(orientation, 15)

%Error: Improper orientaion or fluid height inputted (orientation only accepts horizontal or vertical, case-sensitive)

%I am submitting code that is my own original work. I have not used
%source code, either modified or unmodified, obtained from any
%unauthorized source. Neither have I provided access to my code to any
%peer or unauthorized source. Signed,
%<Tomoki Koike>

%ans =

%    -1

%% ____________________
%% ACADEMIC INTEGRITY STATEMENT

% Call your Academic Integrity function from problem 2
PS07_academic_integrity_koike(nameArray);