% Graphical user interface that either simulates the trajectory of the
% projectile in both two and three dimensions by making use of a graphical
% user interface or uses the shooting method to determine the launch angle
% needed to intercept a drone.

function varargout = launchGUI(varargin)


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @launchGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @launchGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% notes:
% hObject is the handle to the corresponding object
% eventdata is a reserved input (to be defined in a future version of MATLAB
% handles contains the properties of the object

% GUI code begins here:

% --- Executes just before launchGUI is made visible.
function launchGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for launchGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = launchGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function xCor3DText_CreateFcn(hObject, eventdata, handles)
% Creates the static text that labels the 3D x-coordinate input field
set(hObject,'Visible','off'); % Sets the visibility of this text to off 

% --- Executes during object creation, after setting all properties.
function yCor3DText_CreateFcn(hObject, eventdata, handles)
% Creates the static text that labels the 3D y-coordinate input field
set(hObject,'Visible','off'); % Sets the visibility of this text to off 

% --- Executes during object creation, after setting all properties.
function zCorText_CreateFcn(hObject, eventdata, handles)
% Creates the static text that labels the 3D z-coordinate input field
set(hObject,'Visible','off'); % Sets the visibility of this text to off 

% --- Executes during object creation, after setting all properties.
function xCor2DText_CreateFcn(hObject, eventdata, handles)
% Creates the static text that labels the 2D x-coordinate input field

% --- Executes during object creation, after setting all properties.
function yCor2DText_CreateFcn(hObject, eventdata, handles)
% Creates the static text that labels the 2D y-coordinate input field

% --- Executes during object creation, after setting all properties.
function xCor2DEdit_CreateFcn(hObject, eventdata, handles)
% Creates the editable text field to input the 2D x-coordinate
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); 
end

% --- Executes during object creation, after setting all properties.
function yCor2DEdit_CreateFcn(hObject, eventdata, handles)
% Creates the editable text field to input the 2D y-coordinate
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function xCor3DEdit_CreateFcn(hObject, eventdata, handles)
% Creates the editable text field to input the 3D x-coordinate
set(hObject,'Visible','off'); % Sets the visibility of this object to off 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function yCor3DEdit_CreateFcn(hObject, eventdata, handles)
% Creates the editable text field to input the 3D y-coordinate
set(hObject,'Visible','off'); % Sets the visibility of this object to off 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function zCorEdit_CreateFcn(hObject, eventdata, handles)
% Creates the editable text field to input the 3D z-coordinate
set(hObject,'Visible','off'); % Sets the visibility of this object to off 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function droneMassEdit_CreateFcn(hObject, eventdata, handles)
% Creates the editable text field to input the mass of the drone
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function projectileMassEdit_CreateFcn(hObject, eventdata, handles)
% Creates the editable text field to input the mass of the projectile
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function launchAngleEdit_CreateFcn(hObject, eventdata, handles)
% Creates the editable text field to input the launch angle
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function axisAngleText_CreateFcn(hObject, eventdata, handles)
% Creates the static text that labels the axis angle input field
set(hObject,'Visible','off'); % Sets the visibility of this text to off 

% --- Executes during object creation, after setting all properties.
function axisAngleEdit_CreateFcn(hObject, eventdata, handles)
% Creates the editable text field to input the axis angle
set(hObject,'Visible','off'); % Sets the visibility of this object to off 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function wxEdit_CreateFcn(hObject, eventdata, handles)
% Creates the editable text field to input the wind speed in the
% x-direction
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Visible','off'); % Sets the visibility of this object to off 

% --- Executes during object creation, after setting all properties.
function wyEdit_CreateFcn(hObject, eventdata, handles)
% Creates the editable text field to input the wind speed in the
% y-direction
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Visible','off'); % Sets the visibility of this object to off 

% --- Executes during object creation, after setting all properties.
function wzEdit_CreateFcn(hObject, eventdata, handles)
% Creates the editable text field to input the wind speed in the
% z-direction
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Visible','off'); % Sets the visibility of this object to off 

