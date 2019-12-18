function find_fractal_dimensions_and_entropy (handles)

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
    selfRun = 1;
else
    if ~isfield(handles,'figure1')
        handles.md.processed_data_folder = handles.pd_folder;
    end
    selfRun = 0;
end

[sfn,efn] = getFrameNums(handles);
frameNums = sfn:efn;

handles.md = get_meta_data(handles);
sfn = frameNums(1);
efn = frameNums(end);

fileName = sprintf('descriptive_statistics_%d_%d.mat',sfn,efn);fileName = fullfile(handles.md.processed_data_folder,fileName);
ds = load(fileName);

fileName = sprintf('descriptive_statistics_masks_%d_%d.mat',sfn,efn);fileName = fullfile(handles.md.processed_data_folder,fileName);
dsm = load(fileName);

fileName = sprintf('entropy_%d_%d.mat',sfn,efn);fileName = fullfile(handles.md.processed_data_folder,fileName);
ent = load(fileName);

pcs = load_pcs(handles);

ics = load_ics(handles);

mouse_color = getParameter(handles,'Mouse Color');

displayMessage(handles,'Finding fractal dimensions and entropy - Descriptive Stats');
temp = find_fd_ent_ds(ds);
fd_ent = temp;

displayMessage(handles,'Finding fractal dimensions and entropy - Descriptive Stats Masks');
temp = find_fd_ent_dsm(dsm);
fd_ent = [fd_ent;temp];

displayMessage(handles,'Finding fractal dimensions and entropy - Temporal Entropy');
temp = find_fd_ent_ent(ent,{'Entropy',ds});
fd_ent = [fd_ent;temp];
if isfield(ent,'HFD')
    temp = find_fd_ent_ent(ent.HFD,{'Higuchi',ds});
    fd_ent = [fd_ent;temp];
end
if isfield(ent,'FF')
    temp = find_fd_ent_ent(ent.FF,{'Fano Factor',ds});
    fd_ent = [fd_ent;temp];
end
if isfield(ent,'pVRT')
    temp = find_fd_ent_ent(ent.pVRT,{'Variance Ratio',ds});
    fd_ent = [fd_ent;temp];
end

displayMessage(handles,'Finding fractal dimensions and entropy - PCs');
temp = find_fd_ent_pcs(pcs);
fd_ent = [fd_ent;temp];


mouse_color = getParameter(handles,'Mouse Color');
displayMessage(handles,'Finding fractal dimensions and entropy - ICs');
temp = find_fd_ent_ics(ics);
fd_ent = [fd_ent;temp];

fileName = sprintf('fractal_dim_and_entropy_%d_%d.mat',sfn,efn);fileName = fullfile(handles.md.processed_data_folder,fileName);
save(fileName,'fd_ent');

fd_ent_table = table(fd_ent(:,1),fd_ent(:,2),fd_ent(:,3),fd_ent(:,4),fd_ent(:,5));
fd_ent_table.Properties.VariableNames = {'Name','Fractal_Dim','Entropy','Sharpness','Spread'};
n= 0;

function fd_ent = find_fd_ent_ics(ics)
fd_ent = [];
comps = ics.ics.Z';
thisFrame = max(comps,[],2); thisFrame = reshape(thisFrame,ics.nrows,ics.ncols);
sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,'Max IC Img Seq');
thisFrame = min(comps,[],2); thisFrame = reshape(thisFrame,ics.nrows,ics.ncols);
sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,'Min IC Img Seq');

comps = ics.ics_motion.Z';
thisFrame = max(comps,[],2); thisFrame = reshape(thisFrame,ics.nrows,ics.ncols);
sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,'Max IC Motion');
thisFrame = min(comps,[],2); thisFrame = reshape(thisFrame,ics.nrows,ics.ncols);
sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,'Min IC Motion');

comps = ics.pc.ics.Z';
thisFrame = max(comps,[],2); thisFrame = reshape(thisFrame,ics.nrows,ics.ncols);
sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,'Max IC-PC Img Seq');
thisFrame = min(comps,[],2); thisFrame = reshape(thisFrame,ics.nrows,ics.ncols);
sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,'Min IC-PC Img Seq');

comps = ics.pc.ics_motion.Z';
thisFrame = max(comps,[],2); thisFrame = reshape(thisFrame,ics.nrows,ics.ncols);
sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,'Max IC-PC Motion');
thisFrame = min(comps,[],2);thisFrame = reshape(thisFrame,ics.nrows,ics.ncols);
sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,'Min IC-PC Motion');


