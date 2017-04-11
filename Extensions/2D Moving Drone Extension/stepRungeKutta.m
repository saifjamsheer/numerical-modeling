function znext = stepRungeKutta(z,dt,cond,m1,m2)
% Compute the next state vector from the previous ones using the 
% Range-Kutta 4 method (essentially going one step forward in time);
% notable inputs are z (matrix containing current horizontal and vertical
% displacements and velocities of the projectile) and dt (time step in
% seconds).

%% Calculating the state derivative from the current state
A = dt * stateDeriv(z,cond,m1,m2);
B = dt * stateDeriv(z + A/2, cond, m1, m2);
C = dt * stateDeriv(z + B/2, cond, m1, m2);
D = dt * stateDeriv(z + C, cond, m1, m2);

%% Calculating the next state vector from the previous one using the Runge-Kutta 4 update equation
znext = z + (1/6) * (A+2*B+2*C+D);

end