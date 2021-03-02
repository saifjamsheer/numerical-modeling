function method = method_selector()
% Function that creates a list dialog box to allow the user to select one
% of four numerical methods to use.

% Output arguments:
% method - solution method ('forward', 'dufort-frankel', 'backward', 'crank-nicolson')

%% Creating a list selection dialog box for method selection
listTitle = 'Method Selection';
promptText = 'Select a method to be used:';
tileNumbers = {'Forward','DuFort-Frankel','Backward','Crank-Nicolson'}; % List of methods to choose from
[row3, sel3] = listdlg('Name',listTitle,'PromptString',promptText,'ListString',tileNumbers,'SelectionMode','single');

% Using a combination of an if-else statement and a switch statement to
% determine the method selected
if sel3 == 0 || row3 == 1
    method = 'forward';
else
    switch row3
        case 2
            method = 'dufort-frankel'; 
        case 3
            method = 'backward';
        case 4
            method = 'crank-nicolson'; 
    end
end
