function [x,t,u,innermax] = shuttle_rad(tmax, nt, xmax, nx, method, doplot, imagename, r)
% Function for modelling temperature in a space shuttle tile.

% Input arguments:
% tmax      - maximum time
% nt        - number of timesteps
% xmax      - total thickness
% nx        - number of spatial steps
% method    - solution method ('forward', 'dufort-frankel', 'backward', 'crank-nicolson')
% doplot    - true to plot graph; false to suppress graph.
% imagename - 'temp' concatenated with tile number
% r         - boolean that is 1 if radiation is included and 0 if it is excluded

% Output arguments:
% x         - distance vector
% t         - time vector
% u         - temperature matrix
% innermax  - maximum inner surface temperature

%% Setting tile properties
thermcon = 0.141; % thermal conductivity (W/(m K))
density  = 351;   % density (22 lb/ft^3)
specheat = 1258;  % specific heat (~0.3 Btu/lb/F at 500F)
sigma = 56.7e-9; % stefan-boltzmann constant (W/(m^2 K^4))

%% Loading surface temperature data
load(imagename);

%% Setting initial conditions and values

% Time step (s)
dt = tmax / (nt-1);
% Time vector (s)
t = (0:nt-1) * dt;
% Spatial step (m)
dx = xmax / (nx-1);
% Distance vector (m)
x = (0:nx-1) * dx;
% Temperature matrix (deg C)
u = zeros(nt, nx);
% Thermal diffusivity (m^2/s)
alpha = thermcon/(density*specheat); 
% Finite difference method paramater
p = (alpha*dt)/(dx^2); 
% Step for numerical methods
istep = 2:nx-1;
% Maximum iterations to find solution for implicit methods
maxiterations = 100;

% Setting initial conditions to 16 deg C throughout.
% This is done for the first two timesteps.
u([1 2], :) = 16;

