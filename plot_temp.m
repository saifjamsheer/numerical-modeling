% Script that converts data of temperature and time in the form of an image
% to accurate numerical values ready to be used by the MATLAB software.

% Requires user input in the form of mouse clicks.

%% Creating an input box to allow the user to input the tile number he previously selected
prompt = {'Enter the 3-digit number of the tile you selected:'}; % Informing the user what value he/she needs to input
name = 'Determining the Tile'; % Title of the dialog box
numlines = 1; % Number of lines needed for each input
defaultanswer = {'502'}; % Setting default values for the inputs

tileInput = inputdlg(prompt, name, numlines, defaultanswer); 
tileNumber = tileInput{1};
imagefile = strcat('temp',tileNumber);
img = imread([imagefile '.jpg']);

%% Loading the image onto a figure
fig = figure (4);
image(img);
hold on

%% Initializing the time and temperature data vectors
timedata = [];
tempdata = [];

%% Determining the number of pixel columns in the image
[~, c, ~] = size(img); 

%% Instructing the user to allow the image to be scaled correctly
uiwait(msgbox('Please select the origin of the time-temperature graph.','Instruction #1','modal'));
% Get the point corresponding to the origin of the image with a mouse click
[x0, y0] = ginput(1); 

uiwait(msgbox('Please select the maximum value on the x-axis.','Instruction #2','modal')); 
% Get the point corresponding to the max x-axis value of the image with a mouse click
[x1, y1] = ginput(1);
% Instructing the user to input the aforementioned value
xval = inputdlg('Enter this value:', '', 1, {'2000'});
% Converting the inputted variable (string) into a number (double)
maxX = str2double(xval);

uiwait(msgbox('Please select the maximum value on the y-axis.','Instruction #3','modal'));
% Get the point corresponding to the max y-axis value of the image with a mouse click
[x2, y2] = ginput(1); 
% Instructing the user to input the aforementioned value
yval = inputdlg('Enter this value:', '', 1, {'2000'});
% Converting the inputted variable (string) into a number (double)
maxY = str2double(yval);

%% Looping through the horizontal pixels of the image to find the values of the red pixels
for i = 1 : c
    
    % Averaging the y values at each x-value to get x-y pairs
    y = mean(find(img(:,i,1)>150 & img(:,i,2)<100 & img(:,i,3)<100));
  
    % Only considering points where the above conditions are met
    if ~isnan(y)
        % Scaling the x-value into time
        x = (i-x0)*maxX/(x1-x0);
        % Scaling the y-value temperature (F) and converting it to (deg C)
        y = 5/9 * ((y-y0)*maxY/(y2-y0)- 32);
        % Adding data points to the time and temperature data vectors
        timedata = [timedata, x];
        tempdata = [tempdata, y]; 
    end
    
end

hold off

%% Sorting and saving data

% Sort data and remove duplicate points.
[timedata, index] = unique(timedata);
tempdata = tempdata(index);
timedata = [timedata 4000];
tempdata = [tempdata tempdata(end)];

% Save data to .mat file with same name as the image file
save(imagefile, 'timedata', 'tempdata')
close(gcf);