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
%   option.alpha      : blending of symbol face color (0.0 transparent
%                       through 1.0 opaque). (Default : 1.0)
%   option.axismax    : maximum for the radial contours
%   option.checkSTATS : Check input statistics satisfy Taylor relationship
%                       (Default : 'off')
%   option.CMapZData  : data values to use for color mapping of
%                       markers, e.g. RMSD or BIAS. (Default empty)
%
%   option.colCOR      : color for correlation coefficient labels (Default : blue)
%   option.colOBS      : color for observation labels (Default : magenta)
%   option.colRMS      : color for RMS labels (Default : medium green)
%   option.colSTD      : color for STD labels (Default : black)
%   option.colormap    : 'on'/'off' switch to map color shading of
%                        markers to CMapZData values ('on') or min to
%                        max range of CMapZData values ('off').
%                        (Default : 'on')
%
%   option.locationColorBar : location for the colorbar, 'NorthOutside'
%                             or 'eastoutside'
%   option.markerColor     : single color to use for all markers (Default: red)
%   option.markerDisplayed : markers to use for individual experiments,
%                            'marker' for markers
%                            'colorbar' for a color bar
%   option.markerKey       : key to use when marker labels specified as a
%                            map
%   option.markerLabel     : name of the experiment to use for marker
%   option.markerLabelColor: marker label color (Default 'k')
%   option.markerLegend    : 'on'/'off' switch to display marker legend
%   option.markerObs       : marker to use for x-axis indicating observed STD
%                            A choice of 'none' will suppress appearance of
%                            marker. (Default 'none')
%   option.markerSize      : marker size (Default 10)
%
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
%   option.rmslabelformat  : string format for RMS contour labels, e.g. '%.2f'.
%                            (Default '0', format as specified by str function)
%
%   option.showlabelsCOR   : show correlation coefficient labels 
%                            (Default: 'on')
%   option.showlabelsRMS   : show RMS labels (Default: 'on')
%   option.showlabelsSTD   : show STD labels (Default: 'on')
%
%   option.styleCOR        : line style for correlation coefficient grid 
%                            lines (Default: dash-dot '-.')
%   option.styleOBS        : line style for observation grid line. A choice of
%                            empty string '' will suppress appearance of the
%                            grid line (Default: '')
%   option.styleRMS        : line style for RMS grid lines 
%                            (Default: dash '--')
%   option.styleSTD        : line style for STD grid lines 
%                            (Default: dotted ':')
%
%   option.tickCOR(:).val  : tick values for correlation coefficients for
%                            two types of panels
%   option.tickCOR         : CORRELATON grid values
%   option.tickRMS         : RMS values to plot grid circles from
%                            observation point 
%   option.tickSTD         : STD values to plot grid circles from
%                            origin 
%   option.tickRMSangle    : tick RMS angle (Default: 135 degrees)
%   option.titleColorBar   : title for the colorbar
%   option.titleCOR        : show correlation coefficient axis label 
%                            (Default: 'on')
%   option.titleOBS        : label for observation point (Default: '')
%   option.titleRMS        : show RMS axis label (Default: 'on')
%   option.titleSTD        : show STD axis label (Default: 'on')
%   option.titleRMSDangle  : angle at which to display the "RMSD" label for
%                            the RMS contours (Default: 160 degrees)
%
%   option.widthCOR        : linewidth for correlation coefficient grid 
%                            lines (Default: .8)
%   option.widthOBS        : linewidth for observation grid line (Default: .8)
%   option.widthRMS        : linewidth for RMS grid lines (Default: .8)
%   option.widthSTD        : linewidth for STD grid lines (Default: .8)

% Set default parameters
if find(CORs<0)
	option.numberPanels = 2; % double panel
else
	option.numberPanels = 1;
end
option.alpha = 1.0;
option.checkSTATS = 'off';
option.colCOR = [0 0 1];
option.colOBS = 'm';
option.colRMS = [0 .6 0];
option.colSTD = [0 0 0];
option.colormap = 'on';
option.locationColorBar = 'NorthOutside';
option.markerColor = 'r';
option.markerLabelColor = 'k';
option.markerDisplayed = 'marker';
option.markerKey = '';
option.markerLegend = 'off';
option.markerObs = 'none';
option.markerSize = 10;
option.overlay = 'off';
option.rmslabelformat = '%.f';
option.showlabelsCOR = 'on';
option.showlabelsRMS = 'on';
option.showlabelsSTD = 'on';
option.styleCOR = '-.';
option.styleOBS = '';
option.styleRMS = '--';
option.styleSTD = ':';
option.tickCOR(1).val = [1 .99 .95 .9:-.1:0];
option.tickCOR(2).val = [1 .99 .95 .9:-.1:0 -.1:-.1:-.9 -.95 -.99 -1];
option.tickRMSangle  = -1;
option.titleCOR = 'on';
option.titleOBS = '';
option.titleRMS = 'on';
option.titleSTD = 'on';
option.titleRMSDangle = 160.0;

