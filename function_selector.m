function number = function_selector()
% Function that creates a list dialog box to allow the user to select one
% of four programs to launch.

% Output arguments:
% number - integer associated with the selected function

%% Creating a list selection dialog box for function selection
listTitle = 'Function Selection';
selText = 'Select a function to be run:';
funcNames = {'Timestep Stability Checker','Spatial Step Stability Checker','Thickness Comparison','Waterfall Plotter'}; % List of methods to choose from
[row2, sel2] = listdlg('Name',listTitle,'PromptString',selText,'ListString',funcNames,'SelectionMode','single');

% Using a combination of an if-else statement and a switch statement to
% determine the method selected
if sel2 == 0 || row2 == 1
    number = 1;
else
    switch row2
        case 2
            number = 2;
        case 3
            number = 3;
        case 4
            number = 4;
    end
end
