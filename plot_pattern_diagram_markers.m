function varargout = plot_pattern_diagram_markers(X,Y,option)
%PLOT_PATTERN_DIAGRAM_MARKERS Plots color markers on a pattern diagram.
%
%   [HP, HT] = PLOT_PATTERN_DIAGRAM_MARKERS(X,Y,OPTION)
%   Plots color markers on a target diagram according their (X,Y) 
%   locations. The symbols and colors are chosen automatically with a 
%   limit of 70 symbol & color combinations.
%
%   The color bar is titled using the content of option.titleColorBar (if
%     present).
%
%   INPUTS:
%   x : x-coordinates of markers
%   y : y-coordinates of markers
%   z : z-coordinates of markers (used for color shading)
%   option : data structure containing option values. (Refer to 
%     GET_TARGET_DIAGRAM_OPTIONS function for more information.)
%   option.axismax     : maximum for the X & Y values. Used to limit
%     maximum distance from origin to display markers
%   option.markerLabel : labels for markers
%
%   OUTPUTS:
% 	hp: returns handles of plotted points
% 	ht: returns handles of the text legend of points

% Set face color transparency
alpha = option.alpha;

% Set marker size
fontSize = get(gcf,'DefaultAxesFontSize');
markerSize = option.markerSize;

if strcmp(option.markerLegend,'on')
    % Check that marker labels have been provided
    if ~isfield(option,'markerLabel')
        error('No markerLabel field in option data structure.');
    elseif isempty(option.markerLabel)
        error('No marker labels provided.');
    else
        % Determine if labels are provided as a string array or a cell array
        if iscellstr(option.markerLabel)
            labelType = 1;
        else
            labelType = 0;
        end
    end

    % Plot markers of different color and shapes with labels 
    % displayed in a legend
    
    % Define markers
    kind=['+';'o';'x';'s';'d';'^';'v';'p';'*'];
    colorm=['b';'r';'g';'c';'m';'y';'k'];
    if (length(X) > 70)
        disp('You must introduce new markers to plot more than 70 cases.')
        disp('The ''marker'' character array need to be extended inside the code.')
        return
    end
    
    if length(X) <= length(kind)
        % Define markers with specified color
        n=1;
        marker(1:(size(colorm,1)*size(kind,1)),1:2)=' ';
        for ic=1:size(colorm,1)
            for ik=1:size(kind,1)
                marker(n,:)=[kind(ik,:) option.markerColor];
                n=n+1;
            end
        end
    else
        % Define markers and colors using predefined list
        n=1;
        marker(1:(size(colorm,1)*size(kind,1)),1:2)=' ';
        for ic=1:size(colorm,1)
            for ik=1:size(kind,1)
                marker(n,:)=[kind(ik,:) colorm(ic,:)];
                n=n+1;
            end
        end
    end
    
    % Plot markers at data points
    limit = option.axismax;
    hp = [];
    markerLabel = [];
    hMarker = [];
    lMarker = [];
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
        end
    end
    
    % Add legend
    if length(markerLabel) == 0
        warning('No markers within axis limit ranges.');
    else
        add_legend(markerLabel,option,lMarker,markerSize,fontSize,hp);
    end
    
    ht = cell(1); % create an empty cell to return
else
    % Check if marker labels provided
    if isfield(option,'markerLabel')
        markerLabel = option.markerLabel;
        if isempty(option.markerLabel)
            error('No marker labels provided.');
        end
        
        % Determine if labels are provided as a string array or a cell array
        if iscellstr(option.markerLabel)
            labelType = 1;
        else
            labelType = 0;
        end
    else
        markerLabel = 0;
    end
    
    % Plot markers as circles of a single color with accompanying labels
    % and no legend
    
    % Plot markers at data points
    limit = option.axismax;
    hp = [];
    ht = [];
    for i=1:length(X)
        if abs(X(i)) <= limit & abs(Y(i)) <= limit
            % Plot marker
            h = plot(X(i),Y(i),'o','MarkerSize',markerSize, ...
                'MarkerFaceColor',option.markerColor, ...
                'MarkerEdgeColor',option.markerColor, ...
                'Linewidth',2.5);
            hm = setMarkerColor(h,option.markerColor,alpha); % Apply transparency to marker
            hp = [hp; h];
            
            if isa(markerLabel,'cell')
                % Label marker
                xtextpos = double(X(i));
                ytextpos = double(Y(i));
                
                htext = text(xtextpos,ytextpos, ...
                    option.markerLabel(i), ...
                    'Color',option.markerLabelColor);                        
%                 switch labelType
%                     case 0
%                         % String array
%                         htext = text(xtextpos,ytextpos, ...
%                             option.markerLabel(i,:), ...
%                             'Color',option.markerLabelColor);
%                     case 1
%                         % Cell array
%                         htext = text(xtextpos,ytextpos, ...
%                             option.markerLabel(i), ...
%                             'Color',option.markerLabelColor);
%                     otherwise
%                         error(['Invalid label type: ' labelType]);
%                 end
                ht = [ht; htext];
            end
            hold on;
        end % if limit test
    end % markers loop
    
    % Add legend if labels provided as map
    if isMap(markerLabel)
        add_legend(markerLabel,option,[],markerSize,fontSize,hp);
    end
    if length(ht) > 0
        set(ht,'verticalalignment','bottom','horizontalalignment','right', ...
            'fontsize',fontSize)
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

function answer = isMap(A)
%isMap Checks if object A is a Map container.
%
%   isMap(A)
%   Checks if the object A is a AMp container and returns
%     0 = false
%     1 = true

answer = strcmp(class(A),'containers.Map');

end %function isMap