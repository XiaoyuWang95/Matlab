function [] = txt2edf()
% txt2edf(filename, desired_filename);
% Converts a .txt file into an .edf file (European Data Format).
% As is, converts .txt files from MC_DataTool that were originally
% .mcd files.
% Because .txt files are not standardized, you will need to create a function
% that outputs a matrix of your data. Header information can be specified
% by replacing the header. variables below.
% Go to http://www.edfplus.info/specs/edf.html for EDF specifications
% desired_filename is an optional argument that will rename the file.

% if a second argument is passed in, the new file will have that name.
% nargin is the number of input arguments

[filename] = uigetfile({'*.txt','Text Files (*.txt)';'*.*','All Files'},... % Open the user interface for opening files
'Select MCD Text Data File(s)','MultiSelect','on');
if ~iscell(filename)
    if length(filename) <= 1 && filename == 0
        return;
    end
    file = filename;
    filename = cell(1,1);
    filename{1} = file;
end

bar = waitbar(1/(length(filename)*20),'Opening files');
for l = 1:length(filename)
    [~,name,~] = fileparts(filename{l});
    savename = [name,'.edf'];
    edffid = -1;
    while edffid == -1
        [edffid, message] = fopen(savename,'w+','ieee-le'); % create the file
        if edffid == -1
            prompt = ['Other applications are using the file. Please close the file in these applications. Error: ',message];
            response = questdlg(prompt,'Other application(s) using file','Resume','Cancel Conversion','Resume');  % Tell user to close file.
            if strcmp(response,'Cancel Conversion')
                return;
            end
        end
    end

    if exist('edffid','var') && edffid ~= -1 % if we successfully opened the new file
        waitbar(1/(length(filename)*10)+(l-1)/length(filename),bar,['Calculating file size of ',filename{l}]);
        matrix_length = str2double(perl('countlines.pl',filename{l}))-4;
        try
            txtfid = fopen(filename{l}); % open the text file
        catch err
            error('The text file could not be opened. Check your filename and working directory.');
        end

        % <!--
        % These lines are specific to .txt files converted from .mcd files (MC_DataTool).
        % Edit the lines using textscan to retrieve data from your .txt file
        % and return a matrix.

        title = textscan(txtfid,'%s',2,'delimiter','\n');  %Skips the first 2 lines of the document
        if ~strcmp(title{1}{1},'MC_DataTool ASCII conversion')
            beep;
            warning([filename{l},' does not appear to have MC_DataTool ASCII formatting. File conversion skipped.']);
            continue;
        end
        head = textscan(txtfid,'%s',2,'delimiter','\n');  %Retrieves unit information in 2nd two lines

        
        % EDIT ncol to match the number of columns in your data set.
        ncol = length(sscanf(head{1}{2},'%s'))/4;  %number of columns. Each unit column has four characters.
        format = '';
        for i=1:ncol
            format = [format, '%f '];   %Creates the format specifier for textscan
        end
        
        waitbar(1/(length(filename)*8)+(l-1)/length(filename),bar,['Determining sampling frequency of ',filename{l}]);
        matrix = textscan(txtfid,format,1001,'CollectOutput',1); %grabs the first 5000 rows of the .txt document
        matrix = matrix{1};
        hertz = ones(1000,1);
        for i = 1:1000
            hertz(i) = matrix(i+1,1)-matrix(i,1);   % determine the sampling frequency.
        end
        hertz = mean(hertz);
        hertz = round(1/hertz*1000);


        %-->
        waitbar(1/(length(filename)*7)+(l-1)/length(filename),bar,['Creating header information of ',filename{l}]);
        colunits = textscan(head{1}{2},strrep(format,'%f ','%s '),'delimiter',' ');    %Uses 'format' to create a format specifier with strings to pick out units.
        for i=1:ncol
            colunits{i}(cellfun(@isempty,colunits{i})) = [];    %Deletes blank values in the colunits matrix
        end

        % Header information. If you can parse header information from your
        % .txt file, place the variable names here.
        % Everything must be a string. Put numbers in single quotes or use
        % num2str
        header.version = '0';
        header.patientinfo = 'Unknown';
        header.recordid = 'Unknown';
        header.startdate = '01.01.00';
        header.starttime = '01.00.00';
        header.bytes = num2str(256+((ncol-1)*256));
        header.reserved44 = ' ';
        header.numofrecords = num2str(round(matrix_length/(10*hertz)));
        header.duration = '10';
        header.numofsignals = num2str(ncol-1);
        header.transducertype = 'Pinnacle 4000';
        header.physdimension = 'uV';
        header.physmin = '-819';
        header.physmax = '819';
        header.digmin = '-1';
        header.digmax = '1';
        header.prefilter = 'HP:0.1Hz LP:75Hz';
        header.numofsamples = num2str(hertz*10);
        header.reserved32 = ' ';


        % Adds trailing spaces to header variables
        for i=1:8-length(header.version)
            header.version = [header.version,' '];
        end

        for i=1:80-length(header.patientinfo)
            header.patientinfo = [header.patientinfo,' '];
        end

        for i=1:80-length(header.recordid)
            header.recordid = [header.recordid,' '];
        end

        zero_string = '';
        for i=1:8-length(header.bytes)
            zero_string = [zero_string,'0'];
        end
        header.bytes = [zero_string,header.bytes];

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
        for i=1:ncol-1
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

        % Placeholder variables, because the header. subvariables are about to
        % grow in length.
        h.tr = header.transducertype;
        h.pdm = header.physdimension;
        h.pmi = header.physmin;
        h.pma = header.physmax;
        h.dmi = header.digmin;
        h.dma = header.digmax;
        h.pf = header.prefilter;
        h.nos = header.numofsamples;
        h.r = header.reserved32;

        % In EDF, these parameters must be repeated for every column of data.
        for i=1:ncol-2
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
       
        waitbar(1/(length(filename)*6)+(l-1)/length(filename),bar,['Saving header information of ',filename{l}]);
        go = 0;
        while go == 0
            try
                fprintf(edffid,edfheader);
                go = 1;
            catch err
                prompt = [err.message,'Other applications may be using the file. Please close the file in these applications.'];
                response = questdlg(prompt,'Other application(s) using file','Resume','Cancel Conversion','Resume');  % Tell user to close file.
                if strcmp(response,'Cancel Conversion')
                    return;
                end
                go = 0;
            end
        end
        
        waitbar(1/(length(filename)*5)+(l-1)/length(filename),bar,['Extracting matrix of ',filename{l}]);
        frewind(txtfid);
        textscan(txtfid,'%s',4,'delimiter','\n');
        matrix = textscan(txtfid,format,hertz*10,'CollectOutput',1); %grabs the next 600000 rows of the .txt document
        matrix = matrix{1};   %Data matrix
        % This while loop is necessary for large datasets.
        nloops = matrix_length/(hertz*10);
        j = 1;
        while ~isempty(matrix)
            waitbar(((4/5)*j/(length(filename)*nloops))+1/(length(filename)*5)+(l-1)/length(filename),bar,['Retrieving ASCII matrix in ',filename{l}]);
            data = reshape(matrix(:,2:ncol),[],1);
            fwrite(edffid,data,'int16','l'); %writes the data to the file.      
            matrix = textscan(txtfid,format,hertz*10,'CollectOutput',1); %grabs the next 600000 rows of the .txt document
            matrix = matrix{1};   %Data matrix
            j = j+1;
        end       

        fclose('all');     
    end
    disp(['File conversion of ',filename{l},' complete.'])   
end
if ishandle(bar)
    close(bar);
end

end



