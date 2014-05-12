function varargout = w_GRFCorrection(varargin)
% W_GRFCORRECTION MATLAB code for w_GRFCorrection.fig
%      W_GRFCORRECTION, by itself, creates a new W_GRFCORRECTION or raises the existing
%      singleton*.
%
%      H = W_GRFCORRECTION returns the handle to a new W_GRFCORRECTION or the handle to
%      the existing singleton*.
%
%      W_GRFCORRECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in W_GRFCORRECTION.M with the given input arguments.
%
%      W_GRFCORRECTION('Property','Value',...) creates a new W_GRFCORRECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before w_GRFCorrection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to w_GRFCorrection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help w_GRFCorrection

% Last Modified by GUIDE v2.5 22-Mar-2014 15:21:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @w_GRFCorrection_OpeningFcn, ...
                   'gui_OutputFcn',  @w_GRFCorrection_OutputFcn, ...
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


% --- Executes just before w_GRFCorrection is made visible.
function w_GRFCorrection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to w_GRFCorrection (see VARARGIN)
OverlayHeader=varargin{1};
if isempty(OverlayHeader.TestFlag)
    msgbox('GRF only take effects on the statistical map!');        
    return
end

set(handles.dLhEntry,   'String', num2str(OverlayHeader.dLh));
set(handles.FWHMxEntry, 'String', num2str(OverlayHeader.FWHMx));
set(handles.FWHMyEntry, 'String', num2str(OverlayHeader.FWHMy));
set(handles.FWHMzEntry, 'String', num2str(OverlayHeader.FWHMz));

set(handles.MaskEntry,  'String', OverlayHeader.MaskFile);
% Choose default command line output for w_GRFCorrection
handles.OverlayHeader=OverlayHeader;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes w_GRFCorrection wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = w_GRFCorrection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isempty(handles)
    varargout{1}=[];
else
    varargout{1}=handles.OverlayHeader;
    delete(handles.figure1);
end



function MaskEntry_Callback(hObject, eventdata, handles)
% hObject    handle to MaskEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaskEntry as text
%        str2double(get(hObject,'String')) returns contents of MaskEntry as a double


% --- Executes during object creation, after setting all properties.
function MaskEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaskEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RemoveButton.
function RemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.MaskEntry, 'String', '');
handles.OverlayHeader.MaskFile='';
handles.OverlayHeader.Mask=true(handles.OverlayHeader.dim);
guidata(hObject, handles);

% --- Executes on button press in AddButton.
function AddButton_Callback(hObject, eventdata, handles)
% hObject    handle to AddButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DPABIPath=fileparts(which('DPABI.m'));
TemplatePath=fullfile(DPABIPath, 'Templates');
[File , Path]=uigetfile({'*.img;*.nii;*.nii.gz','Brain Image Files (*.img;*.nii;*.nii.gz)';'*.*', 'All Files (*.*)';}, ...
    'Pick Underlay File' , TemplatePath);
if isnumeric(File)
    return
end
MaskFile=fullfile(Path, File);
handles.OverlayHeader.MaskFile=MaskFile;
set(handles.MaskEntry, 'String', MaskFile);

[Mask, Vox, Header] = y_ReadRPI(MaskFile);
handles.OverlayHeader.Mask=logical(Mask);

guidata(hObject, handles);

function FWHMxEntry_Callback(hObject, eventdata, handles)
% hObject    handle to FWHMxEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FWHMxEntry as text
%        str2double(get(hObject,'String')) returns contents of FWHMxEntry as a double


% --- Executes during object creation, after setting all properties.
function FWHMxEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FWHMxEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function FWHMyEntry_Callback(hObject, eventdata, handles)
% hObject    handle to FWHMyEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FWHMyEntry as text
%        str2double(get(hObject,'String')) returns contents of FWHMyEntry as a double


% --- Executes during object creation, after setting all properties.
function FWHMyEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FWHMyEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function FWHMzEntry_Callback(hObject, eventdata, handles)
% hObject    handle to FWHMzEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FWHMzEntry as text
%        str2double(get(hObject,'String')) returns contents of FWHMzEntry as a double


% --- Executes during object creation, after setting all properties.
function FWHMzEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FWHMzEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dLhEntry_Callback(hObject, eventdata, handles)
% hObject    handle to dLhEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dLhEntry as text
%        str2double(get(hObject,'String')) returns contents of dLhEntry as a double


