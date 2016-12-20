function xlsfont(filename,sheetname,varargin)

%XLSFONT modifies fonts of selected Excel cell(s)
%
% xlsfont(filename,sheetname,'Whole', param,value, ...)
% xlsfont(filename,sheetname,'Find',text, param,value, ...)
% xlsfont(filename,sheetname,range, param,value, ...)
%
% xlsfont  : modifies fonts of selected Excel cell(s) in a selected sheet.
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
%           'font'         - to be followed by font name (ex. 'Arial')
%           'size'         - to be followed by font size.
%           'fontstyle'   - to be followed by string combination of all or
%                            any of 'bold','italic','regular'.
%                            example ('italic bold','bold','italic','regular italic')
%           'underline'    - to be followed by one of the following integers:
%                               0: None.
%                               1: Single.
%                               2: Single Accounting.
%                               3: Double.
%                               4: Double Accounting.
%           'strikethrough'- to be followed by 0 or 1.
%           'superscript'  - to be followed by 0 or 1.
%           'subscript'    - to be followed by 0 or 1.
%           'color'        - to be followed by Excel color index number.
%                           (ex. 1:Black 2:White 3:Red 4:Green 5:Blue)
%           'interior'     - to be followed 3 integers indicating (ColorIndex,Pattern,PatternColorIndex)
%                           ColorIndex: to be followed by Excel color index number.
%                                       (ex. 1:Black 2:White 3:Red 4:Green 5:Blue)
%                           Pattern: to be followed by one of the following integers:
% 								0: Automatic
% 								1: Solid
% 								2: Gray 75%
% 								3: Gray 50%
% 								4: Gray 25%
% 								5: Gray 16%
% 								6: Gray 8%
% 								7: Horizontal
% 								8: Vertical
% 								9: Down
% 								10: Up
% 								11: Checker
% 								12: Semi Gray 75%
% 								13: Light Horizontal
% 								14: Light Vertical
% 								15: Light Down
% 								16: Light Up
% 								17: Grid
% 								18: Criss Cross
%                           PatternColorIndex: to be followed by Excel color index number.
%                                       (ex. 1:Black 2:White 3:Red 4:Green 5:Blue)
% Examples:
%      
%   xlsfont('file.xls','Sheet1','whole','font','Courier New');
%   xlsfont('file.xls','Sheet1','A1:C3','size',15,'fontstyle','bold italic');
%   xlsfont('file.xls','Sheet1','B:B','size',15,'fontstyle','regular');
%   xlsfont('file.xls','Sheet1','Find','something','strikethrough',1,'colorindex',3);
%   xlsfont('file.xls','Sheet1','A1','underline',3);
%   xlsfont('file.xls','Sheet1','2:2','interior',1,11,4);
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

n=1;
while n<=length(options)
    if strmatch(options{n},'font','exact')
        set(Excel.Selection.Font,'Name',options{n+1});
        n=n+2;
    elseif strmatch(lower(options{n}),'fontstyle','exact')
        if strmatch('bold',options{n+1})
            set(Excel.Selection.Font,'Bold',1);
        else set(Excel.Selection.Font,'Bold',0); end
        
        if strmatch('italic',options{n+1})
            set(Excel.Selection.Font,'italic',1);
        else set(Excel.Selection.Font,'italic',0); end        
        
        if strmatch('regular',options{n+1})
            set(Excel.Selection.Font,'FontStyle','Regular');
        end
        n=n+2;
    elseif strmatch(lower(options{n}),'size','exact')
        set(Excel.Selection.Font,'Size',options{n+1});
        n=n+2;
    elseif strmatch(lower(options{n}),'underline')
        underline = [-4142 2 4 -4119 5];
        % xlUnderlineStyleNone = -4142        
        % xlUnderlineStyleSingle = 2
        % xlUnderlineStyleSingleAccounting = 4
        % xlUnderlineStyleDouble = -4119
        % xlUnderlineStyleDoubleAccounting = 5
        set(Excel.Selection.Font,'Underline',underline(options{n+1}-1));
        n=n+2;
    elseif strmatch(lower(options{n}),'strikethrough')
        set(Excel.Selection.Font,'Strikethrough',options{n+1});
        n=n+2;
    elseif strmatch(lower(options{n}),'superscript')
        set(Excel.Selection.Font,'Superscript',options{n+1});
        n=n+2;
    elseif strmatch(lower(options{n}),'subscript')
        set(Excel.Selection.Font,'Subscript',options{n+1});
        n=n+2;
    elseif strmatch(lower(options{n}),'color')
        set(Excel.Selection.Font,'ColorIndex',options{n+1});
        n=n+2;
    elseif strmatch(lower(options{n}),'interior')
        pattern_opt = [-4105 1 -4126 -4125 -4124 17 18 -4128 -4166 -4121 ...
                -4162 9 10 11 12 13 14 15 16];
        % xlAutomatic = -4105
        % xlSolid = 1
        % xlGray75 = -4126
        % xlGray50 = -4125
        % xlGray25 = -4124
        % xlGray16 = 17
        % xlGray8 = 18
        % xlHorizontal = -4128
        % xlVertical = -4166
        % xlDown = -4121
        % xlUp = -4162
        % xlChecker = 9
        % xlSemiGray75 = 10
        % xlLightHorizontal = 11
        % xlLightVertical = 12
        % xlLightDown = 13
        % xlLightUp = 14
        % xlGrid = 15
        % xlCrissCross = 16
        set(Excel.Selection.Interior,'ColorIndex',options{n+1});
        set(Excel.Selection.Interior,'Pattern',pattern_opt(options{n+2}+1));
        set(Excel.Selection.Interior,'PatternColorIndex',options{n+3});
        n=n+4;
    else
        n=n+10;
    end
end

invoke(Workbook, 'Save');
invoke(Excel, 'Quit');
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
