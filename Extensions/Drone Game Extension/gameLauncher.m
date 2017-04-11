function gameLauncher()

%% Setting initial drone and projectile conditions
xd1 = randi(100)-randi(100); % x-coordinate of drone 1 (m) (random integer between -100 and 100)
yd1 = 5+randi(95); % y-coordinate of drone 1 (m) (random integer between 5 and 100)
xd2 = 100*rand(1,1); % x-coordinate of drone 2 (m) (random integer between -100 and 100)
yd2 = randi(100)-randi(100); % y-coordinate of drone 2 (m) (random integer between 5 and 100)
xd3 = randi(100)-randi(100); % x-coordinate of drone 3 (m) (random number between -100 and 100)
yd3 = 5+randi(95); % y-coordinate of drone 3 (m) (random number between 5 and 100)
m1 = 0.5; % mass of drone (kg)
m2 = 0.5; % mass of projectile (kg)

%% Creating message boxes to introduce user to the game
uiwait(msgbox('Welcome to the Projectile Launch Game!'));
uiwait(msgbox('Please select a planet of your choice.'));

%% Creating a dialog box that allows the player to select the planet that the game will take place on
listTitle = 'Planet Selection';
promptText = 'Select a planet of your liking:';
planetList = {'Earth','Mercury','Venus','Mars','Jupiter','Saturn','Uranus','Neptune'}; % List of available planets to choose from
[RowNum, Sel] = listdlg('Name',listTitle,'PromptString',promptText,'ListString',planetList,'SelectionMode','single');

g = 9.80665; % Acceleration of free-fall on Earth (m/s^2)

%% Setting constant values according to the selected planet
% Combination of if-else statement and switch statement to determine the
% values of gravitational acceleration (grav), air pressure (pres) and
% temperature (temp) based on the selected planet
if Sel == 0 || RowNum == 1
    planet = 'Earth';
    grav = g; % Gravitational acceleration (m/s^2)
    pres = 101.325*10^3; % Pressure (Pa)
    temp = 288.15; % Temperature (K)
else
    switch RowNum
        case 2
            planet = 'Mercury';
            grav = 0.38*g;
            pres = 5e-10;
            temp = 440;    
        case 3
            planet = 'Venus';
            grav = 0.904*g;
            pres = 9200*10^3;
            temp = 737;    
        case 4
            planet = 'Mars';
            grav = 0.376*g;
            pres = 636;
            temp = 210;    
        case 5
            planet = 'Jupiter';
            grav = 2.528*g;
            pres = 70*10^3;
            temp = 165;    
        case 6
            planet = 'Saturn';
            grav = 1.065*g;
            pres = 140*10^3;
            temp = 134;    
        case 7
            planet = 'Uranus';
            grav = 0.886*g;
            pres = 10*10^3;
            temp = 76;    
        case 8
            planet = 'Neptune';
            grav = 1.14*g;
            pres = 10*10^3;
            temp = 72;    
    end
end
% note: Websites where values were taken from are referenced in the main
% body of the report and can be found in reference list ([5],[6],[7])

%% Creating two interfaces that allow the user to select between difficulties
% Creating a user interface that allows the user to choose if he wants to
% be extreme and go with the extreme difficulty
extremePrompt = 'Would you like a challenge?'; % Asking the user to select one of two options
title = 'For Champions Only'; % Title of the dialog box
extremeC = 'Challenge is my middle name'; % First choice
cowardC = 'I''m too afraid.'; % Second choice

extremeChoice = questdlg(extremePrompt, title, extremeC, cowardC, extremeC);

switch extremeChoice
    case 'Challenge is my middle name'
        % Launches the extreme version of the game (one drone but
        % projectile has to hit it directly)
        gameExtreme(xd1,yd1,m1,m2,planet,grav,pres,temp);
        return
end
        
% Creating a user interface that allows the user to choose one of three non-extreme difficulties
prompt = 'Please select a less challenging difficulty.'; % Informing the user of what he/she should do
title = 'Difficulty Selector'; % Title of the interface
difficulty1 = 'Easy'; % First choice
difficulty2 = 'Medium'; % Second choice
difficulty3 = 'Hard'; % Third choice

selectedDifficulty = questdlg(prompt, title, difficulty1, difficulty2, difficulty3, difficulty1);

% Switch statement based on whether the user selects 'Launch' or 'Abort'
switch selectedDifficulty
    case 'Easy'
        % Launches the easy version of the game (one drone)
        gameEasy(xd1,yd1,m1,m2,planet,grav,pres,temp);
    case 'Medium'
        % Launches the medium version of the game (two drones)
        gameMedium(xd1,yd1,xd2,yd2,m1,m2,planet,grav,pres,temp);
    case 'Hard'
        % Launches the hard version of the game (three drones)
        gameHard(xd1,yd1,xd2,yd2,xd3,yd3,m1,m2,planet,grav,pres,temp);     
end