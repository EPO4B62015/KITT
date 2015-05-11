function varargout = Car_control(varargin)
% CAR_CONTROL MATLAB code for Car_control.fig
%      CAR_CONTROL, by itself, creates a new CAR_CONTROL or raises the existing
%      singleton*.
%
%      H = CAR_CONTROL returns the handle to a new CAR_CONTROL or the handle to
%      the existing singleton*.
%
%      CAR_CONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAR_CONTROL.M with the given input arguments.
%
%      CAR_CONTROL('Property','Value',...) creates a new CAR_CONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Car_control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Car_control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Car_control

% Last Modified by GUIDE v2.5 11-May-2015 23:12:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Car_control_OpeningFcn, ...
                   'gui_OutputFcn',  @Car_control_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before Car_control is made visible.
function Car_control_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Car_control (see VARARGIN)

% Choose default command line output for Car_control
handles.output = hObject;

%Init popupMenu
popupComMenu = findobj(get(hObject, 'Children'), 'Tag', 'comMenu');
serialInfo = instrhwinfo('serial');
popupComMenu.String = serialInfo.AvailableSerialPorts;
handles.comPorts = serialInfo.AvailableSerialPorts;
handles.comMenuValue = 1;

%Init wasd
handles.speed = 150;
handles.dir = 150;
handles.wPressed = 0;
handles.aPressed = 0;
handles.dPressed = 0;
handles.sPressed = 0;

%Init timer

%init meting
global metingen
metingen = [0 0 0 0 0 0 0 0 0]; 
global position
position = 1;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Car_control wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Car_control_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in comMenu.
function comMenu_Callback(hObject, eventdata, handles)
% hObject    handle to comMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns comMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comMenu


