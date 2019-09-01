function add_legend(markerLabel,option,lMarker,markerSize,fontSize,hp)
%ADD_LEGEND Adds a legend to a pattern diagram.
%
%   ADD_LEGEND(markerLabel,option,lMarker,markerSize,fontSize,hp)
%   Adds a legend to a plot according to the data type containing the 
%   provided labels. If labels are provided as a cell array they will  
%   appear in the legend beside the marker provided in the list of handles 
%   in a one-to-one match. If labels are provided as a map they will 
%   appear beside a dot with the color value given to the label.
%
%   INPUTS:
%   markerLabel : cell array or map variable containing markers and labels
%                 to appear in legend
%                 
%                 A cell array must have the format:
%                 markerLabel = {'M1', 'M2', 'M3'}
%                  
%                 A map variable must have the format:
%                 markerLabel = containers.Map({'ERA-5', 'TRMM'}, {'r', 'b'});
%                 where each key is the label and each value the color for 
%                 the marker
%   option : data structure containing option values. (Refer to 
%     GET_TARGET_DIAGRAM_OPTIONS function for more information.)
%   option.numberPanels : Number of panels to display
%                         = 1 for positive correlations
%                         = 2 for positive and negative correlations
%   lMarker : list of markers for the legend
%   markerSize : point size of markers
%   fontSize : font size in points of labels
%   hp : list of plot handles that match markerLabel when latter is a list
%
%   OUTPUTS:
% 	None

% Created on Aug 17, 2019
% Revised on Aug 17, 2019
%
% Author: Peter A. Rochford
%         Symplectic, LLC
%         www.thesymplectic.com
%         prochford@thesymplectic.com

% Set face color transparency
alpha = option.alpha;
pause(1.0); % wait 1 second so transparency is applied

if isa(markerLabel,'cell')
    
    % Check for empty list of plot handles
    if length(hp) == 0
        error('Empty list of plot handles');
    elseif length(hp) ~= length(markerLabel)
        error(['Number of labels and plot handle do not match: ' ...
            num2str(length(markerLabel)) ' != ' num2str(length(hp))]);
    end
    
    % Add legend using labels provided as cell array 
    maxLabelLength = max(cellfun('length', markerLabel));
    if ~isempty(option.markerLabel)
        if is_octave()
            hLegend=legend(hp,markerLabel,'Location','northeast');
        elseif length(markerLabel) <= 6 && maxLabelLength <= 6
            % Put legend outside diagram
            hLegend=legend(hp,markerLabel, ...
                'Location','northeastoutside','AutoUpdate','off', ...
                'FontSize',fontSize);

            % The legend function clears marker customizations such as
            % transparency, so restore transparency by re-updating
            % hMarker.FaceColorData
            legendMarkers(hp,hLegend,lMarker,alpha);
        else
            % Put legend to right of the plot in multiple columns as needed

            nmarkers = length(markerLabel);
            ncol = ceil(nmarkers/15);
            if verLessThan('matlab','9.4')
                % Plot legend in single column of column markers
                % because versions prior to MATLAB R2018a don't support
                % multi-column markers
                hLegend=legend(hp,markerLabel, ...
                    'Position',[0.92 0.5 0.0 0.0],'AutoUpdate','off', ...
                    'FontSize',fontSize);
            else
                % Plot legend of multi-column markers
                hLegend=legend(hp,markerLabel, ...
                    'Location','northeastoutside','AutoUpdate','off', ...
                    'FontSize',fontSize,'NumColumns',ncol);
            end

            % The legend function clears marker customizations such as
            % transparency, so restore transparency by re-updating
            % hMarker.FaceColorData
            legendMarkers(hp,hLegend,lMarker,alpha)
        end
    end

elseif isMap(markerLabel)
    
    % Add legend using labels provided as map
            
    % Define legend elements
    h = zeros(length(markerLabel),1);
    
    legendLabels = [];
    i = 0;
    hl = [];
    lMarker = [];
    for k = keys(markerLabel)
        key = k{1};
        value = markerLabel(key);
        if length(value) == 1
            markerColor = value;
            marker='o';
        else
            markerColor = value(1);
            marker = value(2);
        end
        legendLabels = strvcat(legendLabels,key);
        i = i + 1;
        h = plot(NaN,NaN,[marker markerColor],'MarkerSize',markerSize, ...
            'MarkerFaceColor',markerColor,'MarkerEdgeColor',markerColor);
        lMarker = [lMarker; markerColor];
        hl = [hl; h];
        hold on;
    end

    % Put legend outside diagram
    hLegend=legend(hl,legendLabels, ...
        'Location','northeastoutside','AutoUpdate','off');
    set(hLegend,'FontSize',fontSize);

    % Reapply transparency to marker
    for i = 1:length(hp)
        setMarkerColor(hp(i),hp(i).MarkerFaceColor,alpha);
    end

    % Important: The legend function clears marker customizations such as 
    % transparency, so restore transparency by re-updating hp.FaceColorData
    legendMarkers(hl,hLegend,lMarker,alpha);
else
    error(['markerLabel type is not a cell array or map: ' ... 
                        class(markerLabel)]);
end

end %function add_legend

function legendMarkers(handle,hLegend,lMarker,alpha)
%legendMarkers Apply color & transparency to legend markers
%
%   The legend function clears marker customizations such as
%   transparency, so restore transparency by re-updating the
%   markers. Also apply transparency to the symbols appearing
%   in the legend.
%
%   LEGENDMARKERS(HANDLE,HLEGEND,LMARKER,ALPHA)
%
%   INPUTS:
%   handle  : handle of plot
%   hLegend : handle of legend
%   lMarker : list of marker symbols
%   alpha   : blending of symbol face color (0.0 transparent through 
%             1.0 opaque). (Default : 1.0)
%
%   OUTPUTS:
% 	None

% Test for empty arrays
if length(handle) == 0 || length(hLegend) == 0 || length(lMarker) == 0
    error('handle is empty array');
elseif length(hLegend) == 0
    error('hLegend is empty array');
elseif length(lMarker) == 0
    error('lMarker is empty array');
elseif length(handle) ~= length(lMarker)
    error('handle and lMarker arrays must be same size');
end

% Necessary to do a drawnow before operating on the legend structure
drawnow;

% Process for all markers
for i=1:length(lMarker)
    % Restore marker transparency
    hm = setMarkerColor(handle(i),lMarker(i),alpha);
end

% Get legend components
% hLegendComponents has 2 children: child 1 = LegendIcon, child 2 = Text (label)
hLegendComponents = hLegend.EntryContainer.Children;
for isymbol = 1:length(hLegendComponents)
    hLegendIconComponents = hLegendComponents(isymbol).Icon.Transform.Children;
    
    % child 1 = Marker, child 2 = LineStrip
    hLegendMarker = hLegendIconComponents.Children(1);
    
    % Set legend to same transparency as marker
    icolor = length(hLegendComponents) + 1 - isymbol;
    hm = setMarkerColor(hLegendMarker,lMarker(icolor),alpha); % Apply transparency to marker
end

end %function legendMarkers
