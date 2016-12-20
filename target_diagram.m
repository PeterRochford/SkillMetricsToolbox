function varargout = target_diagram(varargin)
% TARGET_DIAGRAM Plot a target diagram from statistics of different series.
%
% [hp, ht, axl] = target_diagram(Bs,RMSDs,RMSDz,['option',value])
%
% The first 3 arguments must be the inputs as described below followed by
% optional arguments in the format of 'OPTION' name followed by its value
% 'VALUE'. An example call to the function would be 
%
% target_diagram(Bs,RMSDs,RMSDz,'MarkerDisplayed','marker');
%
% INPUTS:
%   Bs    : Bias (B) or Normalized Bias (B*). Plotted along y-axis
%           as "Bias".
%   RMSDs : unbiased Root-Mean-Square Difference (RMSD') or normalized
%           unbiased Root-Mean-Square Difference (RMSD*'). Plotted along 
%           x-axis as "uRMSD".
%   RMSDz : total Root-Mean-Square Difference (RMSD) or other quantities 
%           (if 'nonRMSDz' == 'on'). Labeled on plot as "RMSD".
%
% OUTPUTS:
% 	hp: returns handles of plotted points
%	ht: returns handles of the text legend of points
%	axl: returns a structure of handles of axis labels
%
% LIST OF OPTIONS:
%	For an exhaustive list of options to customize your diagram, please 
%   call the function without arguments:
%		>> target_diagram
%
%   REFERENCE:
%
%   Jolliff, J. K., J. C. Kindle, I. Shulman, B. Penta, M. Friedrichs, 
%     R. Helber, and R. Arnone (2009), Skill assessment for coupled 
%     biological/physical models of marine systems, J. Mar. Sys., 76(1-2),
%     64-82, doi:10.1016/j.jmarsys.2008.05.014

% Rev. by Peter Rochford on 2015-04-13:
%   This is major rewriting of the targetdiag function originally written
%   by G. Charria (08/2009) and obtained from code.google.com:
%   https://code.google.com/p/guillaumecharria/source/browse/trunk/
%   matlab/perso_m_files/targetdiag.m?r=6
%
%   This script has been renamed as target_diagram to make it distinct from
%   targetdiag. The main capabilities are summarized below.
%
%   1) Modularized the original Matlab script and created several new 
%      functions to facilitate addition of new capabilities and source code
%      reuse. Modeled the code to follow that of the companion taylor_diagram 
%      function.
%
%   2) Changed argument interface to accept a list of variable arguments.
%
%   3) Added list of options feature
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
%
% Created: G. Charria (08/2008)
% -- Updated: 03/2010 --
% v0 : Original code
% v1.0 : - option 'MarkerDisplayed'
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
[Bs, RMSDs, RMSDz, narg] = get_target_diagram_arguments(varargin{:});
if nargin == 0; return; end

% __ Get options
option = get_target_diagram_options(narg,varargin{:});

% __ Get axis values for plot
[axes, option] = get_target_diagram_axes(RMSDs,Bs,option);

% __ Plot axes for target diagram
if strcmp(option.overlay,'off')
    ax = plot_target_axes(axes);
end % no overlay

% __ Overlay circles
overlay_target_diagram_circles(option);

% __ Plot data points
switch lower(option.markerDisplayed)
    case 'marker'
        [hp, ht] = plot_pattern_diagram_markers(RMSDs,Bs,option);
    case 'colorbar'
        hp = plot_pattern_diagram_colorbar(RMSDs,Bs,RMSDz,option);
    otherwise
        error(['Unrecognized option: ' optname]);
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
		varargout(3) = {ax};		
end

end % target_diagram function