% --- Executes during object creation, after setting all properties.
function comMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in connectButton.
function connectButton_Callback(hObject, eventdata, handles)
% hObject    handle to connectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
parent = get(hObject, 'Parent');
popupMenu = findobj(parent, 'Tag', 'comMenu');
comport = strcat('\\.\' ,popupMenu.String(popupMenu.Value) );
EPOCommunications('close'); 
result = EPOCommunications('open', comport);
if(result == 1)
    status = EPOCommunications('transmit', 'S'); 
    EPOCommunications('transmit','A1');
    hObject.String = 'Connected...';
    hObject.Enable = 'off';
end
disp(comport);


function distanceToTravel_Callback(hObject, eventdata, handles)
% hObject    handle to distanceToTravel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of distanceToTravel as text
%        str2double(get(hObject,'String')) returns contents of distanceToTravel as a double


% --- Executes during object creation, after setting all properties.
function distanceToTravel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distanceToTravel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in goButton.
function goButton_Callback(hObject, eventdata, handles)
% hObject    handle to goButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global metingen
global position
metingen = [metingen; 0 0 0 0 0 0 0 0 0];
position = position + 1;
parent = get(hObject, 'Parent');
distanceToTravel = findobj(parent, 'Tag', 'distanceToTravel');
disp(distanceToTravel.String);
distance_A = str2num(distanceToTravel.String);
[t1, t2] = intersect_time(distance_A); %Voor de gewenste
%afstand de acceleratie en deceleratie tijden uitreken
t_intersect = t2;
metingen(position, 1) = t_intersect(1);
metingen(position, 2) = t_intersect(2);
metingen(position, 8) = distance_A;
timer = timer_functies(t_intersect(1), t_intersect(2));
disp('Tijden ingevoerd');
disp(t_intersect);
start(timer);

% --- Executes on button press in midterm_3_meter.
function midterm_3_meter_Callback(hObject, eventdata, handles)
% hObject    handle to midterm_3_meter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
distance_b = findobj(hObject.Parent.Children, 'Tag', 'distanceToStop');
disp('Distance to stop is ');
disp(distance_b.String);
%Status opvragen
%Distance tot muur uitrekenen
%Als de sensoren een afstand terug geven van onder de 3 meter dan prac a
%toepassen anders b toepassen.
afstand_tot_muur = data_distance(tic);
if(afstand_tot_muur(1) ~= 999 && afstand_tot_muur(2) ~= 999)
    stop_afstand = str2num(distance_b.String);
    %We willen iets voor de gewenste afstand bijna stilstaan zodat we
    %met een lagere snelheid het punt kunnen benaderen
    rij_afstand = (afstand_tot_muur(1) + afstand_tot_muur(2))/2 - stop_afstand - 20; 
    
    [acc_tijd,rem_tijd] = rem_acc_tijd(rij_afstand);

    %De remtijd moet dus iets korter zijn dan berekend omdat de auto niet
    %geheel stil moet staan.
    rem_tijd = rem_tijd - (1/6*rem_tijd) %t_d is de remtijd
    t = midterm_challenge3(acc_tijd, rem_tijd);
    start(t);
elseif(afstand_tot_muur(1) ~= 999 || afstand_tot_muur(2) ~= 999)
    %opnieuw status opvragen
else
    %buiten sensor range starten
    t = midterm_challenge2;
    start(t);
end


% --- Executes on button press in wasdCheck.
function wasdCheck_Callback(hObject, eventdata, handles)
% hObject    handle to wasdCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of wasdCheck
disp(hObject.Value);


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
check = findobj(hObject, 'Tag', 'wasdCheck');
disp('Keypressed');
if(check.Value > 0)
switch eventdata.Key
    case 'w'
        if (handles.wPressed == 0)
        handles.speed = 160;
        drive(handles.speed, handles.dir)
        handles.wPressed = 1;
        else
        a = exist('statusd')
        if (a == 0)
            statusd = [0 0 0 0 0 0]
        end
        statusd = data(statusd);
        end
    case 's'
        if (handles.sPressed == 0)
        handles.speed = 140;
        drive(handles.speed, handles.dir)
        handles.sPressed = 1;
        else
        a = exist('statusd')
        if (a == 0)
            statusd = [0 0 0 0 0 0]
        end
        statusd = data(statusd);
        end
    case 'd'
        if (handles.dPressed == 0)
        handles.dir = 120;
        drive(handles.speed, handles.dir)
        handles.dPressed = 1;
        else
            
        end
    case 'a'
        if (handles.aPressed == 0)
        handles.dir = 180;
        drive(handles.speed, handles.dir)     
        handles.aPressed = 1;
        else
            
        end
    case 'escape'
        stop_car
    case 'space'
        stop_car
end
end
%Update structure
guidata(hObject, handles);


% --- Executes on key release with focus on figure1 and none of its controls.
function figure1_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
check = findobj(hObject, 'Tag', 'wasdCheck');
if(check.Value > 0)
switch eventdata.Key
    case 'w'
        disp('Key is released')
        drive(140, handles.dir);
        drive(150, handles.dir);
        handles.speed = 150;
        handles.wPressed = 0;

    case 's'
        disp('Key is released')
        drive(160, handles.dir);
        drive(150, handles.dir);
        handles.speed = 150;
        handles.sPressed = 0;
    case 'd'
        disp('Key is released')
       handles.dir = 150;
       handles.dPressed = 0;
       drive(handles.speed, handles.dir)
    case 'a'
        disp('Key is released')
        handles.dir = 150;
        handles.aPressed = 0;
        drive(handles.speed, handles.dir)
end
end
%Update structure
guidata(hObject, handles);


% --- Executes on button press in abortButton.
function abortButton_Callback(hObject, eventdata, handles)
% hObject    handle to abortButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t
t = timer_test(findobj(hObject.Parent, 'Tag', 'wasdCheck'));
start(t);
disp(hObject.Value);




% --- Executes on button press in midterm_5_meter.
function midterm_5_meter_Callback(hObject, eventdata, handles)
% hObject    handle to midterm_5_meter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function prac_b_distance_Callback(hObject, eventdata, handles)
% hObject    handle to prac_b_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prac_b_distance as text
%        str2double(get(hObject,'String')) returns contents of prac_b_distance as a double


% --- Executes during object creation, after setting all properties.
function prac_b_distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prac_b_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in prac_b_start.
function prac_b_start_Callback(hObject, eventdata, handles)
% hObject    handle to prac_b_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
