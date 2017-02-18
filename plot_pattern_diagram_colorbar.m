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
%   The color range is controlled by option.nonRMSDz. 
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
%   option.colormap        : 'on'/'off' switch to map color shading of
%     markers to colormap ('on') or min to max range of Z values ('off').
%   option.titleColorBar : title for the colorbar
%
%   OUTPUTS:
% 	hp: returns handles of plotted points

% Plot color shaded data points using scatter plot
hp=scatter(X,Y,40,Z);
set(hp,'MarkerFaceColor',get(hp,'MarkerEdgeColor'),'Marker','d')

% Set Matlab/Octave scaling for color bar position
if is_octave()
  xscale = 0.85; yscale = 0.75; cxscale = 0.7;
else
  xscale = 1.0; yscale = 1.0; cxscale = 1.0;
end

% Add color bar to plot
switch option.colormap
    case 'on'
        hc=colorbar('Location','NorthOutside');
        location = get_color_bar_location(hc,option,xscale,yscale, ...
                                           cxscale);
        set(hc,'Position',location,'FontSize',8)
    case 'off'
        if length(Z) > 1
            caxis([min(Z) max(Z)])
            hc=colorbar('Location','NorthOutside');
            location = get_color_bar_location(hc,option,xscale,yscale, ...
                                              cxscale);
            set(hc,'Position',location,...
                'XTick',[min(Z) max(Z)], ...
                'XTickLabel',{'Min. RMSD','Max. RMSD'},...
                'FontSize',8)
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

function location = get_color_bar_location(hc,option,xscale,yscale, ...
                                           cxscale)
%GET_COLOR_BAR_LOCATION Determine location for color bar.
%
%   location = GET_COLOR_BAR_LOCATION(HC,OPTION)
%   Determines location to place color bar for type of plot:
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
% 	location : x, y, width, height for color bar

% Check for optional arguments and set defaults if required
if ~exist('xscale','var')
    xscale = 1.0; yscale = 1.0; cxscale = 1.0;
elseif ~exist('yscale','var')
    yscale = 1.0; cxscale = 1.0;
elseif ~exist('cxscale','var')
    cxscale = 1.0;
endif

% Get current position of color bar
cp=get(hc,'Position');

% Calculate location    
if isfield(option,'checkSTATS')
    % Taylor diagram
    location = [cp(1)+0.8*xscale*cp(3) yscale*cp(2) ...
                cxscale*cp(3)/3 cp(4)/2];
else
    % target diagram
    location = [cp(1)+xscale*cp(3) yscale*cp(2) ...
                cxscale*cp(3)/3 cp(4)/2];
endif

end % function get_color_bar_location
