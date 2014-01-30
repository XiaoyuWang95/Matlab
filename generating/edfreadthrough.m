function edfttl()

% edfttl( filename, ttl_filename, desired_filename )
% Integrates an EDF file with TTL annotations and outputs an EDF file
% with all those channels.
% Go to http://www.edfplus.info/specs/edf.html for EDF specifications
% desired_filename is an optional argument that will rename the file.

% if a second argument is passed in, the new file will have that name.
% nargin is the number of input arguments
    [edf_filename, filepath] = uigetfile({'*.edf','European Data Format Files (*.edf)';'*.txt','Text Files (*.txt)';'*.*','All Files'},...
    'Select EDF Data File');
    if edf_filename == 0
        return;
    end
    if filepath == 0
        error('Invalid file path');
    else
        cd(filepath);
    end
    [ttl_filename] = uigetfile({'*.txt','Text Files (*.txt)';'*.edf','European Data Format Files (*.edf)';'*.*','All Files'},...
    'Select Text Annotations File');
    if ttl_filename == 0
        return;'ttl'
        
    else
        [header,channel_data] = edfread(edf_filename);
        ttl_data = grabTTLColumn(ttl_filename);
        Fs = header.samplerate(1)/header.epochduration;
        binary_column = zeros(length(channel_data),1);
        on_length = 10*Fs/1000;
        ttl_data = round(ttl_data*Fs);
        for i=1:length(ttl_data)
            binary_column(ttl_data(i):ttl_data(i)+on_length,1) = 1;
        end
        data = [channel_data,binary_column];
        ncol = length(data(1,:));

        % Header information. If you can parse header information from your
        % .txt file, place the variable names here.
        % Everything must be a string. Put numbers in single quotes or use
        % num2str
        header.version = num2str(header.version);
        header.length = num2str(256+(ncol*256));
        header.reserved44 = ' ';
        numofepochs=header.numofepochs;
        header.numofepochs = num2str(header.numofepochs);
        header.epochduration = num2str(header.epochduration);
        header.numofsignals = num2str(header.numofsignals+1);
        header.reserved32 = ' ';

        % Adds trailing spaces to header variables
        for i=1:8-length(header.version)
            header.version = [header.version,' '];
        end

        for i=1:80-length(header.patientID)
            header.patientID = [header.patientID,' '];
        end

        for i=1:80-length(header.recordID)
            header.recordID = [header.recordID,' '];
        end

        for i=1:8-length(header.length)
            header.length = [header.length,' '];
        end

        for i=1:43  % 43 because header.reserved44 already has a space.
            header.reserved44 = [header.reserved44,' '];
        end

        for i=1:8-length(header.numofepochs)
            header.numofepochs = [header.numofepochs,' '];
        end

        for i=1:8-length(header.epochduration)
            header.epochduration = [header.epochduration,' '];
        end

        for i=1:4-length(header.numofsignals)
            header.numofsignals = [header.numofsignals,' '];
        end

        header.new_labels = '';
        header.new_transducer = '';
        header.new_units = '';
        header.new_phys_min = '';
        header.new_phys_max = '';
        header.new_digi_min = '';
        header.new_digi_max = '';
        header.new_prefilter = '';
        header.new_samples = '';
        for i=1:ncol-1
            label = header.label{i};
            for j=1:16-length(label) % Adds trailing spaces to labels
                label = [label,' '];
            end
            header.new_labels = [header.new_labels,label]; %Concatenates labels into one string as they are constructed

            transducer = header.transducertype{i};
            for j=1:80-length(transducer) % Adds trailing spaces to labels
                transducer = [transducer,' '];
            end
            header.new_transducer = [header.new_transducer,transducer];

            units = header.physdimension{i};
            for j=1:8-length(units)
                units = [units,' '];
            end
            header.new_units = [header.new_units,units];

            phys_min = num2str(header.physmin(i));
            for j=1:8-length(phys_min)
                phys_min = [phys_min,' '];
            end
            header.new_phys_min = [header.new_phys_min,phys_min];

            phys_max = num2str(header.physmax(i));
            for j=1:8-length(phys_max)
                phys_max = [phys_max,' '];
            end
            header.new_phys_max = [header.new_phys_max,phys_max];

            digi_min = num2str(header.digimin(i));
            for j=1:8-length(digi_min)
                digi_min = [digi_min,' '];
            end
            header.new_digi_min = [header.new_digi_min,digi_min];

            digi_max = num2str(header.digimax(i));
            for j=1:8-length(digi_max)
                digi_max = [digi_max,' '];
            end
            header.new_digi_max = [header.new_digi_max,digi_max];

            prefilter = header.prefilt{i};
            for j=1:80-length(prefilter)
                prefilter = [prefilter,' '];
            end
            header.new_prefilter = [header.new_prefilter,prefilter];

            samples = num2str((length(data(:,1)))/numofepochs);
            for j=1:8-length(samples)
                samples = [samples,' '];
            end
            header.new_samples = [header.new_samples,samples];
        end
       header.label = [header.new_labels,'TTL             '];
       header.transducertype = [header.new_transducer,'                                                                                '];
       header.physdimension = [header.new_units,'On/Off  '];
       header.physmin = [header.new_phys_min,'0       '];
       header.physmax = [header.new_phys_max,'1       '];
       header.digimin = [header.new_digi_min,'0       '];
       header.digimax = [header.new_digi_max,'1       '];
       header.prefilt = [header.new_prefilter,'none                                                                            '];
       ttl_sample = num2str(length(data(:,1))/numofepochs);
       for i=1:8-length(ttl_sample)
           ttl_sample = [ttl_sample,' '];
       end
       header.samplerate = [header.new_samples,ttl_sample];

        for j=1:31
            header.reserved32 = [header.reserved32,' '];
        end

        % concatenates header strings
        edfheader = [header.version, header.patientID, header.recordID, header.startdate, header.starttime, header.length, header.reserved44, header.numofepochs, header.epochduration, header.numofsignals, header.label, header.transducertype, header.physdimension, header.physmin, header.physmax, header.digimin, header.digimax, header.prefilt, header.samplerate, header.reserved32];
        %edfheader = [header.version, header.patientID, header.recordID, header.startdate, header.starttime, header.length, header.reserved44, header.numofepochs, header.epochduration, header.numofsignals, header.label, header.transducertype, header.physdimension];
        
        [~,savename,~] = fileparts(edf_filename);
        savename = [savename,' with TTL Channel'];
        [savename, pathname] = uiputfile({'*.edf','European Data Format File (*.edf)'},'Save As',savename);
        if savename == 0 
            return;
        else
            if pathname == 0
                fullname = savename;
            else
                fullname = fullfile(pathname,savename);
            end
            edffid = -1;
            while edffid == -1
                [edffid, message] = fopen(fullname,'w+','ieee-le'); %create the file
                if edffid == -1
                    prompt = ['Other applications are using the file. Please close the file in these applications. Error: ',message];
                    response = questdlg(prompt,'Other application(s) using file','Resume','Cancel','Resume');  % Tell user to close file.
                    if strcmp(response,'Cancel')
                        return;
                    end
                end
            end
            if exist('edffid','var') && edffid ~= -1 % if we successfully opened the new file
                fprintf(edffid,'%s',edfheader);
                fwrite(edffid,data,'int16','l'); %writes the data to the file.
                fclose('all');
                disp('File conversion complete.')
            end
        end

    end





