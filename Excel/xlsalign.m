function xlsalign(filename,sheetname,varargin)

%XLSALIGN modifies alignment options of selected Excel cell(s)
%
% xlsalign(filename,sheetname,'Whole', param,value, ...)
% xlsalign(filename,sheetname,'Find',text, param,value, ...)
% xlsalign(filename,sheetname,range, param,value, ...)
%
% xlsalign  : modifies alignment options of selected Excel cell(s) in a selected sheet.
%
%       filename:       Name of excel file.
%       sheetname:      sheet name.
%       'Whole':        to select whole sheet.
%       'Find':         to look for specific string 'text' in the sheet to
%                       change the font.
%       text:           string text to look for in sheet using 'Find'.
% 
%       USER CONFIGURABLE OPTIONS
%  
%       Possible param/value options are:
%
%           'Horizontal'   - to be followed by one of the following integers:
%                           1: General
%                           2: Left
%                           3: Center
%                           4: Right
%                           5: Fill
%                           6: Justify
%                           7: Center Across Selection
%                           8: Distributed
%           'Vertical'     - to be followed by one of the following integers:
%                           1: Top
%                           2: Center
%                           3: Bottom
%                           4: Justify
%                           5: Distributed
%           'WrapText'     - to be followed by 0 or 1.
%           'Orientation'  - to be followed by integer angle between [-90,90]
%           'IndentLevel'  - to be followed by integer value between [0,15]
%           'ShrinkToFit'  - to be followed by 0 or 1.
%           'TextDirection'- to be followed by one of the following integers:
%                               1: Context
%                               2: Left-to-Right
%                               3: Right-to-Left
%           'MergeCells'   - to be followed by 0 or 1.
%   
% Examples:
%      
%   xlsalign('file.xls','Sheet1','A1:A2','MergeCells',1);
%   xlsalign('file.xls','Sheet1','A1:A2','Horizontal',3,'WrapText',1);
%   xlsalign('file.xls','Sheet1','A1:A2','Orientation',90,'ShrinkToFit',1);
%
%   See also XLSREAD, XLSFINFO, XLSWRITE, XLSCELL, XLSHEETS, , CPTXT2XLS, MSOPEN

%   Copyright 2004 Fahad Al Mahmood
%   Version: 1.0 $  $Date: 21-Mar-2004



options = varargin;
if strmatch(lower(varargin{1}),'find','exact')
    text = varargin{2};
    options = varargin(3:end);
elseif strmatch(lower(varargin{1}),'whole','exact')
    whole = 1;
    options = varargin(2:end);
else
    range = varargin{1};
    options = varargin(2:end);
end

[fpath,file,ext] = fileparts(char(filename));
if isempty(fpath)
    % Use current path
    fpath = pwd;
elseif strfind(fpath,'../')
    % Remove relative path reference because Excel.Workbooks function
    % cannot interpret a path containing '../'
    path1 = pwd;
    path2 = fpath;
    name = '';
    while strfind(path2,'../')
        [path1, name1, ext1] = fileparts(path1);
        [path2, name2, ext2] = fileparts(path2);
        if isempty(name)
            name = name2;
        end
    end
    fpath = [path1 filesep name];
end
Excel = actxserver('Excel.Application');
set(Excel,'Visible',0);
Workbook = invoke(Excel.Workbooks, 'open', [fpath filesep file ext]);
sheet = get(Excel.Worksheets, 'Item',sheetname);
invoke(sheet,'Activate');

if exist('text','var')
    Cell_Found = invoke(Excel.Cells,'Find',text,Excel.ActiveCell,-4123,2,1,1,0,0);
    Cell_Found.Select;
elseif exist('whole','var')
    Excel.Cells.Select;
elseif exist('range','var')
    ExAct = Excel.Activesheet;
    ExActRange = get(ExAct,'Range',range);
    ExActRange.Select;
end

n=1;
while n<=length(options)
    if strmatch(lower(options{n}),'horizontal','exact')
        horz_opt = [1 -4131 -4108 -4152 5 -4130 7 -4117];
        % xlGeneral = 1
        % xlLeft = -4131
        % xlCenter = -4108
        % xlRight = -4152
        % xlFill = 5
        % xlJustify = -4130
        % xlCenterAcrossSelection = 7
        % xlDistributed = -4117        
        set(Excel.Selection,'HorizontalAlignment',horz_opt(options{n+1}));
    elseif strmatch(lower(options{n}),'vertical','exact')
        vert_opt = [-4160 -4108 -4107 -4130 -4117];
        % xlTop = -4160
        % xlCenter = -4108
        % xlBottom = -4107
        % xlJustify = -4130
        % xlDistributed = -4117
        set(Excel.Selection,'VerticalAlignment',vert_opt(options{n+1}));
    elseif strmatch(lower(options{n}),'wraptext','exact')
        set(Excel.Selection,'WrapText',options{n+1});
    elseif strmatch(lower(options{n}),'orientation','exact')
        set(Excel.Selection,'Orientation',options{n+1});
    elseif strmatch(lower(options{n}),'indentlevel','exact')
        set(Excel.Selection,'IndentLevel',options{n+1});
    elseif strmatch(lower(options{n}),'shrinktofit','exact')
        set(Excel.Selection,'ShrinkToFit',options{n+1});
    elseif strmatch(lower(options{n}),'mergecells','exact')
        set(Excel.Selection,'MergeCells',options{n+1});            
    elseif strmatch(lower(options{n}),'textdirection','exact')
        textdir_opt = [-5002 -5003 -5004];
        % xlContext = -5002
        % xlLTR = -5003
        % xlRTL = -5004        
        set(Excel.Selection,'ReadingOrder',textdir_opt(options{n+1}));      
    end
    n=n+2;
end

invoke(Workbook,'Save');
invoke(Excel,'Quit');
delete(Excel);

% Function Find(What, [After], [LookIn], [LookAt], [SearchOrder],
% [SearchDirection As XlSearchDirection = xlNext], [MatchCase], [MatchByte], [SearchFormat])
%
% [After] = Excel.Selection
% [LookIn] = -4123 % xlFormulas
%          = -4163 % xlValues
%          = -4144 % xlComments
% [SearchOrder] = 1 % xlByRows
%               = 2 % xlByColumns
% [SearchDirection] = 1 % xlNext
%                   = 2 % xlPrevious
%  [MatchCase] = 1 % True
%              = 0 % False
%  [MatchByte] = 1 % True
%              = 0 % False
%  [SearchFormat] = 1 % True
%                 = 0 % False  
