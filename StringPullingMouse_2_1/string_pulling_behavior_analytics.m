function varargout = string_pulling_behavior_analytics(varargin)
% STRING_PULLING_BEHAVIOR_ANALYTICS MATLAB code for string_pulling_behavior_analytics.fig
%      STRING_PULLING_BEHAVIOR_ANALYTICS, by itself, creates a new STRING_PULLING_BEHAVIOR_ANALYTICS or raises the existing
%      singleton*.
%
%      H = STRING_PULLING_BEHAVIOR_ANALYTICS returns the handle to a new STRING_PULLING_BEHAVIOR_ANALYTICS or the handle to
%      the existing singleton*.
%
%      STRING_PULLING_BEHAVIOR_ANALYTICS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STRING_PULLING_BEHAVIOR_ANALYTICS.M with the given input arguments.
%
%      STRING_PULLING_BEHAVIOR_ANALYTICS('Property','Value',...) creates a new STRING_PULLING_BEHAVIOR_ANALYTICS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before string_pulling_behavior_analytics_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to string_pulling_behavior_analytics_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help string_pulling_behavior_analytics

% Last Modified by GUIDE v2.5 10-Jan-2019 15:45:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @string_pulling_behavior_analytics_OpeningFcn, ...
                   'gui_OutputFcn',  @string_pulling_behavior_analytics_OutputFcn, ...
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


% --- Executes just before string_pulling_behavior_analytics is made visible.
function string_pulling_behavior_analytics_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to string_pulling_behavior_analytics (see VARARGIN)

% Choose default command line output for string_pulling_behavior_analytics
handles.output = hObject;
% handles.d = varargin{1};
% handles.md = varargin{2};
addpath(genpath(pwd));
enable_disable_1(handles,2,0);
set(handles.pushbutton_fileOpen,'visible','on');
displayMessage(handles,sprintf('Welcome to String Pulling Behavioral Analytics'),{'FontSize',12});
set(hObject,'CloseRequestFcn',@(hObject, event) main_interface_CloseFcn(event, handles));
% guidata(hObject, handles);
% handles.closeFigure = true;


% UIWAIT makes string_pulling_behavior_analytics wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function varargout = main_interface_CloseFcn(eventdata, handles) 
try
    stop(handles.timer_video_loader);
    delete(handles.timer_video_loader);
catch
end

try
    close(handles.disp.ff.hf);figure(10);   
catch
end
close(gcf);
figure(1000);
close(gcf);
closereq;
clearvars -global frames v frameNumber frameTimes masks gradients


% --- Outputs from this function are returned to the command line.
function varargout = string_pulling_behavior_analytics_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% stop(handles.timer_video_loader);
% delete(handles.timer_video_loader);
if isfield(handles,'output')
    varargout{1} = handles.output;
end

function handles = load_file(handles)
disp('Please wait ... I am loading data');
displayMessage(handles,'Please wait ... I am loading data');
[handles.d,handles.md] = dataLoader;
if isempty(handles.d)
    displayMessageBlinking(handles,'Sorry ... could not load',{'ForegroundColor','r'},3);
    return;
end
params = load(handles.md.config_file_name);
set(handles.text_params,'userdata',params);
handles.timer_video_loader = timer('Name','SP_video_loader','Tag','SP_video_loader','BusyMode', 'drop', 'ExecutionMode',...
'fixedRate', 'Period', 0.1, 'TimerFcn', @(hObject, event) timerFunc(event, handles));
handles = initializeDisplay (handles);
d = handles.d;
set(handles.slider1,'value',1, 'min',1, 'max',d.number_of_frames,'SliderStep', [1/d.number_of_frames , 20/d.number_of_frames],'userdata',1);
set(handles.slider_HM,'value',handles.md.resultsMF.colorTol(1,1), 'min',0, 'max',100,'SliderStep', [1/100 , 10/100]);
set(handles.slider_SM,'value',handles.md.resultsMF.colorTol(1,3), 'min',0, 'max',100,'SliderStep', [1/100 , 10/100]);
set(handles.slider_MM,'value',handles.md.resultsMF.colorTol(1,2), 'min',0, 'max',100,'SliderStep', [1/100 , 10/100]);
set(handles.slider_EM,'value',handles.md.resultsMF.colorTol(1,4), 'min',0, 'max',100,'SliderStep', [1/100 , 10/100]);
set(handles.slider_numberOfClusters,'value',3, 'min',1, 'max',7,'SliderStep', [1/6 , 10/100]);
set(handles.edit_handMaskTol,'String',num2str(handles.md.resultsMF.colorTol(1,1)));
set(handles.edit_mouseMaskTol,'String',num2str(handles.md.resultsMF.colorTol(1,2)));
set(handles.edit_stringMaskTol,'String',num2str(handles.md.resultsMF.colorTol(1,3)));
set(handles.edit_earMaskTol,'String',num2str(handles.md.resultsMF.colorTol(1,4)));
set(handles.text_folderName,'String',sprintf('Folder - %s',handles.d.file_path),'FontSize',10);
set(handles.text_fileName,'String',sprintf('File-%s ... loading frame',handles.d.file_name));
set(handles.text_fileName,'userdata',0);
set(handles.text_processing,'userdata',0);
set(handles.text_scale,'String',{'Scale',sprintf('%.3f',handles.md.resultsMF.scale),'mm/pixels'});
set(handles.pushbutton_saveMasks,'Enable','off');
global v;
set(handles.text_fileInfo,'String',sprintf('Video Format: %s %d x %d pixels -- Frame Rate: %.4f fps -- Duration: %.3f s -- Total Frames: %d',v.VideoFormat,handles.md.frameSize(2),handles.md.frameSize(1),v.FrameRate,v.Duration,d.number_of_frames));

temp = getParameter(handles,'Number of Color Clusters');
set(handles.edit_numberOfClusters,'String',num2str(temp));
displayFrames(handles,21);
displayMessage(handles,'Loading will continue in the background!');
displayFrames(handles,1);

function handles = initializeDisplay (handles)
set(handles.figure1,'Name','String Pulling Behavior Analytics');
global frames;
numRs = 4;
numCs = 5;
frns = reshape(1:(numRs*numCs),numCs,numRs)';
ff = makeFigureRowsCols(110,[1 1 11 3],'RowsCols',[numRs numCs],'spaceRowsCols',[0.011 0.0009],'rightUpShifts',[0.03 0.01],'widthHeightAdjustment',[-10 -15]);
set(ff.hf,'WindowButtonMotionFcn',@(hObject, event)dispFigureButtonMotion(event, handles),'Name',fullfile(handles.d.file_path,handles.d.file_name));
set(ff.hf,'WindowButtonUpFcn',@(hObject, event)dispFigureButtonUp(event, handles));
set(ff.hf,'WindowKeyPressFcn',@(hObject, event)dispFigureWindowKeyPressFcn(event, handles));
set(ff.hf,'WindowKeyReleaseFcn',@(hObject, event)dispFigureWindowKeyReleaseFcn(event, handles));
set(ff.hf,'userdata',[0 1 1]);
zw = handles.md.resultsMF.zoomWindow;
if ~isempty(zw)
    set(handles.text_zoomWindow,'String',char(hex2dec('2713')),'ForegroundColor','g');
    tdx = zw(1)+20;
    tdy = zw(2)+20;
    zw1 = [zw(1) zw(2) zw(3)-zw(1)+1 zw(4)-zw(2)+1];
    set(handles.text_zoomWindowSize,'String',sprintf('[%d %d %d %d]',zw1(1),zw1(2),zw1(4),zw1(3)),'userdata',zw1);
else
    set(handles.text_zoomWindow,'String','X','ForegroundColor','r');
    tdx = 50;
    tdy = 70;
end
if ~isempty(handles.md.resultsMF.scale)
    set(handles.text_measure,'String',char(hex2dec('2713')),'ForegroundColor','g');
else
    set(handles.text_measure,'String','X','ForegroundColor','r');
end
for rr = 1:numRs
    for cc = 1:numCs
        axes(ff.h_axes(rr,cc));
        hims(rr,cc) = imagesc(frames{frns(rr,cc)});
        axis equal; axis off;
        set(gca,'XTickLabel',[],'YTickLabel',[],'box','off','XTick',[],'YTick',[]);
        text(tdx,tdy,sprintf('%d',frns(rr,cc)),'fontsize',9);
        if ~isempty(zw)
            xlim([zw(1) zw(3)]);
            ylim([zw(2) zw(4)]);
        end
    end
end

handles.disp.numRs = numRs; handles.disp.numCs = numCs;
handles.disp.ff = ff;
handles.disp.hims = hims;
handles.disp.frns = frns;
handles.epochs.ColumnName = {'Start','Stop'};
populateTable(handles);
checkStatusOfColors(handles);
set(handles.figure1,'userdata',1);
set(handles.text_selected_frame,'String',sprintf('(%d)',1));
displayMasks(handles,1);

function displayFrameWithTags(handles,fn,ha)
if ~exist('ha','var')
    figure(10);clf;
    ha = axes;
