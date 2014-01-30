clear

files = dir('*.txt')       % the directory function returns a cell array containing the name, date, bytes and date-as-number as a single array for each file meeting criterion.

HowManyFiles = length(files) % Need to know the number of files to process.  This number is encoded as the variable "HowManyFiles". 

for FileCounter = 1:length(files)   %Runs the following command for each file meeting criterion within the current directory.
  InputFileList {FileCounter,1} = files (FileCounter).name  %InputFileList is a Cell Array of Strings, meaning an array of strings that are not necessarily uniform in number of characters.
  InputFileList {FileCounter,2} = FileCounter
end  % the use of '{}' to signify array positions identifies this array as a cell array of strings.
%Here, InputFileList receives the names associated with each file in the directory that meets inclusion criteria.  (FileCounter,1) identifies a subarray of the cell array files.  
% '.name' indicates that we need to add the name to InputFileList at element (FileCounter).  So now we have a cell array of Strings, in which all input files are listed. 
% For more information on batch processing, see: http://blogs.mathworks.com/steve/2006/06/06/batch-processing/#1

xlswrite ('OutPutMe.xls', InputFileList)

for FileCounter=1:length(files)  %this loop imports the data files one-by-one and processes them into output files.   
    importfile(files(FileCounter).name)
end
% Import the file '004_base.txt'.  newData1 appears to be a variable, but in fact it is a vitual 3-D matrix: epoch (start to finish in ten sec intervals) X variable number (2 or 42) X variable type (text or numerical).  
%Matlab automatically sorts the data into two matrices.  The first holds the time/date stamp and state in a matrix of 2 columns.  
%The second holds lactate, EEG and EMG data in a matrix of 42 columns 
%SERIOUS CAVEAT: WHILE THE 2 HEADER ROWS ARE REMOVED FROM THE DATA MATRIX, THEY ARE NOT REMOVED FROM THE TEXTDATA MATRIX  

MatrixNames = fieldnames(files); % Create new variable names in the base workspace from the fieldnames associated with the files Cell array.  
%"data" = lactate, EEG and EMG with no headers; "textData" = time/ date stamp and state with headers;
%MatrixNames is a vector containing two cells of type string
%seems odd to me that MartixNames does not appear in the variable list.



for i = 1:length(MatrixNames)
    assignin('base', MatrixNames{i}, newData1.(MatrixNames{i}));
    % assignin (a,b,c) assigns to the workspace A a variable named B filled with the values drawn from the virtual variable C. 
    % Here, it assigns the values of all array cells in the array newData1.(MatrixNames{i} to an array MatrixNames{i} in the workspace 'base'.
    % 'base' is the central matlab workspace, i.e., the workspace that one
    % uses from the Matlab command line. The other Matlab workspace is the
    % 'caller' workspace, the one used by a function, if this command is
    % called from within an operating function.
end

