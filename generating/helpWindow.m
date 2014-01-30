function varargout = helpWindow(varargin)
% HELPWINDOW MATLAB code for helpWindow.fig
%      HELPWINDOW, by itself, creates a new HELPWINDOW or raises the existing
%      singleton*.
%
%      H = HELPWINDOW returns the handle to a new HELPWINDOW or the handle to
%      the existing singleton*.
%
%      HELPWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HELPWINDOW.M with the given input arguments.
%
%      HELPWINDOW('Property','Value',...) creates a new HELPWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before helpWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to helpWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help helpWindow

% Last Modified by GUIDE v2.5 16-Sep-2013 14:25:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @helpWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @helpWindow_OutputFcn, ...
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


% --- Executes just before helpWindow is made visible.
function helpWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to helpWindow (see VARARGIN)

% Choose default command line output for helpWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes helpWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = helpWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in subjectListbox.
function subjectListbox_Callback(hObject, eventdata, handles)
% hObject    handle to subjectListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subjectListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subjectListbox
helpDescription = handles.helpText(get(hObject,'Value'),2);
set(handles.staticTextbox,'String',helpDescription{1});


% --- Executes during object creation, after setting all properties.
function subjectListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjectListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
helpText = load('Defaults\helpText.mat');
set(hObject,'String',helpText.helpText(:,1));
handles.helpText = helpText.helpText;
guidata(hObject,handles);

function editTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to editTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTextbox as text
%        str2double(get(hObject,'String')) returns contents of editTextbox as a double


% --- Executes during object creation, after setting all properties.
function editTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in newSubjectButton.
function newSubjectButton_Callback(hObject, eventdata, handles)
% hObject    handle to newSubjectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.staticTextbox,'Visible','off');
set(handles.editTextbox,'Visible','on');

helpText = load('Defaults\helpText');
subjects = helpText.helpText(:,1);

subjectName = inputdlg('Enter the name of the new help subject:','New Subject');

while ~all(cellfun('isempty',strfind(lower(subjects),lower(subjectName{1}))))
    subjectName = inputdlg('Subject name exists. Please enter a unique help subject name:','New Subject');
end

if strcmpi(subjectName,'cancel')
    return;
else
    [subjects,order] = sort([subjectName;subjects]);
    insertIndex = find(order == 1);
    set(handles.subjectListbox,'String',subjects);
    set(handles.subjectListbox,'Value',insertIndex);
    guidata(hObject, handles);
end




% --- Executes on button press in editSubjectButton.
function editSubjectButton_Callback(hObject, eventdata, handles)
% hObject    handle to editSubjectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in deleteSubject.
function deleteSubject_Callback(hObject, eventdata, handles)
% hObject    handle to deleteSubject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
