function write_taylor_stats(filename,data,varargin)
% WRITE_TAYLOR_STATS Write statistics used in a Taylor diagram to an Excel file.
%
% write_taylor_stats(filename,data[,'option',value])
%
% This function writes to an Excel file FILENAME the statistics used to 
% create a Taylor diagram for each of the data sets contained in DATA. 
% The first 2 arguments must be the inputs as described below followed by
% optional arguments in the format of 'OPTION' name followed by its value
% 'VALUE'.
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
  endif
end

% Write title information to file
status = xlswrite(filename,{'Taylor Statistics'},'A2:A2');

% Determine number of cells in data structure
ncell = length(data);

% Write data for each cell
start_row = 4;
headers = {'Description','Standard Deviation','CRMSD','Correlation Coeff.'};
for i=1:ncell
    if length(option.title) > 0
        % Write dataset descriptor
        title = cellstr(option.title{i});
        row = num2str(start_row);
        xlrange = ['A' row ':A' row];
        status = xlswrite(filename,title,xlrange);
    end
    
    % Write column headers
    row = num2str(start_row+1);
    xlrange = ['A' row ':D' row];
    status = xlswrite(filename,headers,xlrange);
    
    % Write each row of data
    ndata = length(data{i}.sdev);
    A = [];
    for j=1:ndata
        if length(option.label) > 0
            row_data = {option.label{j}, data{i}.sdev(j), data{i}.crmsd(j), ...
                        data{i}.ccoef(j)};
        else
            row_data = {'', data{i}.sdev(j), data{i}.crmsd(j), data{i}.ccoef(j)};
        end
        A = [A; row_data];
    end
    xlrange = ['A' num2str(start_row+2) ':D' num2str(start_row+1+ndata)];
    status = xlswrite(filename,A,xlrange);
    start_row = start_row + ndata + 3;
end

end % write_taylor_stats function

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
