function varargout = taylor_diagram(varargin)
% TAYLOR_DIAGRAM Plot a Taylor Diagram from statistics of different series.
%
% [hp, ht, axl] = taylor_diagram(STDs,RMSs,CORs,['option',value])
%
% Plot a Taylor diagram from statistics of different series.
%
% INPUTS:
%	STDs: Standard deviations
%	RMSs: Centered Root Mean Square Difference 
%	CORs: Correlation
%
%	Each of these inputs are one-dimensional with the same length. First
%	index corresponds to the reference series for the diagram. For example
%	STDs(1) is the standard deviation of the reference series and STDs(2:N) 
%	are the standard deviations of the other series. Note that only the
%	latter are plotted.
% 
%	Note that by definition the following relation must be true for all 
%	series i:
%
%     RMSs(i) = sqrt(STDs(i).^2 + STDs(1)^2 - 2*STDs(i)*STDs(1).*CORs(i))
%
%	This relation is checked if the checkStats option is used, and if not 
%   verified an error message is sent. This relation is not checked by
%   default. Please see Taylor's JGR article for more informations about 
%   this relation.
%	You can use the ALLSTATS function to avoid this to happen, I guess ;-). 
%   You can get it somewhere from: http://codes.guillaumemaze.org/matlab
%
% OUTPUTS:
% hp: returns handles of plotted points
%	ht: returns handles of the text legend of points
%	axl: returns a structure of handles of axis labels
%
% LIST OF OPTIONS:
%	For an exhaustive list of options to customize your diagram, please 
%   call the function without arguments:
%		>> taylor_diagram
%
% See also GET_TAYLOR_DIAGRAM_OPTIONS
%
% SHORT TUTORIAL (see taylordiag_test.m for more informations):
%	 An easy way to get compute inputs is to use the ALLSTATS function you 
%    can get from:
%	 	http://codes.guillaumemaze.org/matlab
%
%	 Let's say you gathered all the series you want to put in the Taylor 
%    diagram in a single matrix BUOY(N,nt) with N the number of series and 
%    nt is their (similar) length.
%	 If BUOY(1,:) is the series of reference for the diagram:
%		 for iseries = 2 : size(BUOY,1)
%		    S = allstats(BUOY(1,:),BUOY(iseries,:));
%		    MYSTATS(iseries,:) = S(:,2); % We get stats versus reference
%		 end %for iseries
%		 MYSTATS(1,:) = S(:,1); % We assign reference stats to the first row
%
%	 Note that the ALLSTATS function can handle NaNs, so be careful to 
%    compute statistics with enough points!
%	 Then you're ready to simply run:
%		taylor_diagram(MYSTATS(:,2),MYSTATS(:,3),MYSTATS(:,4));
%	
%   REFERENCE:
%
%   Taylor, K. E. (2001) Summarizing multiple aspects of model performance
%     in a single diagram, J. Geophys. Res., 106(D7), 7183�7192, 
%     doi:10.1029/2000JD900719.

% Rev. by Peter Rochford on 2017-02-02:
%   This is a major rewriting of the taylordiag function originally written
%   by Guillaume Maze and therefore renamed as taylor_diagram to make it
%   distinct. The main new capabilities are summarized below.
%
%   1) Modularized the original Matlab script and created several new 
%      functions to facilitate addition of new capabilities and source code
%      reuse.
%
%   2) Added option to suppress or invoke check of Taylor statistics 
%      relation. Default is no check.
%
%   3) Modified statistics relation to pass if statistical metrics agree to 
%      within 1%. User can modify code as desired. The original test was 
%      too sensitive.
%
%   4) Fixed bug with coordinates having to be double when passed to "text"
%      function.
%
%   5) Added options for labeling markers and setting the label colors.
%
%   6) Added options for displaying markers represented by individual
%      symbols, a legend option, and color coded markers based on RMSD 
%      value along with a color bar.
%
%   7) Added options for displaying observation STD on the axis, a label for the 
%      point, and a circle.
%
% Rev. by Guillaume Maze on 2010-02-10: Help more helpful ! Options now 
%   displayed by call.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are 
% met:
% 	* Redistributions of source code must retain the above copyright 
%     notice, this list of conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright 
%     notice, this list of conditions and the following disclaimer in the 
%     documentation and/or other materials provided with the distribution.
% 	* Neither the name of the Laboratoire de Physique des Oceans nor the 
%     names of its contributors may be used to endorse or promote products 
%     derived from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY Guillaume Maze ''AS IS'' AND ANY EXPRESS OR 
% IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
% OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
% IN NO EVENT SHALL Guillaume Maze BE LIABLE FOR ANY DIRECT, INDIRECT, 
% INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
% NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
% DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
% THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% __ Check for number of arguments
[STDs, RMSs, CORs, narg] = get_taylor_diagram_arguments(varargin{:});
if nargin == 0; return; end

% __ Get options
option = get_taylor_diagram_options(CORs,narg,varargin{:});

