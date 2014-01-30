function [files,path] = uiGetFilesInCellArray()
% files = uiGetFilesInCellArray();
% Function uiGetFilesInCellArray() opens a user interface for retrieving
% multiple files and returns them in a cell array.

[files,path] = uigetfile({'*raw','Binary MCS Files (*.raw)';'*.*','All Files';'*.edf','EDF Files (*.edf)';'*.txt','Text Files (*.txt)';},... % Open the user interface for opening files
'Select Data File(s)','MultiSelect','On');

if ~iscell(files)
    if isequal(files,0)
        return;
    end
    files = {files};
end

end

