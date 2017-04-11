function znext = stepRKGame(z,dt,cond,m1,m2,grav,pres,temp)
% Compute the next state vector from the previous ones using the 
% Range-Kutta 4 method (essentially going one step forward in time);
% notable inputs are z (matrix containing current horizontal and vertical
% displacements and velocities of the projectile) and dt (time step in
% seconds).

%% Calculating the state derivative from the current state
A = dt * gameDeriv(z,cond,m1,m2,grav,pres,temp);
B = dt * gameDeriv(z + A/2, cond, m1, m2,grav,pres,temp);
C = dt * gameDeriv(z + B/2, cond, m1, m2,grav,pres,temp);
D = dt * gameDeriv(z + C, cond, m1, m2,grav,pres,temp);

%% Calculating the next state vector from the previous one using the Runge-Kutta 4 update equation
znext = z + (1/6) * (A+2*B+2*C+D);

end