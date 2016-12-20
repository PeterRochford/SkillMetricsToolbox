function [axes,option] = get_target_diagram_axes(x,y,option)
%GET_TARGET_DIAGRAM_AXES Get axes value for target_diagram function.
%
%   [AXES,OPTION] = GET_TARGET_DIAGRAM_AXES(X,Y,OPTION)
%   Determines the axes information for a target diagram given the axis 
%   values (X,Y) and the options in the data structure OPTION returned by 
%   the GET_TARGET_DIAGRAM_OPTIONS function.
%
%   INPUTS:
%   x      : values for x-axis
%   y      : values for y-axis
%   option : data structure containing option values. (Refer to 
%     GET_TARGET_DIAGRAM_OPTIONS function for more information.)
%
%   OUTPUTS:
%   axes   : data structure containing axes information for target diagram
%   axes.xtick  : x-values at which to place tick marks
%   axes.ytick  : y-values at which to place tick marks
%   axes.xlabel : labels for xtick values
%   axes.ylabel : labels for ytick values
%   option : data structure containing updated option values

% Specify max/min for axes
if isfield(option, 'axismax')
    foundmax = 1;
else
    foundmax = 0;
end

if foundmax == 0
    % Axis limit not specified
	maxx = max(abs(x(:)));
	maxy = max(abs(y(:)));
else
    % Axis limit is specified
	maxx = option.axismax;
	maxy = option.axismax;
end

% Determine default number of tick marks
hhh = line([-maxx -maxx maxx maxx],[-maxy maxy maxy -maxy],'parent',gca);
set(gca,'dataaspectratio',[1 1 1],'plotboxaspectratiomode','auto')
v = [get(gca,'xlim') get(gca,'ylim')];
nxticks = sum(get(gca,'xtick')>0);
nyticks = sum(get(gca,'ytick')>0);
delete(hhh);

% Set default tick increment and maximum axis values
if foundmax == 0;
    maxx = v(2);
    maxy = v(4);
    option.axismax = max(maxx, maxy);
end

% Check if equal axes requested
if isfield(option,'equalAxes') & strcmp(option.equalAxes,'on')
    if maxx > maxy
        maxy = maxx;
        nyticks = nxticks;
    else
        maxx = maxy;
        nxticks = nyticks;
    end
end
minx = -maxx;
miny = -maxy;

% Determine tick values
if isfield(option, 'ticks') & length(option.ticks) > 0
    xtick = option.ticks;
    ytick = option.ticks;
else
    tincx = maxx/nxticks;
    tincy = maxy/nyticks;
    xtick = minx:tincx:maxx;
    ytick = miny:tincy:maxy;
end

% Assign tick label positions
if ~isfield(option,'xticklabelpos')
    option.xticklabelpos = xtick;
end
if ~isfield(option,'yticklabelpos')
    option.yticklabelpos = ytick;
end

% Set tick labels using provided tick label positions
xlabel = cell(1,length(xtick));
ylabel = cell(1,length(ytick));

% Set x tick labels
for i=1:length(xtick)
    index = find(xtick(i) == option.xticklabelpos);
    if length(index) > 0
        xlabel{i} = num2str(xtick(i));
    else
        xlabel{i} = '';
    end
end
% Set tick labels at 0 to blank
index = find(xtick == 0);
xlabel{index} = '';

% Set y tick labels
for i=1:length(ytick)
    index = find(ytick(i) == option.yticklabelpos);
    if length(index) > 0
        ylabel{i} = num2str(ytick(i));
    else
        ylabel{i} = '';
    end
end
% Set tick labels at 0 to blank
index = find(ytick == 0);
ylabel{index} = '';

% Store output variables in data structure
axes.xtick = xtick;
axes.ytick = ytick;
axes.xlabel = xlabel;
axes.ylabel = ylabel;

end % function get_target_diagram_axes
