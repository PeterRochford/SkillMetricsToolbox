function [markerSymbol, markerColor] = get_markers(X,option)
%GET_MARKERS Define markers to use in a pattern diagram
%
%   marker = GET_MARKERS(X,OPTION)
%   Defines the markers to be used for a pattern diagram.
%
%   INPUTS:
%   x : x-coordinates of markers
%   option : data structure containing option values. (Refer to 
%     GET_TARGET_DIAGRAM_OPTIONS function for more information.)
%   option.axismax     : maximum for the X & Y values. Used to limit
%     maximum distance from origin to display markers
%   option.markerColor : single color to use for all markers (Default: red)
%   option.markerKey   : key to use when marker labels specified as a map
%   option.markerLabel : labels for markers
%
%   OUTPUTS:
% 	markerSymbol: returns marker symbols
% 	markerColor:  returns marker RGB colors

if strcmp(option.markerLegend,'on')
    % Use markers of different colors and shapes
    
    % Define markers
    kind=['+';'o';'x';'s';'d';'^';'v';'p';'*'];
    colorm=['b';'r';'g';'c';'m';'y';'k']; % short names
    if (length(X) > 70)
        disp('You must introduce new markers to plot more than 70 cases.')
        disp('The ''marker'' character array needs to be extended inside the code.')
        return
    end
    
    if length(X) <= length(kind)
        % Enough symbols, so use all markers with specified color
        n=1;
        markerSymbol(1:(size(colorm,1)*size(kind,1)))=' ';
        markerColor=zeros(size(colorm,1)*size(kind,1),3); %store as RGB
        for ic=1:size(colorm,1)
            for ik=1:size(kind,1)
                markerSymbol(n)=kind(ik,:);
                markerColor(n,:)=option.markerColor;
                n=n+1;
            end
        end
    else
        % Define markers and colors using predefined list
        n=1;
        markerSymbol(1:(size(colorm,1)*size(kind,1)))=' ';
        markerColor=zeros(size(colorm,1)*size(kind,1),3); %store as RGB
        for ic=1:size(colorm,1)
            for ik=1:size(kind,1)
                markerSymbol(n)=kind(ik,:);
                markerColor(n,:)=validatecolor(colorm(ic,:));
                n=n+1;
            end
        end
    end
else
    % Use specified markers
    if isfield(option,'markerLabel')
        % Get information from markerLabel
        markerLabel = option.markerLabel;
        if isempty(markerLabel)
            error('No marker labels provided.');
        end

        % Determine what data type used for labels
        if isMap(markerLabel)
            % map container
            if isfield(option,'markerKey')
                key = option.markerKey;
            else
                error('No markerKey specified');
            end
            if ~isKey(markerLabel,key)
                error(['Key not in map: markerLabel(' key ')']);
            end
            value = markerLabel(key);
            mColor = check_color(value);

            if length(value) == 1
                markerSymbol = option.markerSymbol;
                markerColor = mColor;

            else
                markerSymbol = value(2);
                markerColor = validatecolor(value(1));
            end
        elseif iscellstr(markerLabel) || isstring(markerLabel)
            % cell array
            markerSymbol = option.markerSymbol;
            markerColor = option.markerColor;
        else
            markerSymbol = option.markerSymbol;
            markerColor = option.markerColor;
        end
    else
        % default of color dot
        markerSymbol = option.markerSymbol;
        markerColor = option.markerColor;
    end
end

end %function get_markers
