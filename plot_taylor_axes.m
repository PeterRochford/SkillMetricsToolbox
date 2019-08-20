function axes = plot_taylor_axes(axes, cax, option)
%PLOT_TAYLOR_AXES Plot axes for Taylor diagram.
%
%   AX = PLOT_TAYLOR_AXES(AXES,OPTION) plots the x & y axes for a Taylor 
%   diagram using the information provided in the AXES data structure 
%   returned by the GET_TAYLOR_DIAGRAM_AXES function.
%
%   INPUTS:
%   axes   : data structure containing axes information for Taylor diagram
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
%   option.titleSTD     : title for STD axis
%
%   OUTPUTS:
%	  axes: returns a data structure of handles of axis labels

axlabweight = 'bold';
fontSize = get(gcf,'DefaultAxesFontSize') + 2;
if option.numberPanels == 1
    % Single panel
    
    if strcmp(option.titleSTD,'on')
        if is_octave()
          ttt = ylabel('test','fontsize',fontSize);
          x = -0.1*axes.rmax; y = 0.25*axes.rmax;
          text(x,y,'Standard Deviation', ...
          'rotation',90, 'color',option.colSTD, ...
          'fontweight',axlabweight,'fontsize',fontSize);
        else
          ylabel('Standard Deviation', ...
              'color',option.colSTD,'fontweight',axlabweight, ...
              'fontsize',fontSize);
        end
    end

    if strcmp(option.titleCOR,'on')
        clear ttt
        pos1 = 45;	DA = 15;
        lab = 'Correlation Coefficient';
        c = fliplr(linspace(pos1-DA,pos1+DA,length(lab)));
        dd = 1.1*axes.rmax;	ii = 0;
        for ic = 1 : length(c)
            ith = c(ic);
            ttt(ic)=text(dd*cos(ith*pi/180),dd*sin(ith*pi/180),lab(ic));
            set(ttt(ic),'rotation',ith-90,'color',option.colCOR, ...
                'horizontalalignment','center',...
                'verticalalignment','bottom', ...
                'fontsize',fontSize, ...
                'fontweight',axlabweight);
        end
        axes.cor.XLabel = ttt;
    end
    
    if strcmp(option.titleRMS,'on')
        clear ttt
        pos1 = option.titleRMSDangle; DA = 10;
        lab = 'RMSD';
        c = fliplr(linspace(pos1-DA,pos1+DA,length(lab)));
        if option.tickRMS(1) > 0
          dd = 0.7*option.tickRMS(1)+0.3*option.tickRMS(2);
        else
          dd = 0.7*option.tickRMS(2)+0.3*option.tickRMS(3);
        end

        % Adjust spacing of label letters if on too small an arc
        posFraction = dd/axes.rmax;
        if posFraction < 0.35
            DA = 2*DA;
            c = fliplr(linspace(pos1-DA,pos1+DA,length(lab)));
        end
        
        % Write label in a circular arc
        ii = 0;
        for ic = 1 : length(c)
            ith = c(ic); 
            ii = ii + 1;
            xtextpos = double(axes.dx+dd*cos(ith*pi/180));
            ytextpos = dd*sin(ith*pi/180);
            ttt(ii)=text(xtextpos,ytextpos,lab(ii));
            set(ttt(ii),'rotation',ith-90,'color',option.colRMS, ...
                'horizontalalignment','center', ...
                'verticalalignment','top','fontsize',fontSize, ...
                'fontweight',axlabweight);
        end
        axes.rms.XLabel = ttt;
    end
    
else
    % Double panel

    if strcmp(option.titleSTD,'on')
        if is_octave()
          ttt = ylabel('test','fontsize',14);
          x = 0; y = -0.15*axes.rmax;
          text(x,y,'Standard Deviation', ...
            'rotation',0, 'color',option.colSTD, ...
            'HorizontalAlignment', 'center', ...
            'fontweight',axlabweight, 'fontsize',fontSize);
        else
          xlabel('Standard Deviation', ...
              'color',option.colSTD,'fontweight',axlabweight, ...
              'fontsize',fontSize);
        end
    end
    
    if strcmp(option.titleCOR,'on')
        clear ttt
        pos1 = 90;	DA = 25;
        lab = 'Correlation Coefficient';
        c = fliplr(linspace(pos1-DA,pos1+DA,length(lab)));
        dd = 1.1*axes.rmax;	ii = 0;

        % Write label in a circular arc
        for ic = 1 : length(c)
            ith = c(ic);
            ii = ii + 1;
            ttt(ii)=text(dd*cos(ith*pi/180),dd*sin(ith*pi/180),lab(ii));
            set(ttt(ii),'rotation',ith-90,'color',option.colCOR, ...
                'horizontalalignment','center', ...
                'verticalalignment','bottom', ...
                'fontsize',fontSize,'fontweight',axlabweight);
        end
        axes.cor = ttt;
    end
    
    if strcmp(option.titleRMS,'on')
        clear ttt
        lab = 'RMSD';
        pos1 = option.titleRMSDangle; DA = 10;
        c = fliplr(linspace(pos1-DA,pos1+DA,length(lab)));
        if option.tickRMS(1) > 0
          dd = 0.7*option.tickRMS(1)+0.3*option.tickRMS(2);
        else
          dd = 0.7*option.tickRMS(2)+0.3*option.tickRMS(3);
        end
        
        % Adjust spacing of label letters if on too small an arc
        posFraction = dd/axes.rmax;
        if posFraction < 0.35
            DA = 2*DA;
            c = fliplr(linspace(pos1-DA,pos1+DA,length(lab)));
        end
        
        % Write label in a circular arc
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
                'fontsize',fontSize,'fontweight',axlabweight);
        end
        axes.rms = ttt;
    end
end

% Set color of tick labels to that specified for STD contours
set(gca,'XColor',option.colSTD);
set(gca,'YColor',option.colSTD);

% VARIOUS ADJUSTMENTS TO THE PLOT:
daspect([1 1 1]);

% set axes limits, set ticks, and draw axes lines
if option.numberPanels == 2
    axis(cax,axes.rmax*[-1 1 0 1]);
    line([-axes.rmax axes.rmax],[0 0],'color',axes.tc,'linewidth',1.2);
    line([0 0],[0 axes.rmax],'color',axes.tc);
    % hide y-axis line
    set(gca,'Color','none','YColor','none'); % hide y-axis line
else
    ytick = get(cax,'YTick');
    ytick = ytick(ytick >= 0);
    axis(cax,axes.rmax*[0 1 0 1]);
    xticks(ytick); yticks(ytick);

    line([0 axes.rmax],[0 0],'color',axes.tc,'linewidth',1.2);
    line([0 0],[0 axes.rmax],'color',axes.tc,'linewidth',2);
end

% Set axis line width
lineWidth = get(gcf, 'defaultLineLineWidth');
set(gca,'linewidth',lineWidth);

axes.std = gca;

end % function plot_taylor_axes
