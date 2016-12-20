function overlay_taylor_diagram_circles(axes,cax,option)
%OVERLAY_TAYLOR_DIAGRAM_CIRCLES Overlays circle contours on a Taylor diagram.
%
%   OVERLAY_TAYLOR_DIAGRAM_CIRCLES(OPTION)
%   Plots circle contours on a taylor diagram to indicate root mean square 
%   (RMS) and standard deviation values.
%
%   INPUTS:
%   axes   : data structure containing axes information for Taylor diagram
%   cax    : handle for plot axes
%   option : data structure containing option values. (See 
%            GET_TAYLOR_DIAGRAM_OPTIONS for more information.)
%   option.colRMS       : RMS grid and tick labels color (Default: green)
%   option.rincRMS      : Increment spacing for RMS grid
%   option.styleRMS     : Linestyle of the RMS grid
%   option.tickRMS      : RMS values to plot gridding circles from 
%                         observation point
%   option.tickRMSangle : Angle for RMS tick labels with the observation 
%                         point (Default: 135 deg.)
%   option.widthRMS     : Line width of the RMS grid
%
%   option.colSTD       : STD grid and tick labels color (Default: black)
%   option.rincSTD      : Increment spacing for STD grid
%   option.styleSTD     : Linestyle of the STD grid
%   option.tickSTD      : STD values to plot gridding circles from origin
%   option.tickSTDangle : Angle for STD tick labels with the observation 
%                         point (Default: .8)
%   option.widthSTD     : Line width of the STD grid
%
%   OUTPUTS:
%   None.
%
%   See also GET_TAYLOR_DIAGRAM_OPTIONS

% define a circle
th = 0:pi/150:2*pi;
xunit = cos(th);
yunit = sin(th);

% now really force points on x/y axes to lie on them exactly
inds = 1:(length(th)-1)/4:length(th);
xunit(inds(2:2:4)) = zeros(2,1);
yunit(inds(1:2:5)) = zeros(3,1);
% plot background if necessary
if ~ischar(get(cax,'color')),
    %		ig = find(th>=0 & th<=pi);
    ig = 1:length(th);
    patch('xdata',xunit(ig)*axes.rmax,'ydata',yunit(ig)*axes.rmax, ...
        'edgecolor',axes.tc,'facecolor',get(cax,'color'),...
        'handlevisibility','off','parent',cax);
end

% DRAW RMS CIRCLES:
% ANGLE OF THE TICK LABELS
c82 = cos(option.tickRMSangle*pi/180);
s82 = sin(option.tickRMSangle*pi/180);
for ic = 1 : length(option.tickRMS)
    iradius = option.tickRMS(ic);
    iphic = find( sqrt(axes.dx^2+axes.rmax^2-2*axes.dx*axes.rmax*xunit)...
        >= iradius, 1);
    ig = find(iradius*cos(th)+axes.dx <= axes.rmax*cos(th(iphic)));
    hhh = line(xunit(ig)*iradius+axes.dx,yunit(ig)*iradius,'linestyle', ...
        option.styleRMS,'color',option.colRMS,'linewidth', ...
        option.widthRMS,'handlevisibility','off','parent',cax);
    if strcmp(option.showlabelsRMS,'on')
        xtextpos = double((iradius+option.rincRMS/20)*c82+axes.dx);
        ytextpos = (iradius+option.rincRMS/20)*s82;
        text(xtextpos,ytextpos, ...
            ['  ' num2str(iradius)],'verticalalignment','bottom', ...
            'handlevisibility','off','parent',cax,'color', ...
            option.colRMS,'rotation',option.tickRMSangle-90)
    end
end

% DRAW STD CIRCLES:
% draw radial circles
for ic = 1 : length(option.tickSTD)
    i = option.tickSTD(ic);
    hhh = line(xunit*i,yunit*i,'linestyle',option.styleSTD,'color', ...
        option.colSTD,'linewidth',option.widthSTD, ...
        'handlevisibility','off','parent',cax);
    if strcmp(option.showlabelsSTD,'on')
        if option.numberPanels == 2
            if length(find(option.tickSTD==0)) == 0
                text(0,-axes.rinc/20,'0','verticalalignment','top', ...
                    'horizontalAlignment','center',...
                    'handlevisibility','off','parent',cax, ...
                    'color',option.colSTD);
            end
            text(i,-axes.rinc/20, ...
                num2str(i),'verticalalignment','top', ...
                'horizontalAlignment','center', ...
                'handlevisibility','off','parent',cax, ...
                'color',option.colSTD)
            text(-i,-axes.rinc/20, ...
                num2str(i),'verticalalignment','top', ...
                'horizontalAlignment','center', ...
                'handlevisibility','off','parent',cax, ...
                'color',option.colSTD)
        else
            if length(find(option.tickSTD==0)) == 0
                text(-axes.rinc/20,axes.rinc/20,'0', ...
                    'verticalalignment','middle', ...
                    'horizontalAlignment','right',...
                    'handlevisibility','off','parent',cax, ...
                    'color',option.colSTD);
            end
            text(-axes.rinc/20,i, ...
                num2str(i),'verticalalignment','middle', ...
                'horizontalAlignment','right',...
                'handlevisibility','off','parent',cax, ...
                'color',option.colSTD)
        end
    end
end
set(hhh,'linestyle','-') % Make outer circle solid

end % function overlay_target_diagram_circles
