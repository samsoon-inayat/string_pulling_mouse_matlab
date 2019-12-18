function save_mask(handles,fn,object,mask)

md = get_meta_data(handles);
masksMap = getParameter(handles,'Masks Order');
ind = find(strcmp(masksMap,object));
fileName = fullfile(fullfile(md.processed_data_folder,'masks'),sprintf('mask_%d.mat',fn));
if ~exist(fileName,'file')
    pMask = zeros(numel(mask),1); % if no previous file, initialize masks to zero
else
    temp = load(fileName);
    pMask = temp.dpMask;
end
try
    bpMask = de2bi(pMask,8); % convert to binary for separating individual masks ... i.e. uncompress
    bpMask(:,ind) = reshape(mask,numel(mask),1); % put in the mask values at the desired index ind
    dpMask = uint8(bi2de(bpMask)); % convert binary to decimal again
catch
    pMask = zeros(numel(mask),1); % if no previous file, initialize masks to zero
    bpMask = de2bi(pMask,8); % convert to binary for separating individual masks ... i.e. uncompress
    bpMask(:,ind) = reshape(mask,numel(mask),1); % put in the mask values at the desired index ind
    dpMask = uint8(bi2de(bpMask)); % convert binary to decimal again
end
save(fileName,'dpMask'); % save dpMask
