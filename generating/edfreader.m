% Read European Data Format file into MATLAB- I got this from http://www.mathworks.com/matlabcentral/fileexchange/31900-edfread
% I had to modify 'Rs=cumsum([1; (header.epochduration/header.epochduration).*header.samplerate])' from 'Rs=cumsum([1; header.epochduration.*header.samplerate])'
% I believe the version I obtained online happened to work because the writer assumed (consciously or otherwise) that one epoch was one second.  

function [data,header] = edfread(filename) 
fid = fopen(filename,'r','ieee-le');  %opens the input file 'filename' for read only 'r'; specifies that the machine format is Little-endian ordering'  
% PART1 
hdr = char(fread(fid,256,'uchar')'); %read from file named fid/'filename' the first 256 chars of the file with 8-bit ('uchar' precision) 
header.version=str2num(hdr(1:8)); % 8 ascii : version of this data format (0) 
header.patientID = char(hdr(9:88)); % 80 ascii : local patient identification 
header.recordID = char(hdr(89:168)); % 80 ascii : local recording identification 
header.startdate=char(hdr(169:176)); % 8 ascii : startdate of recording (dd.mm.yy) 
header.starttime = char(hdr(177:184)); % 8 ascii : starttime of recording (hh.mm.ss) 
header.length = str2num (hdr(185:192)); % 8 ascii : number of bytes in header record; this is 2048, because there are 256 chars X 8 bytes = 2048 bytes.
reserved = hdr(193:236); % [EDF+C ] % 44 ascii : reserved 
header.numofepochs = str2num (hdr(237:244)); % 8 ascii : number of epochs of data to be included (-1 if unknown) 
header.epochduration = str2num (hdr(245:252)); % 8 ascii : duration of a data record, in seconds 
header.numofsignals = str2num (hdr(253:256));% 4 ascii : number of signals (ns) in data record
%%%% PART2 
header.label=cellstr(char(fread(fid,[16,header.numofsignals],'char')')); % takes the next label (e.g. EEG FpzCz or Body temp) 
header.transducertype =cellstr(char(fread(fid,[80,header.numofsignals],'char')')); % ns * 80 ascii : ns * transducer type (e.g. AgAgCl electrode) 
header.physdimension = cellstr(char(fread(fid,[8,header.numofsignals],'char')')); % ns * 8 ascii : ns * physical dimension (e.g. uV; it is necessary to code microvolts with a u and not a mu.) 
header.physmin = str2num(char(fread(fid,[8,header.numofsignals],'char')')); % ns * 8 ascii : ns * physical minimum (e.g. -500 or 34) 
header.physmax = str2num(char(fread(fid,[8,header.numofsignals],'char')')); % ns * 8 ascii : ns * physical maximum (e.g. 500 or 40) 
header.digimin = str2num(char(fread(fid,[8,header.numofsignals],'char')')); % ns * 8 ascii : ns * digital minimum (e.g. -2048) 
header.digimax = str2num(char(fread(fid,[8,header.numofsignals],'char')')); % ns * 8 ascii : ns * digital maximum (e.g. 2047) 
header.prefilt =cellstr(char(fread(fid,[80,header.numofsignals],'char')')); % ns * 80 ascii : ns * prefiltering (e.g. HP:0.1Hz LP:75Hz) 
header.samplerate = str2num(char(fread(fid,[8,header.numofsignals],'char')')); % ns * 8 ascii : ns * nr of samples in each data record THIS IS NOT SAMPLES PER SECOND; THIS IS SAMPLES PER EPOCH.
reserved = char(fread(fid,[32,header.numofsignals],'char')'); % ns * 32 ascii : ns * reserved
% DATA read; from this point it is numbers only, which are the stream of
% data for a given variable.
Ch_data = fread(fid,'int16'); % read all remaining data in entire file.  
if header.numofepochs<0, % number of data records (-1 if unknown) 
R=sum(header.epochduration*header.samplerate); 
header.numofepochs=fix(length(Ch_data)./R); 
end

% reshape data into a matrix of header.numofepochs columns and however many rows ([]) it takes to generate that many columns of equal length.
Ch_data=reshape(Ch_data, [], header.numofepochs);

% scale set 
sf = (header.physmax - header.physmin)./(header.digimax - header.digimin); 
dc = header.physmax - sf.* header.digimax;
data=cell(1, header.numofsignals); % creates a cell array of empty cells called 'data', that is of dimensions 1 X header.numofsignals. 
%Each of the header.channel variables will be sorted into a header sample rate * duration matrix, in a cell of its own within the data matrix. 
Rs=cumsum([1; (header.epochduration/header.epochduration).*header.samplerate]); 
% '.*' multiplies each element in the matrix header.epochduration by the analogous element in header.samplerate and returns the product to the analogous cell in a novel matrix;
% without the . in '.*', complex matrix calculations involving transposition would be done.
%so now we have a 7X1 matrix with the total # data pts for each physiol parameter. We tack onto the front of the matrix another element containing a value 1 by typing '[1;' in fromt of the calculation.
%This 1 is necessary to act as a starting point for the first of the 8 variables.
%Next make a 8X1 matrix Rs that returns the cumulative sum of the unnamed matrix by cumulating as each element the sum of its value plus all that precede it in the unnamed matrix -> Rs(k):Rs(k+1)-1.
%These values represent the first data point for a given variable in each column of data (representinmg a complete epoch of data) in the matrix known as Ch_data.

for k=1:header.numofsignals % for every channel of data a matrix will be generated and deposited in the cell array data
data{k}=reshape(Ch_data(Rs(k):Rs(k+1)-1, :), [], 1);   %assign to the kth element of the cell array (corresponding to a unique data channel) a matrix that contains   
% scale data 
data{k}=data{k}.*sf(k)+dc(k); 
end
data=cell2mat(data);

