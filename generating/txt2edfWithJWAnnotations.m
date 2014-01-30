function [] = txt2edfWithJWAnnotations(filename, output_filename)   % '[]' signifies that the function txt2edf will not return any variables to the program that calls it.
                                                    % it does not need to return variables, since its output is a file. 
                                                 
% txt2edf(filename, output_filename);
% Converts a .txt file into an .edf file.
% Because .txt files are not standardized, you will need to create a function
% that outputs a matrix of your data. Header information can be specified
% by replacing the header variables below.
% Go to http://www.edfplus.info/specs/edf.html for EDF specifications
% John Loft wrote this program to convert .mcd text files, which are outputs from the MC_DataTool.
% output_filename is an optional argument that will rename the edf-formatted output file.

% if a second argument is passed in, the new file will have that name.
% Else output_filename will be identical to filename.
% nargin is (a standard matlab function that reports) the number of input arguments
if nargin == 2  % if the number of input arguments is two, the user has specified the desired output filename.
    savename = output_filename;  %the name of the new edf file produced is the second of the arguments 
    if isempty(strfind(savename,'.edf')) %if .edf isn't included in the output_filename, an empty array will be produced.  Isempty is true. 
        savename = [savename,'.edf']; %So if .edf is not present, we must append it onto the output filename.
    end
else  %if no output_filename is specified, the new file will have the original .txt filename
    savename = strrep(filename,'.txt','.edf'); % strrep (string replace) replaces any instance of the chars '.txt' within savename with '.edf'
end

if exist(savename,'file')  % if a file by the name of 'savename' exists, we might not want to overwrite it.
    prompt = [savename,' already exists. Do you want to overwrite the file?']; % 'prompt' is declared as a string variable.
    response = questdlg(prompt,'File exists','Yes','No','No');  % Open a question dialog box (questdlg) with a title ('File exists') and a question (prompt). 
                                                                %Gives yes and no as choices and makes no the default if one hits enter. 
    if strcmp(response,'Yes') %strcmp compares the strings 'Yes' and response.
        try % try to overwrite the edf file.  It may already be open, in which case we cannot overwrite it. 
            edffid = fopen(savename,'w+','ieee-le'); %fopen creates the file 'savename' in writable mode ('w+') using 7-bit encryption ('ieee-le')  
        catch err %If the attempt, on the previous line, to create a new file fails, it is because the file is open and cannot be overwritten.  
            error('Make sure to close all programs using the file you want to convert.');  %prompt the user to close the open file so that it may be overwritten.
                                                                                           %The program will still crash but at least we are given a reason why.
        end
    end
else % if the new file does not exist
        edffid = fopen(savename,'w+','ieee-le'); %create the file 'savename' in writable mode ('w+') using 7-bit encryption ('ieee-le')
end

