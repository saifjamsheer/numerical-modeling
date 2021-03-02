function dt(tile,r)
% Function that plots the inner surface temperature against a range of
% timestep values for four numerical methods to investigate the stability
% and accuracy of the methods.

% Input argument:
% tile - 'temp' concatenated with tile number
% r    - boolean that is 1 if radiation is included and 0 if it is excluded

%% Setting initial conditions

% Initializing counter value
i=0; 
% Number of spatial steps (m)
nxst = 21; 
% Maximum tile thickness (m)
thick = 0.05; 
% Maximum time (s)
tmaxst = 4000; 
% Image associated with selected tile
tilename = tile;

%% Looping through a number of timesteps
for ntst = 41:20:1001
    
    % Increasing the counter value by 1
    i=i+1; 
    
    % Creating a vector of time steps
    dtst(i) = tmaxst/(ntst-1); 
    
    % disp (['nt = ' num2str(nt) ', dt = ' num2str(dt(i)) ' s']) 
    
    % Forward-differencing method
    [~, ~, u] = shuttlerad(tmaxst, ntst, thick, nxst, 'forward', false, tilename, r); 
    uf(i) = u(end, 1); 
    
    % Backward-differenicng method
    [~, ~, u] = shuttlerad(tmaxst, ntst, thick, nxst, 'backward', false, tilename, r); 
    ub(i) = u(end, 1); 
    
    % Dufort-Frankel method
    [~, ~, u] = shuttlerad(tmaxst, ntst, thick, nxst, 'dufort-frankel', false, tilename, r); 
    ud(i) = u(end, 1); 
    
    % Crank-Nicolson method
    [~, ~, u] = shuttlerad(tmaxst, ntst, thick, nxst, 'crank-nicolson', false, tilename, r); 
    uc(i) = u(end, 1);
    
end 

%% Plotting the result to determine the most appropriate method and time step
plot(dtst, [uf; ub; ud; uc], 'LineWidth', 1) 
if r == 0
 ylim([100 200]) 
end 
legend ('Forward', 'Backward', 'Dufort-Frankel', 'Crank-Nicolson')
xlabel('\itdt\rm - s'); 
ylabel('\itu\rm - deg C');
