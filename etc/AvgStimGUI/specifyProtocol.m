function varargout = specifyProtocol(varargin)
% SPECIFYPROTOCOL MATLAB code for specifyProtocol.fig
%      SPECIFYPROTOCOL, by itself, creates a new SPECIFYPROTOCOL or raises the existing
%      singleton*.
%
%      H = SPECIFYPROTOCOL returns the handle to a new SPECIFYPROTOCOL or the handle to
%      the existing singleton*.
%
%      SPECIFYPROTOCOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECIFYPROTOCOL.M with the given input arguments.
%
%      SPECIFYPROTOCOL('Property','Value',...) creates a new SPECIFYPROTOCOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before specifyProtocol_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to specifyProtocol_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help specifyProtocol

% Last Modified by GUIDE v2.5 18-Sep-2013 16:07:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @specifyProtocol_OpeningFcn, ...
                   'gui_OutputFcn',  @specifyProtocol_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before specifyProtocol is made visible.
function specifyProtocol_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to specifyProtocol (see VARARGIN)

% Choose default command line output for specifyProtocol
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes specifyProtocol wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = specifyProtocol_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist('handles','var') && ~isempty(handles)
    files = get(handles.protocolPopupmenu,'String');
    fileIndex = get(handles.protocolPopupmenu,'Value');
    handles.output = files(fileIndex);
    % Get default command line output from handles structure
    varargout{1} = handles.output;
else
    varargout{1} = {};
end



% --- Executes on button press in addRowButton.
function addRowButton_Callback(hObject, eventdata, handles)
% hObject    handle to addRowButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tableData = get(handles.protocolTable,'Data');
tableData = [tableData;{'','','','',''}];
set(handles.protocolTable,'Data',tableData);
guidata(hObject, handles);
saveProtocol(hObject, eventdata, handles)

% --- Executes on button press in deleteRowButton.
function deleteRowButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteRowButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.protocolTable,'Data');
if size(data) > 0
    if isempty(handles.selectedCell) && isfield(handles,'nextRowDeletion');
        row = handles.nextRowDeletion;
    else
        row = handles.selectedCell(1);
    end
    if row == length(data(:,1));
        handles.nextRowDeletion = row - 1;
    else
        handles.nextRowDeletion = row;
    end
    data(row,:) = [];
    set(handles.protocolTable,'Data',data);
    saveProtocol(hObject, eventdata, handles)
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function protocolTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to protocolTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
protocolFiles = dir('Defaults\Protocols');
if length(protocolFiles) > 2
    protocol = load(protocolFiles(3).name);
    set(hObject,'Data',protocol.protocol);
end
guidata(hObject, handles);

% --- Executes on selection change in protocolPopupmenu.
function protocolPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to protocolPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns protocolPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from protocolPopupmenu
contents = cellstr(get(hObject,'String'));
protocol = load(contents{get(hObject,'Value')});
set(handles.protocolTable,'Data',protocol.protocol);
guidata(hObject, handles);

function updateProtocolTable(hObject, eventdata, handles)
contents = cellstr(get(handles.protocolPopupmenu,'String'));
protocol = load(contents{get(handles.protocolPopupmenu,'Value')});
set(handles.protocolTable,'Data',protocol.protocol);
guidata(hObject, handles);

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


function updateProtocolsPopupmenu(hObject, eventdata, handles)
protocolFiles = dir('Defaults\Protocols');
if length(protocolFiles) > 2
    protocols = cell(length(protocolFiles)-2,1);
    for i = 1:length(protocolFiles)-2
        protocols{i} = protocolFiles(i+2).name;
    end
    set(handles.protocolPopupmenu,'String',protocols);
    updateProtocolTable(hObject, eventdata, handles);
    guidata(hObject,handles);
end


function [boolean] = protocolExists(name)
protocolFiles = dir('Defaults\Protocols');
boolean = 0;
if length(protocolFiles) > 2
    for i = 3:length(protocolFiles)
        [~,name,~] = fileparts(name);
        [~,thisName,~] = fileparts(protocolFiles(i).name);
        if strcmpi(thisName,name)
           boolean = 1; 
        end
    end