end
global frames;
zw = handles.md.resultsMF.zoomWindow;
if ~isempty(zw)
    set(handles.text_zoomWindow,'String',char(hex2dec('2713')),'ForegroundColor','g');
    tdx = zw(1)+20;
    tdy = zw(2)+20;
else
    set(handles.text_zoomWindow,'String','X','ForegroundColor','r');
    tdx = 50;
    tdy = 70;
end
axes(ha)
imagesc(frames{fn});
axis equal; axis off;
plotTags(handles,gca,fn);
text(tdx,tdy,num2str(fn));
if ~isempty(zw)
    xlim([zw(1) zw(3)]);
    ylim([zw(2) zw(4)]);
end

function hf = displayFrameWithTags_F(handles,fn,allCs,ha)
if ~exist('ha','var')
    hf = figure(10);clf;
    ha = axes;
end
global frames;
zw = handles.md.resultsMF.zoomWindow;
if ~isempty(zw)
    set(handles.text_zoomWindow,'String',char(hex2dec('2713')),'ForegroundColor','g');
    tdx = zw(1)+20;
    tdy = zw(2)+20;
else
    set(handles.text_zoomWindow,'String','X','ForegroundColor','r');
    tdx = 50;
    tdy = 70;
end
imagesc(frames{fn});
axis equal; axis off;
plotTags(handles,gca,fn);
text(tdx,tdy,num2str(fn));
if ~isempty(zw)
    xlim([zw(1) zw(3)]);
    ylim([zw(2) zw(4)]);
end
Cs = allCs{2};
if ~isempty(Cs)
    if ~isempty(Cs(1).PixelList)
        xs = Cs(1).PixelList(:,1)+zw(1);
        ys = Cs(1).PixelList(:,2)+zw(2);
        plot(xs,ys,'.','color','c');
    end
    if ~isempty(Cs(2).PixelList)
        xs = Cs(2).PixelList(:,1)+zw(1);
        ys = Cs(2).PixelList(:,2)+zw(2);
        plot(xs,ys,'.','color','m');
    end
end

Cs = allCs{3};
if ~isempty(Cs)
    if strcmp(Cs(1).Hand,'Left Hand')
        CL = Cs(1); CR = Cs(2);
    else
        CL = Cs(2); CR = Cs(1);
    end
    xs = CR.PixelList(:,1)+zw(1);
    ys = CR.PixelList(:,2)+zw(2);
    plot(xs,ys,'.','color','c');
    xs = CL.PixelList(:,1)+zw(1);
    ys = CL.PixelList(:,2)+zw(2);
    plot(xs,ys,'.','color','m');
end

n = 0;




% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% stop(handles.timer_video_loader)
value = round(get(hObject,'Value'));
set(hObject,'userdata',value);
displayFrames(handles,value);
fn = get(handles.figure1,'userdata');
set(handles.text_selected_frame,'String',sprintf('(%d)',fn));
n = 0;

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function timerFunc(event, handles)
global frameNumber;
global frameTimes;
global frames;
global v;
loaded = get(handles.text_fileName,'userdata');
if ~loaded
    if frameNumber < handles.d.number_of_frames
        if hasFrame(v)
            frameNumber = frameNumber + 1;
            frames{frameNumber} = readFrame(v);
            frameTimes(frameNumber) = v.CurrentTime;
%         else
%             set(handles.text_fileName,'userdata',1);
        end
        set(handles.text_fileName,'String',sprintf('File: %s ... loading frame %d/%d',handles.d.file_name,frameNumber,handles.d.number_of_frames));
    else
        disp('Loading of file complete');
        displayMessage(handles,'Loading of file complete');
        set(handles.text_fileName,'String',sprintf('File: %s',handles.d.file_name));
        stop(timerfind('Name','SP_video_loader'));
        set(handles.text_fileName,'userdata',1);
    %     handles.d.number_of_frames = frameNumber - 1;
    %     guidata(handles.figure1, handles);
    end
% else
%     frameNumber = frameNumber + 1;
%     if frameNumber <= handles.d.number_of_frames
%         bdFrames{frameNumber} = frames{frameNumber} - frames{frameNumber-1};
%         fdFrames{frameNumber} = frames{frameNumber-1} - frames{frameNumber};
%         set(handles.text_fileName,'String',sprintf('Finding difference frames %d/%d',frameNumber,handles.d.number_of_frames));
%     else
%         stop(timerfind('Name','SP_video_loader'));
%         set(handles.text_fileName,'String',sprintf('File: %s',handles.d.file_name));
%     end
end

% --- Executes on button press in pushbutton_zoom_window.
function pushbutton_zoom_window_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_zoom_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if strcmp(get(handles.timer_video_loader,'Running'),'on')
%     stop(handles.timer_video_loader);
% end
% fn = round(get(handles.slider1,'Value'));
fn = get(handles.figure1,'userdata');
global frames;
hf = figure(10);
set(hf,'WindowStyle','modal');
imshow(frames{fn});
axis equal; axis off;
try
    hrect = imrect(gca);
    set(hf,'WindowStyle','normal');
catch
    return;
end
if isempty(hrect)
    displayFrames(handles,fn);
    return;
end
pos = round(hrect.getPosition);
close(hf);
left = pos(1);
if left < 0
    left = 1;
end
top = pos(2);
if top < 0
    top = 1;
end
global v;
right = pos(1)+pos(3);
if right > v.Width
    right = v.Width;
end
bottom = pos(2) + pos(4);
if bottom > v.Height
    bottom = v.Height;
end
handles.md.resultsMF.zoomWindow = [left top right bottom];
zw = [left top right-left+1 bottom-top+1];
set(handles.text_zoomWindowSize,'String',sprintf('[%d %d %d %d]',zw(1),zw(2),zw(4),zw(3)),'userdata',zw);
displayFrames(handles,fn);



% --- Executes when selected cell(s) is changed in epochs.
function epochs_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to epochs (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
% stop(handles.timer_video_loader);
data = get(hObject,'Data');
if ~isempty(eventdata.Indices)
    fn = data{eventdata.Indices(1),eventdata.Indices(2)};
    if ~isempty(fn)
        if eventdata.Indices(2) == 2
            fn = fn - 19;
        end
        try
            displayFrames(handles,fn);
        catch
        end
    end
    set(handles.epochs,'userdata',eventdata.Indices);
end

% --------------------------------------------------------------------
function epochs_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to epochs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n=0;

function dispFigureButtonMotion(event,handles)
% stop(handles.timer_video_loader)
% im = getimage(gca);
% figure(10);clf
% imagesc(im);
% start(handles.timer_video_loader);

function dispFigureButtonUp(event,handles)
handles1 = guidata(handles.figure1);
disp = handles1.disp;
uda = get(gcf,'userdata');
ud = uda(1);
buttonType = get(gcf,'SelectionType');
hfn = findall(gca,'Type','Text');
if length(hfn) > 1
    for ii = 1:length(hfn)
        thisT = str2num(hfn(ii).String);
        if isempty(thisT)
            continue;
        else
            fn = thisT;
            break;
        end
    end
else
    fn = str2num(get(hfn(1),'String'));
end
set(gca,'box','on');
% if ud == 1 % ctrl keyboard key
%     temp = handles.md.resultsMF.epochStarts;
% %     if isempty(find(temp == fn))
%         handles.md.resultsMF.epochStarts = [temp;fn];
%         populateTable(handles);
% %     end
% end
% if ud == 2 % alt keyboard key
%     temp = handles.md.resultsMF.epochEnds;
% %     if isempty(find(temp == fn))
%         handles.md.resultsMF.epochEnds = [temp;fn];
%         populateTable(handles);
% %     end
% end
% if ud == 0
    if strcmp(buttonType,'normal')
        if get(handles.checkbox_displayMasks,'Value')
            displayMasks(handles,fn);
        end
        figure(handles.figure1);
    end
    if strcmp(buttonType,'alt')
        manuallyTagHands(handles,fn);
%         displayFrames(handles,fn);
%         figure(handles.figure1);
    end
    if strcmp(buttonType,'open')
        displayFrames(handles,fn);
%         handles1 = guidata(handles.figure1);
%         disp = handles1.disp;
%         fn1 = round(get(handles.slider1,'Value'));
%         [rr,cc] = find((disp.frns-1+fn1) == fn);
%         thisFrame = get(disp.hims(rr,cc),'CData');
%         figure(1000);clf;
%         imagesc(thisFrame);
%         axis equal;
    end
% end
% if ud == 3 % shift keyboard key
%     manuallyTag(handles,fn);
% end
zw = handles.md.resultsMF.zoomWindow;
ffn = round(get(handles.slider1,'Value'));
pfn = get(handles.figure1,'userdata');
frns = ffn-1+reshape(1:(disp.numRs*disp.numCs),disp.numCs,disp.numRs)';
[rr,cc] = find(frns == pfn);
axes(disp.ff.h_axes(rr,cc));
hrect = findall(gca,'Type','Rectangle');
delete(hrect);
[rr,cc] = find(frns == fn);
uda(2) = rr; uda(3) = cc;
set(disp.ff.hf,'userdata',uda);
axes(disp.ff.h_axes(rr,cc));
if ~isempty(zw)
    rectangle('Position',[zw(1),zw(2),zw(3)-zw(1),zw(4)-zw(2)],'linewidth',3);
else
    sz = handles.md.frameSize;
    rectangle('Position',[1,1,sz(2)-1,sz(1)-1],'linewidth',3);
end
set(handles.figure1,'userdata',fn);
set(handles.text_selected_frame,'String',sprintf('(%d)',fn));
if get(handles.checkbox_displayMasks,'Value')
    displayMasks(handles,fn);
end


function dispFigureWindowKeyPressFcn(event,handles)
uda = get(gcf,'userdata');
if strcmp(event.Key,'control')
    uda(1) = 1;
    set(gcf,'userdata',uda);
end
if strcmp(event.Key,'alt')
    uda(1) = 2;
    set(gcf,'userdata',uda);
end
if strcmp(event.Key,'shift')
    uda(1) = 3;
    set(gcf,'userdata',uda);
end
    
function dispFigureWindowKeyReleaseFcn(event,handles)
uda = get(gcf,'userdata');
uda(1) = 0;
set(gcf,'userdata',uda);



% --- Executes on key press with focus on epochs and none of its controls.
function epochs_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to epochs (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'return')
    pause(0.1);
    data = get(handles.epochs,'Data');
    estarts = cell2mat(data(:,1));
    eends = cell2mat(data(:,2));
    handles.md.resultsMF.epochEnds = eends;
    handles.md.resultsMF.epochStarts = estarts;
end


% --- Executes on key release with focus on figure1 or any of its controls.
function figure1_WindowKeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'page-down')
    
