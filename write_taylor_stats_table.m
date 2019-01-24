function write_taylor_stats_table(filename,data,varargin)
% WRITE_TAYLOR_STATS_TABLE Write statistics used in a Taylor diagram to a CSV file.
%
% write_taylor_stats_table(filename,data[,'option',value])
%
% This function writes to a Comma Separated Value (CSV) file FILENAME the 
% statistics used to create a Taylor diagram for each of the data sets 
% contained in DATA. The first 2 arguments must be the inputs as described 
% below followed by optional arguments in the format of 'OPTION' name 
% followed by its value 'VALUE'.
%
% INPUTS:
%   filename   : name for statistics Excel file
%   data       : a multi-cell data structure containing the statistics used in
%                taylor diagrams
%   data.sdev  : Standard deviations (sigma)
%   data.crmsd : Centered Root Mean Square Difference
%   data.ccoef : Correlation Coefficient (r)
%
% OUTPUTS:
% 	None.
%
% LIST OF OPTIONS:
%   A title description for each dataset TITLE can be optionally provided as 
% well as a LABEL for each data point in the diagram.
%
%   'label', label : label for each data point in Taylor diagram, e.g. 
%                    'OC445 (CB)'
%   'overwrite', boolean : true/false flag to overwrite Excel file
%   'title', title : title descriptor for each data set in data, e.g. 
%                    'Expt. 01.0'
%
% See also taylor_diagram

% Get optional arguments
option = get_write_taylor_stats_options(varargin{:});

% Check for existence of file
if exist(filename,'file')
  if strcmp(option.overwrite,'on')
    delete(filename);
  else
    error(['File already exists: ' filename]);
  end
end

% Determine number of rows
nrows = 0;
ncell = length(data);
for i=1:ncell
    nrows = nrows + length(data{i}.sdev);
end

% Create table specifying data types and column headers
ncols = 5;
sz = [nrows ncols];
varNames = {'Dataset';'Description'; 'Standard_Deviation'; 'CRMSD'; ...
    'Correlation_Coeff'};
varTypes = {'string'; 'string'; 'single'; 'single'; 'single'};
T = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

% Populate table with rows of data
irow = 0;
for i=1:ncell
    % Get dataset descriptor
    if isempty(option.title)
        title = '';
    else
        title = option.title{i};
    end
    
    % Write each row of data
    ndata = length(data{i}.sdev);
    for j=1:ndata
        irow = irow + 1;
        if isempty(option.label)
            description = '';
        else
            description = option.label{j};
        end
        T(irow,:) = {title, description, data{i}.sdev(j), data{i}.crmsd(j), ...
                    data{i}.ccoef(j)};
    end
end

% Write all the data to Comma Separate Value (CSV) file
writetable(T,filename);

end % write_taylor_stats_table function

function option = get_write_taylor_stats_options(varargin)
%GET_WRITE_TAYLOR_STATS_OPTIONS Get optional arguments for write_taylor_stats function.
%
%   [OPTION] = GET_WRITE_TAYLOR_STATS_OPTIONS(NARG,VARARGIN)
%   Retrieves the NARG optional arguments supplied to the WRITE_TAYLOR_STATS 
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
%   option.label : label for each data point in data set.
%   option.overwrite : boolean to overwrite Excel file.
%   option.title : title descriptor for data set.

% Set default parameters
option.label = [];
option.overwrite = 'off';
option.title = [];

% Load custom options, storing values in option data structure
nopt = nargin/2;
for iopt = 1 : 2 : nargin
    optname  = varargin{iopt};
    optvalue = varargin{iopt+1};
    switch lower(optname)
        case 'label'
            option.label = optvalue;
        case 'overwrite'
            option.overwrite = check_on_off(optvalue);
        case 'title'
            option.title=optvalue;
        otherwise
            error(['Unrecognized option: ' optname]);
    end
end % iopt loop

end %function get_write_taylor_stats_options
