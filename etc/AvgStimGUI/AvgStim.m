function varargout = AvgStim(varargin)
%AVGSTIM M-file for AvgStim.fig
%      AVGSTIM, by itself, creates a new AVGSTIM or raises the existing
%      singleton*.
%
%      H = AVGSTIM returns the handle to a new AVGSTIM or the handle to
%      the existing singleton*.
%
%      AVGSTIM('Property','Value',...) creates a new AVGSTIM using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to AvgStim_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      AVGSTIM('CALLBACK') and AVGSTIM('CALLBACK',hObject,...) call the
%      local function named CALLBACK in AVGSTIM.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AvgStim

% Last Modified by GUIDE v2.5 19-Sep-2013 09:32:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AvgStim_OpeningFcn, ...
                   'gui_OutputFcn',  @AvgStim_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AvgStim is made visible.
function AvgStim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for AvgStim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AvgStim wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AvgStim_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in animalStrainPopUpMenu.
function animalStrainPopUpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to animalStrainPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns animalStrainPopUpMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from animalStrainPopUpMenu


% --- Executes during object creation, after setting all properties.
function animalStrainPopUpMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to animalStrainPopUpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addStrainButton.
function addStrainButton_Callback(hObject, eventdata, handles)
% hObject    handle to addStrainButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newStrain = newStrainDialog();
if ~strcmpi(newStrain,'cancel')
    strains = get(handles.animalStrainListbox,'String');
    if all(cellfun('isempty',strfind(strains,newStrain)))
       strains = sort([strains;newStrain]);
       save('Defaults/animalStrains.mat','strains');
       reloadAnimalStrains(hObject, eventdata, handles);
    end
    guidata(hObject, handles);
end


% --- Executes on selection change in animalStrainListbox.
function animalStrainListbox_Callback(hObject, eventdata, handles)
% hObject    handle to animalStrainListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns animalStrainListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from animalStrainListbox


% --- Executes during object creation, after setting all properties.
function animalStrainListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to animalStrainListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
strains = load('Defaults/animalStrains.mat');
set(hObject,'String',strains.strains);
guidata(hObject, handles);


function reloadAnimalStrains(hObject, eventdata, handles)
strains = load('Defaults/animalStrains.mat');
set(handles.animalStrainListbox,'String',strains.strains);
guidata(hObject, handles);


% --- Executes on button press in deleteStrainButton.
function deleteStrainButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteStrainButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
strains = get(handles.animalStrainListbox,'String');
selectedStrain = get(handles.animalStrainListbox,'Value');
strains(selectedStrain) = [];
save('Defaults/animalStrains.mat','strains');
if selectedStrain > 1
    newSelection = selectedStrain-1;
else
    newSelection = 1;
end
set(handles.animalStrainListbox,'Value',newSelection);
reloadAnimalStrains(hObject, eventdata, handles);



% --- Executes on button press in openFilesButton.
function openFilesButton_Callback(hObject, eventdata, handles)
% hObject    handle to openFilesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[files,handles.path] = uigetfile({'*raw','Binary MCS Files (*.raw)';'*.edf','EDF Files (*.edf)';'*.txt','Text Files (*.txt)';'*.*','All Files'},... % Open the user interface for opening files
'Select Data File(s)','MultiSelect','On');
if ~iscell(files)
    if isequal(files,0)
        return;
    end
    files = {files};
end
handles.files = files;
set(handles.selectedFilesListbox,'String',files);
set(handles.selectedFilesListbox,'Enable','on');
set(handles.outputFilesCheckbox,'Enable','on');
outputFilesCheckbox_Callback(hObject, eventdata, handles);
guidata(hObject,handles);


% --- Executes on button press in specifyProtocolButton.
function specifyProtocolButton_Callback(hObject, eventdata, handles)
% hObject    handle to specifyProtocolButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newProtocol = specifyProtocol();
if ~isempty(newProtocol)
    protocolFiles = dir('Defaults\Protocols');
    for i = 1:length(protocolFiles)
        if strcmpi(newProtocol,protocolFiles(i).name)
            set(handles.protocolPopupmenu,'Value',i-2);
        end
    end
