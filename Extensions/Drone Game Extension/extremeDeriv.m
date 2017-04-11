function dz = extremeDeriv(z, m1, m2, grav, pres, temp)
% Takes inputs z (4x1 matrix with values for horizontal displacement,
% horizontal velocity, vertical displacement and vertical velocity), m1
% (mass of the drone), m2 (mass of the projectile), grav (the acceleration
% of free fall in the chosen planet), pres (the air pressure in the chosen 
% planet) and temp (the average air temperature in the chosen planet), and 
% outputs dz (4x1 matrix containing horizontal velocity, horizontal 
% acceleration, vertical velocity and vertical acceleration). 

%% Setting initial conditions and constants
Mp = m2; % Projectile casing mass (kg)
Ap = 0.0005; % Cross-sectional area of projectile casing (m^2)
Cp = 0.1; % Drag coefficient of projectile casing
g = grav; % Acceleration of free fall (m/s^2)

%% Calculating the angle between the horizontal plane and the velocity vector of the projectile
theta = atan(z(4)/z(2)); % Calculated angle (rad)

%% Modeling density as an altitude-dependent variable
% Initial density conditions
p0 = pres; % Air pressure (Pa)
t0 = temp; % Air temperature (K)
Rs = 287.057; % Gas constant of air (J/kg*K)
L = 0.0065; % Lapse rate (K/m) (Assumption: lapse rate same in all planets)

% Calculating the density of air at different altitudes (z(3))
t = t0 - (L*z(3)); % Temperature variation with altitude z(3) (K)
p = p0*((t/t0)^(g/(L*Rs))); % Pressure variation with altitude z(3) (Pa)

D = p/(Rs*t); % Density of air (kg/m^3)

%% Calculating air resistance
v = sqrt((z(2))^2 + (z(4))^2); % Calculating the velocity of the projectile (m/s)

r = sign(z(2))*0.5*D*(v^2)*Cp*Ap; % Air resistance

% note: sign(z(2)) is used to account for the direction of the projectile

%% Calculating the derivatives
dz1 = z(2); % Horizontal velocity of the system
dz2 = -((r*cos(theta))/Mp); % Horizontal acceleration of the system
dz3 = z(4); % Vertical velocity of the system
dz4 = -(g+((r*sin(theta))/Mp)); % Vertical acceleration of the system

%% Establishing the function outputs
% Outputs of the function stored in the form of matrix dz
dz = [dz1; dz2; dz3; dz4];

end