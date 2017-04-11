function [minimum,groundImpact,velImpact] = ivpSolver3D(alpha, beta, x1, y1, u1, m1, m2, vP, vW, vd)
% The function takes in inputs of alpha (launch angle), beta (initial axis
% angle), x1 (x-position of the drone), y1 (y-position of the drone), u1
% (z-location of the drone), m1 (mass of the drone), m2 (mass of the
% projectile), vP ([projectile launch speed), vW (a vector containing
% the wind speeds in three directions) and vD (a vector containing the
% drone speeds in three directions), and outputs minimum (the minimum 
% distance between the projectile and the drone during the course of
% journey), groundImpact (coordinates of the ground impact location) and
% velImpact (final velocity of the system).  

%% Setting the initial conditions
dt = 0.01; % Time step (s)
z(1,:) = 0; % Initial x-position (m)
z(2,:) = vP*cosd(alpha)*cosd(beta); % Launch x-velocity of the projectile(m/s)
z(3,:) = 1; % Initial y-position of the projectile (m)
z(4,:) = vP*sind(alpha); % Launch y-velocity of the projectile (m/s)
z(5,:) = 0; % Initial z-position of the projectile (m)
z(6,:) = vP*cosd(alpha)*sind(beta); % Launch z-velocity of the projectile(m/s)

d(1,:) = x1; % Initial x-position of the drone (m)
d(2,:) = y1; % Initial y-position of the drone (m)
d(3,:) = u1; % Initial z-position of the drone (m) (u is used rather than z as the state variables are represented by z)

vdx = vd(1); % Drone velocity in x-direction (constant) (m/s)
vdy = vd(2); % Drone velocity in y-direction (constant) (m/s)
vdu = vd(3); % Drone velocity in z-direction (constant) (m/s)

hasBeen = false; % Boolean that states whether or not parachute has been deployed
cond = 0; % Variable that is 0 if parachute is undeployed, 1 if the parachute is deployed due to the drone, and 2 if it deploys due to the sensor
pStep = 0; % Initializing the variable pStep (counter value at which parachute is deployed);

%% Implementing the while loop to update the state vectors
n=1; % Counter value for while loop starts at 1

% Continue stepping until the projectile lands on the ground
while z(3,n) >= 0
  
    % Determining the distance between the projectile and the drone
    if (d(3,n)-z(5,n)) == 0 % Checking whether the trajectory of the projectile is along the correct axis angle
        dist = sign(d(2,n)-z(3,n))*sqrt((d(1,n)-z(1,n))^2 + (d(2,n)-z(3,n))^2 + (d(3,n)-z(5,n))^2); % Distance between projectile and drone (m)
        % note: distance is negative if the y-displacement of the projectile is
        % higher than the y-position of the drone, and positive if the
        % y-displacement is lower than the y-position of the drone
    else
        dist = sign(d(3,n)-z(5,n))*sign(d(2,n)-z(3,n))*sqrt((d(1,n)-z(1,n))^2 + (d(2,n)-z(3,n))^2 + (d(3,n)-z(5,n))^2); % Distance between projectile and drone (m)
        % note: distance is negative or positive depending on the y and z
        % positions of the projectile relative to the drone
    end
    
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
            hasBeen = 1; % Parachute has been deployed -> hasBeen is true
            pStep = n; % Counter value for when the parachute was deployed
        end
    end
    
    % Apply Runge-Kutta 4 method for one time step
    z(:,n+1) = stepRungeKutta3D(z(:,n), dt, cond, m1, m2, vW);
    
    % Updating the displacement of the drone in all three directions after
    % one time step
    d(1,n+1) = d(1,n) + vdx*dt; % x-position of the drone
    d(2,n+1) = d(2,n) + vdy*dt; % y-position of the drone
    d(3,n+1) = d(3,n) + vdu*dt; % z-position of the drone
    
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
zF = z(:, end); % 6x1 matrix of final z-values

groundImpact = [zF(1),0,zF(5)]; % x-displacement of the ground impact location
velImpactX = zF(2); % Final velocity in the x-plane
velImpactY = zF(4); % Final velocity in the y-plane
velImpactZ = zF(6); % Final velocity in the z-plane
velImpact = sqrt(velImpactX^2+velImpactY^2+velImpactZ^2); % Final impact velocity


%% Plotting the graph and creating the figure

% figure(1)
% note: commented out to plot figure on GUI axes

% Plotting a 3-D graph of all three displacements
projDisplacement = plot3(z(5,:),z(1,:),z(3,:),'-.b','LineWidth',1.5); % Projectile displacement 

hold on 
grid on

droneDisplacement = plot3(d(3,:),d(1,:),d(2,:),':r','LineWidth',2); % Drone displacement

% Labeling the axes of the graph
xlabel('z-Displacement (m)');
ylabel('x-Displacement (m)');
zlabel('y-Displacement (m)');

% Plotting the parachute deployment position
if pStep ~= 0 % If the parachute has been deployed
    xc = z(1,pStep); % x-coordinate of parachute deployment position
    yc = z(3,pStep); % y-coordinate of parachute deployment position
    uc = z(5,pStep); % z-coordinate of parachute deployment position
    orange = 1/255*[255,140,0]; % Creating a color
    a = scatter3(uc,xc,yc,50,'MarkerFaceColor',orange,'MarkerEdgeColor',orange,'Marker','d'); % Parachute deployment position
    
hold on

% Plotting the initial position of the drone and the positions of ground
% impact, drone location and launcher location
initial = scatter3(d(3,1),d(1,1),d(2,1),100,'rp'); % initial drone position
b = scatter3(z(5,end),z(1,end),0,50,'mo','filled'); % Ground impact location
c = scatter3(0,0,1,100,'c*'); % Projectile launcher location


% Creating labels for relevant plot information and plotting final drone
% position
label1 = 'Projectile displacement (m)';
label2 = 'Drone displacement (m)';
if abs(minimum) <= 1
    % Thie executes if the drone is intercepted
    d = scatter3(d(3,pStep),d(1,pStep),d(2,pStep),100,'gp','filled'); % Final drone position (green marker color) 
    label3 = 'Drone interception and parachute deployment position';
else
    % This executes if the drone evades the projectile
    d = scatter3(d(3,end),d(1,end),d(2,end),100,'rp','filled'); % Final drone position (red marker color) 
    label3 = 'Parachute deployment position';
end
label4 = 'Ground impact location';
label5 = 'Projectile launcher location';

% Creating a legend for the graph based on whether or not the drone was
% intercepted
if any(vd~= 0) % Checks whether the drone was moving
    % This executes if the drone has a velocity
    label6 = 'Initial drone position';
    if abs(minimum) <= 1
        % Executes if the drone was intercepted
        label7 = 'Drone location at point of interception';
        legend([projDisplacement,droneDisplacement,a,b,c,initial,d],{label1,label2,label3,label4,label5,label6,label7},'Location','best');
    else
        % Executes if the drone evaded the projectile
        label7 = 'Final drone position'; 
        legend([projDisplacement,droneDisplacement,a,b,c,initial,d],{label1,label2,label3,label4,label5,label6,label7},'Location','best');
    end
else    
    % This executes if the drone is stationary
    label6 = 'Drone location';
    legend([projDisplacement,a,b,c,d],{label1,label3,label4,label5,label6},'Location','best');
end

hold off

end