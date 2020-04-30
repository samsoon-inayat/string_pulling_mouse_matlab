function initializeDisplay (handles)

d = get_data(handles);
md = get_meta_data(handles);
disp = md.disp;

set(handles.figure1,'Name','String Pulling Behavior Analytics');
scale = getParameter(handles,'Scale');
if ~isempty(scale)
    set(handles.pushbutton_setScale,'ForegroundColor',[0 0.6 0.2]);
else
    set(handles.pushbutton_setScale,'ForegroundColor','r');
end

handles.epochs.ColumnName = {'Start','Stop'};
populateTable(handles);
checkStatusOfColors(handles);
set(handles.figure1,'userdata',1);
set(handles.text_selected_frame,'String',sprintf('(%d)',1));
% displayMasks(handles,1);
set(handles.slider1,'value',1, 'min',1, 'max',d.number_of_frames,'SliderStep', [1/d.number_of_frames , disp.numFrames/d.number_of_frames],'userdata',1);
set(handles.slider_HM,'value',getParameter(handles,'Hands Color Tolerance'), 'min',0, 'max',100,'SliderStep', [1/100 , 10/100]);
set(handles.slider_SM,'value',getParameter(handles,'String Color Tolerance'), 'min',0, 'max',100,'SliderStep', [1/100 , 10/100]);
set(handles.slider_MM,'value',getParameter(handles,'Fur Color Tolerance'), 'min',0, 'max',100,'SliderStep', [1/100 , 10/100]);
set(handles.slider_EM,'value',getParameter(handles,'Ears Color Tolerance'), 'min',0, 'max',100,'SliderStep', [1/100 , 10/100]);
set(handles.slider_numberOfClusters,'value',3, 'min',1, 'max',7,'SliderStep', [1/6 , 10/6]);
set(handles.edit_handMaskTol,'String',num2str(getParameter(handles,'Hands Color Tolerance')));
setParameter(handles,'Fur Color Tolerance',3);
set(handles.edit_mouseMaskTol,'String',num2str(getParameter(handles,'Fur Color Tolerance')));
set(handles.edit_stringMaskTol,'String',num2str(getParameter(handles,'String Color Tolerance')));
set(handles.edit_earMaskTol,'String',num2str(getParameter(handles,'Ears Color Tolerance')));
set(handles.text_folderName,'String',sprintf('Folder - %s',d.file_path),'FontSize',10);
set(handles.text_fileName,'String',sprintf('File: %s',d.file_name));
set(handles.text_processing,'userdata',0);
set(handles.text_scale,'String',{'Scale',sprintf('%.3f',getParameter(handles,'Scale')),'mm/pixels'});
set(handles.pushbutton_saveMasks,'Enable','off');
set(handles.edit_range_search_radius,'String','1.5');
radius = getParameter(handles,'Range Search Radius'); 
if isempty(radius)
    radius = 1.5; setParameter(handles,'Range Search Radius',radius); 
end
set(handles.edit_range_search_radius,'String',num2str(radius));
numberOfPoints = getParameter(handles,'KNN Search Number of Points');
if isempty(numberOfPoints)
    numberOfPoints = 300; setParameter(handles,'KNN Search Number of Points',numberOfPoints);
end
set(handles.edit_KNN_search_number_of_points,'String',num2str(numberOfPoints));
v = d.video_object;
set(handles.text_fileInfo,'String',sprintf('Video Format: %s %d x %d pixels -- Frame Rate: %.4f fps -- Duration: %.3f s -- Total Frames: %d',v.VideoFormat,d.frame_size(2),d.frame_size(1),v.FrameRate,v.Duration,d.number_of_frames));
setParameter(handles,'Frame Rate',v.FrameRate);
temp = getParameter(handles,'Number of Color Clusters');
set(handles.edit_numberOfClusters,'String',num2str(temp));
% displayFrames(handles,21);
% displayMessage(handles,'Loading will continue in the background!');
sarea = getParameter(handles,'Touching Hands Area');
if isempty(sarea)
    set(handles.text_touchingHandsArea,'String',{'Touching Hands Area',sprintf('Not Set')},'ForegroundColor','r');
else
    set(handles.text_touchingHandsArea,'String',{'Touching Hands Area',sprintf('%d Pixels',sarea)});
end
MSER_th = getParameter(handles,'MSER Threshold');
ED_th = getParameter(handles,'Eucledian Distance Threshold');
set(handles.edit_MSER_Threshold,'String',num2str(MSER_th));
set(handles.edit_EucledianDistance,'String',num2str(ED_th));
set(handles.checkbox_updateDisplay,'Value',1);
set(handles.pushbutton_saveData,'Enable','off');
set(handles.checkbox_saveOnTheGo,'Value',1);

varNames = {'edit_margin_left','edit_margin_top','edit_margin_right','edit_margin_bottom','edit_margin_leftH','edit_margin_topH','edit_margin_rightH','edit_margin_bottomH'};
for ii = 1:length(varNames)
    tagName = varNames{ii};
    val = getParameter(handles,tagName);
    if ~isempty(val)
        cmdText = sprintf('set(handles.%s,''String'',num2str(val));',tagName);
        eval(cmdText);
    end
end

try
    cF = getColors(handles,'Fur',4:6,0);
    if ~isempty(cF)
        d = mean(cF - [255 255 255]);
        if d(1) < -128 && d(2) < -128 && d(3) < -128
            setParameter(handles,'Mouse Color','Black');
        else
            setParameter(handles,'Mouse Color','White');
        end
    end
catch
end


fileName = fullfile(md.processed_data_folder,'dispProps.mat');

if exist(fileName,'file')
    dispProps = load(fileName);
else
    dispProps.selectRectangle_color = 'k';
    dispProps.selectRectangle_linewidth = 3;
    dispProps.bodyEllipse_color = 'g';
    dispProps.rightHand_line_color = 'r';
    dispProps.leftHand_line_color = 'b';
    dispProps.rightHand_dot_color = 'm';
    dispProps.leftHand_dot_color = 'c';
    dispProps.rightEar_line_color = 'r';
    dispProps.leftEar_line_color = 'b';
    dispProps.rightEar_dot_color = 'm';
    dispProps.leftEar_dot_color = 'c';
    dispProps.nose_line_color = 'r';
    dispProps.nose_dot_color = 'r';
    dispProps.frameNumber_Text_Color = 'w';
    dispProps.manual_detection_identifier = 'w';
    dispProps.TaggedVideo_Frame_Text_Color = 'w';
    dispProps.TaggedVideo_AutoManual_Text_Color = 'w';
end
set(handles.pushbutton_select_annotation_colors,'userdata',dispProps);

