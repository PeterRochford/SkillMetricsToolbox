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
%	ht: returns handles of the text legend of points

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
    kind=['+';'o';'x';'s';'d';'^';'v';'p';'h';'*'];
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
    nmarker = 0;
    for i=1:length(X)
        if abs(X(i)) <= limit & abs(Y(i)) <= limit
            nmarker = nmarker + 1;
            h = plot(X(i),Y(i),marker(i,:), ...
                'MarkerSize',8,'MarkerFaceColor',marker(i,2), ...
                'Linewidth',2.5);
            hp = [hp; h];
            markerLabel = [markerLabel; option.markerLabel(:,i)];
        end
    end
    
    % Add legend
    if ~isempty(hp)
        if ~isempty(option.markerLabel)
            lhandle=legend(hp,markerLabel,'Location','bestoutside');
        end
    else
        warning('No markers within axis limit ranges.');
    end
    
    ht = cell(1); % create an empty cell to return
else
    % Check if marker labels provided
    if isfield(option,'markerLabel')
        markerLabel = 1;
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
    
    % Plot markers as dots of a single color with accompanying labels
    % and no legend
    
    % Plot markers at data points
    limit = option.axismax;
    hp = [];
    ht = [];
    for i=1:length(X)
        if abs(X(i)) <= limit & abs(Y(i)) <= limit
            % Plot marker
            h = plot(X(i),Y(i),'.','MarkerSize',20, ...
                'Color',option.markerColor);
            hp = [hp; h];
            
            if markerLabel
                % Label marker
                xtextpos = double(X(i));
                ytextpos = double(Y(i));
                switch labelType
                    case 0
                        % String array
                        htext = text(xtextpos,ytextpos, ...
                            option.markerLabel(i,:), ...
                            'Color',option.markerLabelColor);
                    case 1
                        % Cell array
                        htext = text(xtextpos,ytextpos, ...
                            option.markerLabel(i), ...
                            'Color',option.markerLabelColor);
                    otherwise
                        error(['Invalid label type: ' labelType]);
                end
                ht = [ht; htext];
            end
        end
    end
  	set(ht,'verticalalignment','bottom','horizontalalignment','right', ...
        'fontsize',12)
end

% Output
switch nargout
	case 1
		varargout(1) = {hp};
	case 2
		varargout(1) = {hp};
		varargout(2) = {ht};
end

end %function plot_pattern_diagram_markers
