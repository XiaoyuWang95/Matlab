%This function should serve to read an sev file into a Matlab array (an N rows by 1 column matrix).    
%The quick and dirty way is to read the fileSize (first 8 bytes, ignore the next 32 bytes which are empty header space and
%read the rest of the file into an array, like this:
 
function [streamOutput] = sev_read_RS2(SevInputFile) %SevInputFile must be identified in single quotes and must be type sev.
                                        % for instance, the call should be:
                                        % sev_read('BupivSevTest.sev');
    FORMAT_MAP = containers.Map(...
        0:5,...
        {'float32','int32','int16','int8','float64','int64'});

    % open file
    fmt = '*float32'
    fid = fopen(SevInputFile, 'rb');
   
    % create and fill streamOutput structured array '
    
  
    streamOutput = [];
    streamOutput.fileSize = fread(fid, 1, 'uint64'); % get the file size, a single eight byte/64 bit piece of information 
    streamOutput.emptyHeader = fread(fid, 32, 'char'); % the rest of the header is empty, but we must read past these 32 bytes to get our data. 
    streamOutput.Data = fread(fid, inf, fmt) % read the streaming data; this is the physiological signal from  start to finish of the file.
end