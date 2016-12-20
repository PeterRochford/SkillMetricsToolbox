function xlscomment(filename,sheetname,cell,comment,visible)

%XLSCOMMENT Adds comment to a specified cell in Excel sheet.
%
% xlscomment(filename,sheetname,cell,comment,visible)
%
%       filename:       Name of excel file.
%       sheetname:      sheet name.
%       cell:           cell location (ex. 'C5', 'B9')
%       comment:        comment to be inserted consisting of string of characters 
%       visible:        0:  to hide comment.
%                       1:  to make comment visible.
% 
% Example:
%      
%   xlscomment('file.xls','Sheet1','B4','This is my Comment!',1)
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


% Adding Comment to a Cell !
X = get(Excel.ActiveSheet,'Range',cell);
X.Select;
try
X.AddComment;
catch
    warning('comment already exists ... now replaced with new one');
end
set(X.Comment,'Visible',visible);
invoke(X.Comment,'Text',comment);

invoke(Workbook, 'Save');
invoke(Excel, 'Quit');
delete(Excel);