end

if strcmp(eventdata.Key,'page-up')
    
end




% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


function selectAndStoreColors(handles,type)
% fn = round(get(handles.slider1,'Value'));
fn = get(handles.figure1,'userdata');
global frames;
zw = handles.md.resultsMF.zoomWindow;
thisFrame = frames{fn};
if fn > 1
    thisFramem1 = frames{fn-1};
end
hf = figure(10);clf;
selCols = @selectPixelsAndGetHSV_1;
types = {'hands','Fur','String','Ears','Hand-String'};
if ~isempty(intersect(type,[1 2 3 4]))
    try
%         set(hf,'WindowStyle','modal');
        if type == 2
            colorVals = selCols(thisFrame,20,handles,types{type});
        end
        if type == 3 || type == 4
            colorVals = selCols(thisFrame,5,handles,types{type});
        end
        if type == 1
            colorVals = selCols(thisFrame,5,handles,types{type});
    %         colorVals = selectPixelsAndGetRGB(thisFrame,5,handles,type);
        end
        colorVals = unique(colorVals,'rows');
        typeParamName = {'Hands Color', 'Fur Color', 'String Color', 'Ear Color'};
        setParameter(handles,typeParamName{type},colorVals);
        handles.md.resultsMF.colors(1,type) = {colorVals};
        if ~isempty(findobj(hf))
            close(hf);
        end
    catch
        handles.md.resultsMF.colors(1,type) = {[]};
        if ~isempty(findobj(hf))
            close(hf);
        end
    end
end
if ~isempty(intersect(type,[101 102 103]))
    thisFrame = thisFrame - thisFramem1;
    try
%         set(hf,'WindowStyle','modal');
        if type == 101
            colorVals = selCols(thisFrame,5,handles,types{1});
        end
        if type == 102
            colorVals = selCols(thisFrame,5,handles,types{2});
        end
        if type == 103
            colorVals = selCols(thisFrame,5,handles,types{end});
    %         colorVals = selectPixelsAndGetRGB(thisFrame,5,handles,type);
        end
        colorVals = unique(colorVals,'rows');
        typeParamName = {'Hands Diff Color', 'String Diff Color', 'Hands-String Diff Color'};
        setParameter(handles,typeParamName{type-100},colorVals);
        handles.md.resultsMF.diffColors(1,type-100) = {colorVals};
        if ~isempty(findobj(hf))
            close(hf);
        end
    catch
        handles.md.resultsMF.diffColors(1,type-100) = {[]};
        if ~isempty(findobj(hf))
            close(hf);
        end
    end
end
checkStatusOfColors(handles);



% --- Executes on button press in pushbutton_selectHandColor.
function pushbutton_selectHandColor_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectHandColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectAndStoreColors(handles,1);

% --- Executes on button press in pushbutton_selectFurColor.
function pushbutton_selectFurColor_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectFurColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectAndStoreColors(handles,2);

% --- Executes on button press in pushbutton_selectStringColor.
function pushbutton_selectStringColor_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectStringColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectAndStoreColors(handles,3);

% --- Executes on button press in pushbutton_help.
function pushbutton_help_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_resetZoom.
function pushbutton_resetZoom_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_resetZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% stop(handles.timer_video_loader)
handles.md.resultsMF.zoomWindow = [];
value = round(get(handles.slider1,'Value'));
displayFrames(handles,value);


% --- Executes on button press in pushbutton_manuallyTag.
function pushbutton_manuallyTag_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_manuallyTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fn = get(handles.figure1,'userdata');
manuallyTag(handles,fn);


function manuallyTag(handles,fn,tag)
if ~exist('tag','var')
    tag = generalGUIForSelection(handles.md.tags,1);
end
if tag == 0
    return;
end
global frames;
thisFrame = frames{fn};
hf = figure(10);clf;
imagesc(thisFrame);
axis equal;
zw = handles.md.resultsMF.zoomWindow;
if ~isempty(zw)
    xlim([zw(1) zw(3)]);
    ylim([zw(2) zw(4)]);
end
set(hf,'WindowStyle','modal');
[x,y] = ginput(1);
set(hf,'WindowStyle','normal');
% close(hf);
saveMR(handles,fn,tag,x,y,1);

% x1 = x-zw(1); y1 = y-zw(2);
% thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
% tMasks = find_masks_1(handles,thisFrame);
% 
% M.R = handles.md.resultsMF.R;
% M.tags = handles.md.tags;
% indexC = strfind(M.tags,'Subject');
% tag = find(not(cellfun('isempty', indexC)));
% Lia = ismember(M.R(:,[1 2]),[fn tag(1)],'rows');
% if ~any(Lia)
%     tags = M.tags;
%     M.zw = handles.md.resultsMF.zoomWindow;
%     M.scale = handles.md.resultsMF.scale;
%     allCs = [];
%     allCs{1} = find_centroids(M,fn,'mouse',tMasks,thisFrame,allCs);
%     allCs{2} = find_centroids(M,fn,'ears',tMasks,thisFrame,allCs);
% 
% 
%     C = allCs{1};
%     indexC = strfind(tags,'Subject');
%     tag = find(not(cellfun('isempty', indexC)));
%     saveMR(handles,fn,tag(1),C.Centroid(1)+zw(1),C.Centroid(2)+zw(2),0);
%     indexC = strfind(tags,'Subject Props');
%     tag = find(not(cellfun('isempty', indexC)));
%     saveMR(handles,fn,tag,C.MajorAxisLength,C.MinorAxisLength,C.Orientation);
%     if length(allCs{2}) > 1
%         C = allCs{2}(2);%find_centroids(M,fn,'Left Ear');
%         if ~isempty(C.Area)
%             x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
%             indexC = strfind(tags,'Left Ear');
%             tag = find(not(cellfun('isempty', indexC)));
%             saveMR(handles,fn,tag,x,y,0);
%         end
%         C = allCs{2}(1); % right ear
%         if ~isempty(C.Area)
%             x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
%             indexC = strfind(tags,'Right Ear');
%             tag = find(not(cellfun('isempty', indexC)));
%             saveMR(handles,fn,tag,x,y,0);
%         end
%     end
% end
% close(hf);
% displayMasks(handles,fn);
fn = round(get(handles.slider1,'Value'));
displayFrames(handles,fn);

% --- Executes on button press in pushbutton_about.
function pushbutton_about_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
About

% --- Executes on button press in checkbox_displayHandTags.
function checkbox_displayHandTags_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_displayHandTags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_displayHandTags


% --- Executes on button press in checkbox_displayBodyAxis.
function checkbox_displayBodyAxis_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_displayBodyAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_displayBodyAxis


% --- Executes on button press in checkbox_displayEarTags.
function checkbox_displayEarTags_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_displayEarTags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_displayEarTags



function processFrames(handles,fn,numFrames)
clc
if get(handles.pushbutton_processThisFrame,'userdata')
    set(handles.pushbutton_processMultipleFrames,'Enable','on');
    set(handles.pushbutton_processEpoch,'Enable','on');
    set(handles.pushbutton_eraseTagsThisFrame,'Enable','on');
    set(handles.pushbutton_eraseAllTags,'Enable','on');
    set(handles.pushbutton_eraseTagsMultipleFrames,'Enable','on');
    set(handles.pushbutton_userProcess,'Enable','on');
    set(handles.pushbutton_processThisFrame,'userdata',0,'String','Process Selected Frame');
    return;
