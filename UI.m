function varargout = UI(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_OutputFcn, ...
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

% --- Executes just before UI is made visible.
function UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UI (see VARARGIN)

% Choose default command line output for UI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global zero_app
global tol_nr
global max_iter

load('globalvar.mat');

h = findobj(gcbf, 'Tag', 'TIter');
set(h, 'String', num2str(max_iter));

h = findobj(gcbf, 'Tag', 'TZero');
set(h, 'String', num2str(zero_app));

h = findobj(gcbf, 'Tag', 'TTol');
set(h, 'String', num2str(tol_nr));


% --- Outputs from this function are returned to the command line.
function varargout = UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function TEqn_Callback(hObject, eventdata, handles)
% hObject    handle to TEqn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TEqn as text
%        str2double(get(hObject,'String')) returns contents of TEqn as a double


% --- Executes during object creation, after setting all properties.
function TEqn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TEqn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BSolve.
function BSolve_Callback(hObject, eventdata, handles)
% hObject    handle to BSolve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global zero_app
global tol_nr
global max_iter

global hplot
global hroot
global hcrit
global n_iter

h = findobj(gcbf, 'Tag', 'TEqn');
s = get(h, 'String');

h = findobj(gcbf, 'Tag', 'TZero');
zero_app = str2num(get(h, 'String'));

h = findobj(gcbf, 'Tag', 'TTol');
tol_nr = str2num(get(h, 'String'));

h = findobj(gcbf, 'Tag', 'TIter');
max_iter = str2num(get(h, 'String'));

save('globalvar', 'zero_app', 'tol_nr', 'max_iter');

p = str2num(s);
if isnan(p)
    p = eval(s);
end

n_iter = 0;
tic;
r = PolySolve(p);
m = PolyMult(p, r);
tt = toc;

h = findobj(gcbf, 'Tag', 'TNo');
if isempty(r)
    set(h, 'Visible', 'on')
else
    set(h, 'Visible', 'off')
end

d = ([r; m])';
h = findobj(gcbf, 'Tag', 'Table');
set(h, 'Data', d);

h = findobj(gcbf, 'Tag', 'TOut');
set(h, 'String', sprintf('Time taken: %d ms           Total no. of iterations: %d', tt, n_iter));

cp = PolySolve(PolyDiff(p));

switch length(r)
    case 0
        cla
        return
    case 1
        inter = r(1)/10 + 10;
    otherwise
        inter = max(r(end), cp(end)) - min(r(1), cp(1));
end

ls = linspace(r(1) - inter * .025, r(end) + inter * .025, 500);

cla

hplot = plot(ls,polyval(p, ls),'LineWidth',2);
hold on


hroot = plot(r, zeros([1 length(r)]), 'ro','MarkerEdgeColor','k',...
                'MarkerFaceColor',[.49 1 .63],...
                'MarkerSize',6);
hcrit = plot(cp, polyval(p, cp), 'r*','MarkerEdgeColor','r',...
                'MarkerFaceColor',[.8 .3 .1],...
                'MarkerSize',10);

plot([ls(1) ls(end)], [0 0], 'k');
hold off
legend('plot', 'roots', 'crit')

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
global hroot
if get(hObject, 'Value') == 1
    set(hroot, 'Visible', 'on')
else
    set(hroot, 'Visible', 'off')
end

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2

global hcrit
if get(hObject, 'Value') == 1
    set(hcrit, 'Visible', 'on')
else
    set(hcrit, 'Visible', 'off')
end

function TZero_Callback(hObject, eventdata, handles)
% hObject    handle to TZero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TZero as text
%        str2double(get(hObject,'String')) returns contents of TZero as a double


% --- Executes during object creation, after setting all properties.
function TZero_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TZero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function TTol_Callback(hObject, eventdata, handles)
% hObject    handle to TTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TTol as text
%        str2double(get(hObject,'String')) returns contents of TTol as a double


% --- Executes during object creation, after setting all properties.
function TTol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function TIter_Callback(hObject, eventdata, handles)
% hObject    handle to TIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TIter as text
%        str2double(get(hObject,'String')) returns contents of TIter as a double


% --- Executes during object creation, after setting all properties.
function TIter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
global hplot
if get(hObject, 'Value') == 1
    set(hplot, 'Visible', 'on')
else
    set(hplot, 'Visible', 'off')
end
