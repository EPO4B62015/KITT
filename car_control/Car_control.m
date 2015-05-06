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

% Last Modified by GUIDE v2.5 06-May-2015 16:52:26

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

%Init timer

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
disp(comport);


% --- Executes on button press in wasdToggle.
function wasdToggle_Callback(hObject, eventdata, handles)
% hObject    handle to wasdToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of wasdToggle



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
parent = get(hObject, 'Parent')
distaceToTravel = findobj(parent, 'Tag', 'distanceToTravel');
disp(distaceToTravel.String);
%[t1, t2] = intersect_time(distaceToTravel.String); %Voor de gewenste
%afstand de acceleratie en deceleratie tijden uitreken
t2 = [1;2];
timer = timer_functies(t2(1), t2(2));
start(timer)

% --- Executes on button press in Start_challengeB.
function Start_challengeB_Callback(hObject, eventdata, handles)
% hObject    handle to Start_challengeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
parent = get(hObject, 'Parent')
distance_b = findobj(parent, 'Tag', 'distance_b');
disp(distance_b.String);
