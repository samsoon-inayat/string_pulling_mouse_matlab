function deletePDF (pfileName)

if exist(pfileName,'file')
    delete(pfileName);
end
if exist('temp.pdf','file')
    delete('temp.pdf');
end
