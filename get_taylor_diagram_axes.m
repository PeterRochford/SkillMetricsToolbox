function [axes, cax, option] = get_taylor_diagram_axes(rho,option)
%GET_TAYLOR_DIAGRAM_AXES Get axes value for taylor_diagram function.
%
%   [AXES,OPTION] = GET_TAYLOR_DIAGRAM_AXES(RHO,OPTION)
%   Determines the axes information for a Taylor diagram given the axis 
%   values (X,Y) and the options in the data structure OPTION returned by 
%   the GET_TAYLOR_DIAGRAM_OPTIONS function.
%
%   INPUTS:
%   rho    : radial coordinate
%   option : data structure containing option values. (Refer to 
%     GET_TAYLOR_DIAGRAM_OPTIONS function for more information.)
%
%   OUTPUTS:
%   cax       : handle for current axes
%   axes      : data structure containing axes information for Taylor diagram
%   axes.dx   : observed standard deviation
%   axes.next : directive on how to add next plot
%   axes.rinc : increment for radial coordinate
%   axes.rmax : maximum value for radial coordinate
%   axes.rmin : minimum value for radial coordinate
%   axes.tc   : color for x-axis
%   option    : data structure containing updated option values

axes.dx    = rho(1);

%% BEGIN THE PLOT HERE TO GET AXIS VALUES:
hold off
cax = gca;
axes.tc = get(cax,'xcolor');
axes.next = lower(get(cax,'NextPlot'));

% make a radial grid
hold(cax,'on');
if ~isfield(option, 'axismax')
	maxrho = max(abs(rho(:)));
else
	maxrho = option.axismax;
end

% Determine default number of tick marks
if strcmp(option.overlay,'off')
    xlim([-maxrho maxrho]);
    xt = xticks;
    dx = xt(2) - xt(1);
    if xt(1) > -maxrho
        xt = [xt(1) - dx; xt(:)];
    end
    if xt(end) < maxrho
        xt = [xt(:); xt(end) + dx];
    end
else
    xt = xticks;
end
ticks = sum(xt >= 0);

% check radial limits and ticks
axes.rmin = 0; 
if ~isfield(option, 'axismax')
	axes.rmax = xt(end);
    option.axismax = axes.rmax;
else
	axes.rmax = option.axismax;
end
rticks = max(ticks-1,2);
if rticks > 5   % see if we can reduce the number
    if rem(rticks,2) == 0
        rticks = rticks/2;
    elseif rem(rticks,3) == 0
        rticks = rticks/3;
    end
end
axes.rinc = (axes.rmax - axes.rmin)/rticks;
tick  = (axes.rmin + axes.rinc):axes.rinc:axes.rmax;

if ~isfield(option, 'tickRMS')
    option.tickRMS = tick; option.rincRMS = axes.rinc;
end
if ~isfield(option, 'tickSTD')
    option.tickSTD = tick; option.rincSTD = axes.rinc;
end

% Set figure background to white
set(gcf,'color','w');

end % function get_taylor_diagram_axes
