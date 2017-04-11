function comparethickness(image,method,r)
% Function that plots the inner surface temperature against time for a
% practical range of tile thicknesses.

% Input arguments:
% image  - 'temp' concatenated with tile number
% method - solution method ('forward', 'backward' etc)
% r      - boolean that is 1 if radiation is included and 0 if it is excluded

%% Setting initial conditions

% Initializing counter value
i=0; 
% Number of time steps (s)
ntc = 501; 
% Number of spatial steps (m)
nxc = 21; 
% Maximum time (s)
tmaxc = 4000; 
% Suppresses graph
doplot = false;
% Image associated with selected tile
tilename = image;
% Method selected
nummethod = method; 

%% Looping across a number of thickness values
for xmaxc = 0.01:0.01:0.10
    
    % Increasing the counter value by 1
    i=i+1; 
    
    % Creating a vector of thickness values as texts
    xvec{i} = sprintf('%s %s', 'Thickness =', num2str(xmaxc));
    
    % Calling the shuttlerad function to get values of u for each value
    % of xmax (thickness)
    [~, t, u] = shuttlerad(tmaxc, ntc, xmaxc, nxc, nummethod, doplot, tilename, r);
    tn(:,i) = u(:,1); 
    
end

%% Plotting the result to determine the best tile thickness
plot(t, tn, 'LineWidth', 1)
legend(xvec)
xlabel('\itt\rm - s'); 
ylabel('\itu\rm - deg C');
