function [hit,message] = plotterExtreme(alpha, x1, y1, m1, m2, vP, grav, pres, temp)
% The function takes in inputs of alpha (launch angle), x1 (horizontal
% position of drone), y1 (vertical position of drone), m1 (mass of drone),
% m2 (mass of projectile), vP (projectile launch speed), planet (planet the
% game is taking place on), grav (gravity on aforementioned planet), pres
% (pressure on aforementioned planet) and temp (temperature on
% aforementioned planet) and outputs hit (a boolean indicating whether or
% not the drone has been hit) and message (a string with a message based on
% the chosen launch angle). 

% note: There is no parachute involved in this case

%% Setting the initial conditions
angle = alpha; % Launch angle (deg)
dt = 0.001; % Time step (s)
z(1,:) = 0; % Initial horizontal position of the projectile (m)
z(2,:) = vP*(cosd(angle)); % Horizontal launch velocity of the projectile (m/s)
z(3,:) = 1; % Initial vertical position of the projectile (m)
z(4,:) = vP*(sind(angle)); % Vertical launch velocity of the projectile (m/s)

xt = x1; % Horizontal position of the drone (m)
yt = y1; % Vertical position of the drone (m)

%% Implementing the while loop to update the state vectors
n=1; % Counter value for while loop starts at 1

% Continue stepping until the projectile lands on the ground
while z(3,n) >= 0
        
    dist = sign(yt-z(3,n))*sqrt((xt-z(1,n))^2 + (yt-z(3,n))^2); % Distance between projectile and drone
    % note: distance is negative if the y-displacement of the projectile is
    % higher than the y-position of the drone, and positive if the
    % y-displacement is lower than the y-position of the drone
    
    % Adding the distance between the projectile and drone to a vector to
    % eventually determine the minimum of these distances
    distances(n) = dist;
     
    % Apply Runge-Kutta 4 method for one time step
    z(:,n+1) = extremeRKGame(z(:,n),dt,m1,m2,grav,pres,temp);
    
    % Increase the counter value by 1
    n = n+1;
end

%% Determining the value of the minimum distance between the drone and projectile
posMinimum = min(distances(distances>=0)); % Minimum positive distance between the projectile and drone
negMinimum = max(distances(distances<0)); % Minimum negative distance between the projectile and drone

% Determining which of the two minimums is smallest in magnitude and
% setting the variable 'minimum' to that value
if isempty(posMinimum)
    % if all distances are negative the minimum will be a negative value
    minimum = negMinimum; 
elseif isempty(negMinimum)
    % if all distances are positive the minimum will be a positive value
    minimum = posMinimum;
elseif posMinimum <= abs(negMinimum) % Comparing the magnitudes of posMinimum and negMinimum
    minimum = posMinimum;
else
    minimum = negMinimum;
end

%% Plotting the graph and determining the outputs

figure(1)

scatter(1,0,70,'b*'); % Plotting projectile launcher position

% Plotting a curve of horizontal displacement against vertical
% displacement based on whether or not the drone was intercepted
if abs(minimum) <= 0.5
    % Executes if drone has been intercepted
    hit = true; % Hit is set to true as drone has been intercepted
    plot(z(1,:),z(3,:),'-g','LineWidth',2);
    hold on
    scatter(xt,yt,70,'rx','filled'); % Drone location
    message = 'You did it. NO MORE DRONES.'; % Victory message
else
    % Executes if drone evades projectile
    hit = false; % Hit is set to false as the user failed to hit the drone
    plot(z(1,:),z(3,:),':r','LineWidth',1);
    hold on
    scatter(xt,yt,70,'rx'); % Drone location
    message = 'PLEASE STOP MISSING. WE WILL ALL DIE IF YOU KEEP FAILING.'; % Message outputted when launch angle is incorrect
end
        
% Labeling the axes of the graph
xlabel('Horizontal Displacement (m)');
ylabel('Vertical Displacement (m)');

hold on
grid on

% Plotting the position of ground impact location on the graph
scatter(z(1,end),0,20,'yo','filled'); % Ground impact location

end