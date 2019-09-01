function varargout = plot_pattern_diagram_markers(X,Y,option)
%PLOT_PATTERN_DIAGRAM_MARKERS Plots color markers on a pattern diagram.
%
%   [HP, HT] = PLOT_PATTERN_DIAGRAM_MARKERS(X,Y,OPTION)
%   Plots color markers on a target or Taylor diagram according their
%   (X,Y) locations. The symbols and colors are chosen according to the
%   selections made in the OPTION variable. Refer to the following
%   functions for selecting the options:
%     GET_TARGET_DIAGRAM_OPTIONS
%     GET_TAYLOR_DIAGRAM_OPTIONS
%
%   INPUTS:
%   x : x-coordinates of markers
%   y : y-coordinates of markers
%   option : data structure containing option values. (Refer to 
%     *_DIAGRAM_OPTIONS functions for more information.)
%   option.axismax     : maximum for the X & Y values. Used to limit
%     maximum distance from origin to display markers
%   option.markerLabel : labels for markers
%
%   OUTPUTS:
% 	hp: returns handles of plotted points
% 	ht: returns handles of the text legend of points

% Get axis limit
limit = option.axismax;

% Set face color transparency
alpha = option.alpha;

% Set marker size
fontSize = get(gcf,'DefaultAxesFontSize');
markerSize = option.markerSize;

% Define markers to use in pattern diagram
marker = get_markers(X,option);

if strcmp(option.markerLegend,'on')
    % Check that marker labels have been provided
    if ~isfield(option,'markerLabel')
        error('No markerLabel field in option data structure.');
    elseif isempty(option.markerLabel)
        error('No marker labels provided.');
    end
    
    % Plot markers of different color and shapes at data points
    hp = []; markerLabel = [];
    hMarker = []; lMarker = [];
    ht = cell(1); % create an empty cell to return
    for i=1:length(X)
        if abs(X(i)) <= limit & abs(Y(i)) <= limit
            h = plot(X(i),Y(i),marker(i,:),'MarkerSize',markerSize, ...
                'MarkerEdgeColor',marker(i,2), ...
                'Linewidth',2.5);
            hm = setMarkerColor(h,marker(i,2),alpha); % Apply transparency to marker
            hp = [hp; h];
            markerLabel = [markerLabel; option.markerLabel(:,i)];
            hMarker = [hMarker; hm];
            lMarker = [lMarker; marker(i,2)];
            hold on;
        end % if limit test
    end %for loop
    
    % Add legend
    if length(markerLabel) == 0
        warning('No markers within axis limit ranges.');
    else
        add_legend(markerLabel,option,lMarker,markerSize,fontSize,hp);
    end
else
    % Plot same kind of marker at data points
    hp = []; ht = [];
    for i=1:length(X)
        if abs(X(i)) <= limit & abs(Y(i)) <= limit
            % Plot marker
            h = plot(X(i),Y(i),marker,'MarkerSize',markerSize, ...
                'MarkerFaceColor',marker(2), ...
                'MarkerEdgeColor',marker(2), ...
                'Linewidth',2.5);
            hm = setMarkerColor(h,marker(2),alpha); % Apply transparency to marker
            hp = [hp; h];
            
            if isfield(option,'markerLabel') && isa(option.markerLabel,'cell')
                % Label marker
                xtextpos = double(X(i));
                ytextpos = double(Y(i));
                htext = text(xtextpos,ytextpos, ...
                    option.markerLabel(i), ...
                    'Color',option.markerLabelColor);
                ht = [ht; htext];
            end
            hold on;
        end % if limit test
    end % markers loop
    
    % Add legend if labels provided as map
    if isfield(option,'markerLabel')
        if isMap(option.markerLabel)
            add_legend(option.markerLabel,option,[],markerSize,fontSize,hp);
        end
        if length(ht) > 0
            set(ht,'verticalalignment','bottom','horizontalalignment','right', ...
                'fontsize',fontSize)
        end
    end
end

% Output
switch nargout
	case 1
		varargout(1) = {hp};
	case 2
		varargout(1) = {hp};
		varargout(2) = {ht};
end
hold on;

end %function plot_pattern_diagram_markers
