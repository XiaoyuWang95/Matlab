function [outputs] = bruteBinary(filename,path,nlines,startline)
% [formats] = bruteBinary(filename)
% Function bruteBinary uses all precisions and machine formats in the
% function fread to try to determine the encoding of a file with an
% unknown encoding scheme. To prevent memory overloading, only 100 bytes
% are read at a time if the variable nlines is not specified.

if nargin < 1
    [filename,path] = uigetfile({'*.*','All Files';},... % Open the user interface for opening files
    'Select Data File');
    if ~iscell(filename)
        if length(filename) <= 1 && filename == 0
            return;
        end
    end
end

if exist('path','var')
    file = [path,filename];
else
    file = filename;
end


precisions = {'uint','uint8','uint16','uint32','uint64',...
              'uchar','unsigned char','ushort','ulong',...
              'int','int8','int16','int32','int64',...
              'integer*1','integer*2','integer*4','integer*8',...
              'schar','signed char','short','long',...
              'single','double','float','float32','float64',...
              'real*4','real*8','char*1','char','*char'};

machineformats = {'native','ieee-be','ieee-le','ieee-be.l64','ieee-le.l64'};

% outputs = cell(numel(precisions)+numel(precisions)*numel(machineformats),2);
outputs = cell(numel(precisions),2);

for i = 1:numel(precisions)
    fid = fopen(file,'r');
    if nargin > 3
        fread(fid,startline);
    end
    if nargin < 3
        nlines = 20;
    end
    outputs{i,1} = cell2mat(precisions(i)); 
    outputs{i,2} = fread(fid,nlines,cell2mat(precisions(i)))';
    outputs{i,2} = mat2cell(outputs{i,2},1,length(outputs{i,2}));
%     disp([outputs{i,1},': ',outputs{i,2}]);
%     disp(['Char of ',outputs{i,1},': ',char(outputs{i,2})]);
    fclose(fid);
end
celldisp(outputs);
    

end