else
    set(handles.pushbutton_processMultipleFrames,'Enable','off');
    set(handles.pushbutton_processEpoch,'Enable','off');
    set(handles.pushbutton_eraseTagsThisFrame,'Enable','off');
    set(handles.pushbutton_eraseAllTags,'Enable','off');
    set(handles.pushbutton_eraseTagsMultipleFrames,'Enable','off');
    set(handles.pushbutton_userProcess,'Enable','off');
    set(handles.pushbutton_processThisFrame,'userdata',1,'String','Stop Processing');
end
global frames;
tags = handles.md.tags;
sfn = fn - 1;
set(handles.text_processing,'String',sprintf('Processing Frame %d',fn));
pause(0.1);
zw = handles.md.resultsMF.zoomWindow;
stopped = 0;
for ii = 1:numFrames
    if ~get(handles.pushbutton_processThisFrame,'userdata')
        stopped = 1;
        break;
    end
    fn = sfn + ii;
    set(handles.text_processing,'userdata',fn);
    
    thisFrame = frames{fn};
    set(handles.text_processing,'String',sprintf('Processing Frame %d',fn));
%     if fn == 1
        allCs = find_all_centroids(handles,fn,thisFrame(zw(2):zw(4),zw(1):zw(3),:));
%     else
%         allCs = find_all_centroids(handles,fn,thisFrame(zw(2):zw(4),zw(1):zw(3),:),thisFramem1(zw(2):zw(4),zw(1):zw(3),:));
%     end
    C = allCs{1};
    if isfield(C,'PixelList')
        indexC = strfind(tags,'Subject');
        tag = find(not(cellfun('isempty', indexC)));
        saveMR(handles,fn,tag(1),C.Centroid(1)+zw(1),C.Centroid(2)+zw(2),0);
        indexC = strfind(tags,'Subject Props');
        tag = find(not(cellfun('isempty', indexC)));
        saveMR(handles,fn,tag,C.MajorAxisLength,C.MinorAxisLength,C.Orientation);
    end
    if length(allCs{2}) > 1
        C = allCs{2}(2);%find_centroids(M,fn,'Left Ear');
        if isfield(C,'PixelList')
            x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
            indexC = strfind(tags,'Left Ear');
            tag = find(not(cellfun('isempty', indexC)));
            saveMR(handles,fn,tag,x,y,C.Area);
            pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
            pixelsI = sub2ind(handles.md.frameSize,pixels(:,2),pixels(:,1));
            saveMP(handles,fn,tag,pixelsI);
        end
        C = allCs{2}(1); % right ear
        if isfield(C,'PixelList')
            x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
            indexC = strfind(tags,'Right Ear');
            tag = find(not(cellfun('isempty', indexC)));
            saveMR(handles,fn,tag,x,y,C.Area);
            pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
            pixelsI = sub2ind(handles.md.frameSize,pixels(:,2),pixels(:,1));
            saveMP(handles,fn,tag,pixelsI);
        end
    end
    if fn > 1
        M.R = handles.md.resultsMF.R;
        M.tags = tags;
        [xl,yl] = getxyFromR(M,fn-1,'Left Hand');
        [xr,yr] = getxyFromR(M,fn-1,'Right Hand');
    else
        xr = []; xl = [];
    end
%     if ~isempty(xr) && ~isempty(xl)
    if ~isempty(allCs{3})
        Cs = allCs{3};%find_centroids(M,fn,'Right Hand_A');
        if strcmp(Cs(1).Hand,'Left Hand')
            C = Cs(1);
        else
            C = Cs(2);
        end
        if ~isempty(C)
            x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
            indexC = strfind(tags,'Left Hand');
            tag = find(not(cellfun('isempty', indexC)));
            saveMR(handles,fn,tag,x,y,C.manual);
            pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
            pixelsI = sub2ind([size(thisFrame,1) size(thisFrame,2)],pixels(:,2),pixels(:,1));
            saveMP(handles,fn,tag,pixelsI);
        end
        % C = find_centroids(M,fn,'Right Hand_A');
        if strcmp(Cs(1).Hand,'Right Hand')
            C = Cs(1);
        else
            C = Cs(2);
        end
        if ~isempty(C)
            x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
            indexC = strfind(tags,'Right Hand');
            tag = find(not(cellfun('isempty', indexC)));
            saveMR(handles,fn,tag,x,y,C.manual);
            pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
            pixelsI = sub2ind([size(thisFrame,1) size(thisFrame,2)],pixels(:,2),pixels(:,1));
            saveMP(handles,fn,tag,pixelsI);
        end
    end
%     hf = displayFrameWithTags_F(handles,fn,allCs);
%     displayMasks(handles,fn,allCs);
    if numFrames > 1 & mod(ii,5) == 0
        displayFrames(handles,sfn+1);
    end
    pause(0.1);
end
if ~stopped
%     displayFrames(handles,sfn+1);
end
set(handles.pushbutton_processMultipleFrames,'Enable','on');
set(handles.pushbutton_processEpoch,'Enable','on');
set(handles.pushbutton_eraseTagsThisFrame,'Enable','on');
set(handles.pushbutton_eraseAllTags,'Enable','on');
set(handles.pushbutton_eraseTagsMultipleFrames,'Enable','on');
set(handles.pushbutton_userProcess,'Enable','on');
set(handles.pushbutton_processThisFrame,'userdata',0,'String','Process Selected Frame');
ht = text(10,10,'Done!','FontSize',50);
pause(1);
delete(ht);
% displayFrames(handles,sfn+1);


% --- Executes on button press in pushbutton_plotSelectedEpoch.
function pushbutton_plotSelectedEpoch_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plotSelectedEpoch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.epochs,'Data');
currentSelection = get(handles.epochs,'userdata');
fn = data{currentSelection};
if isempty(fn)
    return;
end
startEnd = cell2mat(data(currentSelection(1),:));
sfn = startEnd(1);
efn = startEnd(2);
numFrames = startEnd(2)-startEnd(1)+1;

global frames;
times = handles.d.times;
try
    out = get_all_params(handles,sfn,efn,0);
catch
    return;
end
fns = sfn:efn;
ts = times(fns);

aC = out.body.body_fit;
xrs = out.right_hand.centroid(:,1);
yrs = out.right_hand.centroid(:,2);
xls = out.left_hand.centroid(:,1);
yls = out.left_hand.centroid(:,2);
areaRatio_R2L = out.head.head_yaw;
angleV = out.head.head_roll;
bodyAngle = out.body.body_angle;
bodyLength = out.body.body_length;

frame = frames{fns(1)};
zw = handles.md.resultsMF.zoomWindow;
figure(22);clf;
subplot 421
imagesc(frame);
axis equal;
axis off;
hold on;
for ii = 2:length(fns)
%     ii = fns(iii);
    plot([xrs(ii-1) xrs(ii)],[yrs(ii-1) yrs(ii)],'color','c');
    plot([xls(ii-1) xls(ii)],[yls(ii-1) yls(ii)],'color','m');
end
for ii = 1:10:length(fns)
    C = aC(ii);
%     plot(C.Major_axis_xs,C.Major_axis_ys,'g');
%     plot(C.Minor_axis_xs,C.Minor_axis_ys,'g');
    plot(C.Ellipse_xs,C.Ellipse_ys,'g');
end
xlim([zw(1)-50 zw(3)+50]);
ylim([zw(2)-50 zw(4)]);

if get(handles.radiobutton_x_axis_time,'Value')
    ts = times(fns)-times(fns(1));
    xlab = 'Time (sec)';
else
    ts = fns;
    xlab = 'Frames';