% --- Executes during object creation, after setting all properties.
function projSpeedEdit_CreateFcn(hObject, eventdata, handles)
% Creates the editable text field to input the projectile speed
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Functions for the callback for all input boxes
function xCor2DEdit_Callback(hObject,event,handles)
function yCor2DEdit_Callback(hObject,event,handles)
function xCor3DEdit_Callback(hObject,event,handles)
function yCor3DEdit_Callback(hObject,event,handles)
function zCorEdit_Callback(hObject,event,handles)
function wxEdit_Callback(hObject,event,handles)
function wyEdit_Callback(hObject,event,handles)
function wzEdit_Callback(hObject,event,handles)
function droneMassEdit_Callback(hObject,event,handles)
function projectileMassEdit_Callback(hObject,event,handles)
function projSpeedEdit_Callback(hObject,event,handles)
function launchAngleEdit_Callback(hObject,event,handles)
function axisAngleEdit_Callback(hObject,event,handles)

% --- Executes on button press in shootMethod.
function shootMethod_Callback(hObject, eventdata, handles)
% Sets visibilities of various field to on/off depending on whether or not
% the shooting method is to be implemented
shootValue = get(hObject,'Value'); % Determining whether the box is checked or not
is3D = get(handles.toggle3d1,'Value'); % Determining if the toggle is set to 3D
if shootValue
    % Setting angle texts and input boxes to invisible (as well as moving
    % drone checkbox in 3D case) as the shooting method will be used
    set(handles.launchAngleText,'Visible','off');
    set(handles.launchAngleEdit,'Visible','off');
    set(handles.axisAngleText,'Visible','off');
    set(handles.axisAngleEdit,'Visible','off');
    if is3D
        set(handles.moveDroneCheck,'Visible','off');
    end
else
    set(handles.launchAngleText,'Visible','on');
    set(handles.launchAngleEdit,'Visible','on');
    if is3D
        set(handles.axisAngleText,'Visible','on');
        set(handles.axisAngleEdit,'Visible','on');
        set(handles.moveDroneCheck,'Visible','on');
    end
end

% --- Executes on button press in moveDroneCheck.
function moveDroneCheck_Callback(hObject, eventdata, handles)

% --- Executes on button press in toggle2d.
function toggle2d_Callback(hObject, eventdata, handles)
% Sets the visibilities of relevant field and irrelevant fields to on and
% off respectively when 2D toggle is pressed down

shootValue = get(handles.shootMethod,'Value');
toggleValue = get(hObject,'Value'); % Boolean representing whether or not the toggle is pressed (toggle state)
if toggleValue % Executes if toggle state is 1
    set(handles.clearButton,'UserData',0); % Clears the axes
    cla(handles.axes2d,'reset'); % Resets the axes
    set(handles.xCor3DText,'Visible','off'); % Sets the visibility of the 3D x-coordinate text to off
    set(handles.yCor3DText,'Visible','off'); % Sets the visibility of the 3D y-coordinate text to off
    set(handles.zCorText,'Visible','off'); % Sets the visibility of the 3D z-coordinate text to off
    set(handles.xCor3DEdit,'Visible','off'); % Sets the visibility of the 3D x-coordinate editable field to off
    set(handles.yCor3DEdit,'Visible','off'); % Sets the visibility of the 3D y-coordinate editable field to off
    set(handles.zCorEdit,'Visible','off'); % Sets the visibility of the 3D z-coordinate editable field to off
    set(handles.xCor2DText,'Visible','on'); % Sets the visibility of the 2D x-coordinate text to on
    set(handles.yCor2DText,'Visible','on'); % Sets the visibility of the 2D y-coordinate text to on
    set(handles.xCor2DEdit,'Visible','on'); % Sets the visibility of the 2D x-coordinate editable field to on
    set(handles.yCor2DEdit,'Visible','on'); % Sets the visibility of the 2D y-coordinate editable field to on
    set(handles.axisAngleText,'Visible','off'); % Sets the visibility of the axis angle text to off
    set(handles.axisAngleEdit,'Visible','off'); % Sets the visibility of the axis angle editable field to off
    set(handles.wxText,'Visible','off'); % Sets the visibility of the 3D x-windspeed text to off
    set(handles.wyText,'Visible','off'); % Sets the visibility of the 3D y-windspeed text to off
    set(handles.wzText,'Visible','off'); % Sets the visibility of the 3D z-windspeed text to off
    set(handles.wxEdit,'Visible','off'); % Sets the visibility of the 3D x-windspeed editable field to off
    set(handles.wyEdit,'Visible','off'); % Sets the visibility of the 3D y-windspeed editable field to off
    set(handles.wzEdit,'Visible','off'); % Sets the visibility of the 3D z-windspeed editable field to off
    set(handles.windSpeedText,'Visible','off'); % Sets the visibility of the wind speed label to off
    set(handles.moveDroneCheck,'Visible','on'); % Sets the visibility of the moving drone checkbox to on
    set(handles.launchAngleText,'Visible','on'); % Sets the visibility of the launch angle text to on
    set(handles.launchAngleEdit,'Visible','on'); % Sets the visibility of the launch angle editable field to on
    if get(handles.shootMethod,'Value')
        set(handles.shootMethod,'Value',0); % Sets the shooting method checkbox value to 0 (unchecks)
    end
    if get(handles.moveDroneCheck,'Value')
        set(handles.moveDroneCheck,'Value',0); % Sets the moving drone checkbox value to 0 (unchecks)
    end
