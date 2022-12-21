%% AAE 251 HOMEWORK #1 
% NAME: TOMOKI KOIKE 
%
% TEAM: R06
%
% PROFESSOR: DR. KAREN MARAIS
%
% DUE: JAN 22 2019 (TUE) 10:00AM
%

%% 
% *EQUATIONS*
%
% (1) The Atmospheric Pressure at "Pause" State
%
% $$p = p1 * exp((-1)* g * (h - h1) / R / T)$
%
% (2) The Atmospheric Pressure at "Sphere" State
%
% $$p = p1 * (T / T1)^(-g / R / T_h)$
%
% where   $T_h = (T - T1) / (h - h1)$
%
% (3) The Temperature at Certain Altitude
%
% $$ T = T1 + T_h(h - h1)$
%
% (4) The Density of Atmosphere at Certain Altitude
%
% $$ d = p/R/T$$
%
% (5) The Speed of Sound
%
% $$a = sqrt(y*p/d)$
%
% where   $y = gamma = 1.4$


%%
% *PREPARATION*
altitude_ft = 0:500:100000; % Altitude vector in feet (ft)
altitude_m = 0:1:30480;     % Altitude vector in meters (m)
g_si = 9.81;                % Gravitational acceleration (m/s^2)
g_eng = 32.174;             % Gravitational acceleration (ft/s^2)
R_si = 287.05;                 % Gas constant (J/kg/K)
R_eng = 1716.27;            % Gas constant (ft^2/s^2R)
gamma = 1.4;                % Adiabatic Index or Isentropic Expansion
                            % Constant


lapse_rate_m = [-6.5*power(10,-3), 3*power(10,-3), -4.5*power(10,-3), ...
    4*power(10,-3)];          % Temperature lapse rates (K/m)
lapse_rate_ft = lapse_rate_m / 3.28084 * 1.8; 
                              % Temperature lapse rates (R/ft)

mark_height_m = [0, 11, 25, 47, 53, 79, 90, 105]*1000;
                              % Height at which the the state changes
                              % from "pause" to "sphere" or vice versa
                              % (m)
mark_height_ft = mark_height_m * 3.28084;
                              % Height corresponding to mark_height_m
                              % in feet (ft)
initial_temp_m = [288.16, 216.66, 282.66, 165.66, 256.66];
                              % Initial temperatures (K) where the 
                              % state changes from "pause" to "sphere"
                              % or vice versa
initial_temp_ft = [518.688, 389.988, 515.988, 298.188, 461.988];
                              % Initial temperatures (R) where the
                              % state changes from "pause" to "sphere"
                              % or vice versa
                              
%%                            
% *Temperature*
%
% Finding the temperature by altitude (K)

% Feet
temp_ft = tempCal(initial_temp_ft, altitude_ft, mark_height_ft,...
    lapse_rate_ft);

% Meters
temp_m = tempCal(initial_temp_m, altitude_m, mark_height_m, ...
    lapse_rate_m);


%%
% *Pressure*
%
% Finding pressure by altitude (Pa) or (lb/ft^2)

% Feet
pressure_ft = pressureCal(g_eng, R_eng, temp_ft, initial_temp_ft,...
    altitude_ft, mark_height_ft, lapse_rate_ft, "ENG");

% Meters
pressure_m = pressureCal(g_si, R_si, temp_m, initial_temp_m,...
    altitude_m, mark_height_m, lapse_rate_m, "SI");

%%
% *Density*
%
% Finding the density (kg/m^3) or (slugs/ft^3)

% Feet 
density_ft = pressure_ft ./ temp_ft / R_eng;

% Meters
density_m = pressure_m ./ temp_m / R_si;

%%
% *Speed of Sound*
%
% Finding the speed of sound (m/s) or (ft/s)

% Feet
sound_speed_ft = sqrt(gamma .* pressure_ft ./ density_ft);

% Meters
sound_speed_m = sqrt(gamma .* pressure_m ./ density_m);

%%
% *Generating Table*

% Feet
T_ft = table(altitude_ft, temp_ft, pressure_ft, density_ft,...
    sound_speed_ft);

% Meters
T_m = table(altitude_m, temp_m, pressure_m, density_m,...
    sound_speed_m);


%%
% *Generating Graphs*

% Altitude by Temp (ft)
figure
plot(temp_ft, altitude_ft, '-r')
ylabel('Altitude, h, ft')
xlabel('Temperature, R, rankine')
title('Standard Atmosphere Temperature Model in English Units')

% Altitude by Temp (m)
figure
plot(temp_m, altitude_m / 1000, '-b')
ylabel('Altitude, h, km')
xlabel('Temperature, T, kelvin')
title('Standard Atmosphere Temperature Model in SI Units')

% Altitude by Pressure (ft)
figure
plot(pressure_ft, altitude_ft, '-r')
ylabel('Altitude, h, ft')
xlabel('Pressure, p, lb/ft^2')
title('Standard Atmosphere Pressure Model in English Units')

% Altitude by Pressure (m)
figure
plot(pressure_m, altitude_m / 1000, '-b')
ylabel('Altitude, h, km')
xlabel('Pressure, p, Pa')
title('Standard Atmosphere Pressure Model in SI Units')

% Altitude by Density  (ft)
figure
plot(density_ft, altitude_ft, '-r')
ylabel('Altitude, h, ft')
xlabel('Density, d, slugs/ft^3')
title('Standard Atmosphere Density Model in English Units')

% Altitude by Density (m)
figure
plot(density_m, altitude_m / 1000, '-b')
ylabel('Altitude, h, km')
xlabel('Density, d, kg/m^3')
title('Standard Atmosphere Density Model in SI Units')

% Altitude by Speed of Sound (ft)
figure 
plot(sound_speed_ft, altitude_ft, '-r')
ylabel('Altitude, h, ft')
xlabel('Speed of Sound, a, ft/s')
title('Standard Atmosphere Sound of Speed Model in English Units')

% Altitude by Speed of Sound (m)
figure 
plot(sound_speed_m, altitude_m / 1000, '-b')
ylabel('Altitude, h, km')
xlabel('Speed of Sound, a, m/s')
title('Standard Atmosphere Sound of Speed Model in SI Units')