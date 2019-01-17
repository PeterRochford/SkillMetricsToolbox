function varargout = plot_pattern_diagram_colorbar(X,Y,Z,option)
%PLOT_PATTERN_DIAGRAM_COLORBAR Plots color markers on a pattern diagram shaded according to a supplied value.
%
% Values are indicated via a color bar on the plot.
%
%   [HP] = PLOT_PATTERN_DIAGRAM_COLORBAR(X,Y,Z,OPTION)
%   Plots color markers on a target diagram according their (X,Y) locations.
%   The color shading is accomplished by plotting the markers as a scatter 
%   plot in (X,Y) with the colors of each point specified using Z as a 
%   vector.
%
%   The color range is controlled by option.cmapzdata.
%     option.colormap = 'on' the scatter function maps the elements in 
%       Z to colors in the current colormap
%     option.colormap = 'off' the color axis is mapped to the range
%       [min(Z) max(Z)]
%
%   The color bar is titled using the content of option.titleColorBar (if
%     present).
%
%   INPUTS:
%   x : x-coordinates of markers
%   y : y-coordinates of markers
%   z : z-coordinates of markers (used for color shading)
%   option : data structure containing option values.
%   option.colormap         : 'on'/'off' switch to map color shading of
%                             markers to colormap ('on') or min to max
%                             range of Z values ('off')
%   option.locationColorBar : location for the colorbar, 'NorthOutside'
%                             or 'eastoutside'
%   option.titleColorBar    : title for the colorbar
%
%   OUTPUTS:
% 	hp: returns handles of plotted points

% Plot color shaded data points using scatter plot
fontSize = get(gcf,'DefaultAxesFontSize');
markerSize = option.markerSize^2;

hp=scatter(X,Y,markerSize,Z,'d');
set(hp,'MarkerFaceColor',get(hp,'MarkerEdgeColor'))

% Set parameters for color bar location
location = option.locationColorBar;
switch location
    case 'NorthOutside'
        tickLength = 0.04;

        % Set Matlab/Octave scaling for color bar position
        if is_octave()
          xscale = 0.85; yscale = 0.75; cxscale = 0.7;
        else
          xscale = 1.0; yscale = 1.0; cxscale = 1.0;
        end
    case 'EastOutside'
        tickLength = 0.01;

        % Set Matlab/Octave scaling for color bar position
        if is_octave()
          xscale = 0.85; yscale = 0.75; cxscale = 0.7;
        else
          xscale = 4.5; yscale = 1.0; cxscale = 8.0;
        end
    otherwise
        error(['Error: Invalid color bar location "' location ...
            '"!\n'])
end

% Add color bar to plot
switch option.colormap
    case 'on'
        % map color shading of markers to colormap
        hc = colorbar('Location',location,'TickDirection','out', ...
            'TickLength',tickLength);
        position = get_color_bar_location(hc,option,xscale,yscale, ...
                                           cxscale);
        set(hc,'Position',position,'FontSize',fontSize)
    case 'off'
        % map color shading of markers to min to max range of Z values
        if length(Z) > 1
            caxis([min(Z) max(Z)])
            hc = colorbar('Location',location, ...
                'TickDirection','out', 'TickLength',tickLength);
            position = get_color_bar_location(hc,option,xscale,yscale, ...
                                              cxscale);
            set(hc,'Position',position, 'XTick',[min(Z) max(Z)], ...
                'FontSize',fontSize)
        end
    otherwise
        error(['Invalid option for option.colormap: ' option.colormap]);
end

% Title the color bar
if isfield(option,'titleColorBar')
    title(hc,option.titleColorBar)
else
    title(hc,'Color Scale')
end

% Output
switch nargout
	case 1
		varargout(1) = {hp};
end

end %function plot_pattern_diagram_colorbar

function position = get_color_bar_location(hc,option,xscale,yscale, ...
                                           cxscale)
%GET_COLOR_BAR_LOCATION Determine position for color bar.
%
%   position = GET_COLOR_BAR_LOCATION(HC,OPTION)
%   Determines position to place color bar for type of plot:
%   target diagram and Taylor diagram. Optional scale arguments
%   (xscale,yscale,cxscale) can be supplied to adjust the placement of
%   the colorbar to accommodate different situations, e.g. use in Octave
%   versus Matlab.
%
%   INPUTS:
%   hc      : handle returned by colorbar 
%   option  : data structure containing option values.
%   xscale  : scale factor to adjust x-position of color bar
%   yscale  : scale factor to adjust y-position of color bar
%   cxscale : scale factor to adjust thickness of color bar
%
%   OUTPUTS:
% 	position : x, y, width, height for color bar

% Check for optional arguments and set defaults if required
if ~exist('xscale','var')
    xscale = 1.0; yscale = 1.0; cxscale = 1.0;
elseif ~exist('yscale','var')
    yscale = 1.0; cxscale = 1.0;
elseif ~exist('cxscale','var')
    cxscale = 1.0;
end

% Get current position of color bar
cp = get(hc,'Position');

% Calculate position
if isfield(option,'checkSTATS')
    % Taylor diagram
    position = [cp(1)+xscale*0.5*(1+cosd(45))*cp(3) yscale*cp(2) ...
                cxscale*cp(3)/6 cp(4)];
else
    % target diagram
    position = [cp(1)+xscale*0.5*(1+cosd(60))*cp(3) yscale*cp(2) ...
                cxscale*cp(3)/6 cp(4)];
end
hold on;

end % function get_color_bar_location
