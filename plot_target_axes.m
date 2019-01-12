function ax = plot_target_axes(axes)
%PLOT_TARGET_AXES Plot axes for target diagram.
%
%   PLOT_TARGET_AXES(AXES) plots the x & y axes for a target diagram using
%   the information provided in the AXES data structure returned by 
%   the GET_TARGET_DIAGRAM_AXES function.
%
%   INPUTS:
%   axes   : data structure containing axes information for target diagram
%
%   OUTPUTS:
%	ax: returns a structure of handles of axis labels

% Center axes location.
% Note that the consequence is the tick labels are suppressed
% at the outer ticks in the plot.
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';

% Turn off bounding box and make axes square
box off;
axis square;

% Set new ticks
xticks(axes.xtick);
yticks(axes.ytick);

% Set tick labels
xticklabels(axes.xlabel);
yticklabels(axes.ylabel);

% Set axes limits
axis([axes.xtick(1), axes.xtick(end), axes.ytick(1), axes.ytick(end)])

% Label x-axis
fontSize = get(gcf,'DefaultAxesFontSize');
xpos = axes.xtick(end) + 2*axes.xtick(end)/30;
ypos = -axes.xtick(end)/30;
xlabelh = xlabel('uRMSD','fontsize',fontSize);
set(xlabelh,'position',[xpos ypos -1.0], 'horizontalAlignment', 'left');

% Label y-axis
xpos = 0;
ypos = axes.ytick(end) + 3*axes.ytick(end)/30;
ylabelh = ylabel('Bias','fontsize',fontSize);
set(ylabelh,'position',[xpos ypos -1.0], 'horizontalAlignment', 'center');

% Set axis line width
lineWidth = get(gcf, 'defaultLineLineWidth');
set(gca,'linewidth',lineWidth);

% Set figure background to white, otherwise you get a white figure
% inside a gray box
set(gcf,'color','w');

end % function plot_target_axes
