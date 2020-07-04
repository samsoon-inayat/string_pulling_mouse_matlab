function varargout = genericGUIForChangingPropValues(varargin)
% GENERICGUIFORCHANGINGPROPVALUES MATLAB code for genericGUIForChangingPropValues.fig
%      GENERICGUIFORCHANGINGPROPVALUES, by itself, creates a new GENERICGUIFORCHANGINGPROPVALUES or raises the existing
%      singleton*.
%
%      H = GENERICGUIFORCHANGINGPROPVALUES returns the handle to a new GENERICGUIFORCHANGINGPROPVALUES or the handle to
%      the existing singleton*.
%
%      GENERICGUIFORCHANGINGPROPVALUES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENERICGUIFORCHANGINGPROPVALUES.M with the given input arguments.
%
%      GENERICGUIFORCHANGINGPROPVALUES('Property','Value',...) creates a new GENERICGUIFORCHANGINGPROPVALUES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before genericGUIForChangingPropValues_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to genericGUIForChangingPropValues_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help genericGUIForChangingPropValues

% Last Modified by GUIDE v2.5 23-Apr-2020 23:33:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @genericGUIForChangingPropValues_OpeningFcn, ...
                   'gui_OutputFcn',  @genericGUIForChangingPropValues_OutputFcn, ...
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


% --- Executes just before genericGUIForChangingPropValues is made visible.
function genericGUIForChangingPropValues_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to genericGUIForChangingPropValues (see VARARGIN)

props = varargin{1};
Name_of_Figure = varargin{2};
set(handles.figure1,'Name',Name_of_Figure);
if nargin > 5
    set(handles.pushbutton_save,'Enable','Off');
end
data = propsToData(props);
set(handles.uitable_main,'data',data);
pause(0.5);
jscroll = findjobj(handles.uitable_main);
jTable = jscroll.getViewport.getView;
jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS)
jTable.repaint()
set(handles.figure1,'WindowStyle','modal');
set(handles.figure1,'CloseRequestFcn',@my_closereq);

% Choose default command line output for genericGUIForChangingPropValues
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes genericGUIForChangingPropValues wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = genericGUIForChangingPropValues_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
close(hObject);

function my_closereq(hObject,evnt)
% User-defined close request function 
% to display a question dialog box 
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end

% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.uitable_main,'data');
handles.output = dataToProps(data);
guidata(handles.figure1,handles);
genericGUIForChangingPropValues_OutputFcn(handles.figure1, eventdata, handles);

% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = 0;
guidata(handles.figure1,handles);
genericGUIForChangingPropValues_OutputFcn(handles.figure1, eventdata, handles);


function data = propsToData(props)
fields = fieldnames(props);
data = cell(length(fields),2);
for ii = 1:length(fields)
    cmdTxt = sprintf('data{ii,1} = ''%s'';',fields{ii});
    eval(cmdTxt);
    cmdTxt = sprintf('data{ii,2} = props.%s;',fields{ii});
    eval(cmdTxt);
end

function props = dataToProps(data)
for ii = 1:size(data,1)
    cmdTxt = sprintf('props.%s = data{ii,2};',data{ii,1});
    eval(cmdTxt);
end