end
refreshProtocolList(hObject, eventdata, handles);
guidata(hObject,handles);

function refreshProtocolList(hObject, eventdata, handles)
protocolFiles = dir('Defaults\Protocols');
if length(protocolFiles) > 2
    protocols = cell(length(protocolFiles)-2,1);
    for i = 1:length(protocolFiles)-2
        protocols{i} = protocolFiles(i+2).name;
    end
    set(handles.protocolPopupmenu,'String',protocols);
    guidata(hObject,handles);
end

% --- Executes on button press in centerCheckbox.
function centerCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to centerCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of centerCheckbox


% --- Executes on button press in smoothCheckbox.
function smoothCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to smoothCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of smoothCheckbox
checked = get(hObject,'Value');
if checked
    set(handles.smoothTextbox,'Enable','on');
else
    set(handles.smoothTextbox,'Enable','off');
end
guidata(hObject, handles);

% --- Executes on button press in filterCheckbox.
function filterCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to filterCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filterCheckbox
checked = get(hObject,'Value');
if checked
    set(handles.filterPopupmenu,'Enable','on');
else
    set(handles.filterPopupmenu,'Enable','off');
end
guidata(hObject, handles);



function smoothTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to smoothTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smoothTextbox as text
%        str2double(get(hObject,'String')) returns contents of smoothTextbox as a double


% --- Executes during object creation, after setting all properties.
function smoothTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in artifactCheckbox.
function artifactCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to artifactCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of artifactCheckbox
checked = get(hObject,'Value');
if checked
    set(handles.artifactTextbox,'Enable','on');
else
    set(handles.artifactTextbox,'Enable','off');
end
guidata(hObject, handles);



function artifactTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to artifactTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of artifactTextbox as text
%        str2double(get(hObject,'String')) returns contents of artifactTextbox as a double


% --- Executes during object creation, after setting all properties.
function artifactTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to artifactTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function filterPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filterPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
filterFiles = dir('Defaults\Filters');
if length(filterFiles) > 2
    filters = cell(length(filterFiles)-2,1);
    for i = 1:length(filterFiles)-2
        filters{i} = filterFiles(i+2).name;
    end
    set(hObject,'String',filters);
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in selectFilesButton.
function selectFilesButton_Callback(hObject, eventdata, handles)
% hObject    handle to selectFilesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[files,path] = uigetfile({'*raw','Binary MCS Files (*.raw)';'*.*','All Files';'*.edf','EDF Files (*.edf)';'*.txt','Text Files (*.txt)';},... % Open the user interface for opening files
'Select Data File(s)','MultiSelect','On');
if ~iscell(files)
    if isequal(files,0)
        return;
    end
    % Turns the filename into a cell array
    % so the subsequent for loop works.
    files = {files};
end
handles.files = files;
guidata(hObject,handles);


% --- Executes on button press in helpButton.
function helpButton_Callback(hObject, eventdata, handles)
% hObject    handle to helpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpWindow;


% --- Executes on button press in addFormatButton.
function addFormatButton_Callback(hObject, eventdata, handles)
% hObject    handle to addFormatButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newFormat = inputdlg('Enter a name for the format:','New Format',1);
if ~isempty(newFormat) && ~isempty(newFormat{1})
    while formatExists(newFormat{1})
       newFormat = inputdlg('Format name already exists. Please enter a different name for the format:','New Format',1); 
       if ~isempty(newFormat)
           continue;
       else
           break;
       end
    end
end
if ~isempty(newFormat) && ~isempty(newFormat{1})
    [~,file,ext] = fileparts(newFormat{1});
    if ~strcmp(ext,'.mat')
        newFormat{1} = [file,'.mat'];
    end
    formats = get(handles.formatPopupmenu,'String');
    formats = sort([formats;newFormat]);
    formatIndex = find(ismember(formats,newFormat{1}));
    set(handles.formatPopupmenu,'String',formats);
    set(handles.formatPopupmenu,'Value',formatIndex);
    set(handles.formatTable,'Data',{'','','',''});
    saveFormat(hObject, eventdata, handles)
