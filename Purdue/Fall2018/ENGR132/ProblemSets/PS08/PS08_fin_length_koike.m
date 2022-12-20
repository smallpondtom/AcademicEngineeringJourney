function [minRodLength] = PS08_fin_length_koike(rodDiameter, thermalConductivity, sourceTemp, ambientTemp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program calculates the temperature of a rod which is adjacent
% to a heat source using the infinite fin model. And the function 
% will output the minimum length of the rod for the model to be
% probable.
%
% Function Call
% PS08_fin_length_koike(rodDiameter, thermalConductivity, sourceTemp, ambientTemp);
%
% Input Arguments
% 1. rodDiameter: the diameter of the given rod 
% 2. thermalConductivity: the thermal conductivity of the rod depending 
%    on its material
% 3. sourceTemp: the temperature of the heat source
% 4. ambientTemp: the temperature of the ambient air
%
% Output Arguments
% 1. minRodLength: the minimum possible rod length for the model
%
% Assignment Information
%   Assignment:       	PS 08, Problem 2
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

% the array for academic integrity statement
nameArray = "Tomoki Koike";

% the invalid conditions for the input arguments
% rod diameter
invalidRodDiameter = rodDiameter < 0;
% thermal conductivity
invalidThermalConductivity = thermalConductivity < 0;
% heat source temperature
invalidSourceTemp = sourceTemp < 0;
% ambient air temperature
invalidAmbientTemp = ambientTemp < 0;

% the thermal conductivities for each material (W/(m*K))
%AlConductivity = 205;
%CuConductivity = 400;
%stainlessSteelConductivity = 16;

% setting the constants
%rodDiameter = 0.005; %the diameter of the rods (m)
%sourceTemp = 373;    %the source temperature (K)
%ambientTemp = 298;   %the ambient temperature (K)
heatXcoeff = 100;    %the convection heat transaction coefficient (W/(m^2*K))
perimeter = rodDiameter * pi;
area = pi * (rodDiameter / 2)^2;
m_coeff = sqrt(heatXcoeff * perimeter / area / thermalConductivity);

%% ____________________
%% CALCULATIONS

% the initialization of the output argument
minRodLength = -1;

%start
if invalidRodDiameter
    fprintf("Error! invalid rod diameter");
elseif invalidThermalConductivity
    fprintf("Error! invalid thermal conductivity");
elseif invalidSourceTemp
    fprintf("Error! invalid heat source temperature");
elseif invalidAmbientTemp
    fprintf("Error! invalid ambient air temperature");
else
    tempX = 1;
    x = 0;
    while round(tempX) ~= ambientTemp
        x = x + 0.01;
        tempX = ambientTemp + (sourceTemp - ambientTemp) * exp(-m_coeff * x);
        fprintf("The temperature of the rod x(m) from the heat source is %.0f K\n", tempX);     
    end
minRodLength = x;
end   

% print the final result of the output 
fprintf("\nThe minimum rod length is %.2f m\n\n", minRodLength);

%% ____________________
%% COMMAND WINDOW OUTPUT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for aluminum
% AlConductivity = 205;
% thermalConductivity = AlConductivity;
% rodDiameter = 0.005; %the diameter of the rods (m)
% sourceTemp = 373;    %the source temperature (K)
% ambientTemp = 298;   %the ambient temperature (K)
% PS08_fin_length_koike(rodDiameter, thermalConductivity, sourceTemp, ambientTemp)
% The temperature of the rod x(m) from the heat source is 360 K
% The temperature of the rod x(m) from the heat source is 349 K
% The temperature of the rod x(m) from the heat source is 339 K
% The temperature of the rod x(m) from the heat source is 332 K
% The temperature of the rod x(m) from the heat source is 326 K
% The temperature of the rod x(m) from the heat source is 321 K
% The temperature of the rod x(m) from the heat source is 317 K
% The temperature of the rod x(m) from the heat source is 313 K
% The temperature of the rod x(m) from the heat source is 311 K
% The temperature of the rod x(m) from the heat source is 308 K
% The temperature of the rod x(m) from the heat source is 307 K
% The temperature of the rod x(m) from the heat source is 305 K
% The temperature of the rod x(m) from the heat source is 304 K
% The temperature of the rod x(m) from the heat source is 303 K
% The temperature of the rod x(m) from the heat source is 302 K
% The temperature of the rod x(m) from the heat source is 301 K
% The temperature of the rod x(m) from the heat source is 301 K
% The temperature of the rod x(m) from the heat source is 300 K
% The temperature of the rod x(m) from the heat source is 300 K
% The temperature of the rod x(m) from the heat source is 299 K
% The temperature of the rod x(m) from the heat source is 299 K
% The temperature of the rod x(m) from the heat source is 299 K
% The temperature of the rod x(m) from the heat source is 299 K
% The temperature of the rod x(m) from the heat source is 299 K
% The temperature of the rod x(m) from the heat source is 299 K
% The temperature of the rod x(m) from the heat source is 298 K
% 
% The minimum rod length is 0.26 m
% 
% I am submitting code that is my own original work. I have not used
% source code, either modified or unmodified, obtained from any
% unauthorized source. Neither have I provided access to my code to any
% peer or unauthorized source. Signed,
% <Tomoki Koike>
% 
% ans =
% 
%     0.2600

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for copper
% CuConductivity = 400;
% thermalConductivity = CuConductivity;
% rodDiameter = 0.005; %the diameter of the rods (m)
% sourceTemp = 373;    %the source temperature (K)
% ambientTemp = 298;   %the ambient temperature (K)
% PS08_fin_length_koike(rodDiameter, thermalConductivity, sourceTemp, ambientTemp)
% The temperature of the rod x(m) from the heat source is 373 K
% The temperature of the rod x(m) from the heat source is 363 K
% The temperature of the rod x(m) from the heat source is 355 K
% The temperature of the rod x(m) from the heat source is 347 K
% The temperature of the rod x(m) from the heat source is 341 K
% The temperature of the rod x(m) from the heat source is 335 K
% The temperature of the rod x(m) from the heat source is 330 K
% The temperature of the rod x(m) from the heat source is 326 K
% The temperature of the rod x(m) from the heat source is 322 K
% The temperature of the rod x(m) from the heat source is 319 K
% The temperature of the rod x(m) from the heat source is 316 K
% The temperature of the rod x(m) from the heat source is 314 K
% The temperature of the rod x(m) from the heat source is 312 K
% The temperature of the rod x(m) from the heat source is 310 K
% The temperature of the rod x(m) from the heat source is 308 K
% The temperature of the rod x(m) from the heat source is 307 K
% The temperature of the rod x(m) from the heat source is 306 K
% The temperature of the rod x(m) from the heat source is 305 K
% The temperature of the rod x(m) from the heat source is 304 K
% The temperature of the rod x(m) from the heat source is 303 K
% The temperature of the rod x(m) from the heat source is 302 K
% The temperature of the rod x(m) from the heat source is 302 K
% The temperature of the rod x(m) from the heat source is 301 K
% The temperature of the rod x(m) from the heat source is 301 K
% The temperature of the rod x(m) from the heat source is 301 K
% The temperature of the rod x(m) from the heat source is 300 K
% The temperature of the rod x(m) from the heat source is 300 K
% The temperature of the rod x(m) from the heat source is 300 K
% The temperature of the rod x(m) from the heat source is 299 K
% The temperature of the rod x(m) from the heat source is 299 K
% The temperature of the rod x(m) from the heat source is 299 K
% The temperature of the rod x(m) from the heat source is 299 K
% The temperature of the rod x(m) from the heat source is 299 K
% The temperature of the rod x(m) from the heat source is 299 K
% The temperature of the rod x(m) from the heat source is 299 K
% The temperature of the rod x(m) from the heat source is 299 K
% The temperature of the rod x(m) from the heat source is 298 K
% 
% The minimum rod length is 0.36 m
% 
% I am submitting code that is my own original work. I have not used
% source code, either modified or unmodified, obtained from any
% unauthorized source. Neither have I provided access to my code to any
% peer or unauthorized source. Signed,
% <Tomoki Koike>
% 
% ans =
% 
%     0.3600
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for stainless steel
% stainlessSteelConductivity = 16;
% thermalConductivity = stainlessSteelConductivity;
% rodDiameter = 0.005; %the diameter of the rods (m)
% sourceTemp = 373;    %the source temperature (K)
% ambientTemp = 298;   %the ambient temperature (K)
% PS08_fin_length_koike(rodDiameter, thermalConductivity, sourceTemp, ambientTemp)
% The temperature of the rod x(m) from the heat source is 373 K
% The temperature of the rod x(m) from the heat source is 335 K
% The temperature of the rod x(m) from the heat source is 316 K
% The temperature of the rod x(m) from the heat source is 307 K
% The temperature of the rod x(m) from the heat source is 302 K
% The temperature of the rod x(m) from the heat source is 300 K
% The temperature of the rod x(m) from the heat source is 299 K
% The temperature of the rod x(m) from the heat source is 298 K
% 
% The minimum rod length is 0.08 m
% 
% I am submitting code that is my own original work. I have not used
% source code, either modified or unmodified, obtained from any
% unauthorized source. Neither have I provided access to my code to any
% peer or unauthorized source. Signed,
% <Tomoki Koike>
% 
% ans =
% 
%     0.0800

%% ____________________
%% ACADEMIC INTEGRITY STATEMENT

% Call your academic integrity statement here
PS07_academic_integrity_koike(nameArray);


