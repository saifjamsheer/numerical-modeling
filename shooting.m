function [xideal] = shooting()
% Function that implements the shooting method to find the ideal tile
% thickness to keep the inner surface temperature of the tile below a 
% user-selected temperature.

% Output arguments:
% xideal - optimal tile thickness

%% Creating dialog boxes to allow the user to input values and setting other inputs
prompt = {'Enter the maximum time (s):',... 
    'Enter the number of timesteps:',...
    'Enter the number of spatial steps:'}; % Informing the user what values he/she needs to input
name = 'Variable Inputs'; % Title of the dialog box
numlines = 1; % Number of lines needed for each input
defaultanswer = {'4000','501','21'}; % Setting default values for the inputs

userInputs = inputdlg(prompt, name, numlines, defaultanswer); 

tmax = str2double(userInputs(1)); % maximum time (s)
nt = str2double(userInputs(2)); % number of timesteps
nx = str2double(userInputs(3)); % number of spatial steps
doplot = false; % false to suppress graph.
method = 'crank-nicolson'; % solution method

%% Calling tileselector function to determine the tile the user wants to analyze
imagename = tileselector;

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

%% Allowing the user to select the variables relevant to the implementation of the shooting method
prompt = {'Enter the maximum allowable inner surface temperature (deg):',...
    'Enter the maximum allowable error:'}; % Informing the user what values he/she needs to input
name = 'Shooting Method Inputs'; % Title of the dialog box
numlines = 1; % Number of lines needed for each input
defaultanswer = {'176','0.5'}; % Setting default values for the inputs

userInputs = inputdlg(prompt, name, numlines, defaultanswer); 

umax = str2double(userInputs(1)); % maximum allowable inner surface temperature (deg C)
erracceptable = str2double(userInputs(2)); % acceptable error

%% Setting the initial two thickness guesses
thickness(1) = 0.01;
thickness(2) = 0.10;

%% Determining the errors associated with the first two guesses

% Determining the maximum inner surface temperature for the respective
% value of thickness
[~,~,~,maxtemp(1)] = shuttlerad(tmax,nt,thickness(1),nx,method,doplot,imagename,r);
[~,~,~,maxtemp(2)] = shuttlerad(tmax,nt,thickness(2),nx,method,doplot,imagename,r);

% Calculating the error by finding the difference between the computed
% temperature and the user-selected temperature
error(1) = maxtemp(1) - umax;
error(2) = maxtemp(2) - umax;

%% Shooting method implementation

n = 2; % Starting the counter at a value of 2

% The loop is executed while the error is greater than the user-selected
% maximum acceptable error

while abs(error(n)) > erracceptable
% Using the shooting method to determine subsequent guesses for the launch
% angle until the calculated error satisfies the necessary condition
    
    % Computing the next angle guess using the previous two angle guesses
    thickness(n+1) = thickness(n)-error(n)*((thickness(n)-thickness(n-1))/(error(n)-error(n-1)));
    
    % Checking to see if the shooting method failed
    if isnan(thickness(n+1))
        xideal = 'Thickness Unobtainable';
        return
    end
    
    % Solving the IVP using the newly guessed thickness to determine the
    % corresponding maximum temperature
    [~,~,~,maxtemp(n+1)] = shuttlerad(tmax,nt,thickness(n+1),nx,method,doplot,imagename,r);
        
    % Calculating the error, which is stored in a vector
    error(n+1) = maxtemp(n+1) - umax;
    
    % Incrementing the counter by 1
    n = n+1;
    
end

%% Establishing the value of the output variable
xideal = abs(thickness(end)); % Thickness required to ensure inner surface temperature specification is met

end