lineWidth = get(gcf, 'defaultLineLineWidth');
option.widthCOR = lineWidth;
option.widthOBS = lineWidth;
option.widthRMS = lineWidth;
option.widthSTD = lineWidth;

% Load custom options, storing values in option data structure
nopt = narg/2;
for iopt = 4 : 2 : narg+3
    optname  = varargin{iopt};
    optvalue = varargin{iopt+1};
	switch lower(optname)
    case 'alpha'
         option.alpha = optvalue;
    case 'checkstats'
          option.checkSTATS = optvalue;
          option.checkSTATS = check_on_off(option.checkSTATS);
    case 'cmapzdata'
         option.cmapzdata = optvalue;
         if isa(option.cmapzdata,'char')
            error('CMapZdata cannot be a char!');
        end
    case 'colcor'
         option.colCOR = optvalue;
    case 'colobs'
         option.colOBS = optvalue;
    case 'colormap'
         option.colormap = optvalue;
    case 'colrms'
         option.colRMS = optvalue;
    case 'colstd'
        option.colSTD = optvalue;
    case 'limstd'
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
        if isa(optvalue,'cell')
            % Exclude the label for the reference statistics
            option.markerLabel=optvalue(2:end);
        elseif isMap(optvalue)
            % Only contains labels for the markers
            option.markerLabel=optvalue;
        else
            error(['markerLabel type is not a cell array or map: ' ...
                        class(markerLabel)]);
        end
    case 'markerlabelcolor'
        option.markerLabelColor=optvalue;
    case 'markerlegend'
        option.markerLegend=optvalue;
        check_on_off(option.markerLegend);
    case 'markerobs'
        option.markerObs=optvalue;
    case 'markersize'
        option.markerSize=optvalue;
    case 'nonrmsdz'
        error('nonRMSDz is an obsolete option. Use CMapZdata instead.');
    case 'numberpanels'
        option.numberPanels = optvalue;
    case 'overlay'
        option.overlay=optvalue;
        check_on_off(option.overlay);
    case 'rmslabelformat'
        % Check for valid string format
        valid = check_format(optvalue);
        if ~valid
          error(['Invalid string format for rmslabelformat: ' optvalue]);
        end
        option.rmslabelformat = optvalue;
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
    case 'styleobs'
      option.styleOBS = optvalue;
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
    case 'titleobs'
      option.titleOBS = optvalue;
    case 'titlerms'
      option.titleRMS = optvalue;
      check_on_off(option.titleRMS);
    case 'titlermsdangle'
      option.titleRMSDangle = optvalue;
    case 'titlestd'
      option.titleSTD = optvalue;
      check_on_off(option.titleSTD);
    case 'widthcor'
      option.widthCOR = optvalue;
    case 'widthobs'
      option.widthOBS = optvalue;
    case 'widthrms'
      option.widthRMS = optvalue;
    case 'widthstd'
      option.widthSTD = optvalue;

    otherwise
  		error(['Unrecognized option: ' optname]);
	end
end % iopt loop

end %function get_taylor_diagram_options

function valid = check_format(string)
%CHECK_FORMAT(STRING)
%   Checks the input string is a valid format for sprintf
%
%   CHECK_FORMAT(STRING) is a support function for the 
%   GET_TAYLOR_DIAGRAM_OPTIONS function. It checks for a valid sprintf format
%   for displaying contour values.
  valid = false;
  
  if string(1) ~= '%'
    % Not a format specifier
    return;
  end

  index = regexp(string,'[diufeEgG]{1}');
  if length(index) ~= 1 || index ~= length(string)
    % Invalid conversion character
    return
  end

  if length(string) > 2
    number = str2num(string(2:length(string)-1));
    if length(number) == 0
      return
    end
  end

  valid = true;
end
