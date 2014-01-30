function [] = UltraSpectrogram(files)

    if nargin < 1
        [files,path] = uigetfile({'*raw','Binary MCS Files (*.raw)';'*.*','All Files';'*.edf','EDF Files (*.edf)';'*.txt','Text Files (*.txt)';},... % Open the user interface for opening files
        'Select Data File(s)','MultiSelect','On');
    end
    
    if ~iscell(files)
        if isequal(files,0)
            return;
        end
        % Turns the filename into a cell array
        % so the subsequent for loop works.
        file = files;
        files = cell(1,1);
        files{1} = file;
    end

    
    % Ask if the user wants to smooth the data.
    response = questdlg('Smooth drift in signal?','User Input Required','Yes','No','Yes');
    if strcmp(response,'Yes')
        smoothState = 1;
    else
        smoothState = 0;
    end

    % Ask if the user wants high frequency noise reduction
    % MAKE FILTER DESIGN WINDOW
    response = questdlg('Filter high frequency noise?','User Input Required','Yes','No','Yes');
    if strcmp(response,'Yes')
        filterState = 1;
    else
        filterState = 0;
    end

    % Ask if the user wants to remove artifacts
    response = questdlg('Remove artifacts?','User Input Required','Yes','No','Yes');
    if strcmp(response,'Yes')
        artifactState = 1;
    else
        artifactState = 0;
    end

    processSameChannel = 0;
    for i = 1:length(files)
         [matrix, format, fs] = retrieveData(files{i},path);
         [~,~,ext] = fileparts(files{i});
         if processSameChannel == 0 % If we need to know which channels to process
            if strcmp(ext,'.edf') 
                ttlIndex = find(ismember(format.label,'TTL'))+1; % Find TTL column
                format.label(ttlIndex-1) = []; % Remove TTL from selectable channels
                [channelIndex,processSameChannel] = ChannelSelectDialog(format.label); % Open Dialog to select channel
                units = format.units(channelIndex);
                units = units{1};
                channelIndex = channelIndex + 1; % Offset the selected channel from the time column
            elseif strcmp(ext,'.txt')
                % MAKE TTL AND EEG SELECTION MORE ROBUST/RELIABLE
                offset = 0;
                channelSelectLabel = format.label;
                if ~isempty(ismember(format.label,'t'))
                    offset = 1;
                    channelSelectLabel(ismember(channelSelectLabel,'t')) = []; % Remove the time label from selectable channels           
                    channelSelectLabel(ismember(channelSelectLabel,'%t')) = [];
                end
                if ~isempty(strfind(channelSelectLabel,'Di'))
                    ttlIndex = find(not(cellfun('isempty', strfind(channelSelectLabel,'Di D1 00'))))+offset;
                    offset = offset + length(cell2mat(strfind(channelSelectLabel,'Di')));
                    channelSelectLabel(not(cellfun('isempty', strfind(channelSelectLabel,'Di')))) = [];
                end
                [channelIndex,processSameChannel] = ChannelSelectDialog(channelSelectLabel);
                channelIndex = channelIndex + offset; % offset from ttl column
                units = 'mV';
             elseif strcmp(ext,'.raw')
                offset = 0;
                channelSelectLabel = format.label;
                if ~isempty(ismember(format.label,'t'))
                    offset = 1;
                    channelSelectLabel(ismember(channelSelectLabel,'t')) = []; % Remove the time label from selectable channels           
                    channelSelectLabel(ismember(channelSelectLabel,'%t')) = [];
                end
                if ~isempty(strfind(channelSelectLabel,'Di'))
                    ttlIndex = find(not(cellfun('isempty', strfind(channelSelectLabel,'Di_D1_00'))))+offset;
                    if isempty(ttlIndex)
                        ttlIndex = find(not(cellfun('isempty', strfind(channelSelectLabel,'Di_D1'))))+offset;
                    end
                    offset = offset + length(cell2mat(strfind(channelSelectLabel,'Di')));
                    channelSelectLabel(not(cellfun('isempty', strfind(channelSelectLabel,'Di')))) = [];
                end
                [channelIndex,processSameChannel] = ChannelSelectDialog(channelSelectLabel);
                channelIndex = channelIndex + offset; % offset from ttl column
                units = 'mV';
            end
         end
         type = format.label(channelIndex);
         type = type{1};
         if processSameChannel == -1
             disp('Processing aborted.')
             return;
         end

         time = matrix(:,1);
         data = matrix(:,channelIndex);
         ttl = matrix(:,ttlIndex);
         

         if smoothState == 1
             disp('Smoothing data...')
             data = movingSmoothing(data,150);
         end

         if filterState == 1
            disp('Filtering data...');
            data = filter60Hz(data);       
         end
         eeg = data;

        set(0,'Units','pixels') 
        scnsize = get(0,'ScreenSize');
        scnsize(1) = 10;
        scnsize(2) = 40;
        scnsize(3) = scnsize(3)-20;
        scnsize(4) = scnsize(4)-50;
        ultraSpecFig = figure;
        set(ultraSpecFig,'OuterPosition',scnsize);

        range = 1:length(eeg);
        fs = 500;
        windowlength = 10;
        overlaplength = 9;
        window = fs*windowlength;
        overlap = fs*overlaplength;
        F = .1:.1:12;
        hold off;
        ax(1) = subplot(2,1,1);
        subplot(2,1,1),plot(time(range),eeg(range));
        hold on
        subplot(2,1,1),plot(time(range),ttl(range).*55.5,'k');
        xlabel('Time (s)');
        ylabel('Amplitude (mV)');
       


        disp('Calculating spectogram. Please retain patience. I am doing billions of calculations for you.');
        functionTime = tic;
        [y,f,t,p] = spectrogram(eeg(range),window,overlap,F,fs,'yaxis'); 
        ax(2) = subplot(2,1,2);
        subplot(2,1,2),surf(t,f,10*log(abs(p)),'EdgeColor','none');
        toc(functionTime);
        title(['Spectrogram of ''',files{i},''' with a ', num2str(windowlength),' second window and ', num2str(overlaplength), ' second overlap length.'])
        xlabel('Time (s)');
        ylabel('Frequency (Hz)');
        zlabel('Magnitude');
        linkaxes(ax,'x');
        view(0,90);
        view([0,-90,75]);
        view([-90,0,75]);
        view([-45,-45,75]);

    end
end
%subplot(2,1,2),spectrogram(eeg(range),window,overlap,F,fs,'yaxis'); 
% xlabel('Time (s)');
% ylabel('Frequency (Hz)');

