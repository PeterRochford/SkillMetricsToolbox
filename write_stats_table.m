function write_stats_table(filename,data,varargin)
% WRITE_STATS_TABLE Write statistics to a Comma Separated Value (CSV) file
%
% write_stats_table(filename,data[,'option',value])
%
% This function writes to a Comma Separated Value (CSV) file FILENAME the 
% statistics provided in each of the data sets contained in DATA. The 
% first 2 arguments must be the inputs as described below followed by 
% optional arguments in the format of 'OPTION' name followed by its value 
% 'VALUE'. Each statistic will be labeled according to the name under which
% it is stored in the DATA data structure, e.g. data.bias will be labeled 
% as "bias".
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

% Determine number of cells in data structure and create appropriate 
% header and variable types
varNames = {'Skill_Metric'};
varTypes = {'string'};
ncell = length(data);
for i=1:length(data)
  varNames{i+1} = ['Case_' num2str(i)];
  varTypes{i+1} = 'single';
end

% Get data of all the fields
fieldname = fieldnames(data);
nfields = length(fieldname);

% Create table specifying data types and column headers
sz = [nfields ncell+1];
T = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

% Populate table with rows of data
field_values = zeros(1, ncell);
for i=1:nfields
    % Get data for field
    for j=1:ncell
      field_values(j) = getfield(data(j), fieldname{i});
    end
    
    % Store row of data
    T(i,:) = {fieldname{i},field_values};
end

% Write all the data to Comma Separate Value (CSV) file
writetable(T,filename);

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