% --- Executes during object creation, after setting all properties.
function dLhEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dLhEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in EasyThreshButton.
function EasyThreshButton_Callback(hObject, eventdata, handles)
% hObject    handle to EasyThreshButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OverlayHeader=handles.OverlayHeader;
TestFlag=OverlayHeader.TestFlag;
Df=OverlayHeader.Df;
Df2=OverlayHeader.Df2;
if strcmpi(OverlayHeader.TestFlag, 'Z')
    [ZMap, P]=y_TFRtoZ(OverlayHeader, '', TestFlag, Df, Df2);
else
    ZMap=OverlayHeader.Raw;
end
Mask=OverlayHeader.Mask;
[dLh, resels, FWHM, nVoxels]=y_Smoothest(ZMap, Mask, '', OverlayHeader.Vox);
set(handles.dLhEntry,   'String', num2str(dLh));
set(handles.FWHMxEntry, 'String', num2str(FWHM(1)));
set(handles.FWHMyEntry, 'String', num2str(FWHM(2)));
set(handles.FWHMzEntry, 'String', num2str(FWHM(3)));

% --- Executes on button press in ComputeButton.
function ComputeButton_Callback(hObject, eventdata, handles)
% hObject    handle to ComputeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OverlayHeader=handles.OverlayHeader;
Mask=OverlayHeader.Mask;
nVoxels=length(find(Mask));
TestFlag=OverlayHeader.TestFlag;
VoxelP=str2double(get(handles.VoxelPEntry, 'String'));
ClusterP=str2double(get(handles.ClusterPEntry, 'String'));
dLh=str2double(get(handles.dLhEntry, 'String'));

if strcmpi(TestFlag, 'F')
    zThrd=norminv(1 - VoxelP);
else
    zThrd=norminv(1 - VoxelP/2);
end
D=3;
Em = nVoxels * (2*pi)^(-(D+1)/2) * dLh * (zThrd*zThrd-1)^((D-1)/2) * exp(-zThrd*zThrd/2);
EN = nVoxels * (1-normcdf(zThrd)); %In Friston et al., 1994, EN = S*Phi(-u). (Expectation of N voxels)  % K. Friston, K. Worsley, R. Frackowiak, J. Mazziotta, and A. Evans. Assessing the significance of focal activations using their spatial extent. Human Brain Mapping, 1:214?220, 1994.
Beta = ((gamma(D/2+1)*Em)/(EN)) ^ (2/D); % K. Friston, K. Worsley, R. Frackowiak, J. Mazziotta, and A. Evans. Assessing the significance of focal activations using their spatial extent. Human Brain Mapping, 1:214?220, 1994.

% Get the minimum cluster size
pTemp=1;
ClusterSize=0;
while pTemp >= ClusterP
    ClusterSize=ClusterSize+1;
    pTemp = 1 - exp(-Em * exp(-Beta * ClusterSize^(2/D))); %K. Friston, K. Worsley, R. Frackowiak, J. Mazziotta, and A. Evans. Assessing the significance of focal activations using their spatial extent. Human Brain Mapping, 1:214?220, 1994.
end
OverlayHeader.CSize=ClusterSize*prod(OverlayHeader.Vox);

switch upper(TestFlag)
    case 'T'
        Df=OverlayHeader.Df;
        Thrd=tinv(1-VoxelP/2, Df);
    case 'R'
        Df=OverlayHeader.Df;
        T=tinv(1-VoxelP/2, Df);
        Thrd=sqrt(T^2/(Df+T^2));
    case 'F'
        Df1=OverlayHeader.Df;
        Df2=OverlayHeader.Df2;
        Thrd=finv(1-VoxelP, Df1, Df2);
    case 'Z'
        Thrd=norminv(1-VoxelP/2);
end
OverlayHeader.NMin=-Thrd;
OverlayHeader.PMin=Thrd;

handles.OverlayHeader=OverlayHeader;
guidata(hObject, handles);
uiresume(handles.figure1);

function ClusterPEntry_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterPEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ClusterPEntry as text
%        str2double(get(hObject,'String')) returns contents of ClusterPEntry as a double


% --- Executes during object creation, after setting all properties.
function ClusterPEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ClusterPEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VoxelPEntry_Callback(hObject, eventdata, handles)
% hObject    handle to VoxelPEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VoxelPEntry as text
%        str2double(get(hObject,'String')) returns contents of VoxelPEntry as a double


% --- Executes during object creation, after setting all properties.
function VoxelPEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VoxelPEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