% __ Check the input statistics if requested.
if strcmp(option.checkSTATS,'on')
    last = length(STDs);
    check_taylor_stats(STDs(2:last), RMSs(2:last), CORs(2:last), 0.02);
end %checkStats

% __ Express statistics in polar coordinates.
rho   = STDs;
theta = real(acos(CORs));

% __ Get axis values for plot
[axes, cax, option] = get_taylor_diagram_axes(rho,option);

if strcmp(option.overlay,'off')
    % __ Draw circles about origin
    axes = overlay_taylor_diagram_circles(axes,cax,option);
    
    % __ Draw lines emanating from origin
    axes = overlay_taylor_diagram_lines(axes,cax,option);
    
    % __ Plot axes for Taylor diagram
    axes = plot_taylor_axes(axes,cax,option);
    
    % __ Plot marker on axis indicating observation STD
    axes = plot_taylor_obs(STDs(1),axes,option);
end % no overlay

% __ Plot data points. Note that only rho(2:N) and theta(2:N) are plotted
%    in the figure as rho(1) and theta(1) indicate the observed standard
%    deviation point.
X = rho(2:end).*cos(theta(2:end));
Y = rho(2:end).*sin(theta(2:end));
hold on
switch lower(option.markerDisplayed)
    case 'marker'
        [hp, ht] = plot_pattern_diagram_markers(X,Y,option);
    case 'colorbar'
        if isfield(option, 'cmapzdata')
            % Use array values provided via option.cmapzdata
            Z = option.cmapzdata(2:end);
        else
            % Use Centered Root Mean Square Difference for colors
            Z = RMSs(2:end);
        end
        hp = plot_pattern_diagram_colorbar(X,Y,Z,option);
    otherwise
        error(['Unrecognized option: ' option.markerDisplayed]);
end

% __ Return appropriate arguments
switch nargout
    case 1
        varargout(1) = {hp};
    case 2
        varargout(1) = {hp};
        switch lower(option.markerDisplayed)
            case 'marker'
                varargout(2) = {ht};
            case 'colorbar'
                 varargout(2) = cell(1);
        end
    case 3
        varargout(1) = {hp};
        switch lower(option.markerDisplayed)
            case 'marker'
                varargout(2) = {ht};
            case 'colorbar'
                 varargout(2) = cell(1);
        end
		varargout(3) = {axes};
end

end % taylor_diagram function

function [STDs, RMSs, CORs, narg] = get_taylor_diagram_arguments(varargin)
%[STDs, RMSs, CORs, narg] = get_taylor_diagram_arguments(varargin)
%   Get arguments for taylor_diagram function.
%
%   [STDs, RMSs, CORs, narg] = GET_TAYLOR_DIAGRAM_ARGUMENTS(VARARGIN)
%   Retrieves the arguments supplied to the TAYLOR_DIAGRAM function as
%   a variable-length input argument list (VARARGIN), tests the first 3 
%   arguments are numeric quantities, and returns the number of optional 
%   arguments supplied.
%
%   INPUTS:
%   varagin : variable-length input argument list
%
%   OUTPUTS:
%   STDs: Standard deviations
%   RMSs: Centered Root Mean Square Difference 
%   CORs: Correlation
%   narg  : number of optional arguments
    
STDs=[]; RMSs=[]; CORs=[]; narg = 0;
if nargin == 0
    % Display options list
	display_taylor_diagram_options;
	return
elseif nargin < 3
    error('Insufficient number of arguments')
else
    % Check number of arguments
	narg = nargin - 3;
	if mod(narg,2) ~= 0 
		error('Wrong number of arguments')
	end
end

STDs = varargin{1};
RMSs = varargin{2};
CORs = varargin{3};

% Test the above are numeric quantities
if ~isa(STDs,'numeric')
    error('Argument STDs is not a numeric');
end
if ~isa(RMSs,'numeric')
    error('Argument RMSs is not a numeric');
end
if ~isa(CORs,'numeric')
    error('Argument CORs is not a numeric');
end
end % function get_taylor_diagram_arguments

function display_taylor_diagram_options
%DISPLAY_TARGET_DIAGRAM_OPTIONS
%   Displays available options for TAYLOR_DIAGRAM function.

disp('General options:')
dispopt('''numberPanels''',sprintf(['1 or 2: Panels to display (1 for positive ' ...
    'correlations, 2 for positive and negative correlations).' ...
    '\n\t\tDefault value depends on correlations (CORs).']));
dispopt('''overlay''',sprintf(['''on'' / ''off'' (default): ' ...
    'Switch to overlay current statistics on Taylor diagram. ' ...
    '\n\t\tOnly markers will be displayed.']));
dispopt('''alpha''',sprintf(['Blending of symbol face color (0.0 transparent ' ...
    'through 1.0 opaque)\n\t\t' ...
    '(Default: 1.0)']));
dispopt('''axismax''',sprintf(['Maximum for the radial contours']));
dispopt('''colormap''',sprintf(['''on'' / ''off'' (default): ' ...
    'Switch to map color shading of markers to colormap ("on")\n\t\t' ...
    'or min to max range of RMSDz values ("off").']));

