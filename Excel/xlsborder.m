function xlsborder(filename,sheetname,varargin)

%XLSBORDER modifies borders of selected Excel cell(s)
%
% xlsborder(filename,sheetname,'Whole', param,LineStyle,Weight,ColorIndex, ...)
% xlsborder(filename,sheetname,'Find',text, param,LineStyle,Weight,ColorIndex, ...)
% xlsborder(filename,sheetname,range, param,LineStyle,Weight,ColorIndex, ...)
%
% xlsborder  : modifies borders of selected Excel cell(s) in a selected sheet.
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
%       Possible param options are:
%
%           'Box'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'Cross'     - to be followed by one of the following integers:
%           'DiagonalDown'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'DiagonalUp'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'EdgeBottom'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'EdgeLeft'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'EdgeRight'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'EdgeTop'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'InsideHorizontal'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%           'InsideVertical'   - to be followed 3 integers indicating (LineStyle,Weight,ColorIndex)
%
%       LineStyle:  to be assigned one of the following integers:
%                   0: None
%                   1: Continious
%                   2: Dash
%                   3: Dash Dot
%                   4: Dash Dot Dot
%                   5: Dot
%                   6: Double
%                   7: Slant Dash Dot
%   
%       Weight:     to be assigned one of the following integers:
%                   1: Hairline
%                   2: Thin
%                   3: Medium
%                   4: Thick
%
%       ColorIndex: to be followed by Excel color index number.
%                   (ex. 1:Black 2:White 3:Red 4:Green 5:Blue)
%
% Examples:
%      
%   xlsborder('file.xls','Sheet1','A1:A2','Box',1,2,1);
%   xlsborder('file.xls','Sheet1','A1:B2','Cross',6,4,5);
%   xlsborder('file.xls','Sheet1','A1:A2','EdgeTop',1,2,1,'EdgeBottom',4,3,3);
%
%   See also XLSREAD, XLSFINFO, XLSWRITE, XLSCELL, XLSHEETS, , CPTXT2XLS, MSOPEN

%   Copyright 2004 Fahad Al Mahmood
%   Version: 1.0 $  $Date: 21-Mar-2004

borders_opt = {'DiagonalDown',5;...
        'DiagonalUp',6;
    'EdgeBottom',9;
    'EdgeLeft',7;
    'EdgeRight',10;
    'EdgeTop',8;
    'InsideHorizontal',12;
    'InsideVertical',11};

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
    fpath = pwd;
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

line_style_opt = [-4142 1 -4115 4 5 -4118 -4119 13];
% xlLineStyleNone = -4142
% xlContinious = 1
% xlDash = -4115
% xlDashDot = 4
% xlDashDotDot = 5
% xlDot = -4118
% xlDouble = -4119
% xlSlantDashDot = 13

weight_opt = [1 2 -4138 4];
% xlHairline = 1
% xlThin = 2
% xlMedium = -4138
% xlThick = 4


borders_opt = {'DiagonalDown',5;...
        'DiagonalUp',6;
    'EdgeBottom',9;
    'EdgeLeft',7;
    'EdgeRight',10;
    'EdgeTop',8;
    'InsideHorizontal',12;
    'InsideVertical',11};

n=1;
while n<=length(options)
    borders_loc = strmatch(lower(options{n}),lower(borders_opt(:,1)),'exact');
    if isempty(borders_loc) & strmatch(lower(options{n}),'box','exact');
        Line = get(Excel.Selection,'Borders',9);
        set(Line,'Weight',weight_opt(options{n+2}));
        set(Line,'LineStyle',line_style_opt(options{n+1}+1));
        set(Line,'ColorIndex',options{n+3});
        Line = get(Excel.Selection,'Borders',7);
        set(Line,'Weight',weight_opt(options{n+2}));
        set(Line,'LineStyle',line_style_opt(options{n+1}+1));
        set(Line,'ColorIndex',options{n+3});
        Line = get(Excel.Selection,'Borders',10);
        set(Line,'Weight',weight_opt(options{n+2}));
        set(Line,'LineStyle',line_style_opt(options{n+1}+1));
        set(Line,'ColorIndex',options{n+3});
        Line = get(Excel.Selection,'Borders',8);
        set(Line,'Weight',weight_opt(options{n+2}));
        set(Line,'LineStyle',line_style_opt(options{n+1}+1));
        set(Line,'ColorIndex',options{n+3});
    elseif isempty(borders_loc) & strmatch(lower(options{n}),'cross','exact');
        Line = get(Excel.Selection,'Borders',11);
        set(Line,'Weight',weight_opt(options{n+2}));
        set(Line,'LineStyle',line_style_opt(options{n+1}+1));
        set(Line,'ColorIndex',options{n+3});
        Line = get(Excel.Selection,'Borders',12);
        set(Line,'Weight',weight_opt(options{n+2}));
        set(Line,'LineStyle',line_style_opt(options{n+1}+1));
        set(Line,'ColorIndex',options{n+3});
    elseif ~isempty(borders_loc)
        Line = get(Excel.Selection,'Borders',borders_opt{borders_loc,2});
        set(Line,'Weight',weight_opt(options{n+2}));
        set(Line,'LineStyle',line_style_opt(options{n+1}+1));
        set(Line,'ColorIndex',options{n+3});
    end
    n=n+4;
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
