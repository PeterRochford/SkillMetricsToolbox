function [option] = get_taylor_diagram_options(CORs,narg,varargin)
%GET_TAYLOR_DIAGRAM_OPTIONS Get optional arguments for target_diagram function.
%
%   [OPTION] = GET_TAYLOR_DIAGRAM_OPTIONS(NARG,VARARGIN)
%   Retrieves the NARG optional arguments supplied to the TAYLOR_DIAGRAM 
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
%   option            : data structure containing option values.
%   option.axismax    : Max of the STD axis (radius of the largest circle)
%   option.checkSTATS : Check input statistics satisfy Taylor relationship
%                       (Default : 'off')
%
%   option.colCOR      : color for correlation coefficient labels (Default : blue)
%   option.colRMS      : color for RMS labels (Default : medium green)
%   option.colSTD      : color for STD labels (Default : black)
%
%   option.colormap    : 'on'/'off' switch to map color shading of
%     markers to colormap ('on') or min to max range of RMSDz values
%     ('off'). Set to same value as option.nonRMSDs.
%
%   option.markerDisplayed : markers to use for individual experiments
%   option.markerColor     : single color to use for all markers (Default: red)
%   option.markerLabel     : name of the experiment to use for marker
%   option.markerLabelColor: marker label color (Default 'k')
%   option.markerLegend    : 'on'/'off' switch to display marker legend
%
%   option.nonRMSDz        : 'on'/'off' switch indicating values in RMSDs 
%     do not correspond to total RMS Differences. (Default 'off')
%   option.numberPanels    : Number of panels to display
%                            = 1 for positive correlations
%                            = 2 for positive and negative correlations
%                           (Default value depends on correlations (CORs))
%
%   option.overlay         : 'on'/'off' switch to overlay current
%                            statistics on Taylor diagram (Default 'off')
%                            Only markers will be displayed.
%   option.rincRMS         : axis tick increment for RMS values
%   option.rincSTD         : axis tick increment for STD values
%
%   option.showlabelsCOR   : show correlation coefficient labels 
%                            (Default: 'on')
%   option.showlabelsRMS   : show RMS labels (Default: 'on')
%   option.showlabelsSTD   : show STD labels (Default: 'on')
%
%   option.styleCOR        : line style for correlation coefficient grid 
%                            lines (Default: dash-dot '-.')
%   option.styleRMS        : line style for RMS grid lines 
%                            (Default: dash-dot '--')
%   option.styleSTD        : line style for STD grid lines 
%                            (Default: dash-dot '--')
%
%   option.tickCOR(:).val  : tick values for correlation coefficients for
%                            two types of panels
%   option.tickCOR         : CORRELATON grid values
%   option.tickRMS         : RMS values to plot gridding circles from
%                            observation point 
%   option.tickSTD         : STD values to plot gridding circles from
%                            origin 
%   option.tickRMSangle    : tick RMS angle (Default: 135 degrees)
%   option.titleColorBar   : title for the colorbar
%   option.titleCOR        : show correlation coefficient axis label 
%                            (Default: 'on')
%   option.titleRMS        : show RMS axis label (Default: 'on')
%   option.titleSTD        : show STD axis label (Default: 'on')
%
%   option.widthCOR        : linewidth for correlation coefficient grid 
%                            lines (Default: .8)
%   option.widthRMS        : linewidth for RMS grid lines (Default: .8)
%   option.widthSTD        : linewidth for STD grid lines (Default: .8)

% Set default parameters
if find(CORs<0)
	option.numberPanels = 2; % double panel
else
	option.numberPanels = 1;
