function znext = stepRungeKutta3D(z,dt,cond,m1,m2,vW)
% Compute the next state vector from the previous ones using the 
% Range-Kutta 4 method (essentially going one step forward in time);
% notable inputs are z (matrix containing current x, y and z
% displacements and velocities of the projectile) and dt (time step in
% seconds).

%% Calculating the state derivative from the current state
A = dt * stateDeriv3D(z,cond,m1,m2,vW);
B = dt * stateDeriv3D(z + A/2,cond,m1,m2,vW);
C = dt * stateDeriv3D(z + B/2,cond,m1,m2,vW);
D = dt * stateDeriv3D(z + C,cond,m1,m2,vW);

%% Calculating the next state vector from the previous one using the Runge-Kutta 4 update equation
znext = z + (1/6) * (A+2*B+2*C+D);

end