end

% --- Executes during object creation, after setting all properties.
function toggle3d1_CreateFcn(hObject, eventdata, handles)
% Creates the 3D toggle button

% --- Executes on button press in toggle3d1.
function toggle3d1_Callback(hObject, eventdata, handles)
% Sets the visibilities of relevant field and irrelevant fields to on and
% off respectively when 3D toggle is pressed down

toggleValue = get(hObject,'Value'); % Boolean representing whether or not the toggle is pressed (toggle state)
if toggleValue % Executes if toggle state is 1
    set(handles.clearButton,'UserData',0); % Clears the axes
    cla(handles.axes2d,'reset'); % Resets the axes
    set(handles.xCor3DText,'Visible','on'); % Sets the visibility of the 3D x-coordinate text to on
    set(handles.yCor3DText,'Visible','on'); % Sets the visibility of the 3D y-coordinate text to on
    set(handles.zCorText,'Visible','on'); % Sets the visibility of the 3D z-coordinate text to on
    set(handles.xCor3DEdit,'Visible','on'); % Sets the visibility of the 3D x-coordinate editable field to on
    set(handles.yCor3DEdit,'Visible','on'); % Sets the visibility of the 3D y-coordinate editable field to on
    set(handles.zCorEdit,'Visible','on'); % Sets the visibility of the 3D z-coordinate editable field to on
    set(handles.xCor2DText,'Visible','off'); % Sets the visibility of the 2D x-coordinate text to off
    set(handles.yCor2DText,'Visible','off'); % Sets the visibility of the 2D y-coordinate text to off
    set(handles.xCor2DEdit,'Visible','off'); % Sets the visibility of the 2D x-coordinate editable field to off
    set(handles.yCor2DEdit,'Visible','off'); % Sets the visibility of the 2D y-coordinate editable field to off
    set(handles.axisAngleText,'Visible','on'); % Sets the visibility of the axis angle text to on
    set(handles.axisAngleEdit,'Visible','on'); % Sets the visibility of the axis angle editable field to on
    set(handles.wxText,'Visible','on'); % Sets the visibility of the 3D x-windspeed text to on
    set(handles.wyText,'Visible','on'); % Sets the visibility of the 3D y-windspeed text to on
    set(handles.wzText,'Visible','on'); % Sets the visibility of the 3D z-windspeed text to on
    set(handles.wxEdit,'Visible','on'); % Sets the visibility of the 3D x-windspeed editable field to on
    set(handles.wyEdit,'Visible','on'); % Sets the visibility of the 3D y-windspeed editable field to on
    set(handles.wzEdit,'Visible','on'); % Sets the visibility of the 3D z-windspeed editable field to on
    set(handles.windSpeedText,'Visible','on'); % Sets the visibility of the wind speed label to on
   if get(handles.shootMethod,'Value')
        set(handles.shootMethod,'Value',0); % Sets the shooting method checkbox value to 0 (unchecks)
    end
    if get(handles.moveDroneCheck,'Value')
        set(handles.moveDroneCheck,'Value',0); % Sets the moving drone checkbox value to 0 (unchecks)
    end
    set(handles.launchAngleText,'Visible','on'); % Sets the visibility of the launch angle text to on
    set(handles.launchAngleEdit,'Visible','on'); % Sets the visibility of the launch angle editable field to on