end
oxr = xrs(1);
oyr = yrs(1);
distR = handles.md.resultsMF.scale*sqrt((xrs-oxr).^2 + (yrs-oyr).^2);
oxl = xls(1);
oyl = yls(1);
distL = handles.md.resultsMF.scale*sqrt((xls-oxl).^2 + (yls-oyl).^2);
subplot 422
plot(ts,distR,'c','linewidth',1);hold on;
plot(ts,distL,'m','linewidth',1);
set(gca,'FontSize',10,'FontWeight','Normal'); 
xlabel(xlab);
ylabel('Distance (mm)');
speedR = [0 diff(distR')./diff(ts)];
speedL = [0 diff(distL')./diff(ts)];
subplot 423
plot(ts,abs(speedR),'-c','linewidth',1);hold on;
plot(ts,abs(speedL),'-m','linewidth',1);
set(gca,'FontSize',10,'FontWeight','Normal'); 
xlabel(xlab);
ylabel('Speed (mm/s)');

subplot 424
plot(distR,abs(speedR),'*c','linewidth',1);hold on;
plot(distL,abs(speedL),'*m','linewidth',1);
set(gca,'FontSize',10,'FontWeight','Normal'); 
xlabel('Distance (mm)');
ylabel('Speed (mm/s)');

subplot 425
plot(ts,areaRatio_R2L);hold on;
plot(ts,ones(size(areaRatio_R2L)));
set(gca,'FontSize',10,'FontWeight','Normal'); 
xlabel(xlab);
ylabel('Head Yaw (ARE/ALE)');

subplot 426
plot(ts,angleV);hold on;
plot(ts,zeros(size(areaRatio_R2L)));
set(gca,'FontSize',10,'FontWeight','Normal'); 
xlabel(xlab);
ylabel('Head Roll (Angle-Deg)');

subplot 427
plot(ts,bodyLength*handles.md.resultsMF.scale);hold on;
set(gca,'FontSize',10,'FontWeight','Normal'); 
xlabel(xlab);
ylabel('Body Length (mm)');


subplot 428
plot(ts,bodyAngle);hold on;
set(gca,'FontSize',10,'FontWeight','Normal'); 
xlabel(xlab);
ylabel('Body Angle(deg)');




% --- Executes on button press in pushbutton_userPlot.
function pushbutton_userPlot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_userPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
userPlot(handles);


% --- Executes on button press in pushbutton_userProcess.
function pushbutton_userProcess_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_userProcess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
userProcess(handles);
% function findAllMasks(handles,startFrame,endFrame)
% global frames;
% zw = handles.md.resultsMF.zoomWindow;
% totalFrames = endFrame - startFrame + 1;
% h = waitbar(1/totalFrames,'Processing frames');
% for fni = 1:totalFrames
%     fn = startFrame-1+fni;
%     if ~get(hObject,'userdata')
%         break;
%     end
%     fn
%     thisFrame = frames{fn};
%     thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
%     tic
%     tMasks = find_masks(handles,thisFrame);
%     thisT = toc;
%     masksM(:,:,fn) = tMasks.Im;
%     masksH(:,:,fn) = tMasks.Ih;
%     masksS(:,:,fn) = tMasks.Is;
%     timeRemaining = ((thisT * (totalFrames - fni))/60);
%     waitbar(fni/totalFrames,h,sprintf('Processing frames %d/%d... time remaining %.2f minutes',fni,totalFrames,timeRemaining));
% end
% close(h);
% if fni == totalFrames
%     handles.md.preprocessMF.masksM = masksM;
%     handles.md.preprocessMF.masksH = masksH;
%     handles.md.preprocessMF.masksS = masksS;
%     handles.masksM = masksM;
%     handles.masksH = masksH;
%     handles.masksS = masksS;
%     guidata(handles.figure1,handles);
% end

function displayMasks(handles,fn,allCs)
global frames;
zw = handles.md.resultsMF.zoomWindow;
thisFrame = frames{fn};
if isempty(thisFrame)
    return;
end
if ~isempty(zw)
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
end
try
    if get(handles.checkbox_useSimpleMasks,'Value')
        tMasks = find_masks(handles,thisFrame);
    else
        tMasks = get_masks_KNN(handles,fn);
    end
catch Err
%     rethrow(Err);
    display('Could not compute masks ... check if colors are selected for body parts or selected different thresholds');
    return;
end
rows = 2; cols = 3;
hf = figure(1000);clf;
set(hf,'Name','Masks Window');
subplot(rows,cols,1);
imagesc(thisFrame);axis equal;
title(fn);
subplot(rows,cols,2);
imagesc(tMasks.Im);axis equal;
title('Body');
subplot(rows,cols,3);
imagesc(tMasks.Ie);axis equal;
title('Ears');
subplot(rows,cols,4);
imagesc(tMasks.Ih);axis equal;
title('Hands');
try
subplot(rows,cols,5);
imagesc(tMasks.bd);axis equal;
title('Hands B Diff');
subplot(rows,cols,6);
imagesc(tMasks.fd);axis equal;
title('Hands F Diff');
catch
end
% if ~exist('allCs','var')
%     displayFrameWithTags(handles,fn,gca);
% else
%     displayFrameWithTags_F(handles,fn,allCs,gca);
% end
% title('Tags');
set(hf,'userdata',fn);

function displayMasksOnTheGo(handles,fn,thisFrame,tMasks)
rows = 2; cols = 3;
hf = figure(1000);clf;
set(hf,'Name','Masks Window');
subplot(rows,cols,1);
imagesc(thisFrame);axis equal;
title(fn);
subplot(rows,cols,2);
imagesc(tMasks.Im);axis equal;
title(tMasks.ImTitle);
subplot(rows,cols,3);
imagesc(tMasks.Ih);axis equal;
title(tMasks.IhTitle);
subplot(rows,cols,4);
imagesc(tMasks.Is);axis equal;
title(tMasks.IsTitle);
subplot(rows,cols,5);
imagesc(tMasks.Ie);axis equal;
title(tMasks.IeTitle);
% subplot(rows,cols,6);


% --- Executes on button press in pushbutton_selectEarColor.
function pushbutton_selectEarColor_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectEarColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectAndStoreColors(handles,4);


function edit_earMaskTol_Callback(hObject, eventdata, handles)
% hObject    handle to edit_earMaskTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_earMaskTol as text
%        str2double(get(hObject,'String')) returns contents of edit_earMaskTol as a double


% --- Executes during object creation, after setting all properties.
function edit_earMaskTol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_earMaskTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_displayTags.
function checkbox_displayTags_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_displayTags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_displayTags

fn = round(get(handles.slider1,'Value'));
displayFrames(handles,fn);



% --- Executes on button press in checkbox_scaleBar.
function checkbox_scaleBar_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_scaleBar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_scaleBar
if get(hObject,'Value')
    fn = round(get(handles.slider1,'Value'));
    displayFrames(handles,fn);
end

% --- Executes on button press in pushbutton_measure.
function pushbutton_measure_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_measure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if strcmp(get(handles.timer_video_loader,'Running'),'on')
%     stop(handles.timer_video_loader);
% end
fn = round(get(handles.slider1,'Value'));
global frames;
hf = figure(10);
set(hf,'WindowStyle','modal');
imshow(frames{fn});
axis equal; axis off;
tdx = 20;
tdy = 20;
text(tdx,tdy,sprintf('Draw a line on an object of known dimension (by clicking and dragging)'));
hline = imline(gca);
set(hf,'WindowStyle','normal');
if isempty(hline)
    displayFrames(handles,fn);
    return;
end
pos = round(hline.getPosition);
close(hf);
prompt = 'Enter length with units';
title = 'Input Length';
dims = 1;
answer = inputdlg(prompt,title,dims,{'5 mm'});
% left = pos(1,1);
% right = pos(2,1);
diffP = diff(pos,1,1);
% numPixels = right - left;
numPixels = sqrt(sum(diffP.^2));
mm = sscanf(answer{1},'%f');
handles.md.resultsMF.scale = mm/numPixels;
set(handles.text_scale,'String',{'Scale',sprintf('%.3f',handles.md.resultsMF.scale),'mm/pixels'});
displayFrames(handles,fn);
set(handles.figure1,'userdata',fn);




% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_hand.
function text_hand_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text_hand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if get(hObject,'userdata')
%     set(hObject,'userdata',0);
%     set(handles.edit_handMaskTol,'String',num2str(handles.md.resultsMF.colorTol(1,1)));
% else
%     set(hObject,'userdata',1);
%     set(handles.edit_handMaskTol,'String',num2str(handles.md.resultsMF.colorTol(2,1)));
% end
% fn = get(handles.figure1,'userdata');
% displayMasks(handles,fn);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_ear.
function text_ear_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text_ear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if get(hObject,'userdata')
%     set(hObject,'userdata',0);
%     set(handles.edit_earMaskTol,'String',num2str(handles.md.resultsMF.colorTol(1,4)));
% else
%     set(hObject,'userdata',1);
%     set(handles.edit_earMaskTol,'String',num2str(handles.md.resultsMF.colorTol(2,4)));
% end
% fn = get(handles.figure1,'userdata');
% displayMasks(handles,fn);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_string.
function text_string_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if get(hObject,'userdata')
%     set(hObject,'userdata',0);
%     set(handles.edit_stringMaskTol,'String',num2str(handles.md.resultsMF.colorTol(1,3)));
% else
%     set(hObject,'userdata',1);
%     set(handles.edit_stringMaskTol,'String',num2str(handles.md.resultsMF.colorTol(2,3)));
% end
% fn = get(handles.figure1,'userdata');
% displayMasks(handles,fn);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_fur.
function text_fur_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text_fur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if get(hObject,'userdata')
%     set(hObject,'userdata',0);
%     set(handles.edit_mouseMaskTol,'String',num2str(handles.md.resultsMF.colorTol(1,2)));
% else
%     set(hObject,'userdata',1);
%     set(handles.edit_mouseMaskTol,'String',num2str(handles.md.resultsMF.colorTol(2,2)));
% end
% fn = get(handles.figure1,'userdata');
% displayMasks(handles,fn);


% --- Executes on button press in pushbutton_fastPlay.
function pushbutton_fastPlay_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_fastPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Visible','Off');
set(handles.pushbutton_stopPlay,'userdata',0,'Visible','On');
fn = round(get(handles.slider1,'Value'));
figure(1001);clf;
ha = axes;
numFrames = fn+19;%(handles.d.number_of_frames-1);
try
for ii = fn:numFrames
    if get(handles.pushbutton_stopPlay,'userdata')
        break;
    end
    displayFrameWithTags(handles,ii,ha);
    pause(0.1);
end
catch
end
% displayMasks(handles,fn);
set(handles.pushbutton_stopPlay,'Visible','Off');
set(hObject,'Visible','On');


% --- Executes on button press in pushbutton_exportToExcel.
function pushbutton_exportToExcel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_exportToExcel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Please wait ... writing to excel file');
data = get(handles.epochs,'Data');
currentSelection = get(handles.epochs,'userdata');
if isempty(currentSelection)
    displayMessage(handles,'Please select an epoch first');
    return;
end
fn = data{currentSelection};
if isempty(fn)
    return;
end
startEnd = cell2mat(data(currentSelection(1),:));
sfn = startEnd(1);
numFrames = startEnd(2)-startEnd(1)+1;
efn = sfn+numFrames-1;

global frames;
times = handles.d.times;
R = handles.md.resultsMF.R;
tags = handles.md.resultsMF.tags;
fns = fn:numFrames;
indexC = strfind(tags,'Right Hand');
tagR = find(not(cellfun('isempty', indexC)));
indexC = strfind(tags,'Left Hand');
tagL = find(not(cellfun('isempty', indexC)));
indexC = strfind(tags,'Right Ear');
tagER = find(not(cellfun('isempty', indexC)));
indexC = strfind(tags,'Left Ear');
tagEL = find(not(cellfun('isempty', indexC)));
for ii = 1:length(fns)
    try
        ind = ismember(R(:,[1 2]),[fns(ii) tagR],'rows');
        xrs(ii) = R(ind,3);
        yrs(ii) = R(ind,4);
    catch
        xrs(ii) = -1; yrs(ii) = -1;
    end
    try
        ind = ismember(R(:,[1 2]),[fns(ii) tagL],'rows');
        xls(ii) = R(ind,3);
        yls(ii) = R(ind,4);
    catch
        xls(ii) = -1; yls(ii) = -1;
    end
    ind = ismember(R(:,[1 2]),[fns(ii) tagER],'rows');
    if any(ind)
        xers(ii) = R(ind,3);
        yers(ii) = R(ind,4);
        aers(ii) = R(ind,5);
    else
        xers(ii) = -1;
        yers(ii) = -1;
        aers(ii) = -1;
    end
    ind = ismember(R(:,[1 2]),[fns(ii) tagEL],'rows');
    if any(ind)
        xels(ii) = R(ind,3);
        yels(ii) = R(ind,4);
        aels(ii) = R(ind,5);
    else
        xels(ii) = -1;
        yels(ii) = -1;
        aels(ii) = -1;
    end
    
    iii = ismember(R(:,[1 2]),[fns(ii) 8],'rows');
    jj = ismember(R(:,[1 2]),[fns(ii) 7],'rows');
    bcx(ii) = R(jj,3);
    bcy(ii) = R(jj,4);
    ori(ii) = R(iii,5);
    bl(ii) = R(iii,3);
    bw(ii) = R(iii,4);
    if ori(ii) < 0
        ori(ii) = ori(ii) + 180;
    end
%     aC(ii) = getSubjectFit(R(jj,[3 4]),R(iii,3),R(iii,4),R(iii,5));
end
thisTimes = times(fns);
% tFN = sprintf('%s_frame%d_frame%d.xls',handles.d.file_name(1:(end-4)),sfn,efn);
tFN = sprintf('XL_frame%d_frame%d.xls',sfn,efn);
fileName = fullfile(handles.md.processedDataFolder,tFN);
headings = {'Frame Number','Frame Time','Right Hand X','Right Hand Y','Left Hand X','Left Hand Y','Body Centroid X','Body Centroid Y','Body Length','Body Width','Orientation Angle','Right Ear X','Right Ear Y','Right Ear Area','Left Ear X','Left Ear Y','Left Ear Area'};
props = {'FontSize',11,'ForegroundColor','b'};
displayMessage(handles,'Writing to Excel file ... plz wait',props);
pause(0.1);
xlswrite(fileName,headings,1,'A1:Q1');
data = [fns' thisTimes' xrs' yrs' xls' yls' bcx' bcy' bl' bw' ori' xers' yers' aers' xels' yels' aels'];
xlswrite(fileName,data,1,sprintf('A2:Q%d',size(data,1)+1));
n = 0;
disp('Complete!');
props = {'FontSize',12,'ForegroundColor','r'};
displayMessage(handles,sprintf('Hurray !!! Done writing to Excel file ... %s',tFN),props);
winopen(handles.md.processedDataFolder);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_folderName.
function text_folderName_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text_folderName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen(handles.d.file_path);


function uipanel4_ButtonDownFcn(event,handles)
n = 0;


% --- Executes on button press in checkbox_framesDifference.
function checkbox_framesDifference_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_framesDifference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_framesDifference
fn = round(get(handles.slider1,'Value'));
displayFrames(handles,fn);

% --- Executes on button press in pushbutton_selectHandColorDiff.
function pushbutton_selectHandColorDiff_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectHandColorDiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectAndStoreColors(handles,101);

% --- Executes on button press in pushbutton_selectStringColorDiff.
function pushbutton_selectStringColorDiff_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectStringColorDiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectAndStoreColors(handles,102);

% --- Executes on button press in pushbutton_selectHandMinusStringColorDiff.
function pushbutton_selectHandMinusStringColorDiff_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectHandMinusStringColorDiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectAndStoreColors(handles,103);

% --- Executes on button press in pushbutton_selectColorsInDiffHelp.
function pushbutton_selectColorsInDiffHelp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectColorsInDiffHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in uibuttongroup2.
function uibuttongroup2_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup2 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.checkbox_framesDifference,'Value')
    fn = round(get(handles.slider1,'Value'));
    displayFrames(handles,fn);
end


% --- Executes on button press in pushbutton_findAndSaveKnnMasks.
function pushbutton_findAndSaveKnnMasks_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_findAndSaveKnnMasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~strcmp(get(handles.text_fileName,'String'),sprintf('File: %s',handles.d.file_name))
    displayMessageBlinking(handles,'Please wait for completion of file loading',{'ForegroundColor','r'},3);
    return;
end
framesToProcess = get(handles.uibuttongroup_framesToProcess,'userdata');
objectToProcess = get(handles.uibuttongroup_objectToProcess,'userdata');
props = {'FontSize',9,'ForegroundColor','b'};
displayMessage(handles,'',props);
global frames;
switch framesToProcess
    case 1
        sfn = get(handles.figure1,'userdata');
        efn = sfn;
    case 2
        sfn = round(get(handles.slider1,'Value'));
        efn = sfn + 19;
    case 3
        data = get(handles.epochs,'Data');
        currentSelection = get(handles.epochs,'userdata');
        fn = data{currentSelection};
        if isempty(fn)
            displayMessageBlinking(handles,'Select an epoch',{'FontSize',12,'foregroundColor','r'},3);
        end
        startEnd = cell2mat(data(currentSelection(1),:));
        sfn = startEnd(1);
        efn = startEnd(2);
    case 4
        sfn = 1;
        efn = length(frames);
end
enable_disable(handles,0);
set(handles.pushbutton_stop_processing,'visible','on');
try
    switch objectToProcess
        case 1
            find_masks_KNN(handles,'body',sfn,efn);
        case 2
            find_masks_KNN(handles,'ears',sfn,efn);
        case 3
            find_masks_KNN(handles,'hands',sfn,efn);
        case 4
            find_masks_KNN(handles,'all',sfn,efn);
    end
catch
    fn = get(handles.pushbutton_stop_processing,'userdata');
    props = {'FontSize',12,'ForegroundColor','r'};
    displayMessage(handles,sprintf('Sorry :-( ... error occurred in frame %d',fn),props);
end
enable_disable(handles,1);
set(handles.pushbutton_stop_processing,'visible','off');
switch framesToProcess
    case 1
        displayMasks(handles,sfn);
end

% --- Executes on button press in checkbox_useKnnMasks.
function checkbox_useKnnMasks_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_useKnnMasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_useKnnMasks


% --- Executes on button press in pushbutton_makeVideoWithTags.
function pushbutton_makeVideoWithTags_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_makeVideoWithTags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = get(handles.epochs,'Data');
currentSelection = get(handles.epochs,'userdata');
fn = data{currentSelection};
if isempty(fn)
    return;
end
startEnd = cell2mat(data(currentSelection(1),:));
sfn = startEnd(1);
efn = startEnd(2);
numFrames = startEnd(2)-startEnd(1)+1;

opts.Interpreter = 'tex';
opts.Default = 'No';
% Use the TeX interpreter to format the question
quest = sprintf('Do you want to proceed with %d frames, it might take a while',numFrames);
answer = questdlg(quest,'Please select',...
                  'Yes','No',opts);
if strcmp(answer,'No')
    return;
end

global frames;
times = handles.d.times;
out = get_all_params(handles,sfn,efn,1);
fns = sfn:efn;
thisTimes = times(fns);
% 
% ff = makeFigureRowsCols(104,[22 3.5 1.5 3.5],'RowsCols',[1 1],...
%     'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
%     [-150 -400]);
% gg = 1;
% set(gcf,'color','w');
figure(22);clf;
zw = handles.md.resultsMF.zoomWindow;
% zw = zw1 + [150 150 -300 0];
aC = out.body.body_fit;
xrs = out.right_hand.centroid(:,1);
yrs = out.right_hand.centroid(:,2);
xls = out.left_hand.centroid(:,1);
yls = out.left_hand.centroid(:,2);

fileName = [pwd '\video.avi'];
v = VideoWriter(fileName,'Motion JPEG AVI');
open(v);
for ii = 1:length(fns)
    fn = fns(ii);
    frame = frames{fn};
    cla
    imagesc(frame);
    axis equal;
    axis off;
    hold on;
    C = aC(ii);
    plot(C.Major_axis_xs,C.Major_axis_ys,'g');
    plot(C.Minor_axis_xs,C.Minor_axis_ys,'g');
    plot(C.Ellipse_xs,C.Ellipse_ys,'g');
    point = out.right_hand.centroid(ii,:);
    plot(point(1),point(2),'.c','MarkerSize',20);
    
    point = out.left_hand.centroid(ii,:);
    plot(point(1),point(2),'.m','MarkerSize',20);
    
    point = out.right_ear.centroid(ii,:);
    plot(point(1),point(2),'.c','MarkerSize',20);
    point1 = point;
    
    point = out.left_ear.centroid(ii,:);
    plot(point(1),point(2),'.m','MarkerSize',20);
    point2 = point;
    
    plot([point1(1) point2(1)],[point1(2) point2(2)],'r','linewidth',2);
    
    pxls = out.right_hand.boundary_pixels(ii).ps;
    [rr,cc] = ind2sub(handles.md.frameSize,pxls);
    plot(cc,rr,'c','linewidth',2);
    pxls = out.left_hand.boundary_pixels(ii).ps;
    [rr,cc] = ind2sub(handles.md.frameSize,pxls);
    plot(cc,rr,'m','linewidth',2);
    pxls = out.right_ear.boundary_pixels(ii).ps;
    [rr,cc] = ind2sub(handles.md.frameSize,pxls);
    plot(cc,rr,'c','linewidth',2);
    pxls = out.left_ear.boundary_pixels(ii).ps;
    [rr,cc] = ind2sub(handles.md.frameSize,pxls);
    plot(cc,rr,'m','linewidth',2);
    xlim([zw(1)-50 zw(3)+50]);
    ylim([zw(2)-50 zw(4)]);
    text(zw(1) + 5,zw(2) + 5,sprintf('Frame - %d, Time - %.3f secs',fn,thisTimes(ii)),'FontSize',10,'color','w','FontWeight','Normal');
    Fr = getframe(gcf);
    writeVideo(v,Fr);
    pause(0.1);
end
close(v);
display('Done making video');


% --- Executes on button press in pushbutton_setTouchingHandsThreshold.
function pushbutton_setTouchingHandsThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_setTouchingHandsThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fn = get(handles.figure1,'userdata');
try
    sarea = setTouchingHandsThreshold(handles,fn);
    % sarea = sarea - (sarea/3);
    setParameter(handles,'Touching Hands Area',sarea);
catch
    displayMessageBlinking(handles,'An unknown error has occured',{'ForegroundColor','r'},3);
end


% --- Executes on button press in checkbox_displayMasks.
function checkbox_displayMasks_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_displayMasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_displayMasks


% --- Executes on button press in pushbutton_autoFind.
function pushbutton_autoFind_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_autoFind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~strcmp(get(handles.text_fileName,'String'),sprintf('File: %s',handles.d.file_name))
    displayMessageBlinking(handles,'Please wait for completion of file loading',{'ForegroundColor','r'},3);
    return;
end
props = {'FontSize',9,'ForegroundColor','b'};
displayMessage(handles,'',props);
[sfn,efn] = getFrameNums(handles);
enable_disable(handles,0);
set(handles.pushbutton_stop_processing,'visible','on');
% try
%     if get(handles.checkbox_useSimpleMasks,'Value')
%         thisFrame = frames{sfn};
%         tMasks = find_masks(handles,thisFrame);
%     else
%         tMasks = get_masks_KNN(handles,sfn);
%     end
% %     tMasks = find_masks_knn(handles,sfn);
% catch
%     props = {'FontSize',10,'ForegroundColor','r'};
%     displayMessage(handles,sprintf('Could not retrieve masks. As a first step, define colors and save masks'),props);
%     enable_disable(handles,1);
%     set(handles.pushbutton_stop_processing,'visible','off');
%     return;
% end
objectToProcess = get(handles.uibuttongroup_objectToProcess,'userdata');
try
    switch objectToProcess
        case 1
            findBody(handles,sfn,efn);
        case 2
            findEars(handles,sfn,efn);
        case 3
            findHands(handles,sfn,efn);
        case 4
            findBody(handles,sfn,efn);
            findEars(handles,sfn,efn);
            findHands(handles,sfn,efn);
    end
catch
    fn = get(handles.pushbutton_stop_processing,'userdata');
    props = {'FontSize',12,'ForegroundColor','r'};
    displayMessage(handles,sprintf('Sorry ... :-( ... error occurred in frame %d',fn),props);
end
enable_disable(handles,1);
set(handles.pushbutton_stop_processing,'visible','off');


% --- Executes on button press in pushbutton_erase.
function pushbutton_erase_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_erase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
framesToProcess = get(handles.uibuttongroup_framesToProcess,'userdata');
objectToProcess = get(handles.uibuttongroup_objectToProcess,'userdata');
global frames;
switch framesToProcess
    case 1
        sfn = get(handles.figure1,'userdata');
        efn = sfn;
    case 2
        sfn = round(get(handles.slider1,'Value'));
        efn = sfn + 19;
    case 3
        data = get(handles.epochs,'Data');
        currentSelection = get(handles.epochs,'userdata');
        fn = data{currentSelection};
        if isempty(fn)
            msgbox('Select an appropriate epoch');
        end
        startEnd = cell2mat(data(currentSelection(1),:));
        sfn = startEnd(1);
        efn = startEnd(2);
    case 4
        sfn = 1;
        efn = length(frames);
end
enable_disable(handles,0);
set(handles.pushbutton_stop_processing,'visible','on');
try
    switch objectToProcess
        case 1
            findBody(handles,sfn,efn,1);
        case 2
            findEars(handles,sfn,efn,1);
        case 3
            findHands(handles,sfn,efn,1);
        case 4
            findBody(handles,sfn,efn,1);
            findEars(handles,sfn,efn,1);
            findHands(handles,sfn,efn,1);
    end
catch
    displayMessage(handles,sprintf('Sorry :-( ... error occurred in frame %d',get(handles.pushbutton_stop_processing,'userdata')));
end
enable_disable(handles,1);
set(handles.pushbutton_stop_processing,'visible','off');


function edit_numberOfClusters_Callback(hObject, eventdata, handles)
% hObject    handle to edit_numberOfClusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_numberOfClusters as text
%        str2double(get(hObject,'String')) returns contents of edit_numberOfClusters as a double
nClus = getParameter(handles,'Number of Color Clusters');
nnClus = str2double(get(hObject,'String'));
if isempty(nnClus)
    set(hObject,'String',num2str(nClus));
else
    setParameter(handles,'Number of Color Clusters',nnClus);
end

% --- Executes during object creation, after setting all properties.
function edit_numberOfClusters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_numberOfClusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_manual.
function pushbutton_manual_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sfn = get(handles.figure1,'userdata');
efn = sfn;
manuallyTagHands(handles,sfn);

% 
% framesToProcess = get(handles.uibuttongroup_framesToProcess,'userdata');
% objectToProcess = get(handles.uibuttongroup_objectToProcess,'userdata');
% switch framesToProcess
%     case 1
%         sfn = get(handles.figure1,'userdata');
%         efn = sfn;
%     otherwise
%         disp('Can only execute for selected frame');
% end
% if ~exist('sfn','var')
%     return;
% end
% switch objectToProcess
%     case 1
% %         findBody(handles,sfn,efn,1);
%     case 2
% %         findEars(handles,sfn,efn,1);
%     case 3
%         manuallyTagHands(handles,sfn);
%     case 4
% end


% --- Executes when selected object is changed in uibuttongroup_framesToProcess.
function uibuttongroup_framesToProcess_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_framesToProcess 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
values = {'Selected Frame','Frames in Display Window','Epoch','All Frames'};
thisVal = get(hObject,'String');
indexC = strfind(values,thisVal);
tag = find(not(cellfun('isempty', indexC)));
set(handles.uibuttongroup_framesToProcess,'userdata',tag);


% --- Executes when selected object is changed in uibuttongroup_objectToProcess.
function uibuttongroup_objectToProcess_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_objectToProcess 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
values = {'Body','Ears','Hands','All'};
thisVal = get(hObject,'String');
indexC = strfind(values,thisVal);
tag = find(not(cellfun('isempty', indexC)));
set(handles.uibuttongroup_objectToProcess,'userdata',tag);


% --- Executes on button press in checkbox_over_write.
function checkbox_over_write_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_over_write (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_over_write
get(hObject,'Value')


% --- Executes on button press in pushbutton_epoch_add_row.
function pushbutton_epoch_add_row_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_epoch_add_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.epochs,'Data');
nrows = size(data,1);
data(nrows+1,1) = {[]};
data(nrows+1,2) = {[]};
set(handles.epochs,'Data',data);
handles.md.resultsMF.epochEnds = cell2mat(data(:,2));
handles.md.resultsMF.epochStarts = cell2mat(data(:,1));
    
% --- Executes on button press in pushbutton_epoch_delete_row.
function pushbutton_epoch_delete_row_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_epoch_delete_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.epochs,'Data');
nrows = size(data,1);
selRow = get(handles.epochs,'UserData');
data(selRow(1),:) = [];
set(handles.epochs,'Data',data);
handles.md.resultsMF.epochEnds = cell2mat(data(:,2));
handles.md.resultsMF.epochStarts = cell2mat(data(:,1));


% --------------------------------------------------------------------
function uipanel_messages_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel_messages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% enable_disable(handles,1);
if get(handles.text_processing,'userdata') == 0
    enable_disable(handles,1);
end
props = {'FontSize',9,'ForegroundColor','b'};displayMessage(handles,sprintf(''),props);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_processing.
function text_processing_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text_processing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'userdata') == 0
    enable_disable(handles,1);
end
props = {'FontSize',9,'ForegroundColor','b'};
displayMessage(handles,sprintf(''),props);


% --- Executes on button press in pushbutton_stop_processing.
function pushbutton_stop_processing_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stop_processing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text_processing,'userdata',0);
enable_disable(handles,1);
set(handles.pushbutton_stop_processing,'visible','off');


% --- Executes on slider movement.
function slider_HM_Callback(hObject, eventdata, handles)
% hObject    handle to slider_HM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = get(hObject,'Value');
set(handles.edit_handMaskTol,'String',num2str(val));
if ~get(handles.text_hand,'userdata')
    handles.md.resultsMF.colorTol(1,1) = val;
else
    handles.md.resultsMF.colorTol(2,1) = val;
end
fn = get(handles.figure1,'userdata');
displayMasks(handles,fn);

% --- Executes during object creation, after setting all properties.
function slider_HM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_HM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_handMaskTol_Callback(hObject, eventdata, handles)
% hObject    handle to edit_handMaskTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_handMaskTol as text
%        str2double(get(hObject,'String')) returns contents of edit_handMaskTol as a double


% --- Executes during object creation, after setting all properties.
function edit_handMaskTol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_handMaskTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_SM_Callback(hObject, eventdata, handles)
% hObject    handle to slider_SM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = get(hObject,'Value');
set(handles.edit_stringMaskTol,'String',num2str(val));
if ~get(handles.text_string,'userdata')
    handles.md.resultsMF.colorTol(1,3) = val;
else
    handles.md.resultsMF.colorTol(2,3) = val;
end
fn = get(handles.figure1,'userdata');
displayMasks(handles,fn);

% --- Executes during object creation, after setting all properties.
function slider_SM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_SM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_stringMaskTol_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stringMaskTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stringMaskTol as text
%        str2double(get(hObject,'String')) returns contents of edit_stringMaskTol as a double


% --- Executes during object creation, after setting all properties.
function edit_stringMaskTol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stringMaskTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_MM_Callback(hObject, eventdata, handles)
% hObject    handle to slider_MM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = get(hObject,'Value');
set(handles.edit_mouseMaskTol,'String',num2str(val));
if ~get(handles.text_fur,'userdata')
    handles.md.resultsMF.colorTol(1,2) = val;
else
    handles.md.resultsMF.colorTol(2,2) = val;
end
fn = get(handles.figure1,'userdata');
displayMaskFur(handles,fn);

% --- Executes during object creation, after setting all properties.
function slider_MM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_MM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_mouseMaskTol_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mouseMaskTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mouseMaskTol as text
%        str2double(get(hObject,'String')) returns contents of edit_mouseMaskTol as a double


% --- Executes during object creation, after setting all properties.
function edit_mouseMaskTol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mouseMaskTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_EM_Callback(hObject, eventdata, handles)
% hObject    handle to slider_EM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = get(hObject,'Value');
set(handles.edit_earMaskTol,'String',num2str(val));
if ~get(handles.text_ear,'userdata')
    handles.md.resultsMF.colorTol(1,4) = val;
else
    handles.md.resultsMF.colorTol(2,4) = val;
end
fn = get(handles.figure1,'userdata');
displayMaskFur(handles,fn);

% --- Executes during object creation, after setting all properties.
function slider_EM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_EM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkbox_useSimpleMasks.
function checkbox_useSimpleMasks_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_useSimpleMasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_useSimpleMasks
if get(handles.checkbox_useSimpleMasks,'Value')
    set(handles.uipanel_view_and_refine_masks,'Visible','On');
    set(handles.pushbutton_findAndSaveKnnMasks,'Visible','Off');
else
    set(handles.uipanel_view_and_refine_masks,'Visible','Off');
    set(handles.pushbutton_findAndSaveKnnMasks,'Visible','On');
end


% --- Executes on button press in pushbutton_exit.
function pushbutton_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);

