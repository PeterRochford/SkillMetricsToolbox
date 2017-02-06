function varargout = plot_taylor_obs(ax,obsSTD,axes,option)
%PLOT_TAYLOR_OBS Plots observation STD on Taylor diagram.
%
%   PLOT_TAYLOR_OBS(AX,obsSTD,AXES,OPTION)
%   Optionally plots a marker on the x-axis in indicating observation STD, a
%   a label for this point, and a contour circle indicating the STD value.
%
%   INPUTS:
%   ax     : axes handle for Taylor diagram
%   obsSTD : observation standard deviation
%   axes   : axes values used in Taylor diagram
%   option : data structure containing option values. (Refer to 
%     GET_TARGET_DIAGRAM_OPTIONS function for more information.)
%   option.colOBS    : color for observation labels (Default : magenta)
%   option.markerObs : marker to use for x-axis indicating observed STD
%   option.styleOBS  : line style for observation grid line
%   option.titleOBS  : label for observation point label (Default: '')
%   option.widthOBS  : linewidth for observation grid line (Default: .8)
%
%   OUTPUTS:
% 	None

if isfield(option,'markerObs') && ~strcmp(option.markerObs,'none')
  hold on

  % Display marker on x-axis indicating observed STD
  plot(obsSTD,0.0,option.markerObs,'color',option.colOBS, ... 
    'MarkerSize',6,'MarkerFaceColor',option.colOBS, ...
    'Linewidth',1.0);
end

if ~strcmp(option.titleOBS,'')
  % Put label below the marker
  labelweight = 'bold';
  labelsize = get(ax(1).handle,'fontsize') - 2;
  x = obsSTD; y = -0.05*axes.rmax;
  text(x,y,option.titleOBS, 'color',option.colOBS, ...
        'HorizontalAlignment', 'center', ...
        'fontweight',labelweight, 'fontsize',labelsize);
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

end %function plot_taylor_obs
