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
%   option.alpha           : blending of symbol face color (0.0
%                            transparent through 1.0 opaque). (Default : 1.0)
%   option.axismax         : maximum for the Bias & uRMSD axis
%   option.circleLineSpec  : circle line specification (default dashed 
%                            black, '--k')
%   option.circleLineWidth : circle line width specification (default 1.5)
%   option.circles         : radii of circles to draw to indicate 
%                            isopleths of standard deviation
%   option.CMapZData       : data values to use for color mapping of
%                            markers, e.g. RMSD or BIAS. (Default empty)
%
%   option.colormap        : 'on'/'off' switch to map color shading of
%                            markers to CMapZData values ('on') or min to
%                            max range of CMapZData values ('off').
%                            (Default : 'on')
%   option.equalAxes       : 'on'/'off' switch to set axes to be equal
%                            (default 'on')
%   option.locationColorBar : location for the colorbar, 'NorthOutside'
%                             or 'EastOutside'
%
%   option.markerKey       : key to use when marker labels specified as a
%                            map
%   option.markerLabelColor : marker label color (Default 'k')
%   option.markerdisplayed : markers to use for individual experiments
%   option.markerLabel     : name of the experiment to use for marker
%   option.markerLegend    : 'on'/'off' switch to display marker legend
%                            (Default 'off')
%   option.markerSize      : marker size (Default 12)
%   option.markerSymbol    : marker symbol (Default 'o')
%
%   option.normalized      : statistics supplied are normalized with 
%                            respect to the standard deviation of reference
%                            values (Default 'off')
%   option.obsUncertainty  : Observational Uncertainty (default of 0)
%   option.overlay         : 'on'/'off' switch to overlay current
%                            statistics on target diagram (Default 'off')
%                            Only markers will be displayed.
%   option.ticks           : define tick positions (default is that used 
%     by the axis function)
%   option.xticklabelpos   : position of the tick labels along the x-axis 
%     (empty by default)
%   option.yticklabelpos   : position of the tick labels along the y-axis 
%     (empty by default)
%   option.titleColorBar   : title for the colorbar

% Set default parameters
option.alpha = 1.0;
option.circleLineSpec = '--k';
option.circleLineWidth = get(gcf, 'defaultLineLineWidth');
option.colormap = 'on';
option.equalAxes = 'on';
option.locationColorBar = 'NorthOutside';
option.markerColor = 'r';
option.markerLabelColor = 'k';
option.markerDisplayed = 'marker';
option.markerKey = '';
option.markerLegend = 'off';
option.markerSize = 10;
option.markerSymbol = 'o';
option.normalized = 'off';
option.obsUncertainty = 0.0;
option.overlay = 'off';

% Load custom options, storing values in option data structure
nopt = narg/2;
for iopt = 4 : 2 : narg+3
    optname  = varargin{iopt};
    optvalue = varargin{iopt+1};
    switch lower(optname)
        case 'alpha'
            option.alpha = optvalue;
        case 'circlelinespec'
            option.circleLineSpec=optvalue;
        case 'circlelinewidth'
            option.circleLineWidth=optvalue;
        case 'circles'
            option.circles=optvalue;
        case 'colormap'
            option.colormap=optvalue;
        case 'cmapzdata'
             option.cmapzdata = optvalue;
             if isa(option.cmapzdata,'char')
                error('CMapZdata cannot be a char!');
            end
        case 'equalaxes'
            option.equalAxes=optvalue;
            check_on_off(option.equalAxes);
        case 'limitaxis'
            option.axismax = optvalue;
        case 'locationcolorbar'
            option.locationColorBar=optvalue;
        case 'markerdisplayed'
            option.markerDisplayed=optvalue;
        case 'markercolor'
            option.markerColor=optvalue;
        case 'markerkey'
            option.markerKey=optvalue;
        case 'markerlabel'
            if iscell(optvalue)
                option.markerLabel=optvalue;
            else
                try
                    test = keys(optvalue);
                catch
                    error(['markerlabel value is not a cell array ' ...
                        'or map: ' optvalue]);
                end
                option.markerLabel=optvalue;
            end
        case 'markerlabelcolor'
            option.markerLabelColor=optvalue;
        case 'markerlegend'
            option.markerLegend=optvalue;
            check_on_off(option.markerLegend);
        case 'markersize'
            option.markerSize=optvalue;
        case 'markersymbol'
            option.markerSymbol=optvalue;
        case 'nonrmsdz'
            error('nonRMSDz is an obsolete option. Use CMapZdata instead.');
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

end %function get_target_diagram_options