disp('Marker options:')
dispopt('''MarkerDisplayed''',sprintf([... 
    '''marker'' (default): Experiments are represented by individual symbols\n\t\t' ...
    '''colorBar'': Experiments are represented by a color described ' ...
    'in a colorbar']));
disp('OPTIONS when ''MarkerDisplayed'' == ''marker''');
dispopt('''markerLabel''','Labels for markers');
dispopt('''markerLabelColor''','Marker label color (Default: black)');
dispopt('''markerColor''',sprintf(['Single color to use for all markers' ...
    ' (Default: red)']));
dispopt('''markerLegend''',sprintf(['''on'' / ''off'' (default): ' ...
    'Use legend for markers']));
dispopt('''markerSize''','Marker size (Default: 10)');
dispopt('''markerSymbol''','Marker symbol (Default ''o'')');
disp('OPTIONS when ''MarkerDisplayed'' == ''colorbar''');
dispopt('''cmapzdata''',sprintf(['Data values to use for ' ...
    'color mapping of markers, e.g. RMSD or BIAS.\n\t\t' ...
    '(Used to make range of values appear above color bar.)']));
dispopt('''titleColorBar''','Title of the colorbar.');

disp('RMS axis options:')
dispopt('''tickRMS''','RMS values to plot grid circles from observation point');
dispopt('''rincRMS''','axis tick increment for RMS values');
dispopt('''colRMS''','RMS grid and tick labels color. (Default: green)');
dispopt('''showlabelsRMS''',sprintf(['''on'' (default) / ''off'': ' ...
    'Show the RMS tick labels']));
dispopt('''tickRMSangle''',['Angle for RMS tick labels with the observation '...
    'point. (Default: 135 deg.)']);
dispopt('''rmsLabelFormat''',sprintf(['String format for RMS contour labels, e.g. ' ...
    '''%0:.2f''.\n\t\t' ...
    '(Default ''0'', format as specified by str function.)']));
dispopt('''styleRMS''','Line style of the RMS grid');
dispopt('''widthRMS''','Line width of the RMS grid');
dispopt('''labelRMS''',sprintf(['RMS axis label (Default: ''RMSD'')']));
dispopt('''titleRMS''',sprintf(['''on'' (default) / ''off'': ' ...
    'Show RMSD axis title']));
dispopt('''titleRMSDangle''',sprintf(['angle at which to display the ''RMSD''' ...
    ' label for the\n\t\t' ...
    'RMSD contours (Default: 160 degrees)']));

disp('STD axis options:')
dispopt('''tickSTD''','STD values to plot grid circles from origin');
dispopt('''rincSTD''','axis tick increment for STD values');
dispopt('''colSTD''','STD grid and tick labels color. (Default: black)');
dispopt('''showlabelsSTD''',sprintf(['''on'' (default) / ''off'': ' ...
    'Show the STD tick labels']));
dispopt('''styleSTD''','Line style of the STD grid');
dispopt('''widthSTD''','Line width of the STD grid');
dispopt('''titleSTD''',sprintf(['''on'' (default) / ''off'': ' ...
    'Show STD axis title']));

disp('CORRELATION axis options:')
dispopt('''tickCOR''','CORRELATON grid values');
dispopt('''colCOR''','CORRELATION grid color. (Default: blue)');
dispopt('''showlabelsCOR''',sprintf(['''on'' (default) / ''off'': ' ...
    'Show the CORRELATION tick labels']));
dispopt('''styleCOR''','Line style of the COR grid');
dispopt('''widthCOR''','Line width of the COR grid');
dispopt('''titleCOR''',sprintf(['''on'' (default) / ''off'': ' ...
    'Show CORRELATION axis title']));

disp('Observation Point options:')
dispopt('''colOBS''','Observation STD color. (Default: magenta)');
dispopt('''markerObs''',sprintf(['Marker to use for x-axis indicating observed STD.' ...
    '\n\t\t' ...
    'A choice of ''none'' will suppress appearance of marker. (Default ''none'')']));
dispopt('''styleOBS''',sprintf(['Line style for observation grid line. A choice of ' ...
    'empty string ('''')\n\t\t' ...
    'will suppress appearance of the grid line. (Default: '''')']));
dispopt('''widthOBS''','Line width of the observation STD circle');
dispopt('''titleOBS''','Label for observation STD point on axis');

disp('CONTROL options:')
dispopt('''checkStats''',sprintf(['''on'' / ''off'' (default): ' ...
    'Check input statistics satisfy Taylor relationship']));

end %function

function dispopt(optname,optval)
%DISPOPT(OPTNAME,OPTVAL)
%   Displays option name and values
%
%   DISPOPT(OPTNAME,OPTVAL) is a support function for the 
%   DISPLAY_TARGET_DIAGRAM_OPTIONS function. It displays the option name
%   OPTNAME on a line by itself followed by its value OPTVAL on the 
%   following line.

	disp(sprintf('\t%s',optname));
	disp(sprintf('\t\t%s',optval));
end