if exist('edffid','var') % if we successfully opened the new file, edffid exists as a variable.
    try
        txtfid = fopen(filename); % open the text file, assigning to a variable named txtfid the name of the textfile, and opening it to be read. 
    catch err
        error('The txt file could not be opened. Check your filename and working directory.'); %if no such textfile exists, the program will crash, but at least we know the source of the error.
    end
    
    % <!--
    % These lines are specific to .txt files converted from .mcd files (MC_DataTool).
    % Edit the lines using textscan to retrieve data from your .txt file
    % and return a matrix.
    
    textscan(txtfid,'%s',2,'delimiter','\n');  %Read through the first 2 lines of the file txtfid (= filename.txt).  Because textscan is not associated with a variable here, it is just a readthrough.
    head = textscan(txtfid,'%s',2,'delimiter','\n');  %Head is declared as a cell array.  A cell array is an array of strings.  Here, textscan assigns to head two strings.
    %The two strings are information in lines 3-4 of the txt file.  They are delineated  by return keys ('\n') in the file.
    %'txtfid' tells textscan the file to read from. '%s'tells it that it is reading strings.  2 tells it to do so over two iterations.
    %'Delimiter tells it that the next parameter will specify the delimiter that signifies the end of each string. '\n' is the hidden char for the end of a line. 

    % EDIT numberofcolumns to match the number of columns in your data set.
    numberofcolumns = length(sscanf(head{1}{2},'%s'))/4;  %This line infers the number of columns in your MC_DataTool data set txt file  
    % based on the total number of characters in the fourth line of the txt file.  Head {1} designates head as a readable cell array.  
    %Head{1}{2}specifies that the function referring to head should read the second item in head.
    %This second item in head is the fourth line of the txt file, which contains the labels for the subsequent data columns.  
    % 'sscanf', a function that reads a cell array and converts it to a string, therefore extracts this second item in head
    %and outputs it as a string.  'length' reports the number of chars in that string.  
    %Because MC_Rack gives each column a 4-char label, one can divide the length of the string on line 4 by 4 to get the number of columns. 
    
    format = ''; %initializes a variable 'format' as an empty string (two single quotes together with no space in between).
    for i=1:numberofcolumns
        format = [format, '%f '];   %Creates the format specifier string for textscan.  For instance, if there are 9 data columns (as in our case) it will be '%f %f %f %f %f %f %f %f %f '.  
                                    %Each %f denotes a floating point number.  So we are informing textscan that each line of data being collected
                                    %is a series of 9 floating point numbers.
    end
    
    matrix = textscan(txtfid,format,600000,'CollectOutput',1); %uses textscan to grab the first 600000 rows of the .txt document and place them in the cell array 'matrix'
    % txtfid is the input file. Format is the string that specifies # of floating point numbers per line of matrix.  6000000 is number of iterations.
    % CollectOutPut is a standard parameter that confirms that we want to save the output of textscan.  '1' is a boolean that turns CollectOutput' on.
    
    matrix = matrix{1};   %Converts 'matrix' from a cell array to a matrix of floating-point numbers.  Now it can be processed mathematically. 
    hertz = 1/(matrix(2,1)-matrix(1,1))*1000;  %calculate sampling rate as the variable hertz.  It is calculated from the first data column, which has the time in milliseconds.  
    %matrix point 2,1 is row 2 column 1, the second time point in the data set. matrix point 1,1 is row 1 column 1, the first time point in the data set.
    %Subtract point 1 from point 2 and you have the time lapsed in ms
    %between samples.  Take the inverse and you have the number of samples per msec.  Multiply by 1000 to get number of samples per sec, or Hz. 
    matrix_length = 0;  % Matrix length will eventually tell us the total duration of the file. It must be initialized every time we output a file. 
    
    %-->
    
    % This while loop is only necessary for large datasets.
    
    while ~isempty(matrix) % the tilda '~' is the Matlab equivalent of NOT.  SO this loop will be active only when the matrix is not empty.
                           % DOES EMPTY REFER TO THE ENTIRE MATRIX OR THE INDIVIDUAL CELL FROM WHICH THE DATA ARE BEING READ?
                           % COULD THIS BE DONE AS AN IF STATEMENT? UNDER WHAT CIRCUMSTANCE WOULD MATRIX BE EMPTY?
       
        data = ones(1,(numberofcolumns-1)*length(matrix(:,1)));  % Preallocates a data vector of one row and (# of EEGs times # of samples) and populates it with ones.
        k = 1;  % k is the count for the number of times through this while loop.  Note that this calculation excludes the time stamp column by intention.
           %nested for loops travel down each column of the data matrix, top to bottom, left to right. 'data' becomes one long array that will be converted into a binary string.
       
        for i = 2:length(matrix(1,:))     % i travels across the columns from the first LFP data point in the matrix (starting at 2 skips the time stamp) to the last LFP point.    
            for j = 1:length(matrix(:,1)) % j travels down the rows within each column from the top of the column to the last data point. 
                data(1,k) = matrix(j,i);  % the data at point k of the linear matrix data are given the values of all LFP data points from row 1 col 2 down through the last row and column.
                k = k+1;                  % the counter K is incremented with each read of the matrix. 
            end
        end
        
        try
            fwrite(edffid,data,'int16','l');  %will write the LFP data to edffid with 16-bit integer precision ('int16') and writes binary data in little endian ordering ('l').  
        catch err                               
            error('Make sure to close all programs using the file you want to convert.');
        end
        
        matrix_length = matrix_length + length(matrix(:,1)); %The matrix length is calculated based on the length of one column of the matrix.  
            %The first time through this loop, the length of the matrix before the loop is measured.  The last time through, it reflects the length of the truncated matrix.         
        matrix = textscan(txtfid,format,600000,'CollectOutput',1); %grabs the next 600000 rows of the .txt document.  
                          %If there are no longer 600000 lines left to read, it takes as many as it can and truncates the size of matrix.
        matrix = matrix{1};  %Converts 'matrix' from a cell array to a matrix of floating-point numbers.  Now it can be processed mathematically.
    end       
    
    stringformat = strrep(format,'%f ','%s ');  %line added by JW to convert the floating point characters in the string 'format' to string characters.
    %'strrep is  the string replace function.  Here it will replace all instances of '%f ' with '%s ' in format.  The results are stored as 'stringformat' 
    
    colunits = textscan(head{1}{2},stringformat,'delimiter',' ');  %Textscan is used to populate the cell array 'colunits'.
    %textscan has 4 parameters here. String item 2 of head (line 4 of input column) is the text to be scanned.  Stringformat tells textscan to
    %read the data from that line as a series of strings delimited by ' '.
    
    for i=1:numberofcolumns
        colunits{i}(cellfun(@isempty,colunits{i})) = [];    %Deletes blank values in the colunits matrix.  
    % @Isempty asks for its argument whether that argument is an empty array.  It returns a boolean 1 (empty) or 0 (not empty). 
    % cellfun applies the isempty function ('@isempty') serially to each container within colunits ('colunits{i}').
    % cellfun will output the position of the empty array.  By referring to this position and assigning a null to it, this command makes that array disappear.  
    
    end

    % The structured array header contains the header information that must be present in order to conform with edf format.  
    %If you can parse header information from your .txt file, place the variable names here.
    % Everything must be a string. Put numbers in single quotes or use
    % num2str
    header.version = '0';
    header.patientinfo = 'Unknown';
    header.recordid = 'Unknown';
    header.startdate = '01.01.00';
    header.starttime = '01.00.00';
    header.bytes = num2str(256+((numberofcolumns-1)*256));
    header.reserved44 = ' ';
    header.numofrecords = '1';
    header.duration = num2str(matrix_length/hertz);
    header.numofsignals = num2str(numberofcolumns-1);
    header.transducertype = 'Pinnacle 4000';
    header.physdimension = 'uV';
    header.physmin = '-819';
    header.physmax = '819';
    header.digmin = '-1';
    header.digmax = '1';
    header.prefilter = 'HP:0.1Hz LP:75Hz';
    header.numofsamples = num2str(matrix_length);
    header.reserved32 = ' ';

    duration = header.duration;
    
    % Adds trailing spaces to header variables so that they are precisely the correct size.
    for i=1:8-length(header.version)
        header.version = [header.version,' '];
    end

    for i=1:80-length(header.patientinfo)
        header.patientinfo = [header.patientinfo,' '];
    end

    for i=1:80-length(header.recordid)
        header.recordid = [header.recordid,' '];
    end

    for i=1:8-length(header.bytes)
        header.bytes = [header.bytes,' '];
    end

    for i=1:43  % 43 because header.reserved44 already has a space.
        header.reserved44 = [header.reserved44,' '];
    end

    for i=1:8-length(header.numofrecords)
        header.numofrecords = [header.numofrecords,' '];
    end

    for i=1:8-length(header.duration)
        header.duration = [header.duration,' '];
    end

    for i=1:4-length(header.numofsignals)
        header.numofsignals = [header.numofsignals,' '];
    end

    header.label = ''; 
    for i=1:numberofcolumns-1
        label = ['EEG ',num2str(i)]; %Concatenates label with the value of i to number EEGs
        for j=1:16-length(label) % Adds trailing spaces to labels
            label = [label,' '];
        end
        header.label = [header.label,label]; %Concatenates labels into one string as they are constructed
    end

    % Trailing spaces
    for j=1:80-length(header.transducertype)
        header.transducertype = [header.transducertype,' '];
    end

    for i=1:8-length(header.physdimension)
        header.physdimension = [header.physdimension, ' '];
    end

    for j=1:8-length(header.physmin)
        header.physmin = [header.physmin,' '];
    end

    for j=1:8-length(header.physmax)
        header.physmax = [header.physmax,' '];
    end

    for j=1:8-length(header.digmin)
        header.digmin = [header.digmin,' '];
    end

    for j=1:8-length(header.digmax)
        header.digmax = [header.digmax,' '];
    end

    for j=1:80-length(header.prefilter)
        header.prefilter = [header.prefilter,' '];
    end

    for j=1:8-length(header.numofsamples)
        header.numofsamples = [header.numofsamples,' '];
    end

    for j=1:31
        header.reserved32 = [header.reserved32,' '];
    end

    % Placeholder variables are created in order to add a single header item for the subsection of header corresponding to each data column.
    h.tr = header.transducertype;
    h.pdm = header.physdimension;
    h.pmi = header.physmin;
    h.pma = header.physmax;
    h.dmi = header.digmin;
    h.dma = header.digmax;
    h.pf = header.prefilter;
    h.nos = header.numofsamples;
    h.r = header.reserved32;

    % In EDF, these parameters must be repeated for every column of data. The placeholders (h._) hold a single copy of the contents of
    % header._.  If one were to concatenate header._ onto itself in the following for loop, it would progressively double in size rather than
    % adding a single copy of itself.
    %This for loop will only work if all variables are uniform with respect to their header information.
    
    for i=1:numberofcolumns-2
        header.transducertype = [header.transducertype, h.tr];
        header.physdimension = [header.physdimension, h.pdm];
        header.physmin = [header.physmin, h.pmi];
        header.physmax = [header.physmax, h.pma];
        header.digmin = [header.digmin, h.dmi];
        header.digmax = [header.digmax, h.dma];
        header.prefilter = [header.prefilter, h.pf];
        header.numofsamples = [header.numofsamples, h.nos];
        header.reserved32 = [header.reserved32, h.r];
    end

    % concatenates header strings
    edfheader = [header.version, header.patientinfo, header.recordid, header.startdate, header.starttime, header.bytes, header.reserved44, header.numofrecords, header.duration, header.numofsignals, header.label, header.transducertype, header.physdimension, header.physmin, header.physmax, header.digmin, header.digmax, header.prefilter, header.numofsamples, header.reserved32];

    frewind(edffid) % moves the pointer (the point at which anything written to the file will be written) to the beginning of the edf file.
    try
        fprintf(edffid,edfheader);  
    catch err
        error('Make sure the file you want to convert is closed in all other programs.');
    end

    fclose('all');

end



