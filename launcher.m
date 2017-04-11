function [x,t,u] = launcher()
% Highest order function that launches one of the following four programs 
% depending on what the user selects:

% 1. Timestep Stability Checker (dtstability.m)
% 2. Spatial Step Stability Checker (dxstability.m)
% 3. Thickness Comparer (comparethickness.m)
% 4. Waterfall Plotter (shuttlerad.m)

% Output arguments (only applies if shuttlerad.m is launched):
% x  - distance vector
% t  - time vector
% u  - temperature matrix

%% Creating message box to introduce user to the launcher and inform them of what is required
uiwait(msgbox(sprintf(['Welcome to the launcher.\n\nYou will be required to select ' ... 
    'a tile and the function you would like to launch.']),'Launcher','modal'));

%% Calling tileselector function to determine the tile the user wants to analyze
imagename = tileselector;

%% Calling functionselector function to determine the function to be launched
func = functionselector;

%% Creating a question box to determine whether radiation is to be considered
question = 'Would you like to include the effects of radiation?'; % Question prompt
questTitle = 'Plot Decider'; % Title of the dialog box
choice1 = 'Yes'; % First choice
choice2 = 'No'; % Second choice

decideRad = questdlg(question, questTitle, choice1, choice2, choice1);

% Using a switch statement to determine whether the effects of radiation
% are to be included
switch decideRad
    case 'Yes'
        r = 1;
    case 'No'
        r = 0;
end

%% Determining what should be done based on what function is selected
if func == 1
    dtstability(imagename,r);
elseif func == 2
    dxstability(imagename,r);
else
    method = methodselector;
    if func == 3
        comparethickness(imagename,method,r);
    else 
        [tmax,nt,xmax,nx,doplot] = shuttleinputs;
        [x,t,u] = shuttlerad(tmax,nt,xmax,nx,method,doplot,imagename,r);
    end
end

%% Allowing the user to rerun or exit the launcher

% Creating a question box that allows the user to choose to restart the
% launcher or exit the launcher
prompt = 'Would you like to start over or exit the launcher?'; % Question prompt
title = 'End Screen'; % Title of the dialog box
restart = 'Relaunch'; % First choice
exit = 'Exit'; % Second choice

pause(8)

restartLauncher = questdlg(prompt, title, restart, exit, restart);

% Switch statement determining whether or not the user wants to relaunch
switch restartLauncher
    case 'Relaunch'
        close(gcf); % Closes all figures
        clc; % Clears the command window
        launcher; % Relaunches the game
    case 'Exit'
        clc; % Clears the command window
        return % return statement to end the function if the user chooses to exit
end

end