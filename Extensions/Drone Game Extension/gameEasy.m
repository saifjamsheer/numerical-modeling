function gameEasy(xd,yd,m1,m2,planet,grav,pres,temp)
% Function that takes in inputs xd (drone x-coordinate), yd (drone
% y-coordinate), m1 (drone mass), m2 (projectile mass), planet (planet the
% game is taking place on), grav (gravity on aforementioned planet), pres
% (pressure on aforementioned planet) and temp (temperature on
% aforementioned planet) in order to launch the easy version of an
% interactive game.

%% Creating a wait bar 
% Only purpose of the bar is to make it feel more like a game that needs to load in before you can begin to play
j = waitbar(0,'The game will begin shortly... (0%)');

for i=1:10000
    % Bar increments from 1 to 10000
    if mod(i,100) == 0 
        % Percentage value changes every 100 steps
        perc = num2str(i/100);
        waitbar(i/10000,j,strcat('The game will begin shortly... (',perc,'%)')); 
    end
    waitbar(i/10000,j); % Wait bar is updated 
end

close(j) % Closes the wait bar after loading is complete

%% Creating a message box to direct the reader's eyes to the appropriate location
% As the initial part of the game takes place within the command window, the
% user is told to pay attention to said location as to avoid missing any
% important information
uiwait(msgbox('Please avert your attention to the command window.'));

%% Message chain introducing the user to the game
pause(1);
fprintf('Hey there soldier, how''s it going?\n'); 
pause(2);
fprintf('I''m Private Grif, and I''m here to guide you through this hellhole.\n');
pause(3);
fprintf(['Your job is to figure out the necessary launch angle to intercept a drone that has been terrorizing',' ', planet,'.\n']);
pause(3);
fprintf('No pressure.\n');
fprintf('\n');
pause(2);

% Allowing the user to decide if he wants to skip the rules and instructions
skippable = 'If you''ve already played this game and know what I''m about to tell you, you can enter "s" to skip.\nIf you have no clue what you''re dealing with, enter anything else: ';
skip = input(skippable,'s');
fprintf('\n');
pause(2);
if ~(strcmpi(skip,'s'))
    % The message chain continues if the user decides not to skip
    fprintf('Before you start playing around with the launcher and wasting our projectiles, you have to know some rules and instructions:\n');
    pause(6);
    % Letting the user know the rules and instructions of the game before the game begins to eliminate any confusion
    fprintf('1. Thankfully, we live in a 2D world, so you only have to worry about the horizontal and vertical directions.\n');
    pause(6);
    fprintf('2. The projectile launcher is positioned at 1m above ground level (Y = 1) in the center of the battlefield (X = 0).\n')
    pause(6);
    fprintf(['3. The drone, on the other hand, is at [',num2str(xd),',',num2str(yd),'] ([x,y]).\n']);
    pause(6);
    fprintf('4. We generally fire our projectiles with an initial speed of 50 m/s, but you can play around with the speed if you feel like it.\n');
    pause(6);
    fprintf(['5. Gravity is still a thing here, so you''re going to have to account for that (it''s around',' ',num2str(grav),' ','m/s^2 on',' ',planet,').\n']);
    pause(6);
    fprintf('6. If you get close enough to the drone, a net will release and intercept it, a parachute will be deployed, and we''ll all be safe.\n');
    pause(6);
    fprintf('7. If you fail to do so, a parachute will be deployed when the projectile is 5m above ground and we''ll be one step closer to eternal doom.\n');
    pause(8);
    fprintf(['8. You have 5 attempts to take down the drone. If you fail,',' ',planet,' ','will be destroyed.\n']);
    fprintf('\n');
    pause(6);

    % Allows the user to input a command based on whether or not he understand
    % the rules of the game
    prompt1 = 'Do you understand what is required of you soldier? Enter yes or no: ';
    understand = input(prompt1, 's');
    validInputs = {'yes','no'};
    pause(1);

    % While loop remains active whilst the user fails to input either 'yes' or
    % 'no' (case insensitive)
    while ~strcmpi(understand,validInputs(1)) && ~strcmpi(understand,validInputs(2))
        fprintf('Invalid input. Please stop fooling around.\n');
        understand = input(prompt1, 's');
    end

    pause(2);
    if strcmpi(understand,validInputs(1))
        % Executes if the reader understands the rules (inputs 'yes')
        fprintf('Great, let''s get started.\n');
    else
        % Executes if the reader does not understand the rules (inputs 'no')
        fprintf('Well too bad, I''m not repeating them. Now let''s get going.\n');
    end
else
    % Skips the rules and instructions
    fprintf('Great, let''s get started.\n');
end

fprintf('\n');
pause(3);

%% Creating a figure and plotting points to display the position of the launcher and drone 
fprintf('So here''s the beautiful projectile launcher, and there''s that forking drone in the distance!\n');
pause(3);

figure(1)
a = scatter(0,1,70,'b*'); % Plotting the launcher position
hold on
grid on
b = scatter(xd,yd,70,'rx'); % Plotting the drone location

legend([a,b],'Launcher Position','Drone Location'); % Creating a legend
axis([-100 100 0 200]); % Setting the axes limits
pause(10); % Pausing for 10 seconds to allow the user to get a good view of the positions before inputting his angle and speed
close(gcf); % Closing the figure

%% Creating an input box in which the user can choose an angle and projectile speed to intercept the drone

fprintf('We can''t lose any more lives, quick, input an angle and a speed and let''s strike that drone to the ground.\n');
pause(4);

prompt = {'Enter your desired launch angle (in degrees):','Enter a projectile speed (in m/s):'}; % Informing the user what values he/she needs to input
name = 'Projectile Launcher User Interface'; % Title of the interface
numlines = 1; % Number of lines provided for each input
defaultanswer = {'60', '50'}; % Setting default values for the inputs