function [Bs, RMSDs, RMSDz, narg] = get_target_diagram_arguments(varargin)
%[Bs, RMSDs, RMSDz, narg] = get_target_diagram_arguments(varargin)
%   Get arguments for target_diagram function.
%
%   [Bs, RMSDs, RMSDz, narg] = GET_TARGET_DIAGRAM_ARGUMENTS(VARARGIN)
%   Retrieves the arguments supplied to the TARGET_DIAGRAM function as
%   a variable-length input argument list (VARARGIN), tests the first 3 
%   arguments are numeric quantities, and returns the number of optional 
%   arguments supplied.
%
%   INPUTS:
%   varagin : variable-length input argument list
%
%   OUTPUTS:
%   Bs    : Bias (B) or Normalized Bias (B*). Plotted along y-axis
%           as "Bias".
%   RMSDs : unbiased Root-Mean-Square Difference (RMSD') or normalized
%           unbiased Root-Mean-Square Difference (RMSD*'). Plotted along 
%           x-axis as "uRMSD".
%   RMSDz : total Root-Mean-Square Difference (RMSD) or other quantities 
%           (if 'nonRMSDz' == 'on'). Labeled on plot as "RMSD".
%   narg  : number of optional arguments
    
Bs=[]; RMSDs=[]; RMSDz=[]; narg = 0;
if nargin == 0
    % Display options list
	display_target_diagram_options;
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

Bs = varargin{1};
RMSDs = varargin{2};
RMSDz = varargin{3};

% __ Test the above are numeric quantities
if ~isa(Bs,'numeric')
    error('Argument Bs is not a numeric');
end
if ~isa(RMSDs,'numeric')
    error('Argument RMSDs is not a numeric');
end
if ~isa(RMSDz,'numeric')
    error('Argument RMSDz is not a numeric');
end
end % function get_target_diagram_arguments

function display_target_diagram_options
%DISPLAY_TARGET_DIAGRAM_OPTIONS
%   Displays available options for TARGET_DIAGRAM function.

disp('General options:')
dispopt('''overlay''',sprintf(['''on'' / ''off'' (default): ' ...
    'Switch to overlay current statistics on target diagram. ' ...
    '\n\t\tOnly markers will be displayed.']));

disp('Marker options:')
dispopt('''MarkerDisplayed''',sprintf([... 
    '''marker'' (default): Experiments are represented by individual symbols\n\t\t' ...
    '''colorBar'': Experiments are represented by a color described ' ...
    'in a colorbar']));
disp('OPTIONS when ''MarkerDisplayed'' == ''marker''');
dispopt('''markerLabel''','Labels for markers');
dispopt('''markerLabelColor''','Marker label color (Default: black)');
dispopt('''markerColor''','Marker color');
dispopt('''markerLegend''',sprintf(['''on'' / ''off'' (default): ' ...
    'Use legend for markers']));
disp('OPTIONS when ''MarkerDisplayed'' == ''colorbar''');
dispopt('''nonRMSDs''',sprintf(['''on''/ ''off'' (default): ' ... 
    'Values in RMSDs do not correspond to total RMS Differences.\n\t\t' ...
    '(Used to make range of RMSDs values appear above color bar.)']));
dispopt('''titleColorBar''',sprintf(['Title of the colorbar.']));

disp('Axes options:')
dispopt('''ticks''',sprintf(['define tick positions ' ...
    '(default is that used by axis function)']));
dispopt('''xtickLabelPos''',sprintf(['position of the tick labels ' ...
    'along the x-axis (empty by default)']));
dispopt('''ytickLabelPos''',sprintf(['position of the tick labels ' ...
    'along the y-axis (empty by default)']));
dispopt('''equalAxes''',sprintf(['''on'' (default) / ''off'': ' ... 
    'Set axes to be equal']));
dispopt('''limitAxis''','Max for the Bias & uRMSD axis');

disp('Diagram options:')
dispopt('''circles''',sprintf(['define the radii of circles to draw ' ...
    '(default of (maximum RMSDs)*[.7 1], [.7 1] when normalized diagram)']));
dispopt('''circleLineSpec''',sprintf(['Circle line specification (default ' ...
    'dashed black, ''--k'')']));
dispopt('''circleLineWidth''','Circle line width');
dispopt('''obsUncertainty''',sprintf(['Observational Uncertainty (default of 0)']));
dispopt('''normalized''',sprintf(['''on'' / ''off'' (default): ' ...
    'normalized target diagram']));

end % display_target_diagram_options function

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
