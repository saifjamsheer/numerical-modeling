function dz = gameDeriv(z,cond, m1, m2, grav, pres, temp)
% Takes inputs z (4x1 matrix with values for horizontal displacement,
% horizontal velocity, vertical displacement and vertical velocity), cond
% (a variable with value 0, 1 or 2 depending on whether or not the
% parachute has been deployed and the reason for parachute deployment), m1
% (mass of the drone), m2 (mass of the projectile), grav (the acceleration
% of free fall in the chosen planet), pres (the air pressure in the chosen 
% planet) and temp (the average air temperature in the chosen planet), and 
% outputs dz (4x1 matrix containing horizontal velocity, horizontal 
% acceleration, vertical velocity and vertical acceleration). 

%% Setting initial conditions and constants
Md = m1; % Drone mass (kg)
Mp = m2; % Projectile casing mass (kg)
Ap = 0.0005; % Cross-sectional area of projectile casing (m^2)
Cp = 0.1; % Drag coefficient of projectile casing
Ac = 1.5; % Cross-sectional area of parachute (m^2)
Cc = 0.9; % Drag coefficient of parachute
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

%% Calculating the air resistance (before and after parachute deployment)
v = sqrt((z(2))^2 + (z(4))^2); % Calculating the velocity of the projectile (m/s)

r1 = sign(z(2))*0.5*D*(v^2)*Cp*Ap; % Air resistance before parachute is deployed
r2 = sign(z(2))*0.5*D*(v^2)*(Cc*Ac+Cp*Ap); % Air resistance after parachute is deployed
% note: sign(z(2)) is used to account for the direction of the projectile

%% Calculating the derivatives depending on the condition of parachute deployment
if cond == 0 % Parachute has not been deployed
    
    dz1 = z(2); % Horizontal velocity of the system
    dz2 = -((r1*cos(theta))/Mp); % Horizontal acceleration of the system
    dz3 = z(4); % Vertical velocity of the system
    dz4 = -(g+((r1*sin(theta))/Mp)); % Vertical acceleration of the system
    
elseif cond == 1 % Projectile has intercepted the drone and parachute has been deployed
    
    % In this case the total mass is the sum of the drone mass and
    % projectile casing mass, and the air resistances changes from r1 to
    % r2 due to the parachute
    dz1 = z(2); 
    dz2 = -((r2*cos(theta))/(Mp+Md)); 
    dz3 = z(4); 
    dz4 = -(g+((r2*sin(theta))/(Mp+Md))); 
    
else % Drone has evaded the projectile and the parachute deploys when the projectile is 5m above ground
    
    % In this case the mass does not change but the air resistance changes
    % from r1 to r2 due to the parachute
    dz1 = z(2); 
    dz2 = -((r2*cos(theta))/Mp); 
    dz3 = z(4); 
    dz4 = -(g+((r2*sin(theta))/Mp));  
    
end

%% Establishing the function outputs
dz = [dz1; dz2; dz3; dz4];

end