end
option.checkSTATS = 'off';
option.colCOR = [0 0 1];
option.colRMS = [0 .6 0];
option.colSTD = [0 0 0];
option.markerColor = 'r';
option.markerLabelColor = 'k';
option.markerDisplayed = 'marker';
option.markerLegend = 'off';
option.nonRMSDz = 'off';
option.overlay = 'off';
option.showlabelsCOR = 'on';
option.showlabelsRMS = 'on';
option.showlabelsSTD = 'on';
option.styleCOR = '-.';
option.styleRMS = '--';
option.styleSTD = ':';
option.tickCOR(1).val = [1 .99 .95 .9:-.1:0];
option.tickCOR(2).val = [1 .99 .95 .9:-.1:0 -.1:-.1:-.9 -.95 -.99 -1];
option.tickRMSangle  = 135;	
option.titleCOR = 'on';
option.titleRMS = 'on';
option.titleSTD = 'on';
option.widthCOR = .8;
option.widthRMS = .8;
option.widthSTD = .8;

% Load custom options, storing values in option data structure
nopt = narg/2;
for iopt = 4 : 2 : narg+3
    optname  = varargin{iopt};
    optvalue = varargin{iopt+1};
	switch lower(optname)
        case 'checkstats'
            option.checkSTATS = optvalue;
            option.checkSTATS = check_on_off(option.checkSTATS);
		case 'colcor'
			option.colCOR = optvalue;
		case 'colrms'
			option.colRMS = optvalue;
        case 'colstd'
            option.colSTD = optvalue;
        case 'limstd'
            option.axismax = optvalue;
        case 'markerdisplayed'
            option.markerDisplayed=optvalue;
        case 'markercolor'
            option.markerColor=optvalue;
        case 'markerlabel'
            % Exclude the label for the reference statistics
            option.markerLabel=optvalue(2:end);
        case 'markerlabelcolor'
            option.markerLabelColor=optvalue;
        case 'markerlegend'
            option.markerLegend=optvalue;
            check_on_off(option.markerLegend);
        case 'nonrmsdz'
            option.nonRMSDz=optvalue;
            check_on_off(option.nonRMSDz);
        case 'numberpanels'
            option.numberPanels = optvalue;
        case 'overlay'
            option.overlay=optvalue;
            check_on_off(option.overlay);
		case 'showlabelscor'
			option.showlabelsCOR = optvalue;
            check_on_off(option.showlabelsCOR);
        case 'showlabelsrms'
			option.showlabelsRMS = optvalue;
            check_on_off(option.showlabelsRMS);
		case 'showlabelsstd'
			option.showlabelsSTD = optvalue;
            check_on_off(option.showlabelsSTD);
		case 'stylecor'
			option.styleCOR = optvalue;
		case 'stylerms'
			option.styleRMS = optvalue;
		case 'stylestd'
			option.styleSTD = optvalue;
		case 'tickcor'
			option.tickCOR(option.numberPanels).val = optvalue;
		case 'tickrms'
			option.tickRMS = sort(optvalue);
			option.rincRMS = (max(option.tickRMS)-min(option.tickRMS))/ ...
                length(option.tickRMS);				
		case 'tickrmsangle'
			option.tickRMSangle = optvalue;
        case 'tickstd'
            option.tickSTD = sort(optvalue);
            option.rincSTD = (max(option.tickSTD)-min(option.tickSTD))/ ...
                length(option.tickSTD);
        case 'titlecolorbar'
            option.titleColorBar=optvalue;
		case 'titlecor'
			option.titleCOR = optvalue;
            check_on_off(option.titleCOR);
		case 'titlerms'
			option.titleRMS = optvalue;
            check_on_off(option.titleRMS);
		case 'titlestd'
			option.titleSTD = optvalue;
            check_on_off(option.titleSTD);
		case 'widthcor'
			option.widthCOR = optvalue;
		case 'widthrms'
			option.widthRMS = optvalue;
		case 'widthstd'
			option.widthSTD = optvalue;

        otherwise
			error(['Unrecognized option: ' optname]);
	end
end % iopt loop

option.colormap = option.nonRMSDz;
if strcmp(option.nonRMSDz,'on')
    option.titleRMS = 'off';
end

end %function get_taylor_diagram_options

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
