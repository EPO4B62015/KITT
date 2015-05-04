function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 24-Apr-2015 10:24:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;
handles.speed = 150;
handles.dir = 150;
handles.busyw = 0;
handles.busya = 0;
handles.busyd = 0;
handles.busys = 0;
% Update handles structure
guidata(hObject, handles);

%Maak verbinding met de auto
%comport = '\\.\COM7' %Com poort verschilt Bluetooth Module: 3215
%EPOCommunications('close');
%result = EPOCommunications('open', comport);
%status = EPOCommunications('transmit', 'S');
%EPOCommunications('transmit','A1') %GELUID UIT

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in panic.
function panic_Callback(hObject, eventdata, handles)
% hObject    handle to panic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop_car


% --- Executes on button press in w.
function w_Callback(hObject, eventdata, handles)
% hObject    handle to w (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
speed = 160
dir = 150
drive(speed, dir)



% --- Executes on button press in a.
function a_Callback(hObject, eventdata, handles)
% hObject    handle to a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
speed = 160
dir = 200
drive(speed, dir)


% --- Executes on button press in s.
function s_Callback(hObject, eventdata, handles)
% hObject    handle to s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
speed = 140
dir = 150
drive(speed, dir)

% --- Executes on button press in d.
function d_Callback(hObject, eventdata, handles)
% hObject    handle to d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
speed = 160
dir = 200
drive(speed, dir)

% --- Executes on key press with focus on panic and none of its controls.
function panic_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to panic (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles) %Knoppen linken aan functies
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

switch eventdata.Key
    case 'w'
        if (handles.busyw == 0)
        handles.speed = 160;
        drive(handles.speed, handles.dir)
        handles.busyw = 1;
        else
        a = exist('statusd')
        if (a == 0)
            statusd = [0 0 0 0 0 0]
        end
        statusd = data(statusd);
        end
    case 's'
        if (handles.busys == 0)
        handles.speed = 140;
        drive(handles.speed, handles.dir)
        handles.busys = 1;
        else
        a = exist('statusd')
        if (a == 0)
            statusd = [0 0 0 0 0 0]
        end
        statusd = data(statusd);
        end
    case 'd'
        if (handles.busyd == 0)
        handles.dir = 120;
        drive(handles.speed, handles.dir)
        handles.busyd = 1;
        else
            
        end
    case 'a'
        if (handles.busya == 0)
        handles.dir = 180;
        drive(handles.speed, handles.dir)     
        handles.busya = 1;
        else
            
        end
    case 'escape'
        stop_car
    case 'space'
        stop_car
end
%Update structure
guidata(hObject, handles);

% --- Executes on key release with focus on figure1 and none of its controls.
function figure1_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)

switch eventdata.Key
    case 'w'
        disp('Key is released')
        drive(140, handles.dir);
        drive(150, handles.dir);
        handles.speed = 150;
        handles.busyw = 0;

    case 's'
        disp('Key is released')
        drive(160, handles.dir);
        drive(150, handles.dir);
        handles.speed = 150;
        handles.busys = 0;
    case 'd'
        disp('Key is released')
       handles.dir = 150;
       handles.busyd = 0;
       drive(handles.speed, handles.dir)
    case 'a'
        disp('Key is released')
        handles.dir = 150;
        handles.busya = 0;
        drive(handles.speed, handles.dir)
end

%Update structure
guidata(hObject, handles);

% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop_car


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run ('Open_com.m');





% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
