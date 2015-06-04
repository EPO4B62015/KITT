function varargout = Grid(varargin)
% GRID MATLAB code for Grid.fig
%      GRID, by itself, creates a new GRID or raises the existing
%      singleton*.
%
%      H = GRID returns the handle to a new GRID or the handle to
%      the existing singleton*.
%
%      GRID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRID.M with the given input arguments.
%
%      GRID('Property','Value',...) creates a new GRID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Grid_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Grid_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Grid

% Last Modified by GUIDE v2.5 03-Jun-2015 21:37:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Grid_OpeningFcn, ...
                   'gui_OutputFcn',  @Grid_OutputFcn, ...
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


% --- Executes just before Grid is made visible.
function Grid_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Grid (see VARARGIN)

% Choose default command line output for Grid
handles.output = hObject;

handles.x = 0; %Initialise position vectors
handles.y = 0;
grid on;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Grid wait for user response (see UIRESUME)
% uiwait(handles.Car_grid);


% --- Outputs from this function are returned to the command line.
function varargout = Grid_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = handles.x;
y = handles.y;
scatter(x,y);
global fig_handle2;
fig_handle = findobj(hObject.Parent.Children, 'Tag', 'pushbutton1');
fig_handle2 = fig_handle;

