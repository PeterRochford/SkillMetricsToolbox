function ax = plot_taylor_axes(axes, cax, option)
%PLOT_TAYLOR_AXES Plot axes for Taylor diagram.
%
%   AX = PLOT_TAYLOR_AXES(AXES,OPTION) plots the x & y axes for a Taylor 
%   diagram using the information provided in the AXES data structure 
%   returned by the GET_TAYLOR_DIAGRAM_AXES function.
%
%   INPUTS:
%   axes   : data structure containing axes information for target diagram
%   cax    : handle for plot axes
%   option : data structure containing option values. (Refer to 
%            GET_TAYLOR_DIAGRAM_OPTIONS function for more information.)
%   option.colCOR       : CORs grid and tick labels color (Default: blue)
%   option.colRMS       : RMS grid and tick labels color (Default: green)
%   option.colSTD       : STD grid and tick labels color (Default: black)
%   option.numberPanels : number of panels (quadrants) to use for Taylor
%                         diagram
%   option.tickRMS      : RMS values to plot gridding circles from 
%                         observation point
%   option.titleCOR     : title for CORRELATION axis
%   option.titleRMS     : title for RMS axis
%   option.titleSTD     : title fot STD axis
%
%   OUTPUTS:
%	  ax: returns a data structure of handles of axis labels

ax = [];
axlabweight = 'bold';
ix = 0;
if option.numberPanels == 1
    % Single panel
    
    if strcmp(option.titleSTD,'on')
        ix = ix + 1;
        if is_octave()
          ttt = ylabel('test','fontsize',14);
          x = -0.1*axes.rmax; y = 0.25*axes.rmax;
          ax(ix).handle = text(x,y,'Standard Deviation', ...
          'rotation',90, 'color',option.colSTD, ...
          'fontweight',axlabweight, 'fontsize',get(ttt,'fontsize'));
        else
          ax(ix).handle = ylabel('Standard Deviation', ...
              'color',option.colSTD,'fontweight',axlabweight);
        end
    end

    if strcmp(option.titleCOR,'on')
        ix = ix + 1;
        clear ttt
        pos1 = 45;	DA = 15;
        lab = 'Correlation Coefficient';
        c = fliplr(linspace(pos1-DA,pos1+DA,length(lab)));
        dd = 1.1*axes.rmax;	ii = 0;
        for ic = 1 : length(c)
            ith = c(ic);
            ii = ii + 1;
            ttt(ii)=text(dd*cos(ith*pi/180),dd*sin(ith*pi/180),lab(ii));
            set(ttt(ii),'rotation',ith-90,'color',option.colCOR, ...
                'horizontalalignment','center',...
                'verticalalignment','bottom', ...
                'fontsize',get(ax(1).handle,'fontsize'), ...
                'fontweight',axlabweight);
        end
        ax(ix).handle = ttt;
    end
    
    if strcmp(option.titleRMS,'on')
        ix = ix + 1;
        clear ttt
        DA = 15; pos1 = 160;
        lab = 'RMSD';
        c = fliplr(linspace(pos1-DA,pos1+DA,length(lab)));
        if option.tickRMS(1) > 0
          dd = 0.7*option.tickRMS(1)+0.3*option.tickRMS(2);
        else
          dd = 0.7*option.tickRMS(2)+0.3*option.tickRMS(3);
        end
        ii = 0;
        for ic = 1 : length(c)
            ith = c(ic); 
            ii = ii + 1;
            xtextpos = double(axes.dx+dd*cos(ith*pi/180));
            ytextpos = dd*sin(ith*pi/180);
            ttt(ii)=text(xtextpos,ytextpos,lab(ii));
            set(ttt(ii),'rotation',ith-90,'color',option.colRMS, ...
                'horizontalalignment','center', ...
                'verticalalignment','top','fontsize',get(ax(1).handle, ...
                'fontsize'),'fontweight',axlabweight);
        end
        ax(ix).handle = ttt;
    end
    
else
    % Double panel

    if strcmp(option.titleSTD,'on')
        ix = ix + 1;
        if is_octave()
          ttt = ylabel('test','fontsize',14);
          x = 0; y = -0.15*axes.rmax;
          ax(ix).handle = text(x,y,'Standard Deviation', ...
          'rotation',0, 'color',option.colSTD, ...
          'HorizontalAlignment', 'center', ...
          'fontweight',axlabweight, 'fontsize',get(ttt,'fontsize'));
        else
          ax(ix).handle = ylabel('Standard Deviation', ...
              'color',option.colSTD,'fontweight',axlabweight);
        end
    end
    
    if strcmp(option.titleCOR,'on')
        ix = ix + 1;
        clear ttt
        pos1 = 90;	DA = 25;
        lab = 'Correlation Coefficient';
        c = fliplr(linspace(pos1-DA,pos1+DA,length(lab)));
        dd = 1.1*axes.rmax;	ii = 0;
        for ic = 1 : length(c)
            ith = c(ic);
            ii = ii + 1;
            ttt(ii)=text(dd*cos(ith*pi/180),dd*sin(ith*pi/180),lab(ii));
            set(ttt(ii),'rotation',ith-90,'color',option.colCOR, ...
                'horizontalalignment','center', ...
                'verticalalignment','bottom', ...
                'fontsize',get(ax(1).handle,'fontsize'), ...
                'fontweight',axlabweight);
        end
        ax(ix).handle = ttt;
    end
    
    if strcmp(option.titleRMS,'on')
        ix = ix + 1;
        clear ttt
        pos1 = 160; DA = 10;
        lab = 'RMSD';
        c = fliplr(linspace(pos1-DA,pos1+DA,length(lab)));
        if option.tickRMS(1) > 0
          dd = 0.7*option.tickRMS(1)+0.3*option.tickRMS(2);
        else
          dd = 0.7*option.tickRMS(2)+0.3*option.tickRMS(3);
        end
        ii = 0;
        for ic = 1 : length(c)
            ith = c(ic);
            ii = ii + 1;
            
            xtextpos = double(axes.dx+dd*cos(ith*pi/180));
            ytextpos = double(dd*sin(ith*pi/180));
            ttt(ii) = text(xtextpos,ytextpos,lab(ii));
            set(ttt(ii),'Rotation',90.0,'color',option.colRMS, ...
                'horizontalalignment','center', ...
                'verticalalignment','bottom', ...
                'fontsize',get(ax(1).handle,'fontsize'), ...
                'fontweight',axlabweight);
        end
        ax(ix).handle = ttt;
    end
end

% VARIOUS ADJUSTMENTS TO THE PLOT:
set(cax,'dataaspectratio',[1 1 1]); axis(cax,'off');
set(cax,'NextPlot',axes.next);
set(get(cax,'xlabel'),'visible','on')
set(get(cax,'ylabel'),'visible','on')
view(cax,2);
% set axis limits
if option.numberPanels == 2
    axis(cax,axes.rmax*[-1.15 1.15 0 1.15]);
    line([-axes.rmax axes.rmax],[0 0],'color',axes.tc,'linewidth',1.2);
    line([0 0],[0 axes.rmax],'color',axes.tc);
else
    axis(cax,axes.rmax*[0 1.15 0 1.15]);
    line([0 axes.rmax],[0 0],'color',axes.tc,'linewidth',1.2);
    line([0 0],[0 axes.rmax],'color',axes.tc,'linewidth',2);
end

end % function plot_taylor_axes