userInputs = inputdlg(prompt, name, numlines, defaultanswer);

%% Taking the variables inputted by the user and converting them into useful numbers
angle = str2double(userInputs(1)); % launch angle (deg)
speed = str2double(userInputs(2)); % launch speed (m/s)

%% Creating a user interface that allows the user to either launch the projectile or abort the mission
prompt2 = 'Click launch to launch projectile. Click abort if you are a coward.'; % Question informing the user of his two choices
title = 'Launch Procedure'; % Title of the interface
choice1 = 'Launch'; % First choice
choice2 = 'Abort'; % Second choice

launchProj = questdlg(prompt2, title, choice1, choice2, choice1);

%% Implementing a switch statement based on whether the user selects 'Launch' or 'Abort' to determine the next course of action
switch launchProj
    case 'Launch'
        fprintf('Good decision soldier. Now let''s watch our projectile go.\n');
    case 'Abort'
        % Choosing 'Abort' ends the function, kicking the user out of the
        % game due to cowardice
        fprintf('Cowards die many times before their deaths. We do not need you, we will find a braver soul.\n');
        return
end

pause(0.2);

%% Determining whether the user's first attempt resulted in a hit or miss
% Calling the gamePlotter function in order to determine whether or not the
% projectile managed to intercept the drone
[hit,message] = gamePlotter(angle,xd,yd,m1,m2,speed,grav,pres,temp);

pause(1);

%% Implementing a while loop that loops until the game ends
attempts = 1; % As the user already had one attempt, this variable is initialized with a value of 1

% While loop continues either until the drone has been intercepted (if it
% hasn't already been hit with the first attempt), or if the user has 5
% failed attempts 
while hit ~= 1 && attempts < 5
    
    % Opens up a message box that informs the user what to do based on
    % whether the chosen angle/speed was too high or low
    g = msgbox(message);
    
    % This if-else statement converts the message text into speech based on
    % whether the user's computer is a mac or a pc
    if ismac
        system(sprintf('say -v "Karen" %s', message)); 
    elseif ispc
        NET.addAssembly('System.Speech');
        obj = System.Speech.Synthesis.SpeechSynthesizer;
        obj.Volume = 100;
        Speak(obj, message);
    end
    % note: text-to-speech code modified from existing code found online
    % (referenced in the main body of the report as reference [2])
    
    pause(1.5);
    delete(g); % Closes the message box after the AI finishes speaking
    
    % Displaying the number of attempts left in a warning box to ensure
    % that the user is aware of how many attempts he has left
    leftAttempts = num2str(5-attempts);
    uiwait(warndlg(['You have',' ',leftAttempts,' ','attempts left.']));
    
    
    defaultanswer = {num2str(angle), num2str(speed)}; % Changing default values to user's previous angle and speed inputs
    
    % Recreating the dialog box to allow the user to plot a new angle and
    % projectile speed
    userInputs = inputdlg(prompt, name, numlines, defaultanswer);
    angle = str2double(userInputs(1)); % launch angle (deg)
    speed = str2double(userInputs(2)); % launch speed (m/s)
    
    % Recreating the user interface that allows the user to either launch the
    % projectile or abort the mission
    launchProj = questdlg(prompt2, title, choice1, choice2, choice1);
    
    switch launchProj
        case 'Abort'
            % If the user decides to abort mission. the game ends
            % immediately and the figure in which the trajectories are
            % plotted is closed 
            close(gcf);
            pause(0.5);
            fprintf('I expect better from you. Leave immediately.\n');
            return
    end
    
    % Calling the gamePlotter function with the newly chosen angle and
    % speed in order to determine whether or not the projectile managed to
    % intercept the drone 
    [hit,message] = gamePlotter(angle,xd,yd,m1,m2,speed,grav,pres,temp);
    
    attempts = attempts+1; % Incrementing the number of attempts by 1
    pause(0.1);
    
end

%% Establishing victory and defeat outcomes
if hit == 1
    % If the drone was hit the victory screen is shown
    msgTitle = 'Victory Screen';
    finalMsg = message;
    icon = imread('celebrate.jpg');
else
    % If the drone is missed the defeat screen is shown
    msgTitle = 'Defeat Screen';
    finalMsg = 'You have doomed us all.';
    icon = imread('explode.jpg');
end

% Karen (the AI) reads the message associated with either the victory or
% defeat screen whilst the screen is shown
g = msgbox(finalMsg,msgTitle,'custom',icon);
if ismac
    system(sprintf('say -v "Karen" %s', finalMsg)); 
elseif ispc
    NET.addAssembly('System.Speech');
    obj = System.Speech.Synthesis.SpeechSynthesizer;
    obj.Volume = 100;
    Speak(obj, finalMsg);
end

%% Closing all open figures and boxes to end the game
pause(0.5);
close(gcf);
pause(2);
delete(g);

%% Allowing the user to replay or quit
% Creating a question box that allows the user to choose to replay the game
% or to exit the game
contPrompt = 'Would you like to play again?'; % Question prompt
contTitle = 'Restart Game'; % Title of the dialog box
rep = 'Yes, Replay'; % First choice
exit = 'No, Exit'; % Second choice

replayGame = questdlg(contPrompt, contTitle, rep, exit, rep);

% Switch statement determining whether or not the user wants to replay the
% game
switch replayGame
    case 'Yes, Replay'
        % gameLauncher function is called if the user decides to replay the
        % game
        clc; % Clears the command window
        gameLauncher(); % Relaunches the game
    case 'No, Exit'
        % return statement to end the function if the user chooses to exit
        return
end

end