function [minimum,groundImpact,velImpact] = ivpSolver(alpha, x1, y1, m1, m2, vP)
% The function takes in inputs of alpha (launch angle), x1 (horizontal
% position of drone), y1 (vertical position of drone), m1 (mass of drone),
% m2 (mass of projectile), and vP (projectile launch speed) and outputs a 
% vector containing minimum (the minimum distance between the projectile 
% and drone), groundImpact (coordinates of the ground impact location) and
% velImpact (final velocity of the system). 

%% Setting the initial conditions
angle = alpha; % Launch angle (deg)
dt = 0.001; % Time step (s)
z(1,:) = 0; % Initial horizontal position of the projectile (m)
z(2,:) = vP*(cosd(angle)); % Horizontal launch velocity of the projectile (m/s)
z(3,:) = 1; % Initial vertical position of the projectile (m)
z(4,:) = vP*(sind(angle)); % Vertical launch velocity of the projectile (m/s)

xt = x1; % Horizontal position of the drone
yt = y1; % Vertical position of the drone

hasBeen = false; % Boolean that states whether or not parachute has been deployed
cond = 0; % Variable that is 0 if parachute is undeployed, 1 if the parachute is deployed due to the drone, and 2 if it deploys due to the sensor

pStep = 0; % Initializing pStep variable (position of parachute deployment)
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
    
    % Checking to see if the projectile is within range of the drone and
    % that the parachute has yet to be deployed
    if abs(dist) <= 1 && ~hasBeen  
        cond = 1; % Set condition to 1
        hasBeen = true; % Parachute has been deployed -> hasBeen is true
        pStep = n; % Counter value for when the parachute was deployed
    end
    
    % Checking to see if the parachute has already been deployed
    if ~hasBeen && n > 1 
        % Checking if the vertical displacement of the projectile is
        % downwards and if the y-displacement of the projectile is smaller
        % than 5 meters
        if z(3,n) < z(3,n-1) && z(3,n) <= 5
            cond = 2; % Set condition to 2
            hasBeen = true; % Parachute has been deployed -> hasBeen is true
            pStep = n; % Counter value for when the parachute was deployed
        end
    end
    
    % Apply Runge-Kutta 4 method for one time step
    z(:,n+1) = stepRungeKutta(z(:,n), dt, cond, m1, m2);
    
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

%% Determining the ground impact coordinates and velocity
zF = z(:, end); % 4x1 matrix of final z-values

groundImpact = [zF(1),0]; % x-displacement of the ground impact location
velImpactX = zF(2); % Final velocity in the x-plane
velImpactY = zF(4); % Final velocity in the y-plane
velImpact = sqrt(velImpactX^2+velImpactY^2); % Final impact velocity

%% Plotting the graph and creating the figure

figure(1)

% Plotting a curve of horizontal displacement against vertical
% displacement
projDisplacement = plot(z(1,:),z(3,:),'-.b','LineWidth',1.5); % Projectile displacement

xc = z(1,pStep); % x-coordinate of parachute deployment position
yc = z(3,pStep); % y-coordinate of parachute deployment position

% Labeling the axes of the graph
xlabel('Horizontal Displacement (m)');
ylabel('Vertical Displacement (m)');

hold on
grid on

orange = 1/255*[255,140,0]; % Creating a marker color

% Plotting the positions of parachute deployment, ground impact, drone
% location and projectile launcher location
a = scatter(xc,yc,50,'MarkerFaceColor',orange,'MarkerEdgeColor',orange,'Marker','d'); % Parachute deployment position
b = scatter(zF(1),0,50,'mo','filled'); % Ground impact location
d = scatter(0,1,100,'c*'); % Projectile launcher position

% Creating labels for relevant plot information and ploting the drone
% location
label1 = 'Projectile displacement (m)';
if abs(minimum) <= 1
    % This executes if the drone is intercepted
    c = scatter(xt,yt,100,'gp','filled'); % Drone position (green marker color) 
    label2 = 'Drone interception and parachute deployment position';
else
    % This executes if the drone evades the projectile
    c = scatter(xt,yt,100,'rp'); % Drone position (red marker color) 
    label2 = 'Parachute deployment position';
end
label3 = 'Ground impact location';
label4 = 'Drone location';
label5 = 'Projectile launcher location';

% Creating a legend for the graph
legend([projDisplacement,a,b,c,d],{label1,label2,label3,label4,label5},'Location','best');

hold off

end