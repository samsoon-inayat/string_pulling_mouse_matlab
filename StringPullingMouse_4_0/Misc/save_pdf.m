function save_pdf(hf,pdf_folder,fileName,resolution)

if ~strcmp(fileName((end-3):end),'.pdf')
    fileName = [fileName '.pdf'];
end

fileName = fullfile(pdf_folder,fileName);


save2pdf(fileName,hf,resolution);