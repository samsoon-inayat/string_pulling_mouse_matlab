function offline_processing

variablesToGetFromBase = {'pdfFolder','config_b','config_w','frames_b','frames_w'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',variablesToGetFromBase{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end

%%

allProcessingFunctions = {'descriptive_statistics','find_temporal_xics','find_PCs','find_ICs','find_fractal_dimensions_and_entropy'};
selectProcessingFunctions = allProcessingFunctions(5);
tic
for ii = 1:5
    ii
    config = config_b{ii};
    [sfn,efn] = getFrameNums(config);    
    runFunctions(selectProcessingFunctions,config,sfn,efn);

    config = config_w{ii};
    [sfn,efn] = getFrameNums(config);
    runFunctions(selectProcessingFunctions,config,sfn,efn);
end
time_taken = toc
% save('Time_Taken_offline_processing.mat','time_taken');


function runFunctions(pfs,config,sfn,efn)
for jj = 1:length(pfs)
    if strcmp(pfs{jj},'find_fractal_dimensions_and_entropy')
        cmdTxt = sprintf('%s(config);',pfs{jj})
    else
        cmdTxt = sprintf('%s(config,sfn:efn);',pfs{jj})
    end
    eval(cmdTxt);
end
