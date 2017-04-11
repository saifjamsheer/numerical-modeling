function dz = stateDeriv3D(z,cond,m1,m2,vW)
% Take inputs z (6x1 matrix with values for x-displacement, x-velocity,
% y-displacement, y-velocity, z-displacement and z-velocity), cond (a
% variable with value 0, 1 or 2 depending on whether or not the parachute
% has been deployed and the reason for parachute (deployment), m1 (mass of
% the drone), m2 (mass of the projectile) and vW (a vector containing 
% the wind speeds in three directions), and outputs dz (6x1 matrix
% containing x-velocity, x-acceleration, y-velocity, y-acceleration,
% z-velocity and z-acceleration). 

%% Setting initial conditions and constants
Md = m1; % Drone mass (kg)
Mp = m2; % Projectile casing mass (kg)
Ap = 0.0005; % Cross-sectional area of projectile casing (m^2)
Cp = 0.1; % Drag coefficient of projectile casing
Ac = 1.5; % Cross-sectional area of parachute (m^2)
Cc = 0.9; % Drag coefficient of parachute
g = 9.80665; % Acceleration of free fall (m/s^2)

wX = vW(1); % Wind speed in the x-direction
wY = vW(2); % Wind speed in the y-direction
wZ = vW(3); % Wind speed in the z-direction

wRes = sqrt(wX^2 + wY^2 + wZ^2); % Resultant wind speed

%% Determining the direction of the wind in terms of angles dw1 and dw2

% If-else statements are used to avoid any mathematical errors
if wX == 0 && wY == 0 && wZ == 0
    dw1 = 0; 
    dw2 = 0;
elseif wX == 0 && (wY == 0 || wZ == 0)
    if wY == 0
        dw1 = 0;
        dw2 = atan(wZ/wX);
    else
        dw1 = atan(wY/wX);
        dw2 = 0;
    end
else
    dw1 = atan(wY/wX);
    dw2 = atan(wZ/wX);
end

%% Calculating the angle between the horizontal plane and the velocity vector of the projectile (theta) as well as the axis angle (gamma)
theta = atan(z(4)/z(2)); % Vertical angle (rad)

% Using if-else statements to eliminate mathematical errors
if z(6) == 0 && z(2) == 0
    gamma = 0; % Axis angle (rad)
else 
    gamma = atan(z(6)/z(2));
end

%% Modeling density as an altitude-dependent variable
% Initial density conditions
p0 = 101.325*10^3; % Air pressure at sea level (Pa)
t0 = 288.15; % Air temperature at sea level (K)
Rs = 287.057; % Gas constant of air (J/kg*K)
L = 0.0065; % Lapse rate (K/m)

% Calculating the density of air at different altitudes (z(3))
t = t0 - (L*z(3)); % Temperature variation with altitude z(3) (K)
p = p0*((t/t0)^(g/(L*Rs))); % Pressure variation with altitude z(3) (Pa)

D = p/(Rs*t); % Density of air (kg/m^3)

%% Calculating external forces acting on the projectile
% Calculating the wind force
fw1 = 0.5*D*(wRes^2)*Cp*Ap; % Wind force on the system before the parachute is deployed
fw2 = 0.5*D*(wRes^2)*(Cc*Ac+Cp*Ap); % Wind force on the system after the parachute is deployed

% Calculating the air resistance
v = sqrt((z(2))^2 + (z(4))^2 + (z(6))^2); % Calculating the velocity of the projectile (m/s)

r1 = sign(z(2))*0.5*D*(v^2)*Cp*Ap; % Air resistance before parachute is deployed
r2 = sign(z(2))*0.5*D*(v^2)*(Cc*Ac+Cp*Ap); % Air resistance after parachute is deployed

%% Calculating the derivatives depending on the condition of parachute deployment

if cond == 0 % Parachute has not been deployed
    
    % In this case the total mass is the sum of the drone mass and
    % projectile casing mass, and the air resistances changes from r1 to
    % r2 due to the parachute
    dz1 = z(2); % Velocity of the system in the x-plane
    dz2 = -((r1*cos(theta)*cos(gamma)+sign(wX)*fw1*cos(dw1)*cos(dw2))/Mp); % Acceleration of the system in the x-plane
    dz3 = z(4); % Velocity of the system in the y-plane
    dz4 = -(g+((r1*sin(theta)+sign(wY)*fw1*sin(dw1))/Mp)); % Acceleration of the system in the y-plane
    dz5 = z(6); % Velocity of the system in the z-plane
    dz6 = -((r1*cos(theta)*sin(gamma)+sign(wZ)*fw1*cos(dw1)*sin(dw2))/Mp); % Acceleration of the system in the z-plane
    
elseif cond == 1 % Projectile has intercepted the drone and parachute has been deployed
    
    % In this case the total mass is the sum of the drone mass and
    % projectile casing mass, and the air resistances changes from r1 to
    % r2 due to the parachute
    dz1 = z(2);
    dz2 = -((r2*cos(theta)*cos(gamma)+sign(wX)*fw2*cos(dw1)*cos(dw2))/(Mp+Md));
    dz3 = z(4);
    dz4 = -(g+((r2*sin(theta)+sign(wY)*fw2*sin(dw1))/(Mp+Md)));
    dz5 = z(6);
    dz6 = -((r2*cos(theta)*sin(gamma)+sign(wZ)*fw2*cos(dw1)*sin(dw2))/(Mp+Md));
    
else % Drone has evaded the projectile and the parachute deploys when the projectile is 5m above ground
    
    % In this case the mass does not change but the air resistance changes
    % from r1 to r2 due to the parachute
    dz1 = z(2); 
    dz2 = -((r2*cos(theta)*cos(gamma)+sign(wX)*fw2*cos(dw1)*cos(dw2))/Mp);
    dz3 = z(4);
    dz4 = -(g+((r2*sin(theta)+sign(wY)*fw1*sin(dw1))/Mp));
    dz5 = z(6);
    dz6 = -((r2*cos(theta)*sin(gamma)+sign(wZ)*fw2*cos(dw1)*sin(dw2))/Mp);
    
end

%% Establishing the function outputs
% Outputs of the function stored in the form of matrix dz
dz = [dz1; dz2; dz3; dz4; dz5; dz6];

end