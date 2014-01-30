function [Ch_data,header] = edfread(filename) 
% Read European Data Format file into MATLAB
fid = fopen(filename,'r','ieee-le'); 
% PART1 
hdr = char(fread(fid,256,'uchar')'); 
header.ver=str2num(hdr(1:8)); % 8 ascii : version of this data format (0) 
header.patientID = char(hdr(9:88)); % 80 ascii : local patient identification 
header.recordID = char(hdr(89:168)); % 80 ascii : local recording identification 
header.startdate=char(hdr(169:176)); % 8 ascii : startdate of recording (dd.mm.yy) 
header.starttime = char(hdr(177:184)); % 8 ascii : starttime of recording (hh.mm.ss) 
header.length = str2num (hdr(185:192)); % 8 ascii : number of bytes in header record 
    reserved = hdr(193:236); % [EDF+C ] % 44 ascii : reserved 
header.records = str2num (hdr(237:244)); % 8 ascii : number of data records (-1 if unknown) 
header.duration = str2num (hdr(245:252)); % 8 ascii : duration of a data record, in seconds 
header.channels = str2num (hdr(253:256));% 4 ascii : number of signals (ns) in data record
%%%% PART2 
header.label=cellstr(char(fread(fid,[16,header.channels],'char')')); % ns * 16 ascii : ns * label (e.g. EEG FpzCz or Body temp) 
header.transducer =cellstr(char(fread(fid,[80,header.channels],'char')')); % ns * 80 ascii : ns * transducer type (e.g. AgAgCl electrode) 
header.units = cellstr(char(fread(fid,[8,header.channels],'char')')); % ns * 8 ascii : ns * physical dimension (e.g. uV or degreeC) 
header.physmin = str2num(char(fread(fid,[8,header.channels],'char')')); % ns * 8 ascii : ns * physical minimum (e.g. -500 or 34) 
header.physmax = str2num(char(fread(fid,[8,header.channels],'char')')); % ns * 8 ascii : ns * physical maximum (e.g. 500 or 40) 
header.digimin = str2num(char(fread(fid,[8,header.channels],'char')')); % ns * 8 ascii : ns * digital minimum (e.g. -2048) 
header.digimax = str2num(char(fread(fid,[8,header.channels],'char')')); % ns * 8 ascii : ns * digital maximum (e.g. 2047) 
header.prefilt =cellstr(char(fread(fid,[80,header.channels],'char')')); % ns * 80 ascii : ns * prefiltering (e.g. HP:0.1Hz LP:75Hz) 
header.samplerate = str2num(char(fread(fid,[8,header.channels],'char')')); % ns * 8 ascii : ns * nr of samples in each data record 
reserved = char(fread(fid,[32,header.channels],'char')'); % ns * 32 ascii : ns * reserved
% DATA read
Ch_data = fscanf(fid,'int16',200);
if header.records<0, % number of data records (-1 if unknown) 
R=sum(header.duration*header.samplerate); 
header.records=fix(length(Ch_data)./R); 
end
% reshape data 
Ch_data=reshape(Ch_data, [], header.records);
  
% scale set 
sf = (header.physmax - header.physmin)./(header.digimax - header.digimin); 
dc = header.physmax - sf.* header.digimax;
data=cell(1, header.channels); 
Rs=cumsum([1; header.duration.*header.samplerate]); % index of block data -> Rs(k):Rs(k+1)-1
for k=1:header.channels 
%data{k}=reshape(Ch_data(Rs(k):Rs(k+1)-1, :), [], 1); 
% scale data 
data{k}=data{k}.*sf(k)+dc(k); 
end
% data=cell2mat(data);
