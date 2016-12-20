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

ix = 0;

% Draw axis lines
h = plot([axes.xtick(1) axes.xtick(end)],[0 0],'k'); % x-axis
hold on;
plot([0 0],[axes.ytick(1) axes.ytick(end)],'k'); % y-axis

% Get offsets
Xoff=diff(get(gca,'XLim'))./40;
Yoff=diff(get(gca,'YLim'))./40;

% Plot new ticks  
for i=1:length(axes.xtick)
    plot([axes.xtick(i) axes.xtick(i)],[0 Yoff],'-k');
end;
for i=1:length(axes.ytick)
   plot([Xoff, 0],[axes.ytick(i) axes.ytick(i)],'-k');
end;

% Add labels
text(axes.xtick,zeros(size(axes.xtick))-2.*Yoff,axes.xlabel, ...
    'HorizontalAlignment','center');
text(zeros(size(axes.ytick))-3.*Xoff,axes.ytick,axes.ylabel, ...
    'HorizontalAlignment','left');

% Label x-axis
xpos = axes.xtick(end) + 3*axes.xtick(end)/30;
ypos = 0;
ix = ix + 1;
ax(ix).handle = text(xpos,ypos,'uRMSD','Color','k', ...
    'HorizontalAlignment','left');

% Label y-axis
xpos = 0;
ypos = axes.ytick(end) + 3*axes.ytick(end)/30;
ix = ix + 1;
ax(ix).handle = text(xpos,ypos,'Bias','Color','k', ...
    'HorizontalAlignment','center');

box off;
axis square;
axis off;
set(gcf,'color','w');

end % function plot_target_axes