end

% --- Executes during object creation, after setting all properties.
function axes2d_CreateFcn(hObject, eventdata, handles)
% Creates the axes that drone2DPlotter and drone3DPlotter use to plot the
% trajectories of the projectile

% --- Executes on button press in launchButton.
function launchButton_Callback(hObject, eventdata, handles)
% Push button that launches the simulator when pressed (i.e. it either
% calls drone2DPlotter or drone3DPlotter depending on whether the 2D or 3D
% toggle button is pressed down

toggle2 = get(handles.toggle2d, 'Value'); % Gets the value of the 2D toggle button
toggle3 = get(handles.toggle3d1, 'Value'); % Gets the value of the 3D toggle button
checkVal = get(handles.moveDroneCheck, 'Value'); % Determines whether or not checkbox is checked
shootingMethod = get(handles.shootMethod,'Value'); % Determines whether or not the shooting method box is checked
% Determining whether or not the drone should have a speed
if checkVal
    vdx = 5*(rand(1)-rand(1)); % Drone speed in x-direction (m)
    vdy = 5*(rand(1)-rand(1)); % Drone speed in y-direction (m)
    vdu = 5*(rand(1)-rand(1)); % Drone speed in y-direction (m)
else
    vdx = 0;
    vdy = 0;
    vdu = 0;
end

m1 = str2double(get(handles.droneMassEdit,'string')); % Takes the value inputted into the droneMass editable text field and converts it into a double
m2 = str2double(get(handles.projectileMassEdit,'string')); % Takes the value inputted into the projectileMass editable text field and converts it into a double
angle1 = str2double(get(handles.launchAngleEdit,'string')); % Takes the value inputted into the launchAngle editable text field and converts it into a double
vP = str2double(get(handles.projSpeedEdit,'string')); % Takes the value inputted into the projSpeed editable text field and converts it into a double

if toggle2 % This executes if the 2D toggle is pressed down
    set(handles.clearButton,'UserData',1); % Clear button value is set to 1 so the axes don't remain cleared
    x1 = str2double(get(handles.xCor2DEdit,'string')); % Takes the value representing the drone's x-coordinate and converts it into a double
    y1 = str2double(get(handles.yCor2DEdit,'string')); % Takes the value representing the drone's y-coordinate and converts it into a double
    cla(handles.axes2d,'reset'); % Clears the axes before plotting the graph
    axes(handles.axes2d); % States the axes that will be used to plot the graph
    if shootingMethod
        shootingGUI2D(x1,y1,m1,m2,vP,[vdx,vdy]);
    else
        drone2DPlotter(angle1,x1,y1,m1,m2,vP,hObject,handles,vdx,vdy); % Executes this function, which plots the 2D trajectory of the projectile
    end
else % This executes if the 3D toggle is pressed down
    set(handles.clearButton,'UserData',1); % Clear button value is set to 1 so the axes don't remain cleared
    x1 = str2double(get(handles.xCor3DEdit,'string')); % Takes the value representing the drone's x-coordinate and converts it into a double
    y1 = str2double(get(handles.yCor3DEdit,'string')); % Takes the value representing the drone's y-coordinate and converts it into a double
    z1 = str2double(get(handles.zCorEdit,'string')); % Takes the value representing the drone's z-coordinate and converts it into a double
    angle2 = str2double(get(handles.axisAngleEdit,'string')); % Takes the value inputted into the axisAngle editable text field and converts it into a double
    wx = str2double(get(handles.wxEdit,'string')); % Takes the value representing the wind speed in the x-direction and converts it into a double
    wy = str2double(get(handles.wyEdit,'string')); % Takes the value representing the wind speed in the y-direction and converts it into a double
    wz = str2double(get(handles.wzEdit,'string')); % Takes the value representing the wind speed in the z-direction and converts it into a double
    cla(handles.axes2d,'reset'); % Clears the axes before plotting the graph
    axes(handles.axes2d); % States the axes that will be used to plot the graph
    if shootingMethod
        shootingGUI3D(x1,y1,z1,m1,m2,vP,[wx,wy,wz],[vdx,vdy,vdy]);
    else
        drone3DPlotter(angle1,angle2,x1,y1,z1,m1,m2,vP,[wx,wy,wz],hObject,handles,vdx,vdy,vdu); % Executes this function, which plots the 3D trajectory of the projectile
    end
end

% --- Executes on button press in clearButton.
function clearButton_Callback(hObject, eventdata, handles)
% Clears the axes and ends the execution of drone2DPlotter and
% drone3DPlotter when pressed
set(hObject,'UserData',0); % Sets the inherent value of 'UserData' to 0
cla(handles.axes2d,'reset'); % Clears and resets the axes

% --- Executes during object creation, after setting all properties.
function clearButton_CreateFcn(hObject, eventdata, handles)
% Creates the push botton labeled as 'CLEAR'
set(hObject,'UserData',1); % Initializes the inherent value 'UserData' as 1

% --- Executes on button press in pushExit.
function pushExit_Callback(hObject, eventdata, handles)
% Clears the axes by setting the clear button value to 0 when the button is
% pressed and then closes the GUI
set(handles.clearButton,'UserData','0'); % Setting the value of the clear button to 0 to clear the axes
close(launchGUI); % Closing the GUI

% Function that plots the two-dimensional trajectory of the projectile
function drone2DPlotter(alpha, x1, y1, m1, m2, vP, hObject, handles, vdx, vdy)
% The function takes in inputs of alpha (launch angle), x1 (horizontal
% position of drone), y1 (vertical position of drone), m1 (mass of drone),
% m2 (mass of projectile), vP (projectile launch speed), handles, and vdx
% and vdy (drone speeds) and uses these inputs to plot the 2D trajectory of
% the projectile or/and the drone frame by frame.

% Setting the initial conditions
angle = alpha; % Launch angle (deg)
dt = 0.001; % Time step (s)
z(1,:) = 0; % Initial horizontal position of the projectile (m)
z(2,:) = vP*(cosd(angle)); % Horizontal launch velocity of the projectile (m/s)
z(3,:) = 1; % Initial vertical position of the projectile (m)
z(4,:) = vP*(sind(angle)); % Vertical launch velocity of the projectile (m/s)

d(1,:) = x1; % Horizontal position of the drone
d(2,:) = y1; % Vertical position of the drone

hasBeen = false; % Boolean that states whether or not parachute has been deployed
cond = 0; % Variable that is 0 if parachute is undeployed, 1 if the parachute is deployed due to the drone, and 2 if it deploys due to the sensor

tp = 0.000000001; % Pause time
orange = 1/255*[255,140,0]; % Creating a marker color
n=1; % Counter value for while loop starts at 1

% Continue stepping until the projectile lands on the ground or if the
% clear button value is changed from 1 to 0
while z(3,n) >= 0 && get(handles.clearButton,'UserData')
    
    % Plotting a graph of horizontal and vertical projectile displacement
    k = plot(z(1,n), z(3,n),'.r'); % Plots the specific point on the graph 
    
    grid on;
    
    % Creating the labels for the graph
    xlabel('Horizontal Displacement (m)');
    ylabel('Vertical Displacement (m)');
    
    hold on
    
    % Plotting the launcher location on the graph
    scatter(0,1,70,'g*'); % Projectile launcher location
    
    if n == 1
        % Plotting the initial location of the drone on the graph
        scatter(d(1,n),d(2,n),70,'bp'); % Drone location
    end
    
    % Plotting the drone movement path
    plot(d(1,n),d(2,n),'.b');
    
    pause(tp); % Pausing for time tp 
    
    dist = sign(d(2,n)-z(3,n))*sqrt((d(1,n)-z(1,n))^2 + (d(2,n)-z(3,n))^2); % Distance between projectile and drone
    % note: distance is negative if the y-displacement of the projectile is
    % higher than the y-position of the drone, and positive if the
    % y-displacement is lower than the y-position of the drone
    
    % Checking to see if the projectile is within range of the drone and
    % that the parachute has yet to be deployed
    if abs(dist) <= 1 && ~hasBeen  
        cond = 1; % Set condition to 1
        hasBeen = true; % Parachute has been deployed -> hasBeen is true
        scatter(z(1,n),z(3,n),20,'MarkerFaceColor',orange,'MarkerEdgeColor',orange,'Marker','d'); % Plotting the position of parachute deployment
        dronePos = n;
    end
    
    % Checking to see if the parachute has already been deployed
    if ~hasBeen && n > 1 
        % Checking if the vertical displacement of the projectile is
        % downwards and if the y-displacement of the projectile is smaller
        % than 5 meters
        if z(3,n) < z(3,n-1) && z(3,n) <= 5
            cond = 2; % Set condition to 2
            hasBeen = true; % Parachute has been deployed -> hasBeen is true
            scatter(z(1,n),z(3,n),20,'MarkerFaceColor',orange,'MarkerEdgeColor',orange,'Marker','d'); % Plotting the position of parachute deployment
        end
    end
    
    % Apply Runge-Kutta 4 method for one time step
    z(:,n+1) = stepRungeKutta(z(:,n), dt, cond, m1, m2);
    
    % Updating the displacement of the drone in the horizontal and vertical
    % directions after one time step
    d(1,n+1) = d(1,n) + vdx*dt; % x-position of the drone (m)
    d(2,n+1) = d(2,n) + vdy*dt; % y-position of the drone (m)
    
    % Increase the counter value by 1
    n = n+1;
    
    % Pausing for 0.01 seconds to allow any button value changes to take
    % effect before the loop continues
    pause(0.01);
end

% If the clear button was pressed to end the loop, the ground impact location should
% not be plotted
if get(handles.clearButton,'UserData')
    % Plotting the ground impact location
    scatter(z(1,end),0,20,'mo','filled'); % Ground impact location
    % Plotting final drone location depending on whether or not the drone
    % has been intercepted
    if cond == 1
        scatter(d(1,dronePos),d(2,dronePos),70,'gp','filled');
    else
        scatter(d(1,end),d(2,end),70,'rp','filled');
    end
end

% Function that plots the three-dimensional trajectory of the projectile
function drone3DPlotter(alpha, beta, x1, y1, u1, m1, m2, vP, vW, hObject, handles, vdx, vdy, vdu)
% The function takes in inputs of alpha (launch angle), beta (initial axis
% angle), x1 (x-position of the drone), y1 (y-position of the drone), u1
% (z-location of the drone), m1 (mass of the drone), m2 (mass of the
% projectile), vP ([projectile launch speed), vW (a vector containing
% the wind speeds in three directions), handles, and vdx, vdy and vdu
% (drone speeds) and uses these inputs to plot the 3D trajectory of the
% projectile or/and drone frame by frame. 

% Setting the initial conditions
dt = 0.01; % Time step (s)
z(1,:) = 0; % Initial x-position (m)
z(2,:) = vP*cosd(alpha)*cosd(beta); % Launch x-velocity of the projectile(m/s)
z(3,:) = 1; % Initial y-position of the projectile (m)
z(4,:) = vP*sind(alpha); % Launch y-velocity of the projectile (m/s)
z(5,:) = 0; % Initial z-position of the projectile (m)
z(6,:) = vP*cosd(alpha)*sind(beta); % Launch z-velocity of the projectile(m/s)

d(1,:) = x1; % Initial x-position of the drone (m)
d(2,:) = y1; % Initial y-position of the drone (m)
d(3,:) = u1; % Initial z-position of the drone (m) (u is used rather than z as the state variables are represented by z)

hasBeen = false; % Boolean that states whether or not parachute has been deployed
cond = 0; % Variable that is 0 if parachute is undeployed, 1 if the parachute is deployed due to the drone, and 2 if it deploys due to the sensor

tp = 0.000000001; % Pause time
orange = 1/255*[255,140,0]; % Creating a marker color
n=1; % Counter value for while loop starts at 1

% Continue stepping until the projectile lands on the ground or if the
% clear button value is changed from 1 to 0
while z(3,n) >= 0 && get(handles.clearButton,'UserData')
    
    % Plotting a graph of x, y and z projectile displacements
    k = plot3(z(5,n), z(1,n), z(3,n),'.r');
    set(k,'LineWidth',2);
    
    grid on;
    
    % Labeling the axes of the graph
    xlabel('z-Displacement (m)');
    ylabel('x-Displacement (m)');
    zlabel('y-Displacement (m)');
    
    hold on;
    
    % Plotting the location of the launcher on the graph
    scatter3(0,0,1,70,'g*'); % Projectile launcher location
    
    % Plotting the initial location of the drone on the graph
    if n == 1
        scatter3(d(3,n),d(1,n),d(2,n),70,'bp'); % Initial drone location
    end
    
    % Plotting the drone movement path
    plot3(d(3,n),d(1,n),d(2,n),'.b');
    
    pause(tp); % Pausing for time tp
    
    dist = sign(d(2,n)-z(3,n))*sqrt((d(1,n)-z(1,n))^2 + (d(2,n)-z(3,n))^2 + (d(3,n) - z(5,n))^2); % Distance between projectile and drone (m)
    % note: distance is negative if the y-displacement of the projectile is
    % higher than the y-position of the drone, and positive if the
    % y-displacement is lower than the y-position of the drone
    
    % Checking to see if the projectile is within range of the drone and
    % that the parachute has yet to be deployed
    if abs(dist) <= 1 && ~hasBeen
        cond = 1; % Set condition to 1
        hasBeen = true; % Parachute has been deployed -> hasBeen is true
        scatter3(z(5,n),z(1,n),z(3,n),50,'MarkerFaceColor',orange,'MarkerEdgeColor',orange,'Marker','d') % Plotting the position of parachute deployment
        dronePos = n;
    end
    
    % Checking to see if the parachute has already been deployed
    if ~hasBeen && n > 1 
        % Checking if the vertical displacement of the projectile is
        % downwards and if the y-displacement of the projectile is smaller
        % than 5 meters
        if z(3,n) < z(3,n-1) && z(3,n) <= 5
            cond = 2; % Set condition to 2
            hasBeen = 1; % Parachute has been deployed -> hasBeen is true
            scatter3(z(5,n),z(1,n),z(3,n),50,'MarkerFaceColor',orange,'MarkerEdgeColor',orange,'Marker','d') % Plotting the position of parachute deployment
        end
    end
    
    % Apply Runge-Kutta 4 method for one time step
    z(:,n+1) = stepRungeKutta3D(z(:,n), dt, cond, m1, m2, vW);
    
    % Updating the displacement of the drone in all three directions after
    % one time step
    d(1,n+1) = d(1,n) + vdx*dt; % x-position of the drone
    d(2,n+1) = d(2,n) + vdy*dt; % y-position of the drone
    d(3,n+1) = d(3,n) + vdu*dt; % z-position of the drone
    
    % Increase the counter value by 1
    n = n+1;
    
    % Pausing for 0.01 seconds to allow any button value changes to take
    % effect before the loop continues
    pause(0.01);
    
end

% If the clear button was pressed to end the loop, the ground impact location should
% not be plotted
if get(handles.clearButton,'UserData')
    % Plotting the ground impact location
    scatter3(z(5,end),z(1,end),0,50,'mo','filled'); % Ground impact location
    if cond == 1
        scatter3(d(3,dronePos),d(1,dronePos),d(2,dronePos),70,'gp','filled');
    else
        scatter(d(3,end),d(1,end),d(2,end),70,'rp','filled');
    end
end
