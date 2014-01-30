function [ filetype ] = determineFileType(filename)
% filetype = determineFileType('filename');
% Determines whether the text file is a .mcd file

try
    fid = fopen(filename);
catch err
    error(['The file could not be opened. You may need to close it in another application. Error: ',err]);
end

title = textscan(fid,'%s',1,'delimiter','\n'); %Skips the first two lines of the document.
if strcmp(title{1,1},'MC_DataTool ASCII conversion')
    filetype = 'MCTxt';
end

fclose(fid);
end

