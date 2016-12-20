function [option] = get_target_diagram_options(narg,varargin)
%GET_TARGET_DIAGRAM_OPTIONS Get optional arguments for target_diagram function.
%
%   [OPTION] = GET_TARGET_DIAGRAM_OPTIONS(NARG,VARARGIN)
%   Retrieves the NARG optional arguments supplied to the TARGET_DIAGRAM 
%   function as a variable-length input argument list (VARARGIN), and
%   returns the values in a OPTION data structure. Default values are 
%   assigned to selected optional arguments. Unassigned arguments do not
%   appear in the OPTION data structure. The function will terminate
%   with an error if an unrecognized optional argument is supplied.
%
%   INPUTS:
%   narg    : number of optional arguments
%   varagin : variable-length input argument list
%
%   OUTPUTS:
%   option : data structure containing option values. (Refer to 
%     display_target_diagram_options function for more information.)
%   option.axismax         : maximum for the Bias & uRMSD axis
%   option.circleLineSpec  : circle line specification (default dashed 
%                            black, '--k')
%   option.circleLineWidth : circle line width specification (default 0.5)
%   option.circles         : radii of circles to draw to indicate 
%     isopleths of standard deviation
%   option.colormap        : 'on'/'off' switch to map color shading of
%                            markers to colormap ('on') or min to max range
%                            of RMSDz values ('off'). Set to same value as
%                            option.nonRMSDz. 
%   option.equalAxes       : 'on'/'off' switch to set axes to be equal
%   option.markerLabelColor : marker label color (Default 'k')
%   option.markerdisplayed : markers to use for individual experiments
%   option.markerLabel     : name of the experiment to use for marker
%   option.markerLegend    : 'on'/'off' switch to display marker legend
%                            (Default 'off')
%   option.nonRMSDz        : 'on'/'off' switch indicating values in RMSDz 
%     do not correspond to total RMS Differences. (Default 'off')
%   option.normalized      : statistics supplied are normalized with 
%                            respect to the standard deviation of reference
%                            values (Default 'off')
%   option.obsUncertainty  : Observational Uncertainty (default of 0)
%   option.overlay         : 'on'/'off' switch to overlay current
%                            statistics on Taylor diagram (Default 'off')
%                            Only markers will be displayed.
%   option.ticks           : define tick positions (default is that used 
%     by the axis function)
%   option.xticklabelpos   : position of the tick labels along the x-axis 
%     (empty by default)
%   option.yticklabelpos   : position of the tick labels along the y-axis 
%     (empty by default)
%   option.titleColorBar   : title for the colorbar

% Set default parameters
option.circleLineSpec = '--k';
option.circleLineWidth = 0.5;
option.equalAxes = 'on';
option.markerColor = 'r';
option.markerLabelColor = 'k';
option.markerDisplayed = 'marker';
option.markerLegend = 'off';
option.nonRMSDz = 'off';
option.normalized = 'off';
option.obsUncertainty = 0.0;
option.overlay = 'off';

% Load custom options, storing values in option data structure
nopt = narg/2;
for iopt = 4 : 2 : narg+3
    optname  = varargin{iopt};
    optvalue = varargin{iopt+1};
    switch lower(optname)
        case 'circlelinespec'
            option.circleLineSpec=optvalue;
        case 'circlelinewidth'
            option.circleLineWidth=optvalue;
        case 'circles'
            option.circles=optvalue;
        case 'equalaxes'
            option.equalAxes=optvalue;
            check_on_off(option.equalAxes);
        case 'limitaxis'
            option.axismax = optvalue;
        case 'markerdisplayed'
            option.markerDisplayed=optvalue;
        case 'markercolor'
            option.markerColor=optvalue;
        case 'markerlabel'
            option.markerLabel=optvalue;
        case 'markerlabelcolor'
            option.markerLabelColor=optvalue;
        case 'markerlegend'
            option.markerLegend=optvalue;
            check_on_off(option.markerLegend);
        case 'nonrmsdz'
            option.nonRMSDz=optvalue;
            check_on_off(option.nonRMSDz);
        case 'normalized'
            option.normalized=optvalue;
            check_on_off(option.normalized);
        case 'obsuncertainty'
            option.obsUncertainty=optvalue;
        case 'overlay'
            option.overlay=optvalue;
            check_on_off(option.overlay);
        case 'ticks'
            option.ticks=optvalue;
        case 'titlecolorbar'
            option.titleColorBar=optvalue;
        case 'xticklabelpos'
            option.xticklabelpos=optvalue;
        case 'yticklabelpos'
            option.yticklabelpos=optvalue;
        otherwise
            error(['Unrecognized option: ' optname]);
    end
end % iopt loop

option.colormap = option.nonRMSDz;

end %function get_target_diagram_options

function value = check_on_off(value)
%CHECK_ON_OFF(VALUE)
%   Check whether variable contains a value of "on" or 'off'. Returns an
%   error if neither.
%
%   INPUTS:
%   value : string to check
%
%   OUTPUTS:
%   None.

switch lower(value)
    case 'off'
        return;
    case 'on'
        return;
    case false
        value = 'off';
    case true
        value = 'on';
    otherwise
        error(['Invalid value: ' value]);
end

end %function check_on_off
