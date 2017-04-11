function dxstability(tile,r)
% Function that plots the inner surface temperature against a range of
% timestep values for four numerical methods to investigate the stability
% and accuracy of the methods.

% Input arguments:
% tile - 'temp' concatenated with tile number
% r    - boolean that is 1 if radiation is included and 0 if it is excluded

%% Setting initial conditions and values

% Initializing counter value
i=0; 
% Number of time steps (s)
ntsp = 501; 
% Maximum tile thickness (m)
xmaxsp = 0.05; 
% Maximum time (s)
tmaxsp = 4000; 
% Image associated with selected tile
tilename = tile;

%% Looping through a number of spatial steps
for nxsp = 3:2:101 
    
    % Increasing the counter value by 1
    i=i+1; 
    
    % Creating a vector of spatial steps
    dxsp(i) = xmaxsp/(nxsp-1); 
    
    % disp (['nt = ' num2str(nt) ', dt = ' num2str(dt(i)) ' s']) 
    
    % Forward-differencing method
    [~, ~, u] = shuttlerad(tmaxsp, ntsp, xmaxsp, nxsp, 'forward', false, tilename, r); 
    uf(i) = u(end, 1); 
    
    % Backward-differencing method
    [~, ~, u] = shuttlerad(tmaxsp, ntsp, xmaxsp, nxsp, 'backward', false, tilename, r); 
    ub(i) = u(end, 1); 
    
    % Dufort-Frankel method
    [~, ~, u] = shuttlerad(tmaxsp, ntsp, xmaxsp, nxsp, 'dufort-frankel', false, tilename, r); 
    ud(i) = u(end, 1); 
    
    % Crank-Nicolson method
    [~, ~, u] = shuttlerad(tmaxsp, ntsp, xmaxsp, nxsp, 'crank-nicolson', false, tilename, r); 
    uc(i) = u(end, 1);
end 

%% Plotting the result to determine the most appropriate method and spatial step
plot(dxsp, [uf; ub; ud; uc], 'LineWidth', 1) 
if r == 0
 ylim([100 200]) 
end 
legend ('Forward', 'Backward', 'Dufort-Frankel', 'Crank-Nicolson')
xlabel('\itdx\rm - m'); 
ylabel('\itu\rm - deg C');