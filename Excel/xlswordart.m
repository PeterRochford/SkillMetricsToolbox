function xlswordart(filename,sheetname,Effect,Text,Size,Font,Bold,Italic,Left,Top);

%XLSWORDART Adds WordArt to a specified location in an Excel sheet.
%
% xlswordart(filename,sheetname,Effect,Text,Size,Bold,Italic,Left,Top);
%
%       filename:       Name of excel file.
%       sheetname:      sheet name.
%       Effect:         Integer from 0 to 29.
%       Text:           text to be displayed in WordArt consisting of string of characters 
%       Size:           Integer number indicating font size.
%       Font:           Font name consisting of string of characters (ex.'Arial')
%       Bold:           On: 1, Off: 0
%       Italic:         On: 1, Off: 0
%       Left:           Indent from left side of screen (pixels).
%       Top:            Indent from top side of screen (pixels).
% 
% Examples:
%      
%   xlswordart('file.xls','Sheet1',7,'My Profile!',30,'Impact',1,1,50,50);
%
%   See also XLSREAD, XLSFINFO, XLSWRITE, XLSCELL, XLSHEETS, XLSALIGN,
%   XLSBORDER, XLSFONT, MSOPEN

%   Copyright 2004 Fahad Al Mahmood
%   Version: 1.0 $  $Date: 09-Jun-2004

[fpath,file,ext] = fileparts(char(filename));
if isempty(fpath)
    fpath = pwd;
end
Excel = actxserver('Excel.Application');
set(Excel,'Visible',0);
Workbook = invoke(Excel.Workbooks, 'open', [fpath filesep file ext]);
sheet = get(Excel.Worksheets, 'Item',sheetname);
invoke(sheet,'Activate');
    
    if Bold==1 Bold = -1; end
    if Italic==1 Italic = -1; end
    
X = invoke(Excel.ActiveSheet.Shapes,'AddTextEffect',Effect,Text,Font,Size,Bold,Italic,Left,Top);

% AddTextEffect(PresetTextEffect As MsoPresetTextEffect,
%               Text As String,
%               FontName As String,
%               FontSize As Single,
%               FontBold As MsoTriState,
%               FontItalic As MsoTriState,
%               Left As Single,
%               Top As Single) 

invoke(Workbook, 'Save');
invoke(Excel, 'Quit');
delete(Excel);

%     X.Select;
%     invoke(X.ShapeRange.Fill,'Visible',1);
%     Selection.ShapeRange.Fill.Solid
%     Selection.ShapeRange.Fill.ForeColor.SchemeColor = 53
%     Selection.ShapeRange.Fill.Transparency = 0.2
%     Selection.ShapeRange.Line.Weight = 0.75
%     Selection.ShapeRange.Line.DashStyle = msoLineSolid
%     Selection.ShapeRange.Line.Style = msoLineSingle
%     Selection.ShapeRange.Line.Transparency = 0#
%     Selection.ShapeRange.Line.Visible = msoTrue
%     Selection.ShapeRange.Line.ForeColor.SchemeColor = 51
%     Selection.ShapeRange.Line.BackColor.RGB = RGB(255, 255, 255)
%     Selection.ShapeRange.AlternativeText = "Alternative"