function fd_ent = find_fd_ent_pcs(pcs)
fd_ent = [];
for ii = 1:10
    thisFrame = pcs.score(:,ii);
    thisFrame = reshape(thisFrame,pcs.nrows,pcs.ncols);
    sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,sprintf('PC%d Img Seq',ii));
end

for ii = 1:10
    thisFrame = pcs.motion.score(:,ii);
    thisFrame = reshape(thisFrame,pcs.nrows,pcs.ncols);
    sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,sprintf('PC%d Motion',ii));
end


function fd_ent = find_fd_ent_ent(ent,headerI)
header = headerI{1};
fieldNames = fields(ent);
fd_ent = [];
for ii = 1:length(fieldNames)
    cmdTxt = sprintf('thisField = ent.%s;',fieldNames{ii});
    eval(cmdTxt);
    if isnumeric(thisField)
        thisFrame = thisField;
        sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,sprintf('%s Img Seq %s',header,fieldNames{ii}));
    end
end


fieldNames = fields(ent.motion);
for ii = 1:length(fieldNames)
    cmdTxt = sprintf('thisField = ent.motion.%s;',fieldNames{ii});
    eval(cmdTxt);
    if isnumeric(thisField)
        thisFrame = thisField;
        sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,sprintf('%s Motion %s',header,fieldNames{ii}));
    end
end


function fd_ent = find_fd_ent_ds(ds)
fieldNames = fields(ds);
fd_ent = [];
for ii = 1:length(fieldNames)
    cmdTxt = sprintf('thisField = ds.%s;',fieldNames{ii});
    eval(cmdTxt);
    if isnumeric(thisField)
        thisFrame = thisField;
        sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,sprintf('Descriptive Stats Img Seq %s',fieldNames{ii}));
    end
end


fieldNames = fields(ds.motion);
for ii = 1:length(fieldNames)
    cmdTxt = sprintf('thisField = ds.motion.%s;',fieldNames{ii});
    eval(cmdTxt);
    if isnumeric(thisField)
        thisFrame = thisField;
        sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,sprintf('Descriptive Stats Motion %s',fieldNames{ii}));
    end
end

function fd_ent = find_fd_ent_dsm(ds)
fieldNames = fields(ds);
fd_ent = [];

fieldNames = fields(ds.masks.body);
for ii = 1:length(fieldNames)
    cmdTxt = sprintf('thisField = ds.masks.body.%s;',fieldNames{ii});
    eval(cmdTxt);
    if isnumeric(thisField)
        thisFrame = thisField;
        sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,sprintf('Descriptive Stats Object Masks Body %s',fieldNames{ii}));
    end
end

fieldNames = fields(ds.masks.nose);
for ii = 1:length(fieldNames)
    cmdTxt = sprintf('thisField = ds.masks.nose.%s;',fieldNames{ii});
    eval(cmdTxt);
    if isnumeric(thisField)
        thisFrame = thisField;
        sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,sprintf('Descriptive Stats Object Masks Nose %s',fieldNames{ii}));
    end
end

fieldNames = fields(ds.masks.ears);
for ii = 1:length(fieldNames)
    cmdTxt = sprintf('thisField = ds.masks.ears.%s;',fieldNames{ii});
    eval(cmdTxt);
    if isnumeric(thisField)
        thisFrame = thisField;
        sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,sprintf('Descriptive Stats Object Masks Ears %s',fieldNames{ii}));
    end
end

fieldNames = fields(ds.masks.hands);
for ii = 1:length(fieldNames)
    cmdTxt = sprintf('thisField = ds.masks.hands.%s;',fieldNames{ii});
    eval(cmdTxt);
    if isnumeric(thisField)
        thisFrame = thisField;
        sms = find_spatial_measures(thisFrame); fd_ent = populateList(fd_ent,sms,sprintf('Descriptive Stats Object Masks Hands %s',fieldNames{ii}));
    end
end



function fd_ent = populateList(fd_ent,sms,firstField)
if isempty(fd_ent)
    ind = 1;
else
    ind = size(fd_ent,1) + 1;
end
fd_ent{ind,1} = firstField;    
for ii = 2:(length(sms)+1)
    fd_ent{ind,ii} = sms{ii-1};
end