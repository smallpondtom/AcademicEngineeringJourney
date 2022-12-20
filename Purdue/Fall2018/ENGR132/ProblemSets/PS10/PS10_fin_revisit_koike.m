function [minRodLength] = PS10_fin_revisit_koike(thermalConductivity, minRodDiameter, maxRodDiameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program calculates the temperature of a rod which is adjacent
% to a heat source using the infinite fin model. And the function 
% will output the minimum length of the rod for the model to be
% probable.
%
% Function Call
% PS10_fin_revisit_koike(thermalConductivity, minRodDiameter, maxRodDiameter);
%
% Input Arguments 
% 1. thermalConductivity: the thermal conductivity of the rod depending 
%    on its material
% 2. minRodDiameter: the minimum rod diameter
% 3. maxRodDiameter: the maximum rod diameter 
%
% Output Arguments
% 1. minRodLength: the minimum possible rod length for the model
%
% Assignment Information
%   Assignment:       	PS 10, Problem 1
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

% the rod diameter range (mm)
rodDiameter = minRodDiameter:0.5:maxRodDiameter;

% the invalid conditions for the input arguments
% rod diameter (mm)
invalidRodDiameter = minRodDiameter < 0 | maxRodDiameter < 0.5;
% thermal conductivity
invalidThermalConductivity = thermalConductivity < 0;

% the thermal conductivities for each material (W/(m*K))
%AlConductivity = 205;
%CuConductivity = 400;
%stainlessSteelConductivity = 16;

% setting the constants
sourceTemp = 373;    %the source temperature (K)
ambientTemp = 298;   %the ambient temperature (K)
heatXcoeff = 100;    %the convection heat transaction coefficient (W/(m^2*K))

%% ____________________
%% CALCULATIONS

% the initialization of the output argument
minRodLength = -1;

%start
if invalidRodDiameter
    fprintf("Error! invalid rod diameter");
elseif invalidThermalConductivity
    fprintf("Error! invalid thermal conductivity");
else
    for rodDiameter = minRodDiameter:0.5:maxRodDiameter
        %calculations
        perimeter = rodDiameter * pi;
        area = pi * (rodDiameter / 2).^2;
        m_coeff = sqrt(heatXcoeff * perimeter / area / thermalConductivity);
        tempX = 1;
        x = 0;
        while round(tempX) ~= ambientTemp
            x = x + 0.01;
            tempX = ambientTemp + (sourceTemp - ambientTemp) * exp(-m_coeff * x);
        end
        minRodLength = x;
        % print the final result of the output 
        fprintf("The minimum rod length of a %.4f mm diameter rod is %.8f m\n", rodDiameter, minRodLength);
    end
end   



%% ____________________
%% COMMAND WINDOW OUTPUT

% PS10_fin_revisit_koike(205, 1, 10)
% The minimum rod length of a 1.0000 mm diameter rod is 3.59000000 m
% The minimum rod length of a 1.5000 mm diameter rod is 4.40000000 m
% The minimum rod length of a 2.0000 mm diameter rod is 5.08000000 m
% The minimum rod length of a 2.5000 mm diameter rod is 5.68000000 m
% The minimum rod length of a 3.0000 mm diameter rod is 6.22000000 m
% The minimum rod length of a 3.5000 mm diameter rod is 6.72000000 m
% The minimum rod length of a 4.0000 mm diameter rod is 7.18000000 m
% The minimum rod length of a 4.5000 mm diameter rod is 7.61000000 m
% The minimum rod length of a 5.0000 mm diameter rod is 8.03000000 m
% The minimum rod length of a 5.5000 mm diameter rod is 8.42000000 m
% The minimum rod length of a 6.0000 mm diameter rod is 8.79000000 m
% The minimum rod length of a 6.5000 mm diameter rod is 9.15000000 m
% The minimum rod length of a 7.0000 mm diameter rod is 9.50000000 m
% The minimum rod length of a 7.5000 mm diameter rod is 9.83000000 m
% The minimum rod length of a 8.0000 mm diameter rod is 10.15000000 m
% The minimum rod length of a 8.5000 mm diameter rod is 10.46000000 m
% The minimum rod length of a 9.0000 mm diameter rod is 10.77000000 m
% The minimum rod length of a 9.5000 mm diameter rod is 11.06000000 m
% The minimum rod length of a 10.0000 mm diameter rod is 11.35000000 m
% I am submitting code that is my own original work. I have not used
% source code, either modified or unmodified, obtained from any
% unauthorized source. Neither have I provided access to my code to any
% peer or unauthorized source. Signed,
% <Tomoki Koike>
% 
% ans =
% 
%    11.3500


%% ____________________
%% ACADEMIC INTEGRITY STATEMENT

PS07_academic_integrity_koike("Tomoki Koike")


