[files] = uigetfile({'*.*','All Files';'*.edf','EDF Files (*.edf)';'*.txt','Text Files (*.txt)';'*.mat','MAT-files (*.mat)'},... % Open the user interface for opening files
'Select Data File(s)','MultiSelect','On');
if ~iscell(files)
    if isequal(filename,0)
        return;
    end
    % Turns the filename into a cell array
    % so the subsequent for loop works.
    file = files;
    files = cell(1,1);
    files{1} = file;
end

for i = 1:length(files)
     [matrix, format] = retrieveData(files(i));
     ChannelSelectDialog;
     [~,~,ext] = fileparts(files(i));
     if strcmp(files,'.edf')
        matrix()
     else
         
     end
     [stimMean,randMean] = UltrasoundVerification(files(i).name);
%             disp('Exporting waves to Excel...');
%             exportToExcel(files(i).name, stimMean, randMean, count)
%             count = count + 2;
end
    
path = 'C:\Users\wisorlab\Documents\MATLAB\Matlab Scripts\Michele UltraSound Experiments\Batch Script\Real Time Trials';
files = dir(path);
count = 1;
for i = 1:numel(files)
    if files(i).isdir == 0
        [~,name,ext] = fileparts(files(i).name);
        disp(['Processing ', files(i).name]);
        if strcmp(ext,'.txt')
            [stimMean,randMean] = UltrasoundVerification(files(i).name);
%             disp('Exporting waves to Excel...');
%             exportToExcel(files(i).name, stimMean, randMean, count)
%             count = count + 2;
        end
    end
end
disp('Batch processing complete.');
    
