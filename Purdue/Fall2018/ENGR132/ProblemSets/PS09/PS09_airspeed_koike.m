function [dynamicPressure, soundSpeed] = PS09_airspeed_koike()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program has two steps of calculation which aims to calculate
% the dynamic pressure of an aircraft and the sound of speed. In the
% first step another function is implemented to calculate the 
% atmoshperic pressure and tempeature depending on the altitude. 
% Secondly, using the outputted vectors of the atmospheric pressure 
% and temperature this program computes the dynamic pressure using 
% a specific equation.
%
% Function Call
% [dynamicPressure] = PS09_airspeed_koike();
% Input Arguments
% there are no inputs for this function 
%
% Output Arguments
% 1. dynamicPressure: the dynamic pressure (kPa)
%
% Assignment Information
%   Assignment:       	PS 09, Problem 3
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

% setting all the constants in the equation 
gamma = 1.4;        %ratio between specific heats of air (dimensionless)
machNum = 0.85;     %mach number (dimensionless)
gasConst = 287.04;  %the specific gas constant for air (N*m/(kg*K))

%% ____________________
%% CALCULATIONS

% start of flow

% initializing the outputs atmospheric pressure and temperature
atm_pressure = -99;     %(kPa)
atm_temperature = -99;  %(K)

% initializing the altitude
altitude = 0;

for n = 1:1:(85.5/0.5 + 1)
    altitude(n) = (n - 1) / 2;
    [atm_pressure(n), atm_temperature(n)] = USAtmos_1976(altitude(n));
    % printing out results for clarification
    fprintf('(%d) altitude: %.4f km, atm P: %.4f kPa, atm T: %.4f K\n',...
        n, altitude(n), atm_pressure(n), atm_temperature(n));
end
    
% plotting the graphs for the "X: atm_pressure & Y: altitude" and 
% "X: atm_temperature & Y: altitude" 
figure 
subplot(1,2,1);
plot(atm_pressure, altitude, ".k");
title({'The Atmospheric Pressure' 'Corresponding to the Altitude'});
xlabel('atmospheric pressure(kPa)');
ylabel('altitude (km)');
grid on; 
grid minor;

subplot(1,2,2);
plot(atm_temperature, altitude, ".r");
title({'The Atmospheric Temperature' 'Corresponding to the Altitude'});
xlabel('atmospheric temperature (K)');
ylabel('altitude (km)');
grid on; 
grid minor;

% next using the vectors of the obtained atmospheric pressure and 
% atmospheric temperature we calculate the dynamic pressure

% initializing the dynamic pressure 
dynamicPressure = -99;
soundSpeed = -99;
altitude = -99;
fprintf("\n");


% initializing and converting the tested altitudes into m
test_ft = 20000:1000:45000; %(ft)
%test_ft = [20000 28000 32000 36000 45000]; (ft)
test_km = test_ft * 0.305 / 1000;              %(km)
% initializing the index
k = 1;
for k = 1:1:length(test_km)
    altitude(k) = test_km(k);
    % getting the corresponding atmospheric pressures and 
    % temperatures
    [atm_pressure(k), atm_temperature(k)] = USAtmos_1976(altitude(k));
    % calculating the sound speed (m/s) at given 
    % absolute temperature (K) 
    soundSpeed(k) = sqrt(gamma * gasConst * atm_temperature(k));
    % break down of the calculation for the dynamic pressure
    rho = atm_pressure(k) / gasConst / atm_temperature(k);
    calPart1 = (gamma - 1) * rho / 2 / gamma / atm_pressure(k);
    calPart2 = (machNum * soundSpeed(k))^2 ;
    calPower = gamma / (gamma - 1);
    % calculation of dynamic pressure
    dynamicPressure(k) = atm_pressure(k) * ((1 + calPart1 * calPart2)^calPower - 1);
    % printing out the results for each iterations 
    fprintf('(%d) Altitude %.4f km: The speed of sound is %.4f m/s and dynamic pressure is %.4f kPa\n'...
        , k, altitude(k), soundSpeed(k), dynamicPressure(k));
