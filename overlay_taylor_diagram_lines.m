function overlay_taylor_diagram_lines(axes,cax,option)
%OVERLAY_TAYLOR_DIAGRAM_LINES Draw lines emanating from origin on a Taylor diagram.
%
%   OVERLAY_TAYLOR_DIAGRAM_CIRCLES(AXES,CAX,OPTION)
%   Plots lines emanating from origin to indicate correlation values (CORs) 
%
%   INPUTS:
%   axes   : data structure containing axes information for target diagram
%   cax    : handle for plot axes
%   option : data structure containing option values. (Refer to 
%     GET_TAYLOR_DIAGRAM_OPTIONS function for more information.)
%   option.colCOR   : CORs grid and tick labels color (Default: blue)
%   option.showlabelsCOR : Show or not the CORRELATION tick labels
%   option.styleCOR : Linestyle of the CORs grid
%   option.tickCOR  : CORs values to plot lines from origin
%   option.widthCOR : Line width of the CORs grid
%
%   OUTPUTS:
%   None.
%ToDo: document

% DRAW CORRELATIONS LINES EMANATING FROM THE ORIGIN:
corr = option.tickCOR(option.numberPanels).val;
th  = acos(corr);
cst = cos(th); snt = sin(th);
cs = [-cst; cst];
sn = [-snt; snt];
line(axes.rmax*cs,axes.rmax*sn,'linestyle',option.styleCOR, ...
    'color',option.colCOR,'linewidth',option.widthCOR, ...
    'handlevisibility','off','parent',cax)

% annotate them in correlation coefficient
if strcmp(option.showlabelsCOR,'on')
    rt = 1.05*axes.rmax;
    for i = 1:length(corr)
        text(rt*cst(i),rt*snt(i),num2str(corr(i)),...
            'horizontalalignment','center',...
            'handlevisibility','off','parent',cax, ...
            'color',option.colCOR);
        if i == length(corr)
            loc = int2str(0);
            loc = '1';
        else
            loc = int2str(180+i*30);
            loc = '-1';
        end
    end
end

end % function overlay_target_diagram_circles
