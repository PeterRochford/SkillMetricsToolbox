function axes = plot_taylor_obs(obsSTD,axes,option)
%PLOT_TAYLOR_OBS Plots observation STD on Taylor diagram.
%
%   PLOT_TAYLOR_OBS(AX,obsSTD,AXES,OPTION)
%   Optionally plots a marker on the x-axis in indicating observation STD, a
%   a label for this point, and a contour circle indicating the STD value.
%
%   INPUTS:
%   obsSTD : observation standard deviation
%   axes   : axes information of Taylor diagram
%   option : data structure containing option values. (Refer to 
%     GET_TARGET_DIAGRAM_OPTIONS function for more information.)
%   option.colOBS    : color for observation labels (Default : magenta)
%   option.markerObs : marker to use for x-axis indicating observed STD
%   option.styleOBS  : line style for observation grid line
%   option.titleOBS  : label for observation point label (Default: '')
%   option.widthOBS  : linewidth for observation grid line (Default: .8)
%
%   OUTPUTS:
% 	axes.std =       : current axes

if isfield(option,'markerObs') && ~strcmp(option.markerObs,'none')
  hold on

  % Display marker on x-axis indicating observed STD
  plot(obsSTD,0.0,option.markerObs,'color',option.colOBS, ...
    'MarkerSize',option.markerSize,'MarkerFaceColor',option.colOBS, ...
    'MarkerEdgeColor',option.colOBS,'Linewidth',1.0);
end

if ~strcmp(option.titleOBS,'')
  % Put label below the marker
  labelsize = get(axes.std,'fontsize'); % get label size of STD axes
  xlabelh = xlabel(option.titleOBS, 'color',option.colOBS, ...
        'fontweight','bold', 'fontsize',labelsize);
  xypos = get(xlabelh,'position');
  xypos(1) = obsSTD; % set x-position to below marker
  set(xlabelh,'position',xypos, 'horizontalAlignment', 'center');
end

if ~strcmp(option.styleOBS,'')
  % Draw circle for observation STD
  hold on
  th = 0:pi/150:2*pi;
  xunit = obsSTD*cos(th);
  yunit = obsSTD*sin(th);
  hhh = line(xunit,yunit,'linestyle',option.styleOBS,'color', ...
      option.colOBS,'linewidth',option.widthOBS);
end

axes.std = gca;

end %function plot_taylor_obs