end
guidata(hObject, handles);

function [boolean] = formatExists(name)
formatFiles = dir('Defaults\Export Formats');
boolean = 0;
if length(formatFiles) > 2
    for i = 3:length(formatFiles)
        [~,name,~] = fileparts(name);
        [~,thisName,~] = fileparts(formatFiles(i).name);
        if strcmpi(thisName,name)
           boolean = 1; 
        end
    end
end


% --- Executes on button press in addRowButton.
function addRowButton_Callback(hObject, eventdata, handles)
% hObject    handle to addRowButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles    structure with handles and user data (see GUIDATA)
tableData = get(handles.formatTable,'Data');
format = get(handles.formatPopupmenu,'String');
if length(format) < 1
    addFormatButton_Callback(hObject, eventdata, handles);
else
    tableData = [tableData;{'','','',''}];
    set(handles.formatTable,'Data',tableData);
    guidata(hObject, handles);
    saveFormat(hObject, eventdata, handles)
end


% --- Executes on button press in deleteRowButton.
function deleteRowButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteRowButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.formatTable,'Data');
if size(data) > 0
    if isfield(handles,'selectedCell')
        if isempty(handles.selectedCell) && isfield(handles,'nextRowDeletion');
            row = handles.nextRowDeletion;
        else
            row = handles.selectedCell(1);
        end
    else
        row = length(data(:,1));
    end
    if row == length(data(:,1));
        handles.nextRowDeletion = row - 1;
    else
        handles.nextRowDeletion = row;
    end
    data(row,:) = [];
    set(handles.formatTable,'Data',data);
    saveFormat(hObject, eventdata, handles)
    guidata(hObject, handles);
end

% --- Executes on selection change in formatPopupmenu.
function formatPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to formatPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns formatPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from formatPopupmenu
contents = cellstr(get(hObject,'String'));
format = load(contents{get(hObject,'Value')});
set(handles.formatTable,'Data',format.format);
set(handles.deleteRowButton,'Enable','off');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function formatPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to formatPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
formatFiles = dir('Defaults\Export Formats');
if length(formatFiles) > 2
    formats = cell(length(formatFiles)-2,1);
    for i = 1:length(formatFiles)-2
        formats{i} = formatFiles(i+2).name;
    end
    set(hObject,'String',formats);
end
guidata(hObject, handles);