end


% --- Executes on button press in newProtocolButton.
function newProtocolButton_Callback(hObject, eventdata, handles)
% hObject    handle to newProtocolButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newProtocol = inputdlg('Enter a name for the protocol:','New Protocol',1);
if ~isempty(newProtocol) && ~isempty(newProtocol{1})
    while protocolExists(newProtocol{1})
       newProtocol = inputdlg('Protocol name already exists. Please enter a different name for the protocol:','New Protocol',1); 
       if ~isempty(newProtocol)
           continue;
       else
           break;
       end
    end
end
if ~isempty(newProtocol) && ~isempty(newProtocol{1})
    [~,file,ext] = fileparts(newProtocol{1});
    if ~strcmp(ext,'.mat')
        newProtocol{1} = [file,'.mat'];
    end
    protocols = get(handles.protocolPopupmenu,'String');
    protocols = sort([protocols;newProtocol]);
    protocolIndex = find(ismember(protocols,newProtocol{1}));
    set(handles.protocolPopupmenu,'String',protocols);
    set(handles.protocolPopupmenu,'Value',protocolIndex);
    set(handles.protocolTable,'Data',cell(1,5));
    saveProtocol(hObject, eventdata, handles)
end
guidata(hObject, handles);


% --- Executes on button press in deleteProtocolButton.
function deleteProtocolButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteProtocolButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
files = get(handles.protocolPopupmenu,'String');
if ~isempty(files)
    fileIndex = get(handles.protocolPopupmenu,'Value');
    response = questdlg(strcat('Are you sure you want to delete ''',files(fileIndex),''''),'Delete Protocol','Yes','No','No');
    if strcmpi(response,'yes')
        file = strcat('Defaults\Protocols\',files(fileIndex));
        delete(file{1});
        if fileIndex > 1
            newSelection = fileIndex-1;
        else
            newSelection = 1;
        end
        set(handles.protocolPopupmenu,'Value',newSelection);
        updateProtocolsPopupmenu(hObject, eventdata, handles)
    else
        return;
    end
end
guidata(hObject, handles);

% --- Executes on button press in saveProtocolButton.
function saveProtocolButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveProtocolButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveProtocol(hObject, eventdata, handles);
guidata(hObject, handles);

function saveProtocol(hObject, eventdata, handles)
protocol = get(handles.protocolTable,'Data');
files = get(handles.protocolPopupmenu,'String');
file = strcat('Defaults\Protocols\',files(get(handles.protocolPopupmenu,'Value')));
save(file{1},'protocol');
updateProtocolsPopupmenu(hObject, eventdata, handles)
guidata(hObject, handles);

% --- Executes when selected cell(s) is changed in protocolTable.
function protocolTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to protocolTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
set(handles.deleteRowButton,'Enable','on');
handles.selectedCell = eventdata.Indices;
guidata(hObject, handles);
saveProtocol(hObject, eventdata, handles)


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if isfield(handles,'selectedCell');
%    handles.selectedCell = []; 
%    set(handles.deleteRowButton,'Enable','off');
% end
% guidata(hObject, handles);


% --- Executes on button press in linkFilesButton.
function linkFilesButton_Callback(hObject, eventdata, handles)
% hObject    handle to linkFilesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on protocolTable and none of its controls.
function protocolTable_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to protocolTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
saveProtocol(hObject, eventdata, handles)


% --- Executes when entered data in editable cell(s) in protocolTable.
function protocolTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to protocolTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
saveProtocol(hObject, eventdata, handles)


% --- Executes on button press in doneButton.
function varargout = doneButton_Callback(hObject, eventdata, handles)
% hObject    handle to doneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
files = get(handles.protocolPopupmenu,'String');
fileIndex = get(handles.protocolPopupmenu,'Value');
handles.output = files(fileIndex);
guidata(hObject,handles);
varargout = specifyProtocol_OutputFcn(hObject, eventdata, handles);
delete(handles.figure1);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
