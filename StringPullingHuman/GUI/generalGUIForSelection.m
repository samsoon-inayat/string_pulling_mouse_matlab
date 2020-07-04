function varargout = generalGUIForSelection(varargin)
%GENERALGUIFORSELECTION M-file for generalGUIForSelection.fig
%      GENERALGUIFORSELECTION, by itself, creates a new GENERALGUIFORSELECTION or raises the existing
%      singleton*.
%
%      H = GENERALGUIFORSELECTION returns the handle to a new GENERALGUIFORSELECTION or the handle to
%      the existing singleton*.
%
%      GENERALGUIFORSELECTION('Property','Value',...) creates a new GENERALGUIFORSELECTION using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to generalGUIForSelection_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GENERALGUIFORSELECTION('CALLBACK') and GENERALGUIFORSELECTION('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GENERALGUIFORSELECTION.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help generalGUIForSelection

% Last Modified by GUIDE v2.5 10-Jul-2013 10:39:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @generalGUIForSelection_OpeningFcn, ...
                   'gui_OutputFcn',  @generalGUIForSelection_OutputFcn, ...
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


% --- Executes just before generalGUIForSelection is made visible.
function generalGUIForSelection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

set(handles.listbox,'String',varargin{1});
if nargin == 2
    set(handles.listbox,'Max',1);
end
if nargin == 3
    titleText = varargin{3};
    set(handles.figure1,'title',titleText);
end


set(handles.figure1,'WindowStyle','modal');
set(handles.figure1,'CloseRequestFcn',@my_closereq);

% Choose default command line output for generalGUIForSelection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes generalGUIForSelection wait for user response (see UIRESUME)
uiwait(handles.figure1);

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

% --- Outputs from this function are returned to the command line.
function varargout = generalGUIForSelection_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
contentListBox = get(handles.listbox,'String');
if varargout{1} ~= 0
    for ii = 1:length(varargout{1})
        varargout{2}{ii} = contentListBox{varargout{1}(ii)};
    end
else
    varargout{2} = 0;
end
close(hObject);

% --- Executes on selection change in listbox.
function listbox_Callback(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox


% --- Executes during object creation, after setting all properties.
function listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_select.
function pushbutton_select_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = get(handles.listbox,'Value');
handles.output = value;
guidata(handles.figure1,handles);
generalGUIForSelection_OutputFcn(handles.figure1, eventdata, handles);

% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = 0;
guidata(handles.figure1,handles);
generalGUIForSelection_OutputFcn(handles.figure1, eventdata, handles);
