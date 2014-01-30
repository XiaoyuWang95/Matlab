classdef DisplayManager < handle
    % managing the display control
    properties (SetAccess = 'private', GetAccess = 'public')
        % Plot Handle
        figHandle = [];
        oldCloseFcn;
        
        % Displays
        hMemDispAxes;
        hMemDataLine;
        hCpuDispAxes;
        hCpuDataLine;
        
        % Command Line Display
        hCommandHistoryLabel;        
        
        % buttons        
        hTimeThrinkBtn;
        hTimeExtendBtn;
        
        % Text control
        hMeasureTimeLength;      
                
        hTimeMeasureEdit;
        hCPUMeasureEdit;
        hMemoryMeaureEdit;
        
        % Sys Info Display
        hMachineNameEdit;
        % Operating System
        hOsNameEdit;
        % The Processor information(number and speed)
        hCpuInfoEdit;
        % total Memmory in double(Unit is the same as hMemoryMeasureEdit)
        hMaxMemEdit;
        % matlab ver
        hReleaseVerEdit;
            
        % control buttons
        hStartMeaureBtn;    
    end
    
    properties (SetAccess = 'private', GetAccess = 'public')
        % Measurement
        measureTimeLength = 60; %Units: second
        updatePeriod = 0.5;   %Units: second
        maxDynamicTimeLength = 600; %Units: second
    end
    
    events
        onDelete;
        onStartEngine;
        onStopEngine;
    end
    
    methods
        function dmObj = DisplayManager(figTitle, maxMeasureTime)
            if nargin > 1
                if isnumeric(maxMeasureTime) && maxMeasureTime > 0 && maxMeasureTime < inf
                    dmObj.maxDynamicTimeLength = maxMeasureTime;
                else
                    % TODO, throw exception
                    fprintf('2nd input argument must be positive number\n');
                end
            end
            if nargin == 0 || isempty(figTitle)
                figTitle = 'Display';
            elseif ~ischar(figTitle)
                % Title must be a string
                errorObj = MException('DisplayManager:WrongTitle', 'first input argument must be a string');
                errorObj.throw;
            end
            dmObj.figHandle = figure('DockControls', 'on', 'NumberTitle', 'off', 'Handlevisibility', 'off', ...
                                     'IntegerHandle', 'off', 'ToolBar', 'none', 'Name', figTitle, 'visible', 'off', ...
                                     'NextPlot','add');                                 
            dmObj.centralizePlot();
            dmObj.initialPlot(); 
            dmObj.updateXLim();
            
            % save the original close function of figure
            dmObj.oldCloseFcn = get(dmObj.figHandle, 'CloseRequestFcn');
            set(dmObj.figHandle, 'CloseRequestFcn', @(src, event)delete(dmObj));
            
            % display the figure
            set(dmObj.figHandle, 'visible', 'on');            
        end
        
        function delete(dmObj)            
            
            notify(dmObj, 'onDelete');
            if ishandle(dmObj.figHandle)
                set(dmObj.figHandle, 'CloseRequestFcn', 'closereq');
                close(dmObj.figHandle);
            end
            fprintf('done\n');
        end
    end
    methods
        function centralizePlot(dmObj)
            figWidth = 900;
            figHeight = 600;            
            
            %%-----------begin of work around--------------%%
            % tempory use the default start point
            defaultPosition = get(dmObj.figHandle, 'Position');
            figX = defaultPosition(1)/2;
            figY = defaultPosition(2)/2;
            %%-----------end of work around--------------%%
            set(dmObj.figHandle, 'Position', [figX, figY, figWidth, figHeight]);
        end        
        
        function initialPlot(dmObj)
            bgColor = get(dmObj.figHandle, 'Color');
            edgePercent = .005;
            % Main panel
            hMain = uipanel('Parent', dmObj.figHandle, 'BackgroundColor',bgColor, 'Position',[edgePercent, edgePercent, 1-edgePercent*2, 1-edgePercent*2]);
            
            %% Main Display %%
            displayPercent = 0.7;
            statusMsgHeightPercent = 0.2;            
            dmObj.hCommandHistoryLabel = createUiData('...', hMain);
            set(dmObj.hCommandHistoryLabel, 'style', 'text', 'BackgroundColor', 'white', 'HorizontalAlignment', 'left', 'Position', [edgePercent, edgePercent, displayPercent-2*edgePercent, statusMsgHeightPercent-2*edgePercent]); 
            
            % Display panel
            yDispPos = edgePercent + statusMsgHeightPercent;
            yDispHeight = 1-2*edgePercent - statusMsgHeightPercent;
            hDisplay = uipanel('Parent', hMain, ...
                'BackgroundColor',bgColor*0.8, 'bordertype', 'beveledin', ...
                'Position',[edgePercent, yDispPos, displayPercent-2*edgePercent, yDispHeight]);
            
            % Display Axes            
            plotEdge = 0.1;
             % define color
            memColor = 'b';
            cpuColor = 'r';
            timeColor = 'k';
            frontColor = 'k';
            lineWidth = 2.5;
            
            dmObj.hMemDispAxes = axes('Parent', hDisplay, 'position',[plotEdge, plotEdge, 1-2*plotEdge, 1-2*plotEdge]);            
            set(dmObj.hMemDispAxes, 'Box', 'on', 'XGrid', 'on', 'YGrid', 'on',...
                                  'Ycolor', memColor, 'XColor', timeColor, 'Color', frontColor);
            % Create second axes            
            dmObj.hCpuDispAxes = axes(...
                'HandleVisibility',  get(dmObj.hMemDispAxes,'HandleVisibility'), ...
                'Units',             get(dmObj.hMemDispAxes,'Units'), ...
                'Position',          get(dmObj.hMemDispAxes,'Position'), ...
                'Parent',            get(dmObj.hMemDispAxes,'Parent'), ...
                'YColor',            cpuColor, ...
                'YAxisLocation',     'right',...
                'Color',             'none', ...
                'XGrid','off','YGrid','off','Box','off', ...
                'XTickLabel', '', 'YLim', [0, 100]);            
            
            % set xlabel and ylabel
            xlabel(dmObj.hMemDispAxes, 'Time(seconds)');
            ylabel(dmObj.hMemDispAxes, 'Memory(MB)');            
            ylabel(dmObj.hCpuDispAxes, 'CPU Used (%)');            
            
            dmObj.hMemDataLine = line('Parent', dmObj.hMemDispAxes, 'XData', 1, 'YData', 0);
            set(dmObj.hMemDataLine, 'Color', memColor, 'LineWidth', lineWidth);            
            
            dmObj.hCpuDataLine = line('Parent', dmObj.hCpuDispAxes, 'XData', 1, 'YData', 0);
            set(dmObj.hCpuDataLine, 'Color', cpuColor, 'LineWidth', lineWidth);
            
            % title object for total measurement time length
            dmObj.hMeasureTimeLength = title(dmObj.hMemDispAxes, '',  ...
                                 'Color', get(dmObj.hMemDispAxes, 'XColor'), 'FontSize', 10);
            updateTitle(dmObj);
            
            % Thrink/Extend button for measurement window length
            dmObj.hTimeThrinkBtn = uicontrol('Parent', hDisplay, 'style', 'pushbutton', 'String', '==> <==', ...
                'BackgroundColor', [205, 224, 247]/255, 'ForegroundColor', 'b',   ...
                'Units', 'normalized', 'Position', [0.1, 0.005, 0.15, 0.05], ...
                'TooltipString', sprintf('Left click for normal speed,\n right click for fast speed'), ...
                'callback', @(src, event)thrinkMeasureTime(dmObj, 'normal'), ...
                'ButtonDownFcn', @(src, event)thrinkMeasureTime(dmObj, 'fast'));
            dmObj.hTimeExtendBtn = uicontrol('Parent', hDisplay, 'style', 'pushbutton', 'String', '<== ==>', ...
                'BackgroundColor', [205, 224, 247]/255, 'ForegroundColor', 'b',   ...
                'Units', 'normalized', 'Position', [0.75, 0.005, 0.15, 0.05], ...
                'TooltipString', sprintf('Left click for normal speed,\n right click for fast speed'), ...
                'callback', @(src, event)extendMeasureTime(dmObj, 'normal'), ...
                'ButtonDownFcn', @(src, event)extendMeasureTime(dmObj, 'fast'));
            
            %% Control panel %%
            controlPercent = 1-displayPercent;
            hControl = uipanel('Parent', hMain, 'BorderType', 'none', ...
                'BackgroundColor',bgColor, ...
                'Position',[displayPercent + edgePercent, edgePercent, controlPercent-2*edgePercent, 1-2*edgePercent]);
                                 
            
            PerfDispHeightPercent = 0.35;
            
            % Panel for detailed info display            
            hPerformanceInfoDisplay = uipanel('Parent', hControl, 'Title', 'Performance Details', ...
                'BackgroundColor',bgColor, ...
                'Position',[edgePercent, 1-PerfDispHeightPercent + edgePercent, 1-2*edgePercent, PerfDispHeightPercent-2*edgePercent]);
            
            widgetHeightPercent = 1/3;
            % Time Display                       
            hTimeMeasureLabel = createUiLabel('Time:', hPerformanceInfoDisplay);
            set(hTimeMeasureLabel, 'Position', [edgePercent, 1-widgetHeightPercent+edgePercent, 1/2-2*edgePercent, widgetHeightPercent-2*edgePercent]); 
            
            dmObj.hTimeMeasureEdit = createUiData('12:00:00', hPerformanceInfoDisplay);
            set(dmObj.hTimeMeasureEdit, 'Position', [1/2+edgePercent, 1-widgetHeightPercent+edgePercent, 1/2-2*edgePercent, widgetHeightPercent-2*edgePercent]);
                        
            % CPU display
            hCpuMeasureLabel = createUiLabel('CPU (%):', hPerformanceInfoDisplay);
            set(hCpuMeasureLabel, 'Position', [edgePercent, 1-2*widgetHeightPercent+edgePercent, 1/2-2*edgePercent, widgetHeightPercent-2*edgePercent]);
            
            dmObj.hCPUMeasureEdit = createUiData('0%', hPerformanceInfoDisplay);
            set(dmObj.hCPUMeasureEdit, 'Position', [1/2+edgePercent, 1-2*widgetHeightPercent+edgePercent, 1/2-2*edgePercent, widgetHeightPercent-2*edgePercent]);
            
            
            % Memory Display
            hMemoryMeasureLabel = createUiLabel('Memory (MB):', hPerformanceInfoDisplay);
            set(hMemoryMeasureLabel, 'Position', [edgePercent, 1-3*widgetHeightPercent+edgePercent, 1/2-2*edgePercent, widgetHeightPercent-2*edgePercent]);
            
            dmObj.hMemoryMeaureEdit = createUiData('0', hPerformanceInfoDisplay);
            set(dmObj.hMemoryMeaureEdit, 'Position', [1/2+edgePercent, 1-3*widgetHeightPercent+edgePercent, 1/2-2*edgePercent, widgetHeightPercent-2*edgePercent]);
            
            % Panel for widgets display
            hWidgetsDisplay = uipanel('Parent', hControl, ...
                'BackgroundColor',bgColor, ...
                'Position',[edgePercent, edgePercent, 1-2*edgePercent, 1-PerfDispHeightPercent-2*edgePercent]);
            
            widgetHeightPercent = 1/7;            
            % Device Name
            computerNameStr = getenv('computername');
            dmObj.hMachineNameEdit = createUiData(computerNameStr, hWidgetsDisplay);
            set(dmObj.hMachineNameEdit, 'FontSize', 12, 'Position', [edgePercent, 1-widgetHeightPercent+edgePercent, 1-2*edgePercent, widgetHeightPercent-2*edgePercent]);
            
            
            % OS Label            
            hOsLabel = createUiLabel('OS:', hWidgetsDisplay);
            set(hOsLabel, 'Position', [edgePercent, 1-2*widgetHeightPercent, 1/2-2*edgePercent, widgetHeightPercent-2*edgePercent]);
            
            osStr = 'Winxp';
            dmObj.hOsNameEdit = createUiData(osStr, hWidgetsDisplay);
            set(dmObj.hOsNameEdit, 'Position', [1/2+edgePercent, 1-2*widgetHeightPercent, 1/2-2*edgePercent, widgetHeightPercent-2*edgePercent]);            
            
            % CPU Info            
            hCpuInfoLabel = createUiLabel('Processor:', hWidgetsDisplay);
            set(hCpuInfoLabel, 'Position', [edgePercent, 1-3*widgetHeightPercent, 1/2-2*edgePercent, widgetHeightPercent-2*edgePercent]);           
            
            cpuInfo = '2x1.2GHz';
            dmObj.hCpuInfoEdit = createUiData(cpuInfo, hWidgetsDisplay);
            set(dmObj.hCpuInfoEdit, 'Position', [1/2+edgePercent, 1-3*widgetHeightPercent, 1/2-2*edgePercent, widgetHeightPercent-2*edgePercent]);
            
            % Max Memory
            hMaxMemLabel = createUiLabel('Total Memory:', hWidgetsDisplay);
            set(hMaxMemLabel, 'Position', [edgePercent, 1-4*widgetHeightPercent, 1/2-2*edgePercent, widgetHeightPercent-2*edgePercent]);           
            
            maxMemory = '2000MB';
            dmObj.hMaxMemEdit = createUiData(maxMemory, hWidgetsDisplay);
            set(dmObj.hMaxMemEdit, 'Position', [1/2+edgePercent, 1-4*widgetHeightPercent, 1/2-2*edgePercent, widgetHeightPercent-2*edgePercent]);
            
            % Matlab version
            hReleaseVerLabel = createUiLabel('Release Ver:', hWidgetsDisplay);
            set(hReleaseVerLabel, 'Position', [edgePercent, 1-5*widgetHeightPercent, 1/2-2*edgePercent, widgetHeightPercent-2*edgePercent]);           
            
            releaseVer = 'R2010a';
            dmObj.hReleaseVerEdit = createUiData(releaseVer, hWidgetsDisplay);
            set(dmObj.hReleaseVerEdit, 'Position', [1/2+edgePercent, 1-5*widgetHeightPercent, 1/2-2*edgePercent, widgetHeightPercent-2*edgePercent]);
                      
            
            % Start Button
            
            dmObj.hStartMeaureBtn = uicontrol('Parent', hWidgetsDisplay, 'Style', 'pushbutton', 'FontSize', 10, 'String', 'START',...
                'BackgroundColor',bgColor, 'TooltipString', 'export current measured data to workspace as ''DaqData'' and ''DaqTime''', ...
                'Units', 'normalized', 'Position', [1/4+edgePercent, 4*edgePercent, 1/2-2*edgePercent, widgetHeightPercent-2*edgePercent],...
                'Callback', @(src, event)startEngine(dmObj));
            
        end
        
        
    end
    
    % util functions
    methods     
                
        % start button
        function startEngine(dmObj)
            set(dmObj.hStartMeaureBtn, 'enable', 'inactive');
            fprintf('start engine\n');
            notify(dmObj, 'onStartEngine');            
            % if state was stopped
            % change display to "stop"     
            
            set(dmObj.hStartMeaureBtn, 'enable', 'on', 'String', 'STOP', 'Callback', @(src, event)stopEngine(dmObj));
        end
        function stopEngine(dmObj)
            set(dmObj.hStartMeaureBtn, 'enable', 'inactive');
            fprintf('stop engine\n');            
            notify(dmObj, 'onStopEngine');
            
            % if state was started
            % change display to "start"
            % clean perfData            
            set(dmObj.hStartMeaureBtn, 'enable', 'on', 'String', 'START', 'Callback', @(src, event)startEngine(dmObj));
        end
        
        function updateDisplay(dmObj, dataObj)
            %TODO need public argument check
            if isempty(dataObj.TimeArray)
                return;
            end
            
            % update the lasest measurement
            set(dmObj.hTimeMeasureEdit, 'String', datestr(dataObj.TimeArray(end), 'HH:MM:SS'));
            set(dmObj.hCPUMeasureEdit, 'String', sprintf('%2.2f%s', dataObj.UsedCPUArray(end), dataObj.UsedCPUUnits));
            set(dmObj.hMemoryMeaureEdit, 'String', sprintf('%.2f%s', dataObj.UsedMemoryArray(end), dataObj.UsedMemoryUnits));
            
            % update both lines based on the available samples            
            dispDataLength = ceil(dmObj.measureTimeLength/dmObj.updatePeriod);
            if numel(dataObj.TimeArray) <= dispDataLength                             
                
                % If we don't have enough data for the full screen
                % set data and set xlim to display the full screen
                xData = dispDataLength-numel(dataObj.UsedCPUArray)+1:dispDataLength;
                set(dmObj.hCpuDataLine, 'XData', xData, 'YData', dataObj.UsedCPUArray);
                set(dmObj.hMemDataLine, 'XData', xData, 'YData', dataObj.UsedMemoryArray);                                
            else
                %% If we have enough data for the full screen,  copy the lastest data
                set(dmObj.hCpuDataLine, 'XData', 1:dispDataLength, 'YData', dataObj.UsedCPUArray(end-dispDataLength+1:end));
                set(dmObj.hMemDataLine, 'XData', 1:dispDataLength, 'YData', dataObj.UsedMemoryArray(end-dispDataLength+1:end));                                
            end
            
            measureTimeDelta = dmObj.measureTimeLength/3600/24;
            curMeasureTime = dataObj.TimeArray(end);
            set(dmObj.hMemDispAxes, 'Xtick', get(dmObj.hMemDispAxes, 'XLim'));
            set(dmObj.hMemDispAxes, 'XTickLabel', datestr([curMeasureTime-measureTimeDelta, curMeasureTime], 'MM:SS'));
            % redraw
            drawnow;
        end
        function exportData(dmObj)
            showStatusMsg(dmObj, 'Exporting data to workspace');           
            daqData = get(dmObj.hMemDataLine, 'YData');
            daqTime = get(dmObj.hMemDataLine, 'XData');
            assignin('base', 'DaqData', daqData);
            assignin('base', 'DaqTime', daqTime);
            figure, plot(daqTime, daqData, '-b');
            xlabel('Time(seconds)');
            ylabel('Measured Data');
            drawnow;
        end        
        
        function updateXLim(dmObj)
            % set xLim
            xlim(dmObj.hMemDispAxes, [1, ceil(dmObj.measureTimeLength/dmObj.updatePeriod)]);
            xlim(dmObj.hCpuDispAxes, get(dmObj.hMemDispAxes, 'XLim'));
            
            % update XTickLabel
            
        end
           
        function thrinkMeasureTime(dmObj, speedTag)
            if strcmpi(speedTag, 'fast')
                newTimeLength = dmObj.measureTimeLength/2;
            else
                % decrease by the order of first significant figure                    
                newTimeLength = dmObj.measureTimeLength - normalSpeed(dmObj.measureTimeLength);
            end
            
            if newTimeLength > dmObj.updatePeriod
                dmObj.measureTimeLength = newTimeLength;
                updateTitle(dmObj);
            else
               warnMsg = sprintf('Measurement Time could not be shorter than %.2f', dmObj.updatePeriod);
               showStatusMsg(dmObj, warnMsg);
            end            
            updateXLim(dmObj);
        end
        function extendMeasureTime(dmObj, speedTag)
            if strcmpi(speedTag, 'fast')
                newTimeLength = dmObj.measureTimeLength*2;
            else
                % decrease by the order of first significant figure
                newTimeLength = dmObj.measureTimeLength + normalSpeed(dmObj.measureTimeLength);
            end
            if newTimeLength < dmObj.maxDynamicTimeLength
                dmObj.measureTimeLength = newTimeLength;
                updateTitle(dmObj);
            else
               warnMsg = sprintf('Measurement time needs to be < %g seconds', dmObj.maxDynamicTimeLength);
               showStatusMsg(dmObj, warnMsg);
            end
            updateXLim(dmObj);
        end        
        
        function updateTitle(dmObj)
            set(dmObj.hMeasureTimeLength, 'String', sprintf('\\leftarrow Display Section Length: %gS \\rightarrow', dmObj.measureTimeLength));
        end        
    end
end

% helper functions
function changeVal = normalSpeed(currentVal)
numOrder = floor(log10(currentVal));
if numOrder == 0
    % if current value is 1
    changeVal = 0.1;
elseif numOrder > 0
    % if current value is bigger than 1
    changeVal = 1;
else
    % if current value is smaller than 1
    changeVal = 10^numOrder;
end
end

function uiControlHandle = createUiData(dispStr, parentHandle)
    dispStyle = 'edit';
    uiControlHandle = uicontrol('String', dispStr, 'Style',  dispStyle, 'Parent', parentHandle, ...                                
                                'FontSize', 10, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
                                'Units', 'normalized','BackgroundColor', get(parentHandle, 'BackgroundColor')*1.1);
end

function uiControlHandle = createUiLabel(dispStr, parentHandle)
    dispStyle = 'edit';
    uiControlHandle = uicontrol('String', dispStr, 'Style',  dispStyle, 'Parent', parentHandle, ...                                
                                'FontSize', 10, 'FontWeight', 'bold', 'HorizontalAlignment', 'right', ...
                                'Units', 'normalized','BackgroundColor', get(parentHandle, 'BackgroundColor'));
end