function axes = overlay_taylor_diagram_lines(axes,cax,option)
%OVERLAY_TAYLOR_DIAGRAM_LINES Overlay lines emanating from origin on a Taylor diagram.
%
%   OVERLAY_TAYLOR_DIAGRAM_CIRCLES(AXES,CAX,OPTION)
%   Plots lines emanating from origin to indicate correlation values (CORs) 
%
%   INPUTS:
%   axes   : data structure containing axes information for target diagram
%   cax    : handle for plot axes
%   option : data structure containing option values. (Refer to 
%            GET_TAYLOR_DIAGRAM_OPTIONS function for more information.)
%   option.colCOR   : CORs grid and tick labels color (Default: blue)
%   option.numberPanels  : Number of panels
%   option.showlabelsCOR : Show or not the CORRELATION tick labels
%   option.styleCOR : Linestyle of the CORs grid
%   option.tickCOR  : CORs values to plot lines from origin
%   option.widthCOR : Line width of the CORs grid
%
%   OUTPUTS:
%   axes.cor.tickLabel : tick labels of correlation coefficient contours

% DRAW CORRELATION LINES EMANATING FROM THE ORIGIN:
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
    fontSize = get(gcf,'DefaultAxesFontSize');
    rt = 1.05*axes.rmax;
    for i = 1:length(corr)
        if option.numberPanels == 2
            x = (1.05+abs(cst(i))/30)*axes.rmax*cst(i);
        else
            x = rt*cst(i);
        end
        y = rt*snt(i);
        ttt(i) = text(x,y,num2str(corr(i)),...
            'horizontalalignment','center',...
            'handlevisibility','off','parent',cax, ...
            'color',option.colCOR,'fontsize',fontSize);
    end
end
axes.cor.tickLabel = ttt;

end % function overlay_target_diagram_circles
