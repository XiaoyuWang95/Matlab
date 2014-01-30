files = dir('*.txt')

for FileCounter = 1:Length(Files) 
  InputFileList (FileCounter) = Files (FileCounter,1).name
end





function importfile(fileToRead1)  %create a novel, previously non-existent function called importfile.  
  %when called, importfile imports data  from the file of filename
  %fileToRead1

newData1 = importdata('004_base.txt'); 
% Import the file '004_base.txt'.  newData1 appears to be a variable, but in fact it is a vitual 3-D matrix: epoch (start to finish in ten sec intervals) X variable number (2 or 42) X variable type (text or numerical).  
%Matlab automatically sorts the data into two matrices.  The first holds the time/date stamp and state in a matrix of 2 columns.  
%The second holds lactate, EEG and EMG data in a matrix of 42 columns 
%SERIOUS CAVEAT: WHILE THE 2 HEADER ROWS ARE REMOVED FROM THE DATA MATRIX, THEY ARE NOT REMOVED FROM THE TEXTDATA MATRIX  

MatrixNames = fieldnames(newData1) % Create new variable names in the base workspace from the fieldnames associated with the newdata virtual 3-D matrix.  
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