% --- Executes on slider movement.
function slider_numberOfClusters_Callback(hObject, eventdata, handles)
% hObject    handle to slider_numberOfClusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = get(hObject,'Value');
set(handles.edit_numberOfClusters,'String',num2str(val));
setParameter(handles,'Number of Color Clusters',val);


% --- Executes during object creation, after setting all properties.
function slider_numberOfClusters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_numberOfClusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton_fileOpen.
function pushbutton_fileOpen_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_fileOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles = load_file(handles);
    guidata(handles.figure1, handles);
catch
    return;
end
if ~isempty(handles.d)
    enable_disable_1(handles,2,1);
    set(handles.pushbutton_fileOpen,'visible','off');
else
    displayMessage(handles,sprintf('Welcome to String Pulling Behavioral Analytics'),{'FontSize',12,'ForegroundColor','b'});
end


% --- Executes on button press in checkbox_overwriteMasks.
function checkbox_overwriteMasks_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_overwriteMasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_overwriteMasks


% --- Executes on button press in pushbutton_saveMasks.
function pushbutton_saveMasks_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_saveMasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global masks;
fileName = sprintf('masks.mat');
fullfileName = fullfile(handles.md.processedDataFolder,fileName);
tic
save(fullfileName, '-struct', 'masks','-v7.3');
displayMessage(handles,sprintf('Saved !!! -- time taken = %.3f mins',toc/60));
set(handles.pushbutton_saveMasks,'Enable','Off');



