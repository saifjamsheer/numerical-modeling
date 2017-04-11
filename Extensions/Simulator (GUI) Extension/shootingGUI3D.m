function [finalValues] = shootingGUI3D(x1,y1,u1,m1,m2,vP,vW,vd)
% Function that takes inputs from a GUI and outputs a cell array
% (finalValues) containing alphaFinal (launch angle required to intercept
% the drone), betaFinal(axis angle required to intercept the drone),
% groundPos (coordinates of the system at location of impact) and impactV
% (final velocity of the system). 

%% Determining the initial two launch angle guesses for both the launch angle and the axis angle
% Initial two guesses for the launch angle, first guesses chosen based on
% position of the drone, second guess chosen based on first guess
if x1 == 0 && u1 == 0
    % This condition exists in order to prevent any mathematical errors
    alpha(1) = atand(y1/x1); % First guess for launch angle (deg)
    beta(1) = 0; % First guess for axis angle (deg)
elseif x1 >= 0
    alpha(1) = atand(y1/x1); 
    beta(1) = atand(u1/x1);
else
    alpha(1) = atand(y1/x1)+180; % 180 degrees is added as the drone is in the second quadrant
    beta(1) = atand(u1/x1);
end

alpha(2) = alpha(1)+45; % Second guess for launch angle (deg)
beta(2) = beta(1)+5; % Second guess for axis angle (deg)

%% Determining the error using the initial two guesses
% Determining the minimum distance between the projectile and drone for the
% respective angles using the ivpSolver function
minimum(1) = ivpSolver3D(alpha(1),beta(1),x1,y1,u1,m1,m2,vP,vW,vd);
minimum(2) = ivpSolver3D(alpha(2),beta(2),x1,y1,u1,m1,m2,vP,vW,vd);

% Calculating the error; the error is esentially the smallest distance
% between the projectile and drone at any point of the journey, which is
% equal to the variable 'minimum'
error(1) = minimum(1);
error(2) = minimum(2);

%% Shooting method implementation
acceptableError = 1;  % The task states that the drone can be intercepted if the projectile is within 1m of the drone

n = 2; % Starting the counter at a value of 2

% The loop is executed while the minimum distance between the projectile and the
% drone is greater than 1
while abs(error(n)) > acceptableError
% Using the shooting method to determine subsequent guesses for the launch
% and axis angles until the calculated error satisfies the necessary
% condition

    % Computing the next angle guesses using the previous two angle guesses
    % for both alpha and beta
    alpha(n+1) = alpha(n)-error(n)*((alpha(n)-alpha(n-1))/(error(n)-error(n-1)));
    beta(n+1) = beta(n)-error(n)*((beta(n)-beta(n-1))/(error(n)-error(n-1)));
    
    % Solving the IVP using the newly guessed angles, alpha(n+1) and
    % beta(n+1), to determine the minimum distance
    minimum(n+1) = ivpSolver3D(alpha(n+1),beta(n+1),x1,y1,u1,m1,m2,vP,vW,vd);
    
    % Calculating the error, which is stored in a vector
    error(n+1) = minimum(n+1);
  
    % Incrementing the counter by 1
    n = n+1;
    
end

%% Establishing the values of the output variables
alphaFinal = num2str(alpha(end)); % Launch angle required to intercept the drone (deg)
betaFinal = num2str(beta(end)); % Axis angle required to intercept the drone (deg)
 
% Determining the final velocity and ground impact location

% The final impact coordinates and impact velocity are
% calculated using the ivpSolver function and stored in a vector
[~,g,v] = ivpSolver3D(alpha(end),beta(end),x1,y1,u1,m1,m2,vP,vW,vd);

groundPos = num2str(g); % Coordinates of location of impact as a string (m)
impactV = num2str(v); % Impact velocity as a string (m/s)

% Printing the output values into the command window
fprintf(['Launch Angle (deg):',' ',alphaFinal,'\n']);
fprintf(['Axis Angle (deg):',' ',betaFinal,'\n']);
fprintf(['Ground Position Coordinates [x,y,z] (m):',' ',groundPos,'\n']);
fprintf(['Impact Velocity (m/s):',' ',impactV,'\n']);
fprintf('\n');

finalValues = {'Launch Angle (deg)', alphaFinal; 'Axis Angle (deg)', betaFinal; 'Ground Position Coordinates [x,y,z] (m)', groundPos; 'Impact Velocity (m/s)', impactV}; % Output of the function

end