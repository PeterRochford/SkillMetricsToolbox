% How to create a target diagram with a legend plus changed marker colors and circles
%
% A fourth example of how to create a target diagram given one set of
% reference observations and multiple model predictions for the quantity.
%
% This example is a variation on the third example (target3) where now a
% legend is added, the marker colors are changed, and the radii of circles
% to draw are specified. Note that symbols are used for the points when
% requesting a legend.
%
% All functions in the Skill Metrics Toolbox are designed to only work with
% one-dimensional arrays, e.g. time series of observations at a selected
% location. The one-dimensional data are read in as data structures via a
% mat file. The latter are stored in data structures in the format:
% ref.data, pred1.data, pred2.dat, and pred3.dat. The plot is written to a
% file in Portable Network Graphics (PNG) format.
%
% The reference data used in this example are cell concentrations of a
% phytoplankton collected from cruise surveys at selected locations and 
% time. The model predictions are from three different simulations that
% have been space-time interpolated to the location and time of the sample
% collection. Details on the contents of the data structures (once loaded)
% can be obtained by simply entering the data structure variable name at 
% the command prompt, e.g. 
% >> ref
% ref = 
%          data: [57x1 double]
%          date: {57x1 cell}
%         depth: [57x1 double]
%      latitude: [57x1 double]
%     longitude: [57x1 double]
%       station: [57x1 double]
%          time: {57x1 cell}
%         units: 'cell/L'
%          jday: [57x1 double]

% Author: Peter A. Rochford
%         Symplectic, LLC
%         www.thesymplectic.com
%         prochford@thesymplectic.com

% Close any previously open graphics windows
close all;

% Set the figure properties (optional)
set(gcf,'units','inches','position',[0,10.0,12.0,10.0]);
set(gcf, 'DefaultLineLineWidth', 1.5); % linewidth for plots
set(gcf,'DefaultAxesFontSize',18); % font size of axes text

% Read in data from a mat file
load('target_data.mat');

% Calculate statistics for target diagram
target_stats1 = target_statistics(pred1,ref,'data');
target_stats2 = target_statistics(pred2,ref,'data');
target_stats3 = target_statistics(pred3,ref,'data');

% Store statistics in arrays
bias = [target_stats1.bias; target_stats2.bias; target_stats3.bias];
crmsd = [target_stats1.crmsd; target_stats2.crmsd; target_stats3.crmsd];
rmsd = [target_stats1.rmsd; target_stats2.rmsd; target_stats3.rmsd];

% Specify labels for points in a cell array (M1 for model prediction 1,
% etc.).
label = {'M1', 'M2', 'M3'};

% Produce the target diagram
%
% Label the points and change the axis options. Increase the upper limit
% for the axes, change color and line style of circles. Increase
% the line width of circles. Change color of labels and points. Add a
% legend.
%
% For an exhaustive list of options to customize your diagram, please 
% call the function without arguments:
%	>> target_diagram
[hp, ht, axl] = target_diagram(bias,crmsd,rmsd, ...
    'markerLabel',label, 'markerLabelColor', 'b', 'markerColor', 'b', ...
    'markerLegend', 'on', ...
    'ticks',-50.0:10.0:50.0,'limitAxis',50.0, ...
    'circles',[20.0 40.0 50.0], 'circleLineSpec','-.b','circleLineWidth',1.0);

% Universally change font size of axis tick label, axis label,
% and legend label.
FontSize = 24;
% set(axl,'FontSize',FontSize);

% Change font size of only tick labels and axis labels
% axl.XAxis.FontSize = FontSize;
% axl.YAxis.FontSize = FontSize;

% Change fontsize of only axis labels
% xl = get(axl,'xlabel');
% yl = get(axl,'ylabel');
% xl.FontSize = FontSize; yl.FontSize = FontSize;

% Change fontsize of only tick labels
% set_tick_label_size(axl,FontSize);

% Change font size of legend
% hLegend = findobj(gcf, 'Type', 'Legend');
% set(hLegend,'FontSize',FontSize);

% Write plot to file
writepng(gcf,'target4.png');

function set_tick_label_size(axl,FontSize)
%TICK_LABEL_SIZE Independently set the font size of tick labels.
%
%   TICK_LABEL_SIZE(axl,FontSize)
%   Sets the font size of tick labels associated with the axes handle
%   AXL to FONTSIZE.
%
%   INPUTS:
%   axl      : handle for axes labels
%   FontSize : tick label font size
%
%   OUTPUTS:
%   None

% Get handles to axes labels
xl = get(axl,'XLabel');
yl = get(axl,'YLabel');

% Get current font size of labels
xlFontSize = get(xl,'FontSize');
ylFontSize = get(yl,'FontSize');

% Get axes handles and set tick labels to desired font size
xAX = get(axl,'XAxis');
yAX = get(axl,'YAxis');
set(xAX,'FontSize', FontSize);
set(yAX,'FontSize', FontSize);

% Reset axes labels to original font size
set(xl, 'FontSize', xlFontSize);
set(yl, 'FontSize', ylFontSize);

end % set_tick_label_size function