function edit_go_to_frame_Callback(hObject, eventdata, handles)
% hObject    handle to edit_go_to_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_go_to_frame as text
%        str2double(get(hObject,'String')) returns contents of edit_go_to_frame as a double
val = get(hObject,'String');
fn = str2num(val);
displayFrames(handles,fn);

% --- Executes during object creation, after setting all properties.
function edit_go_to_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_go_to_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_displayAreas.
function checkbox_displayAreas_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_displayAreas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_displayAreas
value = round(get(handles.slider1,'Value'));
displayFrames(handles,value);


% --- Executes on button press in pushbutton_stopPlay.
function pushbutton_stopPlay_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stopPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton_stopPlay,'userdata',1,'Visible','Off');
set(handles.pushbutton_fastPlay,'Visible','On');


% --- Executes on button press in pushbutton_findMouse.
function pushbutton_findMouse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_findMouse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~strcmp(get(handles.text_fileName,'String'),sprintf('File: %s',handles.d.file_name))
    displayMessageBlinking(handles,'Please wait for completion of file loading',{'ForegroundColor','r'},3);
    return;
end
props = {'FontSize',9,'ForegroundColor','b'};
displayMessage(handles,'',props);
[sfn,efn] = getFrameNums(handles);
enable_disable(handles,0);
findBody_Coarse(handles,sfn,efn);
enable_disable(handles,1);
% global frames;
% totalFrames = length(frames);
% frameNums = 1:totalFrames;
% zw = handles.md.resultsMF.zoomWindow;
% Rb = [];
% for ii = 1:length(frameNums)
%     fn = frameNums(ii);
%     thisFrame = frames{fn};
%     thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
%     tic;
%     mask = find_mask_fur_global(handles,thisFrame);
%     C = find_centroids_fur(mask);
%     if ~isempty(C)
%         Rb = [Rb;[fn C.Centroid(1)+zw(1) C.Centroid(2)+zw(2) C.MajorAxisLength C.MinorAxisLength C.Orientation]];
%     end
%     figure(100);clf;
%     Im = imoverlay(thisFrame,mask);
%     imagesc(Im);axis equal;
%     hold on;
%     plot(C.Ellipse_xs,C.Ellipse_ys,'g');
%     displayMessage(handles,sprintf('Finding %s fit ... Processing frame %d - %d/%d ... time remaining %s','body',ii,fn,length(frameNums),getTimeRemaining(length(frameNums),ii)));
% end
% handles.md.resultsMF.RE = Rb;
% displayMessage(handles,sprintf('Done processing frames %d to %d',fn,length(frameNums)));


% --- Executes on button press in checkbox_updateDisplay.
function checkbox_updateDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_updateDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_updateDisplay