function saveFormat(hObject, eventdata, handles)
format = get(handles.formatTable,'Data');
files = get(handles.formatPopupmenu,'String');
if ~isempty(files)
    file = strcat('Defaults\Export Formats\',files(get(handles.formatPopupmenu,'Value')));
    save(file{1},'format');
    updateFormatPopupmenu(hObject, eventdata, handles)
    guidata(hObject, handles);
end

function updateFormatPopupmenu(hObject, eventdata, handles)
formatFiles = dir('Defaults\Export Formats');
if length(formatFiles) > 2
    formats = cell(length(formatFiles)-2,1);
    for i = 1:length(formatFiles)-2
        formats{i} = formatFiles(i+2).name;
    end
else
    formats = {};
end
set(handles.formatPopupmenu,'String',formats);
updateFormatTable(hObject, eventdata, handles);
guidata(hObject,handles);

function updateFormatTable(hObject, eventdata, handles)
contents = cellstr(get(handles.formatPopupmenu,'String'));
try
    format = load(contents{get(handles.formatPopupmenu,'Value')});
catch err
    format.format = [];
end
set(handles.formatTable,'Data',format.format);
guidata(hObject, handles);


% --- Executes on button press in deleteFormatButton.
function deleteFormatButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteFormatButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
files = get(handles.formatPopupmenu,'String');
if ~isempty(files)
    fileIndex = get(handles.formatPopupmenu,'Value');
    response = questdlg(strcat('Are you sure you want to delete ''',files(fileIndex),''''),'Delete Format','Yes','No','No');
    if strcmpi(response,'yes')
        file = strcat('Defaults\Export Formats\',files(fileIndex));
        delete(file{1});
        if fileIndex > 1
            newSelection = fileIndex-1;
        else
            newSelection = 1;
        end
        warning('off','MATLAB:hg:uicontrol:ParameterValuesMustBeValid');
        set(handles.formatPopupmenu,'Value',newSelection);
        updateFormatPopupmenu(hObject, eventdata, handles)
    else
        return;
    end
end
guidata(hObject, handles);

% --- Executes on button press in downsampleCheckbox.
function downsampleCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to downsampleCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of downsampleCheckbox
checked = get(hObject,'Value');
if checked
    set(handles.downsampleEditTextbox,'Enable','on');
else
    set(handles.downsampleEditTextbox,'Enable','off');
end
guidata(hObject, handles);


function downsampleEditTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to downsampleEditTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of downsampleEditTextbox as text
%        str2double(get(hObject,'String')) returns contents of downsampleEditTextbox as a double


% --- Executes during object creation, after setting all properties.
function downsampleEditTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to downsampleEditTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function formatTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to formatTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
formatFiles = dir('Defaults\Export Formats');
if length(formatFiles) > 2
    format = load(formatFiles(3).name);
    set(hObject,'Data',format.format);
else
    set(hObject,'Data',[]);
end
guidata(hObject, handles);


% --- Executes when selected cell(s) is changed in formatTable.
function formatTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to formatTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
set(handles.deleteRowButton,'Enable','on');
handles.selectedCell = eventdata.Indices;
guidata(hObject, handles);
saveFormat(hObject, eventdata, handles);


% --- Executes when entered data in editable cell(s) in formatTable.
function formatTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to formatTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
saveFormat(hObject, eventdata, handles)


% --- Executes on button press in createFilterButton.
function createFilterButton_Callback(hObject, eventdata, handles)
% hObject    handle to createFilterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.fdatool = fdatool;
helpdlg('When finished designing your filter, go to File->Export. Select ''Export To MAT-File'', then save your filter to the folder ''Defaults\Filters''.')



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over filterPopupmenu.
function filterPopupmenu_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to filterPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filterFiles = dir('Defaults\Filters');
if length(filterFiles) > 2
    filters = cell(length(filterFiles)-2,1);
    for i = 1:length(filterFiles)-2
        filters{i} = filterFiles(i+2).name;
    end
    set(handles.filterPopupmenu,'String',filters);
end


% --- Executes on button press in exportCheckbox.
function exportCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to exportCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of exportCheckbox
if get(hObject,'Value')
    set(handles.formatPopupmenu,'Enable','on');
    set(handles.addFormatButton,'Enable','on');
    set(handles.deleteFormatButton,'Enable','on');
    set(handles.addRowButton,'Enable','on');
    set(handles.formatTable,'Enable','on');
else
    set(handles.formatPopupmenu,'Enable','off');
    set(handles.addFormatButton,'Enable','off');
    set(handles.deleteFormatButton,'Enable','off');
    set(handles.addRowButton,'Enable','off');
    set(handles.deleteRowButton,'Enable','off');
    set(handles.formatTable,'Enable','off');
end
guidata(hObject, handles);


% --- Executes on selection change in selectedFilesListbox.
function selectedFilesListbox_Callback(hObject, eventdata, handles)
% hObject    handle to selectedFilesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectedFilesListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectedFilesListbox


% --- Executes during object creation, after setting all properties.
function selectedFilesListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectedFilesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function protocolPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to protocolPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
protocolFiles = dir('Defaults\Protocols');
if length(protocolFiles) > 2
    protocols = cell(length(protocolFiles)-2,1);
    for i = 1:length(protocolFiles)-2
        protocols{i} = protocolFiles(i+2).name;
    end
    set(hObject,'String',protocols);
end
guidata(hObject, handles);


% --- Executes on button press in averagePointsCheckbox.
function averagePointsCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to averagePointsCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of averagePointsCheckbox
if get(hObject,'Value')
    set(handles.averagePointsTextbox,'Enable','on');
else
    set(handles.averagePointsTextbox,'Enable','off');
end
guidata(hObject, handles);


function averagePointsTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to averagePointsTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of averagePointsTextbox as text
%        str2double(get(hObject,'String')) returns contents of averagePointsTextbox as a double


% --- Executes during object creation, after setting all properties.
function averagePointsTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to averagePointsTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8


% --- Executes on button press in outputFilesCheckbox.
function outputFilesCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to outputFilesCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of outputFilesCheckbox
if get(handles.outputFilesCheckbox,'Value')
    if ~isempty(handles.files)
        W = waitbar(0,'Locating output files...');
        lostFiles = {};
        for i = 1:length(handles.files)
            if ~isempty(strfind(handles.files{i},' with TTL Channel'))
                commonFileName = handles.files{i}(1:strfind(handles.files{i},' with TTL Channel')-1);
            else
                commonFileName = handles.files{i}(1:strfind(handles.files{i},'.edf')-1);
            end
            fftfiles = dir(handles.path);
            for j = 1:length(fftfiles)
               [~,name,ext] = fileparts(fftfiles(j).name);
               if strcmp(ext,'.txt') && ~isempty(strfind(name,commonFileName))
                   fileNotFound = 0;
                   break;
               else
                   fileNotFound = 1;
               end
            end
            if fileNotFound
                lostFiles{i} = handles.files{i};
            end
            waitbar(i/length(handles.files),W);
        end
        close(W);
        if ~isempty(lostFiles)
            lostFiles = lostFiles(~cellfun('isempty',lostFiles));
            helpstr = lostFiles{1};
            for j = 2:length(lostFiles)
                helpstr = [helpstr,', ',lostFiles{j}];
            end
            helpdlg(['The output files for the following recordings could not be found: ', helpstr]); 
        end
    else
        helpdlg('Please select the recording file(s) first.');
        set(hObject,'Value',0);
    end
end


% --- Executes on button press in runButton.
function runButton_Callback(hObject, eventdata, handles)
% hObject    handle to runButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'files') || isempty(handles.files)
    helpdlg('Please select the file(s) you''d like to process.');
    return;
end
if isempty(get(handles.animalStrainListbox,'String'))
    helpdlg('Please enter the animal strains to be processed.');
    return;
end
if ~isfield(handles,'protocol') || isempty(handles.protocol)
    helpdlg('Please select a recording protocol.');
    return;
end
if get(handles.downsampleCheckbox,'Value')
    downsampleRate = get(handles.downsampleEditTextbox,'String');
    if isempty(downsampleRate) || ~isnumeric(str2double(downsampleRate)) || isNaN(downsampleRate)
        helpdlg('Please enter the down-sampling rate.');
        return;
    end
end
if get(handles.smoothCheckbox,'Value')
    smoothWindow = get(handles.smoothCheckbox,'String');
    if isempty(smoothWindow) || ~isnumeric(str2double(smoothWindow)) || isNaN(smoothWindow)
        helpdlg('Please enter the smoothing window size.');
        return;
    end
end
if get(handles.filterCheckbox,'Value') && isempty(get(handles.filterPopupmenu,'String'))
    helpdlg('Please select a filter.');
    return;
end
if get(handles.artifactCheckbox,'Value') && isempty(get(handles.artifactTextbox,'String'))
    helpdlg('Please enter number of standard deviations that designate an artifact.');
    return;
end
if get(handles.averagePointsCheckbox,'Value') && isempty(get(handles.averagePointsCheckbox,'String'))
    helpdlg('Please enter the number of points you would like to average.');
    return;
end
if get(handles.exportCheckbox,'Value') && isempty(get(handles.formatPopupmenu,'String'))
    helpdlg('Please select an export format.');
    return;
end


