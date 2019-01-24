function write_stats(filename,data,varargin)
% WRITE_STATS Write statistics to an Excel file
%
% write_stats(filename,data[,'option',value])
%
% This function writes to an Excel file FILENAME the statistics provided 
% in each of the data sets contained in DATA. The first 2 arguments must 
% be the inputs as described below followed by optional arguments in the 
% format of 'OPTION' name followed by its value 'VALUE'. Each statistic
% will be labeled according to the name under which it is stored in the 
% DATA data structure, e.g. data.bias will be labeled as "bias".
%
% INPUTS:
%   filename   : name for statistics Excel file
%   data       : a multi-cell data structure containing the statistics
%   data.stat  : statistics, e.g. data.bias for Bias.
%
% OUTPUTS:
% 	None.
%
% LIST OF OPTIONS:
%   A title description for each dataset TITLE can be optionally provided 
% as well as an overwrite option if the file name currently exists.
%
%   'overwrite', boolean : true/false flag to overwrite Excel file
%   'title', title : title descriptor for each data set in data, e.g. 
%                    'Expt. 01.0'

% Get optional arguments
option = get_write_stats_options(varargin{:});

% Check for existence of file
if exist(filename,'file')
  if option.overwrite
    delete(filename);
  else
    error(['File already exists: ' filename]);
  end
end

% Write title information to file
status = xlswrite(filename,{'Skill Metrics'},'A2:A2');

% Determine number of cells in data structure and create appropriate 
% header
headers = {'Skill Metric'};
ncell = length(data);
for i=1:length(data)
  headers{i+1} = ['Case ' num2str(i)];
end

% Write descriptive title
start_row = 2;
if length(option.title) > 0
    title = cellstr(option.title);
    row = num2str(start_row);
    xlrange = ['A' row ':A' row];
    status = xlswrite(filename,title,xlrange);
end

% Write column headers
start_row = start_row + 2;
row = num2str(start_row);
last_col = char(ncell+1 + 64);
status = xlswrite(filename,headers,['A' row ':' last_col row]);

% Write data of all the fields
fieldname = fieldnames(data);
nfields = length(fieldname);

xlsdata = [];
for i=1:nfields
    % Get data for field
    field_values = [];
    for j=1:ncell
      field_values = [field_values; getfield(data(j), fieldname{i})];
    end
    
    % Store row of data
    row_data = {fieldname{i}};
    row_data(2:ncell+1) = num2cell(field_values);
    xlsdata = [xlsdata; row_data];
end
start_row = start_row + 1;
last_row = start_row + nfields - 1;
last_col = char(ncell + 1 + 64);

% Write all the data to Excel file
xlrange = ['A' num2str(start_row) ':' last_col num2str(last_row)];
status = xlswrite(filename,xlsdata,xlrange);

end % write_target_stats function

function option = get_write_stats_options(varargin)
%GET_WRITE_STATS_OPTIONS Get optional arguments for write_stats function.
%
%   [OPTION] = GET_WRITE_STATS_OPTIONS(NARG,VARARGIN)
%   Retrieves the NARG optional arguments supplied to the WRITE_STATS 
%   function as a variable-length input argument list (VARARGIN), and
%   returns the values in a OPTION data structure. Default values are 
%   assigned to selected optional arguments. Unassigned arguments do not
%   appear in the OPTION data structure. The function will terminate
%   with an error if an unrecognized optional argument is supplied.
%
%   INPUTS:
%   varagin : variable-length input argument list
%
%   OUTPUTS:
%   option : data structure containing option values.
%   option.title : title descriptor for data set.
%   option.overwrite : boolean to overwrite Excel file.

% Set default parameters
option.overwrite = false;
option.title = [];

% Load custom options, storing values in option data structure
nopt = nargin/2;
for iopt = 1 : 2 : nargin
    optname  = varargin{iopt};
    optvalue = varargin{iopt+1};
    switch lower(optname)
        case 'overwrite'
            option.overwrite = check_on_off(optvalue);
        case 'title'
            option.title=optvalue;
        otherwise
            error(['Unrecognized option: ' optname]);
    end
end % iopt loop

end % function get_write_stats_options
