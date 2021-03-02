function tile = tile_selector()
% Function that creates a list dialog box to allow the user to select the
% tile data they wish to have loaded in and analyzed.

% Output arguments:
% tile - 'temp' concatenated with selected tile number

%% Creating a list to allow the user to select the tile that will be loaded in and analyzed
listTitle = 'Tile Selection';
listText = 'Select a tile to be analyzed:';
tileNumbers = {'Tile 502','Tile 590','Tile 468','Tile 597','Tile 480','Tile 850','Tile 730','Tile 711'}; % List of tiles to choose from
[row1, sel1] = listdlg('Name',listTitle,'PromptString',listText,'ListString',tileNumbers,'SelectionMode','single');

% Combination of if-else statement and switch statement to determine the
% tile that was selected
if sel1 == 0 || row1 == 1
    tile = 'temp502';
else
    switch row1
        case 2
            tile = 'temp590'; 
        case 3
            tile = 'temp468';  
        case 4
            tile = 'temp597'; 
        case 5
            tile = 'temp480'; 
        case 6
            tile = 'temp850';  
        case 7
            tile = 'temp730';    
        case 8
            tile = 'temp711'; 
    end
end

%% Determining whether the plot image of the temperature for the selected tile needs to be traced
imagefile = strcat(tile,'.mat');
if exist(imagefile) ~= 2
    plottemp
end
