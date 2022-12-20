function []= PS07_observatory_koike_ipitman(x_coord, y_coord)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% We are an engineering team that is working to install cameras in an
% small museum. We have to meet certain requirements such as: the 
% cameras cannot be on the walls, doors, or outside the building.
%
% Function Call
% PS07_observatory_koike_ipitman.m(x_coord, y_coord)
%
% Input Arguments
% 1. x_coord: x coordinates 
% 2. y_coord: y coordinates 
% Output Arguments
% no outputs 
%
% Assignment Information
%   Assignment:			PS 07, Problem 1
%   Team ID:			002-08
%   Paired Partner:		Tomoki Koike, koike@purdue.edu
%   Paired Partner:		Ian Pitman, ipitman@purdue.edu
%   Contributor:		Name, login@purdue [repeat for each]
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

% Defining the ranges of the x-coordinates and the y-coordinates 
% which designate the rooms of the small museum and the museum itself

% the observatory
observ = (-5<x_coord && x_coord<5)&&(-sqrt(25-x_coord^2)<y_coord && y_coord<sqrt(25-x_coord^2));

% exhibit hall 
exbHall = ((-5<x_coord && x_coord<5)&&(1<y_coord && y_coord<9)&&(~(-sqrt(25-x_coord^2)<=y_coord && y_coord<=sqrt(25-x_coord^2))));

% mechanical room
mechRoom = ((-6<x_coord && x_coord<0)&&(-9<y_coord && y_coord<1)&&(~(-sqrt(25-x_coord^2)<=y_coord && y_coord<=sqrt(25-x_coord^2))));

% offices
office = ((0<x_coord && x_coord<6)&&(-9<y_coord && y_coord<1)&&(~(-sqrt(25-x_coord^2)<=y_coord && y_coord<=sqrt(25-x_coord^2))));

%% ____________________
%% CALCULATIONS

% accesses the location of the surveillence camera and displays the \
% specific location 
%Calling function: PS07_observatory_koike_ipitman.m(x_coord, y_coord);

    if observ
        disp('The surveillence camera is in the observatory.');
    elseif exbHall
        disp('The surveillence camera is in the exhibit hall.');
    elseif mechRoom
        disp('The surveillence camera is in the mechanical room.');
    elseif office
        disp('The surveillence camera is in the offices.');
    else 
        disp('ERROR! The surveillence camera is in a improper location.');
    end

%% ____________________
%% FORMATTED TEXT DISPLAYS

%x_coord = 0;
%y_coord = 1;
%PS07_observatory_koike_ipitman(x_coord, y_coord)
%The surveillence camera is in the observatory.

%PS07_observatory_koike_ipitman(1, 1)
%The surveillence camera is in the observatory.

%% ____________________
%% COMMAND WINDOW OUTPUTS

%PS07_observatory_koike_ipitman(0, 0)
%The surveillence camera is in the observatory.

%PS07_observatory_koike_ipitman(0, 5)
%ERROR! The surveillence camera is in a improper location.

%PS07_observatory_koike_ipitman(0, -5)
%ERROR! The surveillence camera is in a improper location.

%PS07_observatory_koike_ipitman(5, 0)
%ERROR! The surveillence camera is in a improper location.

%PS07_observatory_koike_ipitman(-5, 0)
%ERROR! The surveillence camera is in a improper location.

%PS07_observatory_koike_ipitman(2, 8)
%The surveillence camera is in the exhibit hall.

%PS07_observatory_koike_ipitman(5*cos(20), 5*sin(20))
%ERROR! The surveillence camera is in a improper location.

%PS07_observatory_koike_ipitman(-4, -7)
%The surveillence camera is in the mechanical room.

%PS07_observatory_koike_ipitman(1, -7)
%The surveillence camera is in the offices.


%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% We have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have we provided
% access to our code to another. The function we are submitting
% is our own original work.