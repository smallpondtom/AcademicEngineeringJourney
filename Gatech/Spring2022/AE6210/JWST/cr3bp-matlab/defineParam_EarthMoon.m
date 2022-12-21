%% Define CR3BP for Earth-Moon parameters
% Yuri Shimane, 2022/02/15
fprintf('*** Earth-Moon system ***\n');

param.systemname = 'EarthMoon';

% values from NAIF de431 kernel
param.gm1 = 3.9860043543609598E+05;
param.gm2 = 4.9028000661637961E+03;

% mass parameter
param.mu = param.gm2/(param.gm1 + param.gm2);

% define canonical scales
param.Lstar = 0.3844e6;  % [km]
param.Tstar = sqrt((param.Lstar)^3/(param.gm1 + param.gm2));  % [sec]
param.Vstar = param.Lstar / param.Tstar; % [km/s]

% define Lagrange points
param.LP = lagrangePoints(param.mu); % Lagrange points

fprintf('   System mu: %2.6s\n',param.mu)
fprintf('   Characteristic length scale: %6.5s [km]\n',param.Lstar);
fprintf('   Characteristic time scale: %f [days]\n',param.Tstar/(60*60*24));
