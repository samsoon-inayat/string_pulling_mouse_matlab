%% Cellsort Artificial Data Test

% Eran Mukamel
% December 1, 2009
% eran@post.harvard.edu
    
% fn = 'ArtificialData_SNR_0.1_FOV_250.tif';

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
end
frames = get_frames(handles);

[sfn,efn] = getFrameNums(handles);
zw = getParameter(handles,'Auto Zoom Window');
% fn = fullfile(handles.md.processedDataFolder,sprintf('epoch_%d_%d.tif',sfn,efn));

if ~exist('fn','var')
    frameNums = sfn:efn;
    temp = frames{frameNums(1)};
    temp = temp(zw(2):zw(4),zw(1):zw(3),:);
    fn = double(rgb2gray(temp));
    for ii = 2:length(frameNums)
        temp = frames{frameNums(ii)};
        temp = temp(zw(2):zw(4),zw(1):zw(3),:);
        fn(:,:,ii) = double(rgb2gray(temp));
    end
end
n=0;
%% 1. PCA

outputdir = handles.md.processedDataFolder;
outputdir = fullfile(outputdir,'cellsort_preprocessed_data');
mkdir(outputdir)
badframes = [];
dsamp = [];
tic
nPCs = 200;
flims = [];
figure(1);clf
[mixedsig, mixedfilters, CovEvals, covtrace, movm, movtm] = ...
    CellsortPCA(fn, flims, nPCs, dsamp, outputdir, badframes);
toc
%% 2a. Choose PCs
figure(2);clf;
tic
[PCuse] = CellsortChoosePCs(fn, mixedfilters);
toc
%% 2b. Plot PC spectrum

figure(3);clf
CellsortPlotPCspectrum(fn, CovEvals, PCuse)

%% 3a. ICA
tic
nIC = length(PCuse);
mu = 0.5;

[ica_sig, ica_filters, ica_A, numiter] = CellsortICA(mixedsig, mixedfilters, CovEvals, PCuse, mu, nIC);
toc
%% 3b. Plot ICs
tic
tlims = [];
dt = 0.1;

figure(20)
CellsortICAplot('series', ica_filters, ica_sig, movm, tlims, dt, [], [], PCuse);
toc
%% 4a. Segment contiguous regions within ICs
tic
smwidth = 2;
thresh = 2;
arealims = [30 90];
plotting = 1;
figure(200);
[ica_segments, segmentlabel, segcentroid] = CellsortSegmentation(ica_filters, smwidth, thresh, arealims, plotting);
toc
%% 4b. CellsortApplyFilter 
tic
subtractmean = 1;

cell_sig = CellsortApplyFilter(fn, ica_segments, flims, movm, subtractmean);
toc
%% 5. CellsortFindspikes 

deconvtau = 0;
spike_thresh = 2;
normalization = 1;

[spmat, spt, spc] = CellsortFindspikes(ica_sig, spike_thresh, dt, deconvtau, normalization);

%% Show results

figure(2)
CellsortICAplot('series', ica_filters, ica_sig, movm, tlims, dt, 1, 2, PCuse, spt, spc);
