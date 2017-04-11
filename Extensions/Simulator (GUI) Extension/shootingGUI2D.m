function [finalValues] = shootingGUI2D(x1,y1,m1,m2,vP,vd)
% Function that takes inputs from a GUI and outputs a cell array
% (finalValues) containing alphaFinal (launch angle required to intercept
% the drone), groundPos (coordinates of the system at location of impact)
% and impactV (final velocity of the system). 

%% Determining the initial two launch angle guesses
% Initial two guesses for the launch angle, first guess chosen based on
% position of the drone, second guess chosen based on first guess; if-else
% statement used to determine whether the initial guess should be between 0
% and 90 or 90 and 180
if x1 >= 0
    alpha(1) = atand(y1/x1); % First angle guess (deg)
    alpha(2) = alpha(1)+45; % Second angle guess (deg)
else 
    alpha(1) = atand(y1/x1)+180; % First angle guess (deg)
    alpha(2) = alpha(1)+45; % Second angle guess (deg)
end

%% Determining the error for the first two guesses
% Determining the minimum distance between the projectile and drone for the
% respective launch angle using the ivpSolver function
minimum(1) = movingSolver(alpha(1),x1,y1,m1,m2,vP,vd);
minimum(2) = movingSolver(alpha(2),x1,y1,m1,m2,vP,vd);

% Calculating the error; the error is esentially the smallest distance
% between the projectile and drone at any point of the journey, which is
% equal to the variable 'minimum'
error(1) = minimum(1); 
error(2) = minimum(2);

%% Shooting method implementation
acceptableError = 1; % The task states that the drone can be intercepted if the projectile is within 1m of the drone

n = 2; % Starting the counter at a value of 2

% The loop is executed while the minimum distance between the projectile and the
% drone is greater than 1

while abs(error(n)) > acceptableError
% Using the shooting method to determine subsequent guesses for the launch
% angle until the calculated error satisfies the necessary condition
    
    % Computing the next angle guess using the previous two angle guesses
    alpha(n+1) = alpha(n)-error(n)*((alpha(n)-alpha(n-1))/(error(n)-error(n-1)));
     
    % Solving the IVP using the newly guessed angle, alpha(n+1) to
    % determine the minimum distance 
    minimum(n+1) = movingSolver(alpha(n+1),x1,y1,m1,m2,vP,vd);
        
    % Calculating the error, which is stored in a vector
    error(n+1) = minimum(n+1);
    
    % Incrementing the counter by 1
    n = n+1;
    
end

%% Establishing the values of the output variables
alphaFinal = num2str(alpha(end)); % Launch angle required to intercept the drone (deg)

% Determining the final velocity and ground impact location

% The final impact coordinates and impact velocity are
% calculated using the ivpSolver function and stored in a vector
[~,g,v] = movingSolver(alpha(end),x1,y1,m1,m2,vP,vd);

groundPos = num2str(g); % Coordinates of location of impact as a string (m)
impactV = num2str(v); % Impact velocity as a string (m/s)

% Printing the output values into the command window
fprintf(['Launch Angle (deg):',' ',alphaFinal,'\n']);
fprintf(['Ground Position Coordinates [x,y,z] (m):',' ',groundPos,'\n']);
fprintf(['Impact Velocity (m/s):',' ',impactV],'\n');
fprintf('\n');

finalValues = {'Launch Angle (deg)', alphaFinal; 'Ground Position Coordinates [x,y] (m)', groundPos; 'Impact Velocity (m/s)', impactV}; % Output of the function

end