end


fprintf("\n");

figure 
plot(dynamicPressure, altitude, ":ob");
title('The Dynamic Pressure Corresponding to the Altitude');
xlabel('dynamic pressure(kPa)');
ylabel('altitude (km)');
grid on; 
grid minor;

figure 
plot(soundSpeed, altitude, ":ob");
title('The Speed of Sound Corresponding to the Altitude');
xlabel('speed of sound (m/s)');
ylabel('altitude (km)');
grid on; 
grid minor;

%% ____________________
%% COMMAND WINDOW OUTPUT

% part1 from 0km to 86km
% (1) altitude: 0.0000 km, atm P: 101.3250 kPa, atm T: 288.1500 K
% (2) altitude: 0.5000 km, atm P: 95.4608 kPa, atm T: 284.9000 K
% (3) altitude: 1.0000 km, atm P: 89.8746 kPa, atm T: 281.6500 K
% (4) altitude: 1.5000 km, atm P: 84.5560 kPa, atm T: 278.4000 K
% (5) altitude: 2.0000 km, atm P: 79.4952 kPa, atm T: 275.1500 K
% (6) altitude: 2.5000 km, atm P: 74.6825 kPa, atm T: 271.9000 K
% (7) altitude: 3.0000 km, atm P: 70.1085 kPa, atm T: 268.6500 K
% (8) altitude: 3.5000 km, atm P: 65.7641 kPa, atm T: 265.4000 K
% (9) altitude: 4.0000 km, atm P: 61.6402 kPa, atm T: 262.1500 K
% (10) altitude: 4.5000 km, atm P: 57.7283 kPa, atm T: 258.9000 K
% (11) altitude: 5.0000 km, atm P: 54.0199 kPa, atm T: 255.6500 K
% (12) altitude: 5.5000 km, atm P: 50.5068 kPa, atm T: 252.4000 K
% (13) altitude: 6.0000 km, atm P: 47.1810 kPa, atm T: 249.1500 K
% (14) altitude: 6.5000 km, atm P: 44.0348 kPa, atm T: 245.9000 K
% (15) altitude: 7.0000 km, atm P: 41.0607 kPa, atm T: 242.6500 K
% (16) altitude: 7.5000 km, atm P: 38.2514 kPa, atm T: 239.4000 K
% (17) altitude: 8.0000 km, atm P: 35.5998 kPa, atm T: 236.1500 K
% (18) altitude: 8.5000 km, atm P: 33.0990 kPa, atm T: 232.9000 K
% (19) altitude: 9.0000 km, atm P: 30.7425 kPa, atm T: 229.6500 K
% (20) altitude: 9.5000 km, atm P: 28.5236 kPa, atm T: 226.4000 K
% (21) altitude: 10.0000 km, atm P: 26.4363 kPa, atm T: 223.1500 K
% (22) altitude: 10.5000 km, atm P: 24.4744 kPa, atm T: 219.9000 K
% (23) altitude: 11.0000 km, atm P: 22.5950 kPa, atm T: 216.6500 K
% (24) altitude: 11.5000 km, atm P: 20.8819 kPa, atm T: 216.6500 K
% (25) altitude: 12.0000 km, atm P: 19.2987 kPa, atm T: 216.6500 K
% (26) altitude: 12.5000 km, atm P: 17.8356 kPa, atm T: 216.6500 K
% (27) altitude: 13.0000 km, atm P: 16.4834 kPa, atm T: 216.6500 K
% (28) altitude: 13.5000 km, atm P: 15.2337 kPa, atm T: 216.6500 K
% (29) altitude: 14.0000 km, atm P: 14.0787 kPa, atm T: 216.6500 K
% (30) altitude: 14.5000 km, atm P: 13.0113 kPa, atm T: 216.6500 K
% (31) altitude: 15.0000 km, atm P: 12.0248 kPa, atm T: 216.6500 K
% (32) altitude: 15.5000 km, atm P: 11.1132 kPa, atm T: 216.6500 K
% (33) altitude: 16.0000 km, atm P: 10.2706 kPa, atm T: 216.6500 K
% (34) altitude: 16.5000 km, atm P: 9.4919 kPa, atm T: 216.6500 K
% (35) altitude: 17.0000 km, atm P: 8.7723 kPa, atm T: 216.6500 K
% (36) altitude: 17.5000 km, atm P: 8.1072 kPa, atm T: 216.6500 K
% (37) altitude: 18.0000 km, atm P: 7.4926 kPa, atm T: 216.6500 K
% (38) altitude: 18.5000 km, atm P: 6.9245 kPa, atm T: 216.6500 K
% (39) altitude: 19.0000 km, atm P: 6.3995 kPa, atm T: 216.6500 K
% (40) altitude: 19.5000 km, atm P: 5.9143 kPa, atm T: 216.6500 K
% (41) altitude: 20.0000 km, atm P: 5.4720 kPa, atm T: 216.6500 K
% (42) altitude: 20.5000 km, atm P: 5.0576 kPa, atm T: 217.1500 K
% (43) altitude: 21.0000 km, atm P: 4.6754 kPa, atm T: 217.6500 K
% (44) altitude: 21.5000 km, atm P: 4.3229 kPa, atm T: 218.1500 K
% (45) altitude: 22.0000 km, atm P: 3.9977 kPa, atm T: 218.6500 K
% (46) altitude: 22.5000 km, atm P: 3.6976 kPa, atm T: 219.1500 K
% (47) altitude: 23.0000 km, atm P: 3.4206 kPa, atm T: 219.6500 K
% (48) altitude: 23.5000 km, atm P: 3.1650 kPa, atm T: 220.1500 K
% (49) altitude: 24.0000 km, atm P: 2.9289 kPa, atm T: 220.6500 K
% (50) altitude: 24.5000 km, atm P: 2.7110 kPa, atm T: 221.1500 K
% (51) altitude: 25.0000 km, atm P: 2.5097 kPa, atm T: 221.6500 K
% (52) altitude: 25.5000 km, atm P: 2.3238 kPa, atm T: 222.1500 K
% (53) altitude: 26.0000 km, atm P: 2.1520 kPa, atm T: 222.6500 K
% (54) altitude: 26.5000 km, atm P: 1.9932 kPa, atm T: 223.1500 K
% (55) altitude: 27.0000 km, atm P: 1.8465 kPa, atm T: 223.6500 K
% (56) altitude: 27.5000 km, atm P: 1.7109 kPa, atm T: 224.1500 K
% (57) altitude: 28.0000 km, atm P: 1.5855 kPa, atm T: 224.6500 K
% (58) altitude: 28.5000 km, atm P: 1.4695 kPa, atm T: 225.1500 K
% (59) altitude: 29.0000 km, atm P: 1.3622 kPa, atm T: 225.6500 K
% (60) altitude: 29.5000 km, atm P: 1.2630 kPa, atm T: 226.1500 K
% (61) altitude: 30.0000 km, atm P: 1.1712 kPa, atm T: 226.6500 K
% (62) altitude: 30.5000 km, atm P: 1.0863 kPa, atm T: 227.1500 K
% (63) altitude: 31.0000 km, atm P: 1.0077 kPa, atm T: 227.6500 K
% (64) altitude: 31.5000 km, atm P: 0.9349 kPa, atm T: 228.1500 K
% (65) altitude: 32.0000 km, atm P: 0.8680 kPa, atm T: 228.6500 K
% (66) altitude: 32.5000 km, atm P: 0.8057 kPa, atm T: 230.0500 K
% (67) altitude: 33.0000 km, atm P: 0.7482 kPa, atm T: 231.4500 K
% (68) altitude: 33.5000 km, atm P: 0.6951 kPa, atm T: 232.8500 K
% (69) altitude: 34.0000 km, atm P: 0.6461 kPa, atm T: 234.2500 K
% (70) altitude: 34.5000 km, atm P: 0.6008 kPa, atm T: 235.6500 K
% (71) altitude: 35.0000 km, atm P: 0.5589 kPa, atm T: 237.0500 K
% (72) altitude: 35.5000 km, atm P: 0.5202 kPa, atm T: 238.4500 K
% (73) altitude: 36.0000 km, atm P: 0.4843 kPa, atm T: 239.8500 K
% (74) altitude: 36.5000 km, atm P: 0.4511 kPa, atm T: 241.2500 K
% (75) altitude: 37.0000 km, atm P: 0.4204 kPa, atm T: 242.6500 K
% (76) altitude: 37.5000 km, atm P: 0.3919 kPa, atm T: 244.0500 K
% (77) altitude: 38.0000 km, atm P: 0.3654 kPa, atm T: 245.4500 K
% (78) altitude: 38.5000 km, atm P: 0.3409 kPa, atm T: 246.8500 K
% (79) altitude: 39.0000 km, atm P: 0.3182 kPa, atm T: 248.2500 K
% (80) altitude: 39.5000 km, atm P: 0.2971 kPa, atm T: 249.6500 K
% (81) altitude: 40.0000 km, atm P: 0.2775 kPa, atm T: 251.0500 K
% (82) altitude: 40.5000 km, atm P: 0.2593 kPa, atm T: 252.4500 K
% (83) altitude: 41.0000 km, atm P: 0.2424 kPa, atm T: 253.8500 K
% (84) altitude: 41.5000 km, atm P: 0.2267 kPa, atm T: 255.2500 K
% (85) altitude: 42.0000 km, atm P: 0.2120 kPa, atm T: 256.6500 K
% (86) altitude: 42.5000 km, atm P: 0.1984 kPa, atm T: 258.0500 K
% (87) altitude: 43.0000 km, atm P: 0.1857 kPa, atm T: 259.4500 K
% (88) altitude: 43.5000 km, atm P: 0.1739 kPa, atm T: 260.8500 K
% (89) altitude: 44.0000 km, atm P: 0.1629 kPa, atm T: 262.2500 K
% (90) altitude: 44.5000 km, atm P: 0.1527 kPa, atm T: 263.6500 K
% (91) altitude: 45.0000 km, atm P: 0.1431 kPa, atm T: 265.0500 K
% (92) altitude: 45.5000 km, atm P: 0.1342 kPa, atm T: 266.4500 K
% (93) altitude: 46.0000 km, atm P: 0.1259 kPa, atm T: 267.8500 K
% (94) altitude: 46.5000 km, atm P: 0.1181 kPa, atm T: 269.2500 K
% (95) altitude: 47.0000 km, atm P: 0.1100 kPa, atm T: 270.6500 K
% (96) altitude: 47.5000 km, atm P: 0.1033 kPa, atm T: 270.6500 K
% (97) altitude: 48.0000 km, atm P: 0.0970 kPa, atm T: 270.6500 K
% (98) altitude: 48.5000 km, atm P: 0.0910 kPa, atm T: 270.6500 K
% (99) altitude: 49.0000 km, atm P: 0.0855 kPa, atm T: 270.6500 K
% (100) altitude: 49.5000 km, atm P: 0.0802 kPa, atm T: 270.6500 K
% (101) altitude: 50.0000 km, atm P: 0.0753 kPa, atm T: 270.6500 K
% (102) altitude: 50.5000 km, atm P: 0.0707 kPa, atm T: 270.6500 K
% (103) altitude: 51.0000 km, atm P: 0.0670 kPa, atm T: 270.6500 K
% (104) altitude: 51.5000 km, atm P: 0.0629 kPa, atm T: 269.2500 K
% (105) altitude: 52.0000 km, atm P: 0.0590 kPa, atm T: 267.8500 K
% (106) altitude: 52.5000 km, atm P: 0.0554 kPa, atm T: 266.4500 K
% (107) altitude: 53.0000 km, atm P: 0.0519 kPa, atm T: 265.0500 K
% (108) altitude: 53.5000 km, atm P: 0.0487 kPa, atm T: 263.6500 K
% (109) altitude: 54.0000 km, atm P: 0.0456 kPa, atm T: 262.2500 K
% (110) altitude: 54.5000 km, atm P: 0.0427 kPa, atm T: 260.8500 K
% (111) altitude: 55.0000 km, atm P: 0.0400 kPa, atm T: 259.4500 K
% (112) altitude: 55.5000 km, atm P: 0.0375 kPa, atm T: 258.0500 K
% (113) altitude: 56.0000 km, atm P: 0.0350 kPa, atm T: 256.6500 K
% (114) altitude: 56.5000 km, atm P: 0.0328 kPa, atm T: 255.2500 K
% (115) altitude: 57.0000 km, atm P: 0.0307 kPa, atm T: 253.8500 K
% (116) altitude: 57.5000 km, atm P: 0.0287 kPa, atm T: 252.4500 K
% (117) altitude: 58.0000 km, atm P: 0.0268 kPa, atm T: 251.0500 K
% (118) altitude: 58.5000 km, atm P: 0.0250 kPa, atm T: 249.6500 K
% (119) altitude: 59.0000 km, atm P: 0.0234 kPa, atm T: 248.2500 K
% (120) altitude: 59.5000 km, atm P: 0.0218 kPa, atm T: 246.8500 K
% (121) altitude: 60.0000 km, atm P: 0.0203 kPa, atm T: 245.4500 K
% (122) altitude: 60.5000 km, atm P: 0.0190 kPa, atm T: 244.0500 K
% (123) altitude: 61.0000 km, atm P: 0.0177 kPa, atm T: 242.6500 K
% (124) altitude: 61.5000 km, atm P: 0.0165 kPa, atm T: 241.2500 K
% (125) altitude: 62.0000 km, atm P: 0.0153 kPa, atm T: 239.8500 K
% (126) altitude: 62.5000 km, atm P: 0.0143 kPa, atm T: 238.4500 K
% (127) altitude: 63.0000 km, atm P: 0.0133 kPa, atm T: 237.0500 K
% (128) altitude: 63.5000 km, atm P: 0.0124 kPa, atm T: 235.6500 K
% (129) altitude: 64.0000 km, atm P: 0.0115 kPa, atm T: 234.2500 K
% (130) altitude: 64.5000 km, atm P: 0.0107 kPa, atm T: 232.8500 K
% (131) altitude: 65.0000 km, atm P: 0.0099 kPa, atm T: 231.4500 K
% (132) altitude: 65.5000 km, atm P: 0.0092 kPa, atm T: 230.0500 K
% (133) altitude: 66.0000 km, atm P: 0.0086 kPa, atm T: 228.6500 K
% (134) altitude: 66.5000 km, atm P: 0.0079 kPa, atm T: 227.2500 K
% (135) altitude: 67.0000 km, atm P: 0.0074 kPa, atm T: 225.8500 K
% (136) altitude: 67.5000 km, atm P: 0.0068 kPa, atm T: 224.4500 K
% (137) altitude: 68.0000 km, atm P: 0.0063 kPa, atm T: 223.0500 K
% (138) altitude: 68.5000 km, atm P: 0.0059 kPa, atm T: 221.6500 K
% (139) altitude: 69.0000 km, atm P: 0.0054 kPa, atm T: 220.2500 K
% (140) altitude: 69.5000 km, atm P: 0.0050 kPa, atm T: 218.8500 K
% (141) altitude: 70.0000 km, atm P: 0.0046 kPa, atm T: 217.4500 K
% (142) altitude: 70.5000 km, atm P: 0.0043 kPa, atm T: 216.0500 K
% (143) altitude: 71.0000 km, atm P: 0.0040 kPa, atm T: 214.6500 K
% (144) altitude: 71.5000 km, atm P: 0.0036 kPa, atm T: 213.6500 K
% (145) altitude: 72.0000 km, atm P: 0.0034 kPa, atm T: 212.6500 K
% (146) altitude: 72.5000 km, atm P: 0.0031 kPa, atm T: 211.6500 K
% (147) altitude: 73.0000 km, atm P: 0.0029 kPa, atm T: 210.6500 K
% (148) altitude: 73.5000 km, atm P: 0.0026 kPa, atm T: 209.6500 K
% (149) altitude: 74.0000 km, atm P: 0.0024 kPa, atm T: 208.6500 K
% (150) altitude: 74.5000 km, atm P: 0.0022 kPa, atm T: 207.6500 K
% (151) altitude: 75.0000 km, atm P: 0.0021 kPa, atm T: 206.6500 K
% (152) altitude: 75.5000 km, atm P: 0.0019 kPa, atm T: 205.6500 K
% (153) altitude: 76.0000 km, atm P: 0.0017 kPa, atm T: 204.6500 K
% (154) altitude: 76.5000 km, atm P: 0.0016 kPa, atm T: 203.6500 K
% (155) altitude: 77.0000 km, atm P: 0.0015 kPa, atm T: 202.6500 K
% (156) altitude: 77.5000 km, atm P: 0.0014 kPa, atm T: 201.6500 K
% (157) altitude: 78.0000 km, atm P: 0.0012 kPa, atm T: 200.6500 K
% (158) altitude: 78.5000 km, atm P: 0.0011 kPa, atm T: 199.6500 K
% (159) altitude: 79.0000 km, atm P: 0.0011 kPa, atm T: 198.6500 K
% (160) altitude: 79.5000 km, atm P: 0.0010 kPa, atm T: 197.6500 K
% (161) altitude: 80.0000 km, atm P: 0.0009 kPa, atm T: 196.6500 K
% (162) altitude: 80.5000 km, atm P: 0.0008 kPa, atm T: 195.6500 K
% (163) altitude: 81.0000 km, atm P: 0.0007 kPa, atm T: 194.6500 K
% (164) altitude: 81.5000 km, atm P: 0.0007 kPa, atm T: 193.6500 K
% (165) altitude: 82.0000 km, atm P: 0.0006 kPa, atm T: 192.6500 K
% (166) altitude: 82.5000 km, atm P: 0.0006 kPa, atm T: 191.6500 K
% (167) altitude: 83.0000 km, atm P: 0.0005 kPa, atm T: 190.6500 K
% (168) altitude: 83.5000 km, atm P: 0.0005 kPa, atm T: 189.6500 K
% (169) altitude: 84.0000 km, atm P: 0.0004 kPa, atm T: 188.6500 K
% (170) altitude: 84.5000 km, atm P: 0.0004 kPa, atm T: 187.6500 K
% (171) altitude: 85.0000 km, atm P: 0.0004 kPa, atm T: 186.6500 K
% (172) altitude: 85.5000 km, atm P: 0.0003 kPa, atm T: 185.6500 K
% 
% part2 altitude 20000, 28000, 32000, 36000, 45000ft
% (1) Altitude 6.1000 km: The speed of sound is 316.0083 m/s and dynamic pressure is 28.1003 kPa
% (2) Altitude 8.5400 km: The speed of sound is 305.7577 m/s and dynamic pressure is 19.8688 kPa
% (3) Altitude 9.7600 km: The speed of sound is 300.5014 m/s and dynamic pressure is 16.5580 kPa
% (4) Altitude 10.9800 km: The speed of sound is 295.1514 m/s and dynamic pressure is 13.7088 kPa
% (5) Altitude 13.7250 km: The speed of sound is 295.0629 m/s and dynamic pressure is 8.8777 kPa
%
% part 2  from 20000ft to 45000ft with 1000ft increment 
% (1) Altitude 6.1000 km: The speed of sound is 316.0083 m/s and dynamic pressure is 28.1003 kPa
% (2) Altitude 6.4050 km: The speed of sound is 314.7452 m/s and dynamic pressure is 26.9419 kPa
% (3) Altitude 6.7100 km: The speed of sound is 313.4770 m/s and dynamic pressure is 25.8224 kPa
% (4) Altitude 7.0150 km: The speed of sound is 312.2037 m/s and dynamic pressure is 24.7409 kPa
% (5) Altitude 7.3200 km: The speed of sound is 310.9252 m/s and dynamic pressure is 23.6964 kPa
% (6) Altitude 7.6250 km: The speed of sound is 309.6414 m/s and dynamic pressure is 22.6879 kPa
% (7) Altitude 7.9300 km: The speed of sound is 308.3523 m/s and dynamic pressure is 21.7144 kPa
% (8) Altitude 8.2350 km: The speed of sound is 307.0577 m/s and dynamic pressure is 20.7750 kPa
% (9) Altitude 8.5400 km: The speed of sound is 305.7577 m/s and dynamic pressure is 19.8688 kPa
% (10) Altitude 8.8450 km: The speed of sound is 304.4521 m/s and dynamic pressure is 18.9949 kPa
% (11) Altitude 9.1500 km: The speed of sound is 303.1409 m/s and dynamic pressure is 18.1524 kPa
% (12) Altitude 9.4550 km: The speed of sound is 301.8240 m/s and dynamic pressure is 17.3404 kPa
% (13) Altitude 9.7600 km: The speed of sound is 300.5014 m/s and dynamic pressure is 16.5580 kPa
% (14) Altitude 10.0650 km: The speed of sound is 299.1728 m/s and dynamic pressure is 15.8045 kPa
% (15) Altitude 10.3700 km: The speed of sound is 297.8384 m/s and dynamic pressure is 15.0790 kPa
% (16) Altitude 10.6750 km: The speed of sound is 296.4979 m/s and dynamic pressure is 14.3807 kPa
% (17) Altitude 10.9800 km: The speed of sound is 295.1514 m/s and dynamic pressure is 13.7088 kPa
% (18) Altitude 11.2850 km: The speed of sound is 295.0629 m/s and dynamic pressure is 13.0437 kPa
% (19) Altitude 11.5900 km: The speed of sound is 295.0629 m/s and dynamic pressure is 12.4312 kPa
% (20) Altitude 11.8950 km: The speed of sound is 295.0629 m/s and dynamic pressure is 11.8475 kPa
% (21) Altitude 12.2000 km: The speed of sound is 295.0629 m/s and dynamic pressure is 11.2912 kPa
% (22) Altitude 12.5050 km: The speed of sound is 295.0629 m/s and dynamic pressure is 10.7610 kPa
% (23) Altitude 12.8100 km: The speed of sound is 295.0629 m/s and dynamic pressure is 10.2557 kPa
% (24) Altitude 13.1150 km: The speed of sound is 295.0629 m/s and dynamic pressure is 9.7741 kPa
% (25) Altitude 13.4200 km: The speed of sound is 295.0629 m/s and dynamic pressure is 9.3151 kPa
% (26) Altitude 13.7250 km: The speed of sound is 295.0629 m/s and dynamic pressure is 8.8777 kPa

%% ____________________
%% ACADEMIC INTEGRITY STATEMENT

% Call your academic integrity statement here
PS07_academic_integrity_koike("Tomoki Koike");