function [tmax,nt,xmax,nx,doplot] = inputs()
% Function that allows the user to input the values to be used in the
% shuttle.m function through an input dialog box.

% Output arguments:
% tmax     - maximum time
% nt       - number of timesteps
% xmax     - total thickness
% nx       - number of spatial steps
% doplot   - true to plot graph; false to suppress graph.

%% Creating dialog boxes to allow the user to input values
prompt = {'Enter the maximum time (s):',... 
    'Enter the number of timesteps:',...
    'Enter the total thickness of the tile (m):',... 
    'Enter the number of spatial steps:'}; % Informing the user what values he/she needs to input
name = 'Variable Inputs'; % Title of the dialog box
numlines = 1; % Number of lines needed for each input
defaultanswer = {'4000','501','0.05','21'}; % Setting default values for the inputs

userInputs = inputdlg(prompt, name, numlines, defaultanswer); 

tmax = str2double(userInputs(1)); % maximum time (s)
nt = str2double(userInputs(2)); % number of timesteps
xmax = str2double(userInputs(3)); % maximum thickness (m)
nx = str2double(userInputs(4)); % number of spatial steps

%% Creating a question box to determine whether a graph should be plotted
question = 'Would you like to plot a graph?'; % Question prompt
questTitle = 'Plot Decider'; % Title of the dialog box
choice1 = 'Yes'; % First choice
choice2 = 'No'; % Second choice

decidePlot = questdlg(question, questTitle, choice1, choice2, choice1);

% Using a switch statement to determine whether a graph is to be plotted
switch decidePlot
    case 'Yes'
        doplot = true;
    case 'No'
        doplot = false;
end