%% Main timestepping loop
for n = 2 : nt - 1
    %% Setting boundary conditions
    
    % LHS boundary condition: inner surface.
    L = 16;
    
    % RHS boundary condition: outer surface. 
    % Use interpolation to get temperature R at time t(n+1).
    R = interp1(timedata, tempdata, t(n+1), 'linear', 'extrap');
    
    %% Selecting the numerical method based on whether radiation is to be included or not
    if r == 1
        % Effects of radiation are included
        switch method

            % Forward-differencing method
            case 'forward'
                % Heat flow per surface area at left hand boundary
                q1 = sigma * (L^4 - u(n,1)^4);

                % Robin boundary condition (LHS)
                u(n+1,1) = (1 - 2*p) * u(n,1) + 2*p * (u(n,2) + (dx * q1)/thermcon);

                % Calculating internal values
                u(n+1,istep) = (1-2*p) * u(n,istep) + p * (u(n,istep-1) + u(n,istep+1));

                % Dirichlet boundary condition (RHS)
                u(n+1,nx) = R;

            % DuFort-Frankel method
            case 'dufort-frankel'
                % Heat flow per surface area at left hand boundary
                q1 = sigma * (L^4 - u(n,1)^4);

                % Robin boundary condition (LHS)
                u(n+1,1) = 1/(1+2*p) * ((1-2*p) * u(n-1,1) + 4*p * (u(n,2) + (dx * q1)/thermcon));

                % Calculating internal values
                u(n+1,istep) = 1/(1+2*p) * ((1-2*p)*u(n-1,istep) + 2*p * (u(n,istep-1) + u(n,istep+1)));

                % Dirichlet boundary condition (RHS)
                u(n+1,nx) = R;

            % Backward-differencing method
            case 'backward'
                % Calculating internal values iteratively using Gauss-Seidel
                % Starting values are equal to old values
                u(n+1, :) = u(n, :);

                for iteration = 1 : maxiterations
                    for i=1:nx
                        if i == 1
                            % Heat flow per surface area at left hand boundary
                            q1 = sigma * (L^4 - u(n+1,1)^4);
                            % Robin boundary condition (LHS)
                            u(n+1,i) = (u(n,i) + 2 * p * (u(n+1,i+1) + dx * q1 / thermcon))/(1 + 2 * p);
                        elseif i == nx
                            % Dirichlet boundary condition (RHS)
                            u(n+1,i) = R;
                        else
                            % Calculating internal values
                            u(n+1,i) = (u(n,i) + p * (u(n+1,i-1) + u(n+1,i+1)))/(1 + 2 * p);
                        end

                    end
                end 

            % Crank-Nicolson method
            case 'crank-nicolson'
               % Calculating internal values iteratively using Gauss-Seidel
                % Starting values are equal to old values
                u(n+1, :) = u(n, :);

                for iteration = 1 : maxiterations
                    for i=1:nx
                        if i == 1
                            % Heat flow per surface area at left hand boundary
                            q1 = sigma * (L^4 - u(n,1)^4);
                            q1x = sigma * (L^4 - u(n+1,1)^4);
                            % Robin boundary condition (LHS)
                            u(n+1,i) = (2*p*(u(n+1,i+1) + (dx * (q1 + q1x))/thermcon + u(n,i+1)) + ...
                                2*(1-p)*u(n,i))/(2*(1+p));
                        elseif i == nx
                            % Dirichlet boundary condition (RHS)
                            u(n+1,i) = R;
                        else
                            % Calculating internal values
                            u(n+1,i) = (p*(u(n+1,i+1) + u(n+1,i-1) + u(n,i+1) + u(n,i-1)) + ...
                                2*(1-p)*u(n,i))/(2*(1+p));
                        end
                    end
                end 

            otherwise
                error (['Undefined method: ' method])
                return
        end
    
    else
        % Effects of radiation are excluded
        switch method
            % Forward-differencing method
            case 'forward'
                % Neumann boundary condition (LHS)
                u(n+1,1) = (1 - 2*p) * u(n,1) + 2*p * u(n,2);

                % Calculating internal values
                u(n+1,istep) = (1-2*p) * u(n,istep) + p * (u(n,istep-1) + u(n,istep+1));

                % Dirichlet boundary condition (RHS)
                u(n+1,nx) = R;
            % DuFort-Frankel method
            case 'dufort-frankel'
                % Neumann boundary condition (LHS)
                u(n+1,1) = 1/(1+2*p) * ((1-2*p) * u(n-1,1) + 4*p * u(n,2));

                % Calculating internal values
                u(n+1,istep) = 1/(1+2*p) * ((1-2*p)*u(n-1,istep) + 2*p * (u(n,istep-1) + u(n,istep+1)));

                % Dirichlet boundary condition (RHS)
                u(n+1,nx) = R;
            % Backward-differencing method
            case 'backward'
                % First matrix row (Neumann boundary condition)
                b(1)     = 1 + 2*p;
                c(1)     = -2*p;
                d(1)     = u(n,1);
                % Calculating nternal matrix rows
                a(istep) = -p;
                b(istep) = 1 + 2*p;
                c(istep) = -p;
                d(istep) = u(n,istep);
                % Last matrix row (Dirichlet boundary condition)
                a(nx)    = 0;
                b(nx)    = 1;
                d(nx)    = R;
                % Solving the matrix using the tdm function
                u(n+1,:) = tdm(a,b,c,d);
            % Crank-Nicolson method
            case 'crank-nicolson'
                % First matrix row (Neumann boundary condition)
                b(1)     = 1 + p;
                c(1)     = -p;
                d(1)     = (1-p) * u(n,1) + p * u(n,2);
                % Calculating internal matrix rows
                a(istep) = -p/2;
                b(istep) = 1 + p;
                c(istep) = -p/2;
                d(istep) = p/2*u(n,1:nx-2) + (1-p)*u(n,istep) + p/2*u(n,3:nx);
                % Last matrix row (Dirichlet boundary condition)
                a(nx)    = 0;
                b(nx)    = 1;
                d(nx)    = R;
                % Solving the matrix using the tdm function
                u(n+1,:) = tdm(a,b,c,d);
            otherwise
                error (['Undefined method: ' method])
                return
        end
    end 
end

%% Plotting a waterfall plot of thickness, time and temperature
if doplot
    figure (3)
    waterfall(x,t,u);
    axis tight
    shading interp
    colorbar
    xlabel('\itx\rm - m'); 
    ylabel('\itt\rm - s'); 
    zlabel('\itu\rm - deg C');
end

%% Determining the maximum inner surface temperature
innermax = max(u